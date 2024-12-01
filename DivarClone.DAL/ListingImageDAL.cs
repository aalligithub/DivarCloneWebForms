using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;
using Shared;
using static DivarClone.DAL.ListingDTO;

namespace DivarClone.DAL
{
    public interface IListingImageDAL
    {
        List<ListingDTO> GetListingImagesFromDB();

        void DeleteListingImageFromDB();

        Task<bool> InsertImagePathIntoDB(int? ListingId, List<string> PathToImageFTP, string imageHash);
    }
    public class ListingImageDAL : IListingImageDAL
    {

    }
}
