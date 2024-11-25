using System;
using System.Collections.Generic;
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
                var connectionString = "Server=DESKTOP-OOJCK86;Database=DivarClone;Trusted_Connection=True;MultipleActiveResultSets=true;Encrypt=false";

                var listingDAL = new ListingDAL(connectionString);
                _listingBLL = new ListingBLL(listingDAL);

                // Bind the listings to the GridView
                BindListings();
            }
        }

        private void BindListings()
        {
            var listings = _listingBLL.GetAllListings();
            gvListings.DataSource = listings;
            gvListings.DataBind();
        }
    }
}
