using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DivarClone.BLL;
using DivarClone.DAL;

namespace DivarCloneWebForms
{
    public partial class ListingDetail : System.Web.UI.Page
    {
        private IListingBLL _listingBLL;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                var connectionString = "Server=DESKTOP-OOJCK86;Database=DivarCloneV2;Trusted_Connection=True;MultipleActiveResultSets=true;Encrypt=false";

                var listingDAL = new ListingDAL(connectionString);
                _listingBLL = new ListingBLL(listingDAL);
                // Get the listingId from the query string
                string listingIdStr = Request.QueryString["Id"];

                if (int.TryParse(listingIdStr, out int listingId))
                {
                    // Fetch listing details
                    DisplayListingDetails(listingId);
                }
                else
                {
                    lblError.Text = "Invalid listing ID.";
                }
            }
        }

        private void DisplayListingDetails(int listingId)
        {
            try
            {
                var listing = _listingBLL.GetAllListings(id:listingId);

                if (listing != null && listing.Count > 0)
                {
                    // Populate UI controls with listing data
                    lblListingName.Text = listing[0].Name;
                    lblDescription.Text = listing[0].Description;
                    lblPrice.Text = listing[0].Price.ToString();
                    lblPoster.Text = listing[0].Poster;
                    // Bind images to a repeater or other image control
                    rptImages.DataBind();
                }
                else
                {
                    lblError.Text = "Listing not found.";
                }
            }
            catch (Exception ex)
            {
                throw; //error here
            }
        }
    }
}