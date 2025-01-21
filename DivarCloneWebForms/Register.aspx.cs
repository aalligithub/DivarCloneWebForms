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

        }

        protected void SubmitButton_Click(object sender, EventArgs e)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["DivarCloneContextConnection"].ConnectionString;

            var authenticationDAL = new AuthenticationDAL(connectionString);
            var _authenticationBLL = new AuthenticationBLL(authenticationDAL);
            var userDTO = new UserDTO();

            DivarCloneWebForms.SiteMaster masterPage = (DivarCloneWebForms.SiteMaster)this.Master;

            string password = passwordFiled.Text;
            string passwordRepeat = passwordRepeatField.Text;

            if (password == passwordRepeat)
            {
                userDTO.Name = nameField.Text;
                userDTO.Username = usernameField.Text;
                userDTO.Password = password;
                userDTO.Email = emailField.Text;
                userDTO.PhoneNumber = phonenumberField.Text;

                if (_authenticationBLL.SignUserUp(userDTO))
                    Response.Redirect("~/Login.aspx");
                else
                    masterPage.MasterLabel.Text = "ثبت نام موفقیت آمیز نبود";
            }
            else {
                masterPage.MasterLabel.Text = "تکرار رمز عبور با رمز عبور همخوانی ندارد";
            }
        }
    }
}