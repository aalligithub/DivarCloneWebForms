<%@ Control Language="C#" ClassName="UserControl" AutoEventWireup="true" CodeBehind="UserControl.ascx.cs" Inherits="DivarCloneWebForms.UserControlls.UserControl" %>

<div>
	<style>
        .user-control-menu {
            background-color: rgb(220, 53, 69);
            border: 2px solid white;
            color: white;
            margin-bottom: 5px;
        }

        .user-control-menu:hover {
            background-color: rgb(200, 50, 60);
            color:white;
        }
	</style>
	<div class="list-group">
        <asp:button class="btn btn-outline-secondary" Text="داشبورد ادمین" type="button" ID="adminDash_btn" runat="server" OnClick="AdminDashButton_Click" Visible="false"></asp:button>
        <asp:button class="btn btn-outline-secondary" Text="آگهی های خاص" type="button" ID="secretListings_btn" runat="server" OnClick="SecretListingsButton_Click" Visible="false"></asp:button>
        <asp:button class="btn btn-outline-secondary" Text="آگهی های من" type="button" ID="myListings_btn" runat="server" OnClick="MyListingsButton_Click" Visible="false"></asp:button>
	</div>
</div>