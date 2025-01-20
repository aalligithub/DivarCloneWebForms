<%@ Control Language="C#" ClassName="Navbar" AutoEventWireup="true" CodeBehind="navbar.ascx.cs" Inherits="DivarCloneWebForms.navbar" %>

<nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom box-shadow mb-3">
    <div class="container-fluid">

        <!-- Home Button -->
        <asp:ImageButton 
            ID="imgHomeButton" 
            runat="server" 
            ImageUrl="~/ImageCache/icon.png" 
            OnClick="ImageHomeButton_Click" 
            AlternateText="آگهی ها"
            CssClass="navbar-brand"
            style="width:50px; height:60px;"
        />

        <!-- Navbar Toggle (for mobile view) -->
        <button 
            class="navbar-toggler" 
            type="button" 
            data-bs-toggle="collapse" 
            data-bs-target="#navbarContent" 
            aria-controls="navbarContent" 
            aria-expanded="false" 
            aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <!-- Collapsible Content -->
        <div class="collapse navbar-collapse" id="navbarContent">
            <ul class="navbar-nav me-auto">

                <!-- Create Listing Buttons -->
                <li class="nav-item">
                    <asp:Button 
                        CssClass="btn btn-danger me-2" 
                        Text="ثبت آگهی" 
                        ID="createListing_btn" 
                        runat="server" 
                        OnClick="CreateListingButton_Click" 
                        Visible="false" />
                    
                    <asp:Button 
                        CssClass="btn btn-danger" 
                        Text="ثبت آگهی خاص" 
                        ID="createSecretListing_btn" 
                        runat="server" 
                        OnClick="CreateSecretListingButton_Click" 
                        Visible="false" />
                </li>
            </ul>

            <%-- Search box --%>
            <div class="input-group me-3" style="max-width:400px;">
                <asp:TextBox 
                    ID="searchFieldInput" 
                    CssClass="form-control" 
                    Placeholder="آگهی مورد نظر" 
                    runat="server" 
                    AutoPostBack="false" 
                    aria-label="Search">
                </asp:TextBox>
    
                <asp:Button 
                    ID="searchButton" 
                    Text="جست و جو" 
                    CssClass="btn btn-danger" 
                    OnClick="SearchListingTitle_Click" 
                    runat="server" />
            </div>

            <!-- Filter Dropdown -->
            <div class="btn-group me-3">
                <button 
                    type="button" 
                    class="btn btn-danger dropdown-toggle" 
                    data-bs-toggle="dropdown" 
                    aria-expanded="false">
                    فیلتر کردن نتایج
                </button>

                <ul class="dropdown-menu">
                    <li><asp:LinkButton Text="وسایل برقی" ID="electricListing_btn" runat="server" OnClick="ElectricListingFilter_Click" CssClass="dropdown-item"/></li>
                    <li><asp:LinkButton Text="املاک" ID="realstateListing_btn" runat="server" OnClick="RealStateListingFilter_Click" CssClass="dropdown-item"/></li>
                    <li><asp:LinkButton Text="وسایل نقلیه" ID="vehiclesListing_btn" runat="server" OnClick="VehiclesListingFilter_Click" CssClass="dropdown-item"/></li>
                </ul>
            </div>

            <!-- Auth Buttons -->
            <div class="btn-group">
                <asp:Panel ID="Panel2" runat="server">
                    <asp:Button 
                        CssClass="btn btn-danger me-2" 
                        Text="خروج" 
                        ID="logout_btn" 
                        runat="server" 
                        OnClick="LogoutButton_Click" 
                        Visible="false" />
                    
                    <asp:Button 
                        CssClass="btn btn-danger me-2" 
                        Text="ورود" 
                        ID="login_btn" 
                        runat="server" 
                        OnClick="LoginButton_Click" 
                        Visible="false" />
                    
                    <asp:Button 
                        CssClass="btn btn-danger" 
                        Text="ثبت نام" 
                        ID="register_btn" 
                        runat="server" 
                        OnClick="RegisterButton_Click" 
                        Visible="false" />
                    
                    <asp:Label 
                        runat="server" 
                        ID="userWelcome" 
                        CssClass="text-muted ms-2" 
                        Visible="false">
                    </asp:Label>
                </asp:Panel>
            </div>
        </div>
    </div>
</nav>

