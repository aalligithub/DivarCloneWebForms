using System;
using System.Collections.Generic;
using System.IO;
using System.Web;
using DivarClone.BLL;
using DivarClone.DAL;
using System.Configuration;

namespace DivarCloneWebForms
{
    public partial class CreateNewSecretListing : System.Web.UI.Page
    {
        private IListingBLL _listingBLL;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                var connectionString = ConfigurationManager.ConnectionStrings["DivarCloneContextConnection"].ConnectionString;

                var listingDAL = new ListingDAL(connectionString);
                var _listingBLL = new ListingBLL(listingDAL);
                var listingDTO = new ListingDTO();
            }
        }

        protected void SubmitButton_Click(object sender, EventArgs e)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["DivarCloneContextConnection"].ConnectionString;

            var listingDAL = new ListingDAL(connectionString);
            var _listingBLL = new ListingBLL(listingDAL);
            var listingDTO = new ListingDTO();

            int? listingId = null;

            // Retrieve form values
            string name = Name.Text.Trim();
            string description = Description.Text.Trim();
            string price = Price.Text.Trim();
            string category = Category.SelectedValue;
            string poster = Poster.Value; // Assume the logged-in user

            // Validation
            if (string.IsNullOrEmpty(name))
            {
                ErrorLabel.Text = "Name cannot be empty.";
                return;
            }

            if (string.IsNullOrEmpty(description))
            {
                ErrorLabel.Text = "Description cannot be empty.";
                return;
            }

            if (!int.TryParse(price, out int parsedPrice) || parsedPrice <= 0)
            {
                ErrorLabel.Text = "Price must be a valid positive number.";
                return;
            }

            if (string.IsNullOrEmpty(category))
            {
                ErrorLabel.Text = "Category must be selected.";
                return;
            }

            if (string.IsNullOrEmpty(poster))
            {
                ErrorLabel.Text = "Poster information is missing.";
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
                    Poster = poster,
                    DateTimeOfPosting = DateTime.Now,
                };

                listingId = _listingBLL.CreateSecretListingAsync(listing);

                SuccessLabel.Text = "Listing submitted successfully!";
            }
            catch (Exception ex)
            {
                ErrorLabel.Text = $"An error occurred: {ex.Message}";
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

            //if there was images process
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

                    //if (isInserted)
                    //{
                    //    SuccessLabel.Text = "Listing and images saved successfully!";
                    //}
                    //else
                    //{
                    //    ErrorLabel.Text = "Failed to save images to the database.";
                    //}
                }
                catch (Exception ex)
                {
                    ErrorLabel.Text = $"An error occurred: {ex.Message}";
                }
            }
            // Redirect or show success message
            //Response.Redirect("~/SuccessPage.aspx");
        }
    }
}