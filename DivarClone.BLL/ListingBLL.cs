using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using System.Security.Cryptography;
using System.Text;
using DivarClone.DAL;
using Shared;
using static DivarClone.DAL.ListingDTO;
using System.Net;
using FluentFTP;
using static System.Net.Mime.MediaTypeNames;

namespace DivarClone.BLL
{
    public interface IListingBLL
    {
        List<ListingDTO> GetAllListingsWithImages(int? id = null, string username = null, string textToSearch = null, int? categoryEnum = null, bool includeImages = true, bool isSecret = false);

        List<ListingDTO> GetAllListings(
    int? id = null,
    string username = null,
    string textToSearch = null,
    int? categoryEnum = null,
    bool includeImages = true,
    bool isSecret = false);
    }

    public class ListingBLL : IListingBLL
    {
        private readonly IListingDAL _listingDAL;

        public ListingBLL(IListingDAL listingDAL)
        {
            _listingDAL = listingDAL;
        }

        public List<ListingDTO> GetAllListingsWithImages(
            int? id = null,
            string username = null,
            string textToSearch = null,
            int? categoryEnum = null,
            bool includeImages = true,
            bool isSecret = false) 
        {
            var listings = _listingDAL.GetListings(id, username, textToSearch, categoryEnum, includeImages, isSecret);

            foreach (var listing in listings)
            {
                if (listing.Images != null && listing.Images.Count > 0) {

                    var keys = listing.Images.Keys.ToList(); // Get the keys to iterate over
                    foreach (var key in keys)
                    {
                        var image = listing.Images[key];
                        if (GetImageFromFTP(key, image.ImagePath).Result)
                        {
                            listing.Images[key] = (image.ImagePath, Path.Combine("/ImageCache/", $"{key}.jpg")); // Update the dictionary entry
                        }
                    }
                }
            }

            return listings;
        }

        public List<ListingDTO> GetAllListings(
    int? id = null,
    string username = null,
    string textToSearch = null,
    int? categoryEnum = null,
    bool includeImages = true,
    bool isSecret = false)
        {
            var listings = _listingDAL.GetListings(id, username, textToSearch, categoryEnum, includeImages, isSecret);

            //foreach (var listing in listings)
            //{
            //    foreach (var imagePath in listing.Images)
            //    {
            //        GetImagesFromFTP(imagePath[]);
            //    }
            //}

            return listings;
        }

        //public void CreateListing(ListingDTO listingDTO) {
        //    _listingDAL.CreateListingAsync(listingDTO);

        //    if (listingDTO.Images != null || listingDTO.Images.Count >= 1) {
        //        foreach (var image in listingDTO.Images)
        //        {
        //            _listingDAL.InsertImagePathIntoDB(i);
        //        }
        //    }
        //}

        public async Task<string> ComputeHash(string toHash)
        {
            if (string.IsNullOrEmpty(toHash))
                throw new ArgumentNullException(nameof(toHash), "Input string cannot be null or empty.");

            try
            {
                using (var sha256 = SHA256.Create())
                {
                    var hashBytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(toHash));
                    var hex = new StringBuilder(hashBytes.Length * 2);

                    foreach (byte b in hashBytes)
                        hex.AppendFormat("{0:x2}", b); // Lowercase hex

                    return  hex.ToString();
                }
            }
            catch (Exception ex)
            {
                Logger.Instance.LogError(ex.Message);
                throw;
            }
        }

        public async Task<bool> GetImageFromFTP(int imageId, string ftpPath)
        {
            //string localFileName = Path.Combine("/ImageCache/", $"{imageId}.jpg");

            using (var client = new FtpClient("127.0.0.1", "Ali", "Ak362178"))
            {
                try
                {

                    string localDirectory = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "ImageCache");
                    string localFileName = Path.Combine(localDirectory, $"{imageId}.jpg");

                    // Ensure the directory exists
                    if (!Directory.Exists(localDirectory))
                    {
                        Directory.CreateDirectory(localDirectory);
                    }

                    client.AutoConnect();

                    try
                    {
                        client.DownloadFile(localFileName, ftpPath);
                    }
                    catch
                    {
                        return false;
                    }

                    Logger.Instance.LogInfo("Image download success");
                    return true;
                    
                }
                catch (Exception ex)
                {
                    Logger.Instance.LogError($"{ex.Message} couldnt connect to FTP ");
                    return false;
                }
            }
        }

        public async Task UploadImageToFTP(string imageId, string ftpPath)
        {
            string localFileName = Path.Combine("/ImageCache/", $"{imageId}.jpg"); // Assuming the images are JPG format.

            using (var client = new AsyncFtpClient("ftp://127.0.0.1:21", "Ali", "Ak362178"))
            {
                try
                {
                    await client.AutoConnect();

                    // Download the file from FTP and save it locally with imageId as the name.
                    await client.DownloadFile(localFileName, ftpPath);

                    Console.WriteLine($"Image {imageId} downloaded successfully to {localFileName}.");
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"Failed to download image {imageId} from {ftpPath}: {ex.Message}");
                    // Log the exception or handle the error as needed.
                }
            }
        }

    }
}
