using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using DivarClone.BLL;
using DivarClone.DAL;

namespace DivarCloneWebForms
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string connectionString = ConfigurationManager.AppSettings["connectionstrings"];

        }

        protected void SubmitButton_Click(object sender, EventArgs e)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["DivarCloneContextConnection"].ConnectionString;

            var authenticationDAL = new AuthenticationDAL(connectionString);
            var _authenticationBLL = new AuthenticationBLL(authenticationDAL);
            var userDTO = new UserDTO();

            string password = passwordFiled.Text;
            string passwordRepeat = passwordRepeatField.Text;

            if (password == passwordRepeat)
            {
                userDTO.Name = nameField.Text;
                userDTO.Username = usernameField.Text;
                userDTO.Password = password;
                userDTO.Email = emailField.Text;
                userDTO.PhoneNumber = phonenumberField.Text;

                _authenticationBLL.SignUserUp(userDTO);

                //add success message
            }
            else {
                // show error for password
            }
        }
    }
}