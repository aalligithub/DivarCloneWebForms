using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DivarClone.DAL;
using System.Xml.Linq;
using DivarClone.BLL;

namespace DivarCloneWebForms
{
    public partial class CreateNewListing : System.Web.UI.Page
    {
        private IListingBLL _listingBLL;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                var connectionString = "Server=DESKTOP-OOJCK86;Database=DivarCloneV2;Trusted_Connection=True;MultipleActiveResultSets=true;Encrypt=false";

                var listingDAL = new ListingDAL(connectionString);
                _listingBLL = new ListingBLL(listingDAL);
                var listingDTO = new ListingDTO();
            }
        }
    

        protected void SubmitButton_Click(object sender, EventArgs e)
        {
            // Retrieve form values
            string name = Name.Text;
            string description = Description.Text;
            string price = Price.Text;
            string category = Category.SelectedValue;
            string poster = Poster.Value;

            // Handle the file uploads
            // Add logic to save the listing and files in the database and FTP server
            for (int i = 1; i <= 6; i++)
            {
                var fileControl = Request.Files["ImageFile" + i];
                if (fileControl != null && fileControl.ContentLength > 0)
                {
                    // Save file logic here
                }
            }

            // Redirect or show success message
            //Response.Redirect("~/SuccessPage.aspx");
        }
    }
}