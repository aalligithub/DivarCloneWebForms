using System;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using FluentFTP.Helpers;

namespace DivarCloneWebForms
{
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                dangerDiv.Visible = false;
            }

            UpdateDangerDivVisibility();

        }
        public Label MasterLabel
        {
            get { return masterlbl; }
        }

        public void UpdateDangerDivVisibility()
        {
            // Show the dangerDiv if there is any text in the MasterLabel
            dangerDiv.Visible = !string.IsNullOrEmpty(masterlbl.Text);
        }
    }
}