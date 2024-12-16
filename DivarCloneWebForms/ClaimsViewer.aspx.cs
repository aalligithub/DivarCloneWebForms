using System;
using System.Collections.Generic;
using System.Security.Claims;
using System.Text;
using System.Web;
using Newtonsoft.Json;
using System.Web.Security;

namespace DivarCloneWebForms
{
    public partial class ClaimsViewer : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Get the FormsAuthentication cookie
                HttpCookie authCookie = HttpContext.Current.Request.Cookies[FormsAuthentication.FormsCookieName];
                if (authCookie != null)
                {
                    // Decrypt the cookie value to get the ticket
                    FormsAuthenticationTicket ticket = FormsAuthentication.Decrypt(authCookie.Value);

                    if (ticket != null)
                    {
                        // Deserialize the claims from the UserData field
                        var claims = JsonConvert.DeserializeObject<Dictionary<string, string>>(ticket.UserData);

                        // Build an HTML representation of the claims
                        var claimsHtml = new StringBuilder("<ul>");
                        foreach (var claim in claims)
                        {
                            claimsHtml.Append($"<li><strong>{claim.Key}:</strong> {claim.Value}</li>");
                        }
                        claimsHtml.Append("</ul>");

                        // Display the claims
                        ClaimsLiteral.Text = claimsHtml.ToString();
                    }
                    else
                    {
                        ClaimsLiteral.Text = "Failed to decrypt the authentication ticket.";
                    }
                }
                else
                {
                    ClaimsLiteral.Text = "No authentication cookie found.";
                }
            }
        }

    }
}
