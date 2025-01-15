using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using DivarClone.BLL;
using DivarClone.DAL;
using System.Configuration;
using System.Web.UI.WebControls;

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
                var connectionString = ConfigurationManager.ConnectionStrings["DivarCloneContextConnection"].ConnectionString;

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

        protected string GetFirstImageData(Dictionary<int, (string ImagePath, string ImageData)> images)
        {
            // Adjust logic to select the appropriate image
            if (images != null && images.Count > 0)
            {
                return images.Values.First().ImageData; // Return the first image's ImageData
            }
            return string.Empty; // Fallback if no image is available
        }

        protected void DeleteImageButton_Click(object sender, EventArgs e)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["DivarCloneContextConnection"].ConnectionString;

            var listingDAL = new ListingDAL(connectionString);
            _listingBLL = new ListingBLL(listingDAL);

            Button btn = (Button)sender;
            int listingId = int.Parse(btn.CommandArgument);

            if (_listingBLL.DeleteListing(listingId))
            {
                //success label
            }
            else
            {
                //error label
            }
        }
    }
}
