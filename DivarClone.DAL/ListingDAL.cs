using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Reflection;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using Shared;
using static DivarClone.DAL.ListingDTO;
using static Shared.Logger;

namespace DivarClone.DAL
{
    public interface IListingDAL
    {
        List<ListingDTO> GetAllListings();

        List<ListingDTO> GetSpecificListing(int id);

        List<ListingDTO> FilterResult(object categoryEnum);

        List<ListingDTO> SearchResult(string textToSearch);

        string ComputeImageHash(string path);

        //string DownloadImageAsBase64(string imagePath);

        //List<ListingDTO> RetrieveListingWithImages(SqlDataReader rdr);

        //byte[] GetImagesFromFTPForListing(string ImagePath);
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


        public string ComputeImageHash(string path)
        {
            using (var sha256 = SHA256.Create())
            {
                var bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(path));

                if (bytes == null || bytes.Length == 0)
                    return string.Empty;

                var hex = new StringBuilder(bytes.Length * 2);

                foreach (byte b in bytes)
                    hex.AppendFormat("{0:x2}", b); // Lowercase hex

                return hex.ToString();
            }
        }

        public async Task<string> DownloadImageAsBase64(string imagePath)
        {
            byte[] imageBytes = await GetImagesFromFTPForListing(imagePath);

            if (imageBytes != null)
            {
                // Convert byte array to Base64 string
                string base64Image = Convert.ToBase64String(imageBytes);
                return $"data:image/jpeg;base64,{base64Image}"; // Assuming the image is JPEG
            }
            return null;
        }

        public async Task<byte[]> GetImagesFromFTPForListing(string ImagePath)
        {
            FtpWebRequest ftpRequest = null;
            FtpWebResponse ftpResponse = null;
            byte[] imageBytes = null;

            try
            {
                //string ftpHost = Environment.GetEnvironmentVariable("FTP_HOST");
                string ftpHost = "ftp://127.0.0.1:21";

                ftpRequest = (FtpWebRequest)WebRequest.Create(ImagePath);
                ftpRequest.Method = WebRequestMethods.Ftp.DownloadFile;

                ftpRequest.Credentials = new NetworkCredential(
                    "Ali", "Ak362178"
                //Environment.GetEnvironmentVariable("FTP_USERNAME"),
                //Environment.GetEnvironmentVariable("FTP_PASSWORD")
                );

                ftpRequest.EnableSsl = false;
                ftpRequest.UsePassive = false;
                ftpRequest.UseBinary = false;

                using (ftpResponse = (FtpWebResponse)await ftpRequest.GetResponseAsync())
                using (Stream responseStream = ftpResponse.GetResponseStream())
                using (MemoryStream memoryStream = new MemoryStream())
                {
                    // Copy the FTP response stream to memory stream
                    await responseStream.CopyToAsync(memoryStream);

                    // Convert memory stream to byte array
                    imageBytes = memoryStream.ToArray();
                }

                Logger.Instance.LogInfo($"Download Complete, status: {ftpResponse.StatusDescription}");
            }
            catch (Exception ex)
            {
                Logger.Instance.LogError(ex + " Failed to convert Image into byte array ");
                ftpResponse?.Close();
                return Array.Empty<byte>();
            }
            finally
            {
                ftpResponse?.Close();
            }

            return imageBytes;
        }

