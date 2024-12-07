using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using DivarClone.DAL;
using static DivarClone.DAL.ListingDTO;

namespace DivarClone.BLL
{
    public interface IListingBLL
    {
        List<ListingDTO> GetAllListings();
    }

    public class ListingBLL : IListingBLL
    {
        private readonly IListingDAL _listingDAL;

        public ListingBLL(IListingDAL listingDAL)
        {
            _listingDAL = listingDAL;
        }

        public List<ListingDTO> GetAllListings()
        {
            var listings = _listingDAL.GetListings(id:2014, isSecret:true);

            // additional logic can go here (e.g., filtering or sorting)

            return listings;
        }
    }
}
