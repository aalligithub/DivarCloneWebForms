using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using DivarClone.BLL;
using DivarClone.DAL;

namespace DivarCloneWebForms
{
    public partial class Listings : System.Web.UI.Page
    {
        private IListingBLL _listingBLL;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Using Web.config for configuration
                var connectionString = "Server=DESKTOP-OOJCK86;Database=DivarCloneV2;Trusted_Connection=True;MultipleActiveResultSets=true;Encrypt=false";

                var listingDAL = new ListingDAL(connectionString);
                _listingBLL = new ListingBLL(listingDAL);

                BindListings();
            }
        }

        private void BindListings()
        {
            var listings = _listingBLL.GetAllListingsWithImages();
            rptListings.DataSource = listings;
            rptListings.DataBind();
        }

        protected string GetImageData(Dictionary<int, (string ImagePath, string ImageData)> images)
        {
            // Adjust logic to select the appropriate image
            if (images != null && images.Count > 0)
            {
                return images.Values.First().ImageData; // Return the first image's ImageData
            }
            return string.Empty; // Fallback if no image is available
        }
    }
}