        public List<ListingDTO> RetrieveListingWithImages(SqlDataReader rdr)
        {
            var listingsDictionary = new Dictionary<int, ListingDTO>();

            while (rdr.Read())
            {
                int listingId = Convert.ToInt32(rdr["Id"]);

                // Check if the listing is already added to the dictionary
                if (!listingsDictionary.TryGetValue(listingId, out ListingDTO listing))
                {
                    listing = new ListingDTO
                    {
                        Id = listingId,
                        Name = rdr["Name"].ToString(),
                        Description = rdr["Description"].ToString(),
                        Price = Convert.ToInt32(rdr["Price"]),
                        Poster = rdr["Poster"].ToString(),
                        category = (Category)Enum.Parse(typeof(Category), rdr["Category"].ToString()),
                        DateTimeOfPosting = Convert.ToDateTime(rdr["DateTimeOfPosting"]),
                        ImagePath = new List<string>()
                    };

                    listingsDictionary[listingId] = listing;
                }
                if (!rdr.IsDBNull(rdr.GetOrdinal("ImagePaths")))
                {
                    string concatenatedPaths = rdr["ImagePaths"].ToString();
                    var imagePaths = concatenatedPaths.Split(',');

                    foreach (var imagePath in imagePaths)
                    {
                        if (!listing.ImagePath.Contains(imagePath))
                        {
                            listing.ImagePath.Add(imagePath);
                        }
                    }
                }
                else if (!listing.ImagePath.Contains("ftp://127.0.0.1/Images/Listings/No_Image_Available.jpg"))
                {
                    //Environment.GetEnvironmentVariable("PATH_TO_DEFAULT_IMAGE")
                    listing.ImagePath.Add("ftp://127.0.0.1/Images/Listings/No_Image_Available.jpg");
                }

                foreach (string imagePath in listing.ImagePath)
                {
                    try
                    {
                        var base64Image = DownloadImageAsBase64(imagePath).Result;

                        if (!string.IsNullOrEmpty(base64Image) && !listing.ImageData.Contains(base64Image))
                        {
                            listing.ImageData.Add(base64Image);
                        }
                    }
                    catch (Exception ex)
                    {
                        throw;
                    }
                }
            }
            return listingsDictionary.Values.ToList();
        }

        public List<ListingDTO> GetAllListings()
        {
            var listingsList = new List<ListingDTO>();

            using (var con = new SqlConnection(Constr))
            {
                con.Open();

                try
                {
                    var cmd = new SqlCommand("SP_GetListingsWithImages", con);

                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    SqlDataReader rdr = cmd.ExecuteReader();

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
                            ImagePath = new List<string>()
                        };

                        listingsList.Add(listing);
                    }
                }
                catch (Exception ex)
                {
                    throw;
                }
                finally
                {
                    con.Close();
                }

                return listingsList;
            }
        }

        public List<ListingDTO> GetSpecificListing(int id)
        {
            var listingList = new List<ListingDTO>();

            try
            {
                using (var con = new SqlConnection(Constr))
                {
                    con.Open();
                }
            }
            catch (Exception)
            {
                throw;
            }
            try
            {
                var cmd = new SqlCommand("SP_GetSpecificListing", con);
                cmd.CommandType = System.Data.CommandType.StoredProcedure;

                using (var rdr = cmd.ExecuteReader())
                {
                    // Use helper method to retrieve listings with images
                    listingList = RetrieveListingWithImages(rdr);
                }

                return listingList;

            }
            catch (Exception)
            {
                throw;
            }
        }

        public List<ListingDTO> FilterResult(object categoryEnum)
        {
            try
            {
                if (con != null && con.State == ConnectionState.Closed)
                {
                    con.Open();
                }

                var cmd = new SqlCommand("SP_FilterListing", con);
                cmd.CommandType = System.Data.CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@category_enum", categoryEnum);

                SqlDataReader rdr = cmd.ExecuteReader();

                var listingsList = RetrieveListingWithImages(rdr);

                return listingsList.ToList();

            }
            catch (Exception ex)
            {
                Logger.Instance.LogError(ex + "Error creating listing");
                throw;
            }
            finally { con.Close(); }
        }

        public List<ListingDTO> SearchResult(string textToSearch)
        {
            try
            {
                if (con != null && con.State == ConnectionState.Closed)
                {
                    con.Open();
                }

                var cmd = new SqlCommand("SP_SearchListing", con);
                cmd.CommandType = System.Data.CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@TextToSearch", textToSearch);

                SqlDataReader rdr = cmd.ExecuteReader();

                var listingsList = RetrieveListingWithImages(rdr);

                return listingsList.ToList();

            }
            catch (Exception ex)
            {
                Logger.Instance.LogError(ex + "Error creating listing");
                throw;
            }
            finally { con.Close(); }
        }
    }
}
