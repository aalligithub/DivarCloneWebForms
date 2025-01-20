using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DivarClone.BLL;
using DivarClone.DAL;
using System.Configuration;

namespace DivarCloneWebForms
{
    public partial class ListingDetail : System.Web.UI.Page
    {
        private IListingBLL _listingBLL;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Get the listingId from the query string
                string listingIdStr = Request.QueryString["Id"];

                if (int.TryParse(listingIdStr, out int listingId))
                {
                    // Fetch listing details
                    DisplayListingDetails(listingId);
                }
                else
                {
                    lblError.Text = "آگهی یافت نشد";
                }
            }
        }

        private void InitializeDependencies()
        {
            var connectionString = ConfigurationManager.ConnectionStrings["DivarCloneContextConnection"].ConnectionString;

            var listingDAL = new ListingDAL(connectionString);
            _listingBLL = new ListingBLL(listingDAL);
        }

        private void DisplayListingDetails(int listingId)
        {
            InitializeDependencies();

            try
            {
                var listing = _listingBLL.GetAllListingsWithImages(id:listingId);

                if (listing != null && listing.Count > 0)
                {
                    // Populate UI controls with listing data
                    lblListingName.Text = listing[0].Name;
                    lblDescription.Text = listing[0].Description;
                    lblPrice.Text = listing[0].Price.ToString();
                    lblPoster.Text = listing[0].Poster;
                    lblDateTime.Text = listing[0].DateTimeOfPosting.ToString();

                    ListingIdHiddenField.Value = listing[0].Id.ToString();
                    // Bind images to a repeater or other image control

                    var images = listing[0].Images?
                        .Select(kv => new { ImageId = kv.Key, ImageData = kv.Value.ImageData, ListingId = listing[0].Id })
                        .ToList();

                    rptImages.DataSource = images; //is there a way to bind listing[0].Id alongside?
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