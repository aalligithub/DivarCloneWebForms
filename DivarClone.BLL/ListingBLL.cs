using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Linq;
using System.Reflection;
using System.Xml.Linq;
using DivarClone.DAL;
using static DivarClone.DAL.ListingDTO;

namespace DivarClone.BLL
{
    public interface IListingBLL
    {
        List<ListingDTO> MapListingsToDTO(SqlDataReader listingReader, SqlDataReader imageReader);
    }

    public class ListingBLL : IListingBLL
    {
        private readonly IListingDAL _listingDAL;

        public ListingBLL(IListingDAL listingDAL)
        {
            _listingDAL = listingDAL;
        }

        public List<ListingDTO> MapListingsToDTO(SqlDataReader listingReader, SqlDataReader imageReader)
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

        //public List<ListingDTO> GetAllListings()
        //{
        //    var listings = _listingDAL.GetAllListings();

        //    // Additional logic can go here (e.g., filtering or sorting)

        //    return listings;
        //}
    }
}
