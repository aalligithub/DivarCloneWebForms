using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;
using DivarClone.BLL;
using DivarClone.DAL;
using Shared;

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
            var connectionString = "Server=DESKTOP-OOJCK86;Database=DivarCloneV2;Trusted_Connection=True;MultipleActiveResultSets=true;Encrypt=false";

            var authenticationDAL = new AuthenticationDAL(connectionString);
            var _authenticationBLL = new AuthenticationBLL(authenticationDAL);
            var userDTO = new UserDTO();

            string email = Email.Text;
            string password = Password.Text;

            userDTO  = _authenticationBLL.AuthenticateUser(email, password);

            if (userDTO != null)
            {
                _authenticationBLL.AuthorizeUser(userDTO);
                SuccessLabel.Text = "success";
            }
            else
            {
                ErrorLabel.Text = "Wrong";
            }

        }
    }
}