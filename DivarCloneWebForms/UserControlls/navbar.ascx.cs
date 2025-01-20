using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DivarClone.BLL;
using DivarClone.DAL;
using System.Configuration;
using Shared;

namespace DivarCloneWebForms
{
    public partial class navbar : System.Web.UI.UserControl
    {
        private IAuthenticationBLL _authenticationBLL;

        protected void Page_Load(object sender, EventArgs e)
        {
            // if user is logged in
            if (HttpContext.Current.User.Identity.IsAuthenticated)
            {
                logout_btn.Visible = true;

                if(Shared.PermissionHelper.HasPermission("CanCreateListings"))
                    createListing_btn.Visible = true;

                if (Shared.PermissionHelper.HasPermission("CanViewSpecialListing"))
                    createSecretListing_btn.Visible = true;
            } 
            else //user isnt logged in
            {
                login_btn.Visible = true;
                register_btn.Visible = true;
            }

        }

        private void InitializeDependencies()
        {
            var connectionString = ConfigurationManager.ConnectionStrings["DivarCloneContextConnection"].ConnectionString;

            var authenticationDAL = new AuthenticationDAL(connectionString);
            _authenticationBLL = new AuthenticationBLL(authenticationDAL);
        }

        protected void LogoutButton_Click(object sender, EventArgs e)
        {
            InitializeDependencies();
            _authenticationBLL.Logout();
        }

        protected void LoginButton_Click(Object sender, EventArgs e)
        {
            Response.Redirect("~/Login.aspx");
        }

        protected void RegisterButton_Click(Object sender, EventArgs e)
        {
            Response.Redirect("~/Register.aspx");
        }

        protected void CreateListingButton_Click(Object sender, EventArgs e)
        {
            Response.Redirect("~/CreateNewListing.aspx");
        }

        protected void CreateSecretListingButton_Click(Object sender, EventArgs e)
        {
            Response.Redirect("~/CreateNewSecretListing.aspx");
        }
    }
}