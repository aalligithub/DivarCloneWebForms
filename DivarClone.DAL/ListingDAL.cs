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
        List<ListingDTO> GetListings(int? id = null, string username = null, string textToSearch = null, int? categoryEnum = null, bool includeImages = true, bool isSecret = false);

        SqlDataReader GetListingImages(int? listingId = null);

        List<ListingDTO> MapIndividualListingsAndImagesToDTO(SqlDataReader listingReader, SqlDataReader imageReader);

        List<ListingDTO> MapJoinedListingToDTO(SqlDataReader mergedReader);

        Task DeleteUserListing(int id);

        Task<int?> CreateListingAsync(ListingDTO listing);

        Task<bool> UpdateListingAsync(ListingDTO listing);

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


        public List<ListingDTO> GetListings(int? id = null, string username = null, string textToSearch = null, int? categoryEnum = null, bool includeImages = true, bool isSecret = false)
        {
            var storedProcedure = "";

            using (var con = new SqlConnection(Constr))
            {
                con.Open();

                try
                {
                    //get listings and images together or get listings individually, when only listings are needed can also be used alongside GetListingImages for full listing

                    if (includeImages) storedProcedure = "[Listing].[SP_GetListingsWithImages]";
                    else storedProcedure = "[Listing].[SP_GetListings]";

                    var cmd = new SqlCommand(storedProcedure, con);

                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    if (id.HasValue) cmd.Parameters.AddWithValue("@Id", id);
                    if (!string.IsNullOrEmpty(username)) cmd.Parameters.AddWithValue("@Username", username);
                    if (!string.IsNullOrEmpty(textToSearch)) cmd.Parameters.AddWithValue("@TextToSearch", textToSearch);
                    if (categoryEnum.HasValue) cmd.Parameters.AddWithValue("@category_enum", categoryEnum.Value);
                    if (isSecret) cmd.Parameters.AddWithValue("@isSecret", 1);

                    SqlDataReader rdr = cmd.ExecuteReader();
                    
                    return MapJoinedListingToDTO(rdr);
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

                    if (listingId.HasValue) cmd.Parameters.AddWithValue("@listingId", listingId.Value);

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

        public List<ListingDTO> MapIndividualListingsAndImagesToDTO(SqlDataReader listingReader, SqlDataReader imageReader)
        {
            var listingsDictionary = new Dictionary<int, ListingDTO>();

            while (listingReader.Read())
            {
                var listingDTO = new ListingDTO
                {
                    Id = Convert.ToInt32(listingReader["Id"]),
                    Name = listingReader["Name"].ToString(),
                    Description = listingReader["Description"].ToString(),
                    Price = Convert.ToInt32(listingReader["Price"]),
                    Poster = listingReader["Poster"].ToString(),
                    category = (Category)Enum.Parse(typeof(Category), listingReader["Category"].ToString()),
                    DateTimeOfPosting = Convert.ToDateTime(listingReader["DateTimeOfPosting"])
                };
            }

            while (imageReader.Read())
            {
                int listingId = Convert.ToInt32(imageReader["ListingId"]);

                if (listingsDictionary.TryGetValue(listingId, out var listingDTO))
                {
                    string imagePath = imageReader["ImagePath"].ToString();

                    // Add ImagePath to the DTO
                    if (!listingDTO.ImagePath.Contains(imagePath))
                    {
                        listingDTO.ImagePath.Add(imagePath);
                    }
                }
            }

            return listingsDictionary.Values.ToList();
        }

        public List<ListingDTO> MapJoinedListingToDTO(SqlDataReader mergedReader)
        {
            var listingList = new List<ListingDTO>();


            while (mergedReader.Read())
            {
                var listingDTO = new ListingDTO()
                {
                    Id = Convert.ToInt32(mergedReader["Id"]),
                    Name = mergedReader["Name"].ToString(),
                    Description = mergedReader["Description"].ToString(),
                    Price = Convert.ToInt32(mergedReader["Price"]),
                    Poster = mergedReader["Poster"].ToString(),
                    category = (Category)Enum.Parse(typeof(Category), mergedReader["Category"].ToString()),
                    DateTimeOfPosting = Convert.ToDateTime(mergedReader["DateTimeOfPosting"]),


                };

                //ADD FUNCTIONALITY TO SKIP IMAGES IF THE STORED PROCEDURE CHANGES
                //IF IMAGE PATH NOT EXISTS SKIP THIS:
                if (!mergedReader.IsDBNull(mergedReader.GetOrdinal("ImagePaths")))
                {
                    string concatenatedPaths = mergedReader["ImagePaths"].ToString();
                    var imagePaths = concatenatedPaths.Split(',');

                    foreach (var imagePath in imagePaths)
                    {
                        if (!listingDTO.ImagePath.Contains(imagePath))
                        {
                            listingDTO.ImagePath.Add(imagePath);
                        }
                    }
                }

                listingList.Add(listingDTO);
            }

            return listingList;
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
