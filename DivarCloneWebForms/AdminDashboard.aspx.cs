using System;
using System.Web.UI.WebControls;
using DivarClone.BLL;
using DivarClone.DAL;
using System.Configuration;
using System.Linq;
using System.Collections.Generic;


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

                rptUsers.ItemDataBound += rptUsers_ItemDataBound;

                BindUsers();
            }
        }

        private void BindUsers()
        {
            var users = _adminBLL.GetAllUsers();

            rptUsers.DataSource = users; // list of UserDTOs
            rptUsers.DataBind(); //Id is bound here
        }

        protected void rptUsers_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                // Get the current UserDTO
                var userDto = (UserDTO)e.Item.DataItem;

                // Find the inner repeater
                var rptRolesPermissions = (Repeater)e.Item.FindControl("rptRolesPermissions");

                if (rptRolesPermissions != null)
                {
                    // Calculate the permissions the user lacks
                    var userPermissions = userDto.Permissions; // List of user's current permissions
                    var allAdminPermissions = PermissionCacheManager.RolePermissionsCache["Admin"]; // All admin permissions
                    var lackingPermissions = allAdminPermissions.Except(userPermissions).ToList();

                    // Bind the lacking permissions to the inner repeater
                    rptRolesPermissions.DataSource = lackingPermissions;
                    rptRolesPermissions.DataBind(); // this is the inner repeater

                    // Store the user ID for later use
                    foreach (RepeaterItem item in rptRolesPermissions.Items)
                    {
                        var btnAddPermission = (Button)item.FindControl("btnAddPermission");
                        if (btnAddPermission != null)
                        {
                            btnAddPermission.CommandArgument = $"{userDto.Id},{btnAddPermission.CommandArgument}";
                        }
                    }

                }
            }
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

        protected void GiveUserPermission_Click(object sender, EventArgs e)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["DivarCloneContextConnection"].ConnectionString;

            var AdminDAL = new AdminDAL(connectionString);
            _adminBLL = new AdminBLL(AdminDAL);

            var AuthenticationDAL = new AuthenticationDAL(connectionString);
            _authenticationBLL = new AuthenticationBLL(AuthenticationDAL);

            var button = (Button)sender;
            var commandArgs = button.CommandArgument.Split(',');

            int userId = int.Parse(commandArgs[0]); // User ID from HiddenField
            string permissionName = commandArgs[1]; // Permission name from Container.DataItem

            _authenticationBLL.GiveUserSpecialPermission(userId, permissionName);
        }
    }
}