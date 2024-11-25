using System.Collections.Generic;
using DivarClone.DAL;

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
            // Fetch listings from DAL
            var listings = _listingDAL.GetAllListings();

            // Additional logic can go here (e.g., filtering or sorting)

            return listings;
        }
    }
}
