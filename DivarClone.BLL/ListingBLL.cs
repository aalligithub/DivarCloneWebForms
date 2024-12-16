using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using System.Security.Cryptography;
using System.Text;
using DivarClone.DAL;
using Shared;
using FluentFTP;
using System.Web;
using System.Web.UI;

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

        Task<string> ComputeHash(string toHash);

        bool GetImageFromFTP(int imageId, string ftpPath);

        bool UploadImageToFTP(byte[] fileBytes, string ftpPath);

        List<(HttpPostedFile, string)> CollectDistinctImages(List<HttpPostedFile> ImageFiles);

        int? CreateListingAsync(ListingDTO listingDTO);

        bool InsertImagePathIntoDB(int? listingId, string PathToImageFTP, string fileHash);
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
                        if (GetImageFromFTP(key, image.ImagePath))
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

        public int? CreateListingAsync(ListingDTO listingDTO)
        {
            return _listingDAL.CreateListingAsync(listingDTO);
        }

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

                    return hex.ToString();
                }
            }
            catch (Exception ex)
            {
                Logger.Instance.LogError(ex.Message);
                throw;
            }
        }

        public bool GetImageFromFTP(int imageId, string ftpPath)
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

        public bool UploadImageToFTP(byte[] fileBytes, string ftpPath)
        {
            using (var client = new FtpClient("127.0.0.1", "Ali", "Ak362178"))
            {
                try
                {
                    client.AutoConnect();

                    // Download the file from FTP and save it locally with imageId as the name.
                    using (var memoryStream = new MemoryStream(fileBytes))
                    {
                        // Upload the file to the FTP server
                        client.UploadStream(memoryStream, ftpPath);
                    }

                    Console.WriteLine($"Image uploaded loaded successfully to ftp.");
                    return true;
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"Failed to upload image");
                    return false;
                    // Log the exception or handle the error as needed.
                }
            }
        }

        public List<(HttpPostedFile, string)> CollectDistinctImages(List<HttpPostedFile> ImageFiles)
        {
            string fileHash = "";
            var uniqueFiles = new List<(HttpPostedFile File, string Hash)>();
            var fileHashes = new HashSet<string>();

            foreach (var ImageFile in ImageFiles)
            {
                try
                {
                    fileHash = ComputeHash(ImageFile.FileName).Result;

                    if (!fileHashes.Contains(fileHash))
                    {
                        fileHashes.Add(fileHash);
                        uniqueFiles.Add((ImageFile, fileHash));
                    }
                }
                catch (Exception ex)
                {
                    Logger.Instance.LogError(ex+" Error computing hash for ImageFile");
                    throw;
                }
            }

            return uniqueFiles;
        }

        public bool InsertImagePathIntoDB(int? listingId, string PathToImageFTP, string fileHash)
        {
            try
            {
                _listingDAL.InsertImagePathIntoDB(listingId, PathToImageFTP, fileHash);
            }
            catch (Exception ex)
            {
                Logger.Instance.LogError(ex + " Failed to access DAL InserImagePathIntoDB");
                return false;
            }
            return true;
        }

    }
}
