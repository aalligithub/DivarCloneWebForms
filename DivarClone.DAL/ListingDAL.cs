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
        List<ListingDTO> GetAllListings();
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

        // this method is actually RetrieveListingWithImages(SqlDataReader rdr) from MVC but here because of the different architecture image handling is moved to BLL
        public List<ListingDTO> MapListingsToDTO(SqlDataReader rdr)
        {
            var listingsList = new List<ListingDTO>();

            while (rdr.Read())
            {
                var listing = new ListingDTO
                {
                    Id = Convert.ToInt32(rdr["Id"]),
                    Name = rdr["Name"].ToString(),
                    Description = rdr["Description"].ToString(),
                    Price = Convert.ToInt32(rdr["Price"]),
                    Poster = rdr["Poster"].ToString(),
                    category = (Category)Enum.Parse(typeof(Category), rdr["Category"].ToString()),
                    DateTimeOfPosting = Convert.ToDateTime(rdr["DateTimeOfPosting"]),
                };

                listingsList.Add(listing);
            }

            return listingsList;
        }

        public List<ListingDTO> GetAllListings()
        {
            var listingsList = new List<ListingDTO>();

            using (var con = new SqlConnection(Constr))
            {
                con.Open();

                try
                {
                    var cmd = new SqlCommand("SP_GetListings", con);

                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    SqlDataReader rdr = cmd.ExecuteReader();

                    listingsList = MapListingsToDTO(rdr);
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

                return listingsList;
            }
        }

        public List<ListingDTO> GetSecretListings(int UserId)
        {
            List<ListingDTO> listingsList = new List<ListingDTO>();

            if (con != null && con.State == ConnectionState.Closed)
            {
                con.Open();
            }

            try
            {
                var cmd = new SqlCommand("SP_GetAllSecretListingsWithImages", con);

                cmd.CommandType = System.Data.CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@UserId", UserId);

                SqlDataReader rdr = cmd.ExecuteReader();

                listingsList = MapListingsToDTO(rdr);
            }
            catch (Exception ex)
            {
                Logger.Instance.LogError(ex+" Error Getting Listing list from Listings table");
                return null;
            }
            finally
            {
                con.Close();
            }

            return listingsList;
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

        public List<ListingDTO> GetSpecificListing(int id)
        {
            var listing = new List<ListingDTO>();

            try
            {
                if (con != null && con.State == ConnectionState.Closed)
                {
                    con.Open();
                }
                var cmd = new SqlCommand("SP_GetSpecificListing", con);
                cmd.CommandType = System.Data.CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@Id", id);

                SqlDataReader rdr = cmd.ExecuteReader();

                listing = MapListingsToDTO(rdr).FirstOrDefault();

                return listing;

            }
            catch (Exception)
            {
                throw;
            }
        }
    }
}
