<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ListingDetail.aspx.cs" Inherits="DivarCloneWebForms.ListingDetail" %>

<asp:Content ID="Content3" ContentPlaceHolderID="DynamicContent" runat="server">

    <style>
        /* General Styling */
        body {
            font-family: 'Arial', sans-serif;
            line-height: 1.6;
            background-color: #f9f9f9;
            color: #333;
        }

        h3 {
            font-size: 1.5rem;
            color: #555;
            margin-bottom: 10px;
        }

        h2 {
            font-size: 2rem;
            font-weight: bold;
            color: #333;
            margin-bottom: 15px;
        }

        p {
            font-size: 1rem;
            margin-bottom: 10px;
            color: #666;
        }

        /* Zoom Figure */
        figure.zoom {
            position: relative;
            overflow: hidden;
            cursor: zoom-in;
            background-size: 0;
            background-repeat: no-repeat;
            background-position: center;
            transition: transform 0.8s, background-size 0.8s ease-in-out;
            border-radius: 8px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        figure.zoom img {
            width: 100%;
            height: 500px;
            object-fit: contain;
            transition: opacity 0.8s, transform 0.8s ease-in-out;
            display: none;
            z-index: 10;
            border-radius: 8px;
        }

        figure.zoom.active {
            transform: scale(1.5) translateX(0px) translateY(50px);
            background-size: 150%;
            background-position: 100%;
            z-index: 10;
        }

        figure.zoom.active img {
            opacity: 0;
        }

        /* Navigation Buttons */
        .w3-button {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            background-color: rgba(0, 0, 0, 0.6);
            color: white;
            border: none;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .w3-button:hover {
            background-color: rgba(0, 0, 0, 0.8);
        }

        .w3-display-left {
            left: 10px;
        }

        .w3-display-right {
            right: 10px;
        }
    </style>

    <!-- Error Message -->
    <asp:Label ID="lblError" runat="server" ForeColor="Red" CssClass="error-label"></asp:Label>

    <!-- Content Layout -->
    <div class="container">
        <div class="row">
            <!-- Listing Details -->
            <div class="col">
                <h3>تیتر آگهی</h3>
                <h2><asp:Label ID="lblListingName" runat="server"></asp:Label></h2>

                <h3>توضیحات آگهی</h3>
                <p><asp:Label ID="lblDescription" runat="server"></asp:Label></p>

                <p><b>قیمت:</b> <asp:Label ID="lblPrice" runat="server"></asp:Label></p>
                <p><b>آگهی شده توسط:</b> <asp:Label ID="lblPoster" runat="server"></asp:Label></p>
                <p><b>تاریخ آگهی:</b> <asp:Label ID="lblDateTime" runat="server"></asp:Label></p>
            </div>

            <!-- Listing Images -->
            <div class="col">
                <h3>عکس ها</h3>

                <!-- Hidden Field -->
                <asp:HiddenField ID="ListingIdHiddenField" runat="server" />

                <!-- Image Repeater -->
                <asp:Repeater ID="rptImages" runat="server">
                    <ItemTemplate>
                        <figure class="zoom" onclick="toggleZoom(this)" id="listing-img-figure-<%# Eval("ListingId") %>" style="background-image: url('<%# Eval("ImageData")%>');">
                            <img src='<%# Eval("ImageData") %>' id="<%# Eval("ImageId") %>" class="mySlides-<%# Eval("ListingId") %>" alt="No image" />
                        </figure>
                    </ItemTemplate>
                </asp:Repeater>

                <!-- Navigation Buttons -->
                <button class="w3-button w3-display-left" type="button" onclick="moveSlides(-1)">&#10094;</button>
                <button class="w3-button w3-display-right" type="button" onclick="moveSlides(1)">&#10095;</button>
            </div>
        </div>
    </div>

    <script>
        var slideIndex = {};

        var listingId = document.getElementById('<%= ListingIdHiddenField.ClientID %>').value;

        slideIndex[listingId] = 1; // Initialize slide index for this listing

        showDivs(slideIndex[listingId], listingId);

        function moveSlides(step) {
            // Get the ListingId from the hidden field
            var listingId = document.getElementById('<%= ListingIdHiddenField.ClientID %>').value;

            if (listingId) {
                slideIndex[listingId] += step;
                showDivs(slideIndex[listingId], listingId);
            } else {
                console.error("ListingId is not available.");
            }
        }

        function showDivs(n, listingId) {
            var i;
            var slides = document.getElementsByClassName("mySlides-" + listingId);

            if (n > slides.length) { slideIndex[listingId] = 1; }
            if (n < 1) { slideIndex[listingId] = slides.length; }

            for (i = 0; i < slides.length; i++) {
                slides[i].style.display = "none";
            }
            slides[slideIndex[listingId] - 1].style.display = "block";
        }

        function toggleZoom(element) {
            element.classList.toggle('active'); // Toggle the 'active' class to trigger the zoom effect

            // If zoom is activated (active class added), add the mousemove listener
            if (element.classList.contains('active')) {
                element.addEventListener('mousemove', zoom);
            } else {
                element.removeEventListener('mousemove', zoom); // Remove the listener when zoom is deactivated
            }
        }

        function zoom(e) {
            var zoomer = e.currentTarget;
            var offsetX, offsetY;

            if (e.offsetX !== undefined) {
                offsetX = e.offsetX;
                offsetY = e.offsetY;
            } else if (e.touches) {
                offsetX = e.touches[0].pageX - zoomer.offsetLeft;
                offsetY = e.touches[0].pageY - zoomer.offsetTop;
            }

            var x = (offsetX / zoomer.offsetWidth) * 100;
            var y = (offsetY / zoomer.offsetHeight) * 100;
            zoomer.style.backgroundPosition = x + '% ' + y + '%';
        }

    </script>
</asp:Content>

