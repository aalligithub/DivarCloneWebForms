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
                    InitializeDependencies();

                    var listing = _listingBLL.GetAllListingsWithImages(id: listingId);

                    if (listing.Count == 0)
                    {
                        listing = _listingBLL.GetAllListingsWithImages(id: listingId, isSecret: true);
                        DisplayListingDetails(listing[0]);
                    }

                    DisplayListingDetails(listing[0]);                    
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

        private void DisplayListingDetails(ListingDTO listing)
        {
            InitializeDependencies();

            try
            {
                if (listing != null)
                {
                    // Populate UI controls with listing data
                    lblListingName.Text = listing.Name;
                    lblDescription.Text = listing.Description;
                    lblPrice.Text = listing.Price.ToString();
                    lblPoster.Text = listing.Poster;
                    lblDateTime.Text = listing.DateTimeOfPosting.ToString();

                    ListingIdHiddenField.Value = listing.Id.ToString();
                    // Bind images to a repeater or other image control

                    var images = listing.Images?
                        .Select(kv => new { ImageId = kv.Key, ImageData = kv.Value.ImageData, ListingId = listing.Id })
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