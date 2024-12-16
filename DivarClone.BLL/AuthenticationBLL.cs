using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
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
    }

    public class AuthenticationBLL: IAuthenticationBLL
    {
        private readonly IAuthenticationDAL _authenticationDAL;

        public AuthenticationBLL(IAuthenticationDAL authenticationDAL)
        {
            _authenticationDAL = authenticationDAL;
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
    }
}
