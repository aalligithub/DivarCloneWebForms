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

        List<ListingDTO> MapJoinedListingToDTO(SqlDataReader mergedReader, bool hasImages);

        Task<bool> DeleteListing(int id);

        Task<int?> CreateListingAsync(ListingDTO listing);

        Task<bool> InsertImagePathIntoDB(int? listingId, List<string> PathToImageFTP, string fileHash);

        Task<bool> UpdateListingAsync(ListingDTO listing);

        Task<bool> MakeListingSecret(int? listingId);

        Task<bool> DeleteListingImage(int imageId);
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

        public Dictionary<int, (string ImagePath, string ImageData)> Images { get; set; } = new Dictionary<int, (string, string)>(); //ImageId is the int key
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
            var listings = new List<ListingDTO>();

            var storedProcedure = "";

            try
            {
                using (var con = new SqlConnection(Constr))
                {
                    con.Open();

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

                    using (var rdr = cmd.ExecuteReader())
                    {
                        listings = MapJoinedListingToDTO(rdr, includeImages);
                    }
                }
            }
            catch (Exception ex)
            {
                Logger.Instance.LogError($"Connection to Database failed : {ex}");
                throw;
            }

            return listings;
        }

        public List<ListingDTO> MapJoinedListingToDTO(SqlDataReader mergedReader, bool hasImages)
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

                if (hasImages)
                {
                    if (!mergedReader.IsDBNull(mergedReader.GetOrdinal("ImagePairs")))
                    {
                        var imagePaths = mergedReader["ImagePairs"].ToString().Split(',');

                        foreach (var pair in imagePaths)
                        {
                            var parts = pair.Split('$');

                            int.TryParse(parts[0], out int imageId);

                            var imagePath = parts[1];

                            listingDTO.Images.Add(imageId, (imagePath, null));
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
                using (var con = new SqlConnection(Constr))
                {
                    con.Open();

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
            }
            catch (Exception ex)
            {
                Logger.Instance.LogError(ex + "Error creating listing");
                throw ex;
            }
        }

        public async Task<bool> InsertImagePathIntoDB(int? listingId, List<string> PathToImageFTP, string fileHash)
        {
            try
            {
                using (var con = new SqlConnection(Constr))
                {
                    con.Open();
                    var cmd = new SqlCommand("SP_InsertImagePathIntoImages", con);
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    foreach (var path in PathToImageFTP)
                    {
                        cmd.Parameters.AddWithValue("@ListingId", listingId);
                        cmd.Parameters.AddWithValue("@ImagePath", path);

                        cmd.Parameters.AddWithValue("@ImageHash", fileHash);

                        await cmd.ExecuteNonQueryAsync();
                        cmd.Parameters.Clear();
                    }
                    return true;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine(ex, "failed to add image path to db");
                return false;
            }
        }

        public async Task<bool> UpdateListingAsync(ListingDTO listing)
        {
            try
            {
                using (var con = new SqlConnection(Constr))
                {
                    con.Open();

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
            }
            catch (Exception ex)
            {
                Logger.Instance.LogError(ex + $"Error updating listing with ID {listing.Id}");

                return false;
            }
        }

        public async Task<bool> MakeListingSecret(int? listingId)
        {
            try
            {
                Logger.Instance.LogInfo("Attempting to make listing with Id = {listingId} secret..." + listingId);

                using (var con = new SqlConnection(Constr))
                {
                    con.Open();

                    var cmd = new SqlCommand("SP_MakeListingSecret", con);
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@listingId", listingId);

                    await cmd.ExecuteNonQueryAsync();
                }
            }
            catch (Exception ex)
            {
                Logger.Instance.LogError(ex + "Error making listing with Id = {listingId} secret" + listingId);

                return false;
            }

            return true;
        }

        public async Task<bool> DeleteListing(int id)
        {
            try
            {
                Logger.Instance.LogInfo("Attempting to delete listing with Id = {Id}" + id);

                using (var con = new SqlConnection(Constr))
                {
                    con.Open();

                    var cmd = new SqlCommand("SP_DeleteListing", con);
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Id", id);

                    await cmd.ExecuteNonQueryAsync();

                    // this method doesnt handle ftp operations but make sure images are removed from ftp aswell in the BLL

                    return true;
                }
            }
            catch (Exception ex)
            {
                Logger.Instance.LogError(ex + "Error deleting listing with Id = {Id}" + id);

                return false;
            }
        }

        public async Task<bool> DeleteListingImage(int imageId)
        {
            //this will work with a BLL method to delete the image from the ftp 
            using (var con = new SqlConnection(Constr))
            {
                con.Open();

                try
                {
                    var cmd = new SqlCommand("SP_DeleteListingImage", con);

                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@ImageId", imageId);

                    await cmd.ExecuteNonQueryAsync();

                    return true ;
                }
                catch (Exception ex)
                {
                    Logger.Instance.LogError($"Connection to Database failed : {ex}");
                    throw;
                }
            }

        }
    }
}
