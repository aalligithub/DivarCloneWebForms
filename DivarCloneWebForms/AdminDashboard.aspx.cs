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
                rptUsers.ItemDataBound += rptUsers_ItemDataBound;

                BindUsers();
            }
        }

        private void InitializeDependencies()
        {
            var connectionString = ConfigurationManager.ConnectionStrings["DivarCloneContextConnection"].ConnectionString;

            var AdminDAL = new AdminDAL(connectionString);
            _adminBLL = new AdminBLL(AdminDAL);

            var AuthenticationDAL = new AuthenticationDAL(connectionString);
            _authenticationBLL = new AuthenticationBLL(AuthenticationDAL);
        }

        private void BindUsers(
            int? userId = null,
            string username = null,
            string email = null,
            string permissionName = null,
            string roleName = null)
        {
            InitializeDependencies();

            var users = _adminBLL.GetAllUsers(userId,username,email,permissionName,roleName);

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

                var rptSpecialPermissions = (Repeater)e.Item.FindControl("rptRemoveSpecialPermission");

                if (rptRolesPermissions != null)
                {
                    // Calculate the permissions the user lacks
                    var userPermissions = userDto.Permissions; // List of user's current permissions

                    if (userDto.SpecialPermission.Count > 0)
                        foreach (var specialPermission in userDto.SpecialPermission)
                        {
                            userPermissions.Add(specialPermission);
                        }
                    
                    var allAdminPermissions = PermissionCacheManager.RolePermissionsCache["Admin"]; // All admin permissions
                    var lackingPermissions = allAdminPermissions.Except(userPermissions).ToList();

                    // Bind the lacking permissions to the inner repeater
                    rptRolesPermissions.DataSource = lackingPermissions;
                    rptRolesPermissions.DataBind(); // this is the inner repeater

                    rptSpecialPermissions.DataSource = userDto.SpecialPermission.Where(p => !string.IsNullOrEmpty(p)).ToList();
                    rptSpecialPermissions.DataBind();

                    // Store the user ID for later use
                    foreach (RepeaterItem item in rptRolesPermissions.Items)
                    {
                        var btnAddPermission = (Button)item.FindControl("btnAddPermission");
                        if (btnAddPermission != null)
                        {
                            btnAddPermission.CommandArgument = $"{userDto.Id},{btnAddPermission.CommandArgument}";
                        }
                    }

                    foreach (RepeaterItem item in rptSpecialPermissions.Items)
                    {
                        var btnRemoveSpecialPermission = (Button)item.FindControl("btnRemoveSpecialPermission");
                        if (btnRemoveSpecialPermission != null)
                        {
                            btnRemoveSpecialPermission.CommandArgument = $"{userDto.Id},{btnRemoveSpecialPermission.CommandArgument}";
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

            InitializeDependencies();
            _authenticationBLL.AssignUserRole(userId, role, true);

            rptUsers.ItemDataBound += rptUsers_ItemDataBound;
            BindUsers();
        }

        protected void GiveUserPermission_Click(object sender, EventArgs e)
        {
            InitializeDependencies();

            var button = (Button)sender;
            var commandArgs = button.CommandArgument.Split(',');

            int userId = int.Parse(commandArgs[0]); // User ID from HiddenField
            string permissionName = commandArgs[1]; // Permission name from Container.DataItem

            _authenticationBLL.GiveUserSpecialPermission(userId, permissionName);

            rptUsers.ItemDataBound += rptUsers_ItemDataBound;
            BindUsers();
        }

        protected void RemoveUserSpecialPermission_Click(object sender, EventArgs e)
        {
            InitializeDependencies();

            var button = (Button)sender;
            var commandArgs = button.CommandArgument.Split(',');

            int userId = int.Parse(commandArgs[0]); // User ID from HiddenField
            string permissionName = commandArgs[1]; // Permission name from Container.DataItem

            _authenticationBLL.RemoveUserSpecialPermission(userId, permissionName);

            rptUsers.ItemDataBound += rptUsers_ItemDataBound;
            BindUsers();
        }
    }
}