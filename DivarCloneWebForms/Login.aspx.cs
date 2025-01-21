using System;
using DivarClone.BLL;
using DivarClone.DAL;
using System.Configuration;
using System.Web.UI;

namespace DivarCloneWebForms
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {

            }
        }

        protected void SubmitButton_Click(object sender, EventArgs e)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["DivarCloneContextConnection"].ConnectionString;

            var authenticationDAL = new AuthenticationDAL(connectionString);
            var _authenticationBLL = new AuthenticationBLL(authenticationDAL);
            var userDTO = new UserDTO();

            DivarCloneWebForms.SiteMaster masterPage = (DivarCloneWebForms.SiteMaster)this.Master;

            string email = Email.Text;
            string password = Password.Text;

            userDTO  = _authenticationBLL.AuthenticateUser(email, password);

            if (userDTO != null)
            {
                _authenticationBLL.AuthorizeUser(userDTO);
                masterPage.MasterLabel.Text = "وارد شدید";

                Response.Redirect("~/Listings.aspx");
            }
            else
            {
                masterPage.MasterLabel.Text = "اطلاعات ورود اشتباه است";
            }

        }
    }
}