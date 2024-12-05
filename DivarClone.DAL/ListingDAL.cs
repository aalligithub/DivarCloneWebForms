using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using Shared;
using static DivarClone.DAL.ListingDTO;

namespace DivarClone.DAL
{
    public interface IListingDAL
    {
        SqlDataReader GetListings(int? id = null, string username = null, string textToSearch = null, int? categoryEnum = null);

        SqlDataReader GetListingImages(int? listingId = null);

        Task DeleteUserListing(int id);

        Task<int?> CreateListingAsync(ListingDTO listing);

        Task<bool> UpdateListingAsync(ListingDTO listing);

        //List<ListingDTO> MapListingsToDTO(SqlDataReader rdr);

        Task<bool> MakeListingSecret(int? listingId);
    }

    public class ListingDTO
    {
        public enum Category //enum تعریف کردیم که کتگوری فقط از اعضای از پیش تایین شده انتخاب شود
        {
            Electronics,
            Realstate,
            Vehicles
        }

        public int Id { get; set; }

        public string Name { get; set; }

        public string Description { get; set; }

        public int? Price { get; set; }

        public string Poster { get; set; }

        public Category category { get; set; }

        public DateTime DateTimeOfPosting { get; set; }

        public List<string> ImagePath { get; set; } = new List<string>();

        public List<string> ImageData { get; set; } = new List<string>();
    }

    public class ListingDAL : IListingDAL
    {
        public string Constr { get; set; }
        public SqlConnection con;
        private readonly string _connectionString;

        public ListingDAL(string connectionString)
        {
            con = new SqlConnection(Constr);
            _connectionString = connectionString;
            Constr = _connectionString;
        }

        public SqlDataReader GetListings(int? id = null, string username = null, string textToSearch = null, int? categoryEnum = null)
        {
            using (var con = new SqlConnection(Constr))
            {
                con.Open();

                try
                {
                    var cmd = new SqlCommand("SP_GetListings", con);

                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    if (id.HasValue)
                    {
                        cmd.Parameters.AddWithValue("@Id", id);
                    }

                    if (!string.IsNullOrEmpty(username))
                    {
                        cmd.Parameters.AddWithValue("@Username", username);
                    }

                    if (!string.IsNullOrEmpty(textToSearch))
                    {
                        cmd.Parameters.AddWithValue("@TextToSearch", textToSearch);
                    }

                    if (categoryEnum.HasValue)
                    {
                        cmd.Parameters.AddWithValue("@category_enum", categoryEnum.Value);
                    }

                    SqlDataReader rdr = cmd.ExecuteReader();

                    return rdr;

                }
                catch (Exception ex)
                {
                    Logger.Instance.LogError($"Connection to Database failed : {ex}");
                    throw;
                }
                finally
                {
                    con.Close();
                }
            }
        }

        public SqlDataReader GetListingImages(int? listingId = null)
        {
            using (var con = new SqlConnection(Constr))
            {
                con.Open();

                try
                {
                    var cmd = new SqlCommand("SP_GetListingImages", con);

                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    if (listingId.HasValue)
                    {
                        cmd.Parameters.AddWithValue("@listingId", listingId.Value);
                    }

                    SqlDataReader rdr = cmd.ExecuteReader();

                    return rdr;
                }
                catch (Exception ex)
                {
                    Logger.Instance.LogError($"Connection to Database failed : {ex}");
                    throw;
                }
                finally
                {
                    con.Close();
                }
            }
        }

        public async Task<int?> CreateListingAsync(ListingDTO listing)
        {
            try
            {
                if (con != null && con.State == ConnectionState.Closed)
                {
                    con.Open();
                }
                var cmd = new SqlCommand("SP_CreateListing", con);
                cmd.CommandType = System.Data.CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@Name", listing.Name);
                cmd.Parameters.AddWithValue("@Description", listing.Description);
                cmd.Parameters.AddWithValue("@Price", listing.Price);
                cmd.Parameters.AddWithValue("@Poster", listing.Poster);
                cmd.Parameters.AddWithValue("@Category", (int)listing.category);
                cmd.Parameters.AddWithValue("@DateTimeOfPosting", DateTime.Now);

                int newListingId = Convert.ToInt32(await cmd.ExecuteScalarAsync());

                System.Diagnostics.Debug.WriteLine("New Listing Created with Listing Id : " + newListingId);
                return newListingId;
            }
            catch (Exception ex)
            {
                Logger.Instance.LogError(ex + "Error creating listing");
                return null;
            }
            finally
            {
                con.Close();
            }
        }

        public async Task<bool> UpdateListingAsync(ListingDTO listing)
        {
            try
            {
                if (con != null && con.State == ConnectionState.Closed)
                {
                    con.Open();
                }

                var cmd = new SqlCommand("SP_UpdateListing", con);
                cmd.CommandType = System.Data.CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@Id", listing.Id);
                cmd.Parameters.AddWithValue("@Name", listing.Name);
                cmd.Parameters.AddWithValue("@Description", listing.Description);
                cmd.Parameters.AddWithValue("@Price", listing.Price);
                cmd.Parameters.AddWithValue("@Poster", listing.Poster);
                cmd.Parameters.AddWithValue("@Category", (int)listing.category);
                cmd.Parameters.AddWithValue("@DateTime", DateTime.Now);

                await cmd.ExecuteNonQueryAsync();

                Logger.Instance.LogInfo($"Listing with ID {listing.Id} updated successfully.");
                return true;
            }
            catch (Exception ex)
            {
                if (con != null && con.State == ConnectionState.Closed)
                {
                    con.Open();
                }
                var cmd = new SqlCommand("SP_AddLogToDb", con);
                cmd.CommandType = System.Data.CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@Operation", "LISTING UPDATE");
                cmd.Parameters.AddWithValue("@Details", "Listing updated FAILED with details : " + listing.Id + " " + listing.Name + " " + listing.Description + " " + listing.Price + " " + listing.Poster + " " + (int)listing.category + " " + DateTime.Now + " ");
                cmd.Parameters.AddWithValue("@LogDate", DateTime.Now);

                await cmd.ExecuteNonQueryAsync();

                Logger.Instance.LogError(ex + $"Error updating listing with ID {listing.Id}");

                return false;
            }
        }

        public async Task<bool> MakeListingSecret(int? listingId)
        {
            try
            {
                Logger.Instance.LogInfo("Attempting to make listing with Id = {listingId} secret..." + listingId);

                if (con != null && con.State == ConnectionState.Closed)
                {
                    con.Open();
                }

                var cmd = new SqlCommand("SP_MakeListingSecret", con);
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@listingId", listingId);

                await cmd.ExecuteNonQueryAsync();
            }
            catch (Exception ex)
            {
                Logger.Instance.LogError(ex + "Error making listing with Id = {listingId} secret" + listingId);

                return false;
            }
            finally
            {
                con.Close();
            }

            return true;
        }

        public async Task DeleteUserListing(int id)
        {
            try
            {
                Logger.Instance.LogInfo("Attempting to delete listing with Id = {Id}" + id);

                if (con != null && con.State == ConnectionState.Closed)
                {
                    con.Open();
                }

                var cmd = new SqlCommand("SP_DeleteUserListing", con);
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Id", id);

                await cmd.ExecuteNonQueryAsync();
                //try
                //{
                //    //delete the images from ftp aswell
                //}
            }
            catch (Exception ex)
            {
                Logger.Instance.LogError(ex + "Error deleting listing with Id = {Id}" + id);
            }
            finally
            {
                con.Close();
            }
        }

    }
}
