using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using DivarClone.BLL;
using DivarClone.DAL;
using System.Configuration;
using System.Web.UI.WebControls;
using System.Security.Policy;
using Shared;
using System.Web.Services.Description;

namespace DivarCloneWebForms
{
    public partial class Listings : System.Web.UI.Page
    {
        private IListingBLL _listingBLL;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindListings();
                SetButtonsVisibility();
            }

            if (Request.QueryString["message"] != null)
            {
                var message = Request.QueryString["message"];
                DivarCloneWebForms.SiteMaster masterPage = (DivarCloneWebForms.SiteMaster)this.Master;
                masterPage.MasterLabel.Text = message;
            }

            if (Request.QueryString["secret"] != null && Request.QueryString["secret"] == "true")
            {
                if (ClaimsHelper.HasPermission("CanViewSpecialListing"))
                {
                    BindListings(isSecret: true); //ajax?
                    SetButtonsVisibility();
                }
                else
                {
                    DivarCloneWebForms.SiteMaster masterPage = (DivarCloneWebForms.SiteMaster)this.Master;
                    masterPage.MasterLabel.Text = "اجازه لازم را ندارید";
                } 
            }

            if (Request.QueryString["username"] != null)
            {
                BindListings(username: Request.QueryString["username"]); //ajax?
            }

            if (Request.QueryString["filter"] != null)
            {
                BindListings(categoryEnum: int.Parse(Request.QueryString["filter"])); //ajax?
            }

            if (Request.QueryString["textToSearch"] != null)
            {
                BindListings(textToSearch: Request.QueryString["textToSearch"]); //ajax?
            }
        }

        private void InitializeDependencies()
        {
            var connectionString = ConfigurationManager.ConnectionStrings["DivarCloneContextConnection"].ConnectionString;

            var listingDAL = new ListingDAL(connectionString);
            _listingBLL = new ListingBLL(listingDAL);
        }

        private void SetButtonsVisibility()
        {
            foreach (RepeaterItem item in rptListings.Items)
            {
                Button deleteBtn = (Button)item.FindControl("deleteListing_btn");
                Button editBtn = (Button)item.FindControl("editListing_btn");

                if (ClaimsHelper.HasPermission("CanViewSpecialListing"))
                {
                    if (deleteBtn != null)
                    {
                        deleteBtn.Visible = true; // Show the delete button
                    }
                    if (editBtn != null)
                    {
                        editBtn.Visible = true; // Show the edit button
                    }
                }
                else
                {
                    if (deleteBtn != null)
                    {
                        deleteBtn.Visible = false; // Hide the delete button
                    }
                    if (editBtn != null)
                    {
                        editBtn.Visible = false; // Hide the edit button
                    }
                }
            }
        }

        private void BindListings(int? id = null, string username = null, string textToSearch = null, int? categoryEnum = null, bool includeImages = true, bool isSecret = false)
        {
            InitializeDependencies();

            var listings = _listingBLL.GetAllListingsWithImages(id, username, textToSearch, categoryEnum, includeImages, isSecret);
            rptListings.DataSource = listings;
            rptListings.DataBind();
        }

        protected string GetFirstImageData(Dictionary<int, (string ImagePath, string ImageData)> images)
        {
            // Adjust logic to select the appropriate image
            if (images != null && images.Count > 0)
            {
                return images.Values.First().ImageData; // Return the first image's ImageData
            }
            return string.Empty; // Fallback if no image is available
        }

        protected void DeleteListingButton_Click(object sender, EventArgs e)
        {
            InitializeDependencies();

            DivarCloneWebForms.SiteMaster masterPage = (DivarCloneWebForms.SiteMaster)this.Master;
            
            Button btn = (Button)sender;
            int listingId = int.Parse(btn.CommandArgument);

            if (_listingBLL.DeleteListing(listingId))
            {
                masterPage.MasterLabel.Text = "آگهی با موفقیت حذف شد";
                masterPage.UpdateDangerDivVisibility();
            }
            else
            {
                masterPage.MasterLabel.Text = "آگهی حذف نشد";
                masterPage.UpdateDangerDivVisibility();
            }

            BindListings();
            SetButtonsVisibility();
        }
    }
}
