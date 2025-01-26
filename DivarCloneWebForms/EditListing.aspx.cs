using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DivarClone.BLL;
using DivarClone.DAL;
using System.Configuration;

namespace DivarCloneWebForms
{
    public partial class EditListing : System.Web.UI.Page
    {
        private IListingBLL _listingBLL;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Get the listingId from the query string
                string listingIdStr = Request.QueryString["Id"];

                if (int.TryParse(listingIdStr, out int listingId))
                {
                    // Fetch listing details
                    DisplayListingDetails(listingId);
                }
                else
                {
                    dangerDiv.Visible= true;
                    lblError.Text = "آگهی یافت نشد";
                }
            }
        }

        private void InitializeDependencies()
        {
            var connectionString = ConfigurationManager.ConnectionStrings["DivarCloneContextConnection"].ConnectionString;

            var listingDAL = new ListingDAL(connectionString);
            _listingBLL = new ListingBLL(listingDAL);
        }

        private void DisplayListingDetails(int listingId)
        {
            InitializeDependencies();
            try
            {
                var listing = _listingBLL.GetAllListingsWithImages(id: listingId);
                if (listing.Count == 0)
                {
                    listing = _listingBLL.GetAllListingsWithImages(id: listingId, isSecret: true);
                }

                if (listing != null && listing.Count > 0)
                {
                    // Populate UI controls with listing data
                    Name.Text = listing[0].Name;
                    Description.Text = listing[0].Description;
                    Price.Text = listing[0].Price.ToString();
                    
                    Category.SelectedValue = ((int)listing[0].category).ToString();
                    // Bind images to a repeater or other image control


                    var images = listing[0].Images?
                        .Select(kv => new { ImageId = kv.Key, ImageData = kv.Value.ImageData })
                        .ToList();

                    rptImages.DataSource = images; //error
                    rptImages.DataBind();
                }
                else
                {
                    dangerDiv.Visible = true;
                    lblError.Text = "آگهی یافت نشد";
                }
            }
            catch (Exception ex)
            {
                throw; //error here
            }
        }

        protected void SubmitEditButton_Click(object sender, EventArgs e)
        {
            InitializeDependencies();

            var listingDTO = new ListingDTO();

            string listingIdStr = Request.QueryString["Id"];

            int.TryParse(listingIdStr, out int listingId);

            // Retrieve form values
            string name = Name.Text.Trim();
            string description = Description.Text.Trim();
            string price = Price.Text.Trim();
            string category = Category.SelectedValue;

            // Validation
            if (string.IsNullOrEmpty(name))
            {
                dangerDiv.Visible = true;
                lblError.Text = "نام نمیتواند خالی باشد";
                return;
            }

            if (string.IsNullOrEmpty(description))
            {
                dangerDiv.Visible = true;
                lblError.Text = "توضیحات نمیتواند خالی باشد";
                return;
            }

            if (!int.TryParse(price, out int parsedPrice) || parsedPrice <= 0)
            {
                dangerDiv.Visible = true;
                lblError.Text = "قیمت میبایست یک عدد مثبت باشد";
                return;
            }

            if (string.IsNullOrEmpty(category))
            {
                dangerDiv.Visible = true;
                lblError.Text = "دسته بندی انتخاب کنید";
                return;
            }

            // If all validations pass, process the data and create the listing
            try
            {
                ListingDTO listing = new ListingDTO
                {
                    Name = name,
                    Description = description,
                    Price = parsedPrice,
                    category = Enum.TryParse(category, out ListingDTO.Category selectedCategory)
                                ? selectedCategory
                                : throw new Exception("Invalid category."),
                    DateTimeOfPosting = DateTime.Now,
                };

                _listingBLL.UpdateListing(listingId, listing);

                successDiv.Visible = true;
                lblSuccess.Text = "آگهی با موفقیت تغییر کرد";

                DisplayListingDetails(listingId);                
            }
            catch (Exception ex)
            {
                dangerDiv.Visible = true;
                lblError.Text = $"An error occurred: {ex.Message}";
            }

            //for Images:
            // Step 1: Gather files from form
            var imageFiles = new List<HttpPostedFile>();
            for (int i = 1; i <= 6; i++)
            {
                var fileControl = Request.Files["ImageFile" + i];
                if (fileControl != null && fileControl.ContentLength > 0)
                {
                    imageFiles.Add(fileControl);
                }
            }

            ////if there was images process
            if (imageFiles.Count > 0)
            {
                try
                {
                    // Step 2: Deduplicate files using BLL method
                    var distinctImages = _listingBLL.CollectDistinctImages(imageFiles);

                    var uploadedPaths = new List<string>();

                    foreach (var (file, fileHash) in distinctImages)
                    {
                        // Step 3: Generate unique file path
                        string uniqueFileName = $"{fileHash}.jpg";
                        string ftpPath = $"Images/Listings/{uniqueFileName}";

                        // Upload image to FTP
                        using (var memoryStream = new MemoryStream())
                        {
                            file.InputStream.CopyTo(memoryStream); // Read the uploaded file into memory
                            byte[] fileBytes = memoryStream.ToArray();

                            if (_listingBLL.UploadImageToFTP(fileBytes, ftpPath)) // Ensure the file is uploaded
                            {
                                uploadedPaths.Add(ftpPath); // Collect the FTP path for DB insertion

                                // Step 4: Save each file's path and hash to the DB
                                _listingBLL.InsertImagePathIntoDB(listingId, ftpPath, fileHash);
                            }
                        }
                    }

                    dangerDiv.Visible = true;
                    lblError.Text = "عکس اضافه شد";

                    // Fetch listing details
                    DisplayListingDetails(listingId);
                }
                catch (Exception ex)
                {
                    dangerDiv.Visible = true;
                    lblError.Text = $"An error occurred: {ex.Message}";

                    // Fetch listing details
                    DisplayListingDetails(listingId);
                }
            }
            // Redirect or show success message

            //Response.Redirect("~/Listings.aspx");
        }

        protected void DeleteImageButton_Click(object sender, EventArgs e)
        {
            InitializeDependencies();

            Button btn = (Button)sender;
            int imageId = int.Parse(btn.CommandArgument);

            if (_listingBLL.DeleteListingImage(imageId))
            {
                successDiv.Visible = true;
                lblSuccess.Text = "عکس حذف شد";

                string listingIdStr = Request.QueryString["Id"];
                if (int.TryParse(listingIdStr, out int listingId))
                {
                    // Fetch listing details
                    DisplayListingDetails(listingId);
                }
            }
            else {
                dangerDiv.Visible = true;
                lblError.Text = "خطای حذف عکس";
            }
        }
    }
}