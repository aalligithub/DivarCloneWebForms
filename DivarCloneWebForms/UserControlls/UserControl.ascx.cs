using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Shared;

namespace DivarCloneWebForms.UserControlls
{
    public partial class UserControl : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (HttpContext.Current.User.Identity.IsAuthenticated)
            {
                myListings_btn.Visible = true;

                if (PermissionHelper.HasPermission("CanViewDashboard"))
                    adminDash_btn.Visible = true;
                
                if (PermissionHelper.HasPermission("CanViewSpecialListing"))
                    secretListings_btn.Visible = true;
            }
        }

        protected void AdminDashButton_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/AdminDashboard.aspx");
        }

        protected void SecretListingsButton_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Listings.aspx?secret=true");
        }

        protected void MyListingsButton_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Listings.aspx?username=" + HttpContext.Current.User.Identity.Name);
        }
    }
}