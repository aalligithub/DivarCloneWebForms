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

            //foreach (var listing in listings)
            //{
            //    foreach (var imagePath in listing.Images)
            //    {
            //        GetImagesFromFTP(imagePath[]);
            //    }
            //}

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

        public async Task GetImageFromFTP(string imageId, string ftpPath)
        {
            string localFileName = Path.Combine("/ImageCache/", $"{imageId}.jpg"); // Assuming the images are JPG format.

            using (var client = new AsyncFtpClient("ftp.example.com", "username", "password"))
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

        public async Task UploadImageToFTP(string imageId, string ftpPath)
        {
            string localFileName = Path.Combine("/ImageCache/", $"{imageId}.jpg"); // Assuming the images are JPG format.

            using (var client = new AsyncFtpClient("ftp.example.com", "username", "password"))
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
