using System;
using System.Security.Claims;
using System.Text;
using System.Web;

namespace DivarCloneWebForms
{
    public partial class ClaimsViewer : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Get the current user's ClaimsPrincipal
                var principal = HttpContext.Current.User as ClaimsPrincipal;
                if (principal != null)
                {
                    // Build an HTML representation of the claims
                    var claimsHtml = new StringBuilder("<ul>");
                    foreach (var claim in principal.Claims)
                    {
                        claimsHtml.Append($"<li><strong>{claim.Type}:</strong> {claim.Value}</li>");
                    }
                    claimsHtml.Append("</ul>");

                    // Display the claims
                    ClaimsLiteral.Text = claimsHtml.ToString();
                }
                else
                {
                    ClaimsLiteral.Text = "No claims are available for the current user.";
                }
            }
        }
    }
}
