using System;
using System.Web.UI.WebControls;
using DivarClone.BLL;
using DivarClone.DAL;
using System.Configuration;


namespace DivarCloneWebForms
{
    public partial class AdminDashboard : System.Web.UI.Page
    {
        private IAdminBLL _adminBLL;
        private IAuthenticationBLL _authenticationBLL;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                var connectionString = ConfigurationManager.ConnectionStrings["DivarCloneContextConnection"].ConnectionString;

                var AdminDAL = new AdminDAL(connectionString);
                _adminBLL = new AdminBLL(AdminDAL);

                var AuthenticationDAL = new AuthenticationDAL(connectionString);
                _authenticationBLL = new AuthenticationBLL(AuthenticationDAL);

                BindUsers();

                // Roles and Permissions for dropdowns

            }
        }

        private void BindUsers()
        {
            var users = _adminBLL.GetAllUsers();
            rptUsers.DataSource = users;
            rptUsers.DataBind();
        }

        protected void ChangeUserRole_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;

            string commandArgument = btn.CommandArgument;
            string[] args = commandArgument.Split(',');
            int userId = int.Parse(args[0]);
            string role = args[1];

            ChangeUserRole(userId, role);
        }

        protected void ChangeUserRole(int userId, string roleName)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["DivarCloneContextConnection"].ConnectionString;

            var AdminDAL = new AdminDAL(connectionString);
            _adminBLL = new AdminBLL(AdminDAL);

            var AuthenticationDAL = new AuthenticationDAL(connectionString);
            _authenticationBLL = new AuthenticationBLL(AuthenticationDAL);

            _authenticationBLL.AssignUserRole(userId, roleName, true);
        }
    }
}