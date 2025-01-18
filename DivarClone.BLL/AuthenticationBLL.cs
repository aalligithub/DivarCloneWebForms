using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using System.Web;
using System.Web.Security;
using DivarClone.DAL;
using Newtonsoft.Json;
using Shared;

namespace DivarClone.BLL
{
    public static class CustomClaims
    {
        public const string Permission = "Permission";
    }

    public interface IAuthenticationBLL
    {
        UserDTO AuthenticateUser(string username, string password);

        bool AssignUserRole(int userId, string roleName, bool updateExistingRole = false);

        Task<bool> RemoveUserSpecialPermission(int userId, string permissionName);

        bool GiveUserSpecialPermission(int userId, string permissionName);
    }

    public class AuthenticationBLL: IAuthenticationBLL
    {
        private readonly IAuthenticationDAL _authenticationDAL;

        public AuthenticationBLL(IAuthenticationDAL authenticationDAL)
        {
            _authenticationDAL = authenticationDAL;
        }

        public bool SignUserUp(UserDTO user)
        {
            if (_authenticationDAL.SignUserUp(user))
                return true;
            else
                return false; 
        }

        public UserDTO AuthenticateUser(string userName, string password)
        {
            try
            {
               return _authenticationDAL.AuthenticateUser(userName, password); //checks if user exists in user base
            }
            catch (Exception ex)
            {
                Logger.Instance.LogError(ex + " Couldnt access authenticationDAL, couldnt Authenticate user");
                return null;
            }
        }

        public Dictionary<string, string> GiveUserClaims(UserDTO user)
        {
            var claims = new Dictionary<string, string>
            {
                { "Email", user.Email },
                { "Role", user.Role }
            };

            if (user.Permissions != null && user.Permissions.Any())
            {
                var permissions = string.Join(",", user.Permissions);
                claims.Add("Permissions", permissions);
            }

            //usage
            //var permissions = claims["Permissions"].Split(',');

            return claims;
        }

        public void AuthorizeUser(UserDTO user)
        {
            var claims = GiveUserClaims(user);

            string serializedClaims = JsonConvert.SerializeObject(claims);

            FormsAuthenticationTicket ticket = new FormsAuthenticationTicket(
                1,                        // Ticket version
                user.Username,                 // Username to store
                DateTime.Now,             // Issue date
                DateTime.Now.AddMinutes(30), // Expiration
                true,                     // Persistent?
                //user.Role                // User data (e.g., roles)
                serializedClaims
            );

            string encryptedTicket = FormsAuthentication.Encrypt(ticket);

            // Create the cookie
            HttpCookie authCookie = new HttpCookie(FormsAuthentication.FormsCookieName, encryptedTicket);
            authCookie.HttpOnly = true; // Prevent client-side script access

            // Add the cookie to the response
            HttpContext.Current.Response.Cookies.Add(authCookie);

            // Redirect to the originally requested page
            string returnUrl = FormsAuthentication.GetRedirectUrl(user.Username, true);
            HttpContext.Current.Response.Redirect(returnUrl);
        }

        public void Logout()
        {
            // Sign out the user by removing the FormsAuthentication ticket
            FormsAuthentication.SignOut();

            // Optionally clear all cookies to ensure no residual authentication data remains
            HttpCookie authCookie = HttpContext.Current.Request.Cookies[FormsAuthentication.FormsCookieName];
            if (authCookie != null)
            {
                authCookie.Expires = DateTime.Now.AddDays(-1); // Expire the cookie
                HttpContext.Current.Response.Cookies.Add(authCookie);
            }

            // Redirect to the login page or home page
            HttpContext.Current.Response.Redirect("~/Login.aspx");
        }

        public bool AssignUserRole(int userId, string roleName, bool updateExistingRole = false)
        {
            _authenticationDAL.AssignUserRole(userId, roleName, updateExistingRole);
            return true;
        }

        public async Task<bool> RemoveUserSpecialPermission(int userId, string permissionName)
        {
            await _authenticationDAL.RemoveUserSpecialPermission(userId, permissionName);
            return true;
        }

        public bool GiveUserSpecialPermission(int userId, string permissionName)
        {
            _authenticationDAL.GiveUserSpecialPermission((int)userId, permissionName);
            return true;
        }
    }
}
