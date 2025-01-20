<%@ Control Language="C#" ClassName="Navbar" AutoEventWireup="true" CodeBehind="navbar.ascx.cs" Inherits="DivarCloneWebForms.navbar" %>

<nav class="navbar navbar-expand-sm navbar-toggleable-sm navbar-light bg-white border-bottom box-shadow mb-3">
    <div class="container-fluid">
        <a class="navbar-brand" asp-area="" asp-controller="Home" asp-action="Index"></a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarContent">
            <ul class="navbar-nav me-auto">

                <li class="nav-item">
                    <asp:button class="btn btn-outline-secondary" Text="ثبت آگهی" type="button" ID="createListing_btn" runat="server" OnClick="CreateListingButton_Click" Visible="false"></asp:button>
                    <asp:button class="btn btn-outline-secondary" Text="ثبت آگهی خاص" type="button" ID="createSecretListing_btn" runat="server" OnClick="CreateSecretListingButton_Click" Visible="false"></asp:button>

                </li>
            </ul>
        </div>

        <div class="btn-group me-3">
            <button type="button" class="btn btn-secondary dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false" style="background-color: rgb(220, 53, 69); border: 2px solid white; color: white;">
                فیلتر کردن نتایج
            </button>

            <ul class="dropdown-menu">
            </ul>
        </div>

        <div class="input-group" style="width:300px;">
            <input id="searchFieldInput" type="text" class="form-control" placeholder="آگهی مورد نظر" aria-label="Recipient's username" aria-describedby="button-addon2">
            <button class="btn btn-outline-secondary" type="button" id="button-addon2" onclick="filterByText(document.getElementById('searchFieldInput').value)">جست و جو</button>

            <asp:Panel ID="Panel2" runat="server">
                <asp:button class="btn btn-outline-secondary" Text="خروج" type="button" ID="logout_btn" runat="server" OnClick="LogoutButton_Click" Visible="false"></asp:button>
                <asp:button class="btn btn-outline-secondary" Text="ورود" type="button" ID="login_btn" runat="server" OnClick="LoginButton_Click" Visible="false"></asp:button>
                <asp:button class="btn btn-outline-secondary" Text="ثبت نام" type="button" ID="register_btn" runat="server" OnClick="RegisterButton_Click" Visible="false"></asp:button>

            </asp:Panel>
        </div>
        <div style="margin-left:40px;">
        </div>
    </div>
</nav>
