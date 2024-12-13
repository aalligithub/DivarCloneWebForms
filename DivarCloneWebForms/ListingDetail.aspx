<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ListingDetail.aspx.cs" Inherits="DivarCloneWebForms.ListingDetail" %>

<asp:Content ID="Content3" ContentPlaceHolderID="DynamicContent" runat="server">
<asp:Label ID="lblError" runat="server" ForeColor="Red"></asp:Label>
<div>
    <h2><asp:Label ID="lblListingName" runat="server"></asp:Label></h2>
    <p><asp:Label ID="lblDescription" runat="server"></asp:Label></p>
    <p><b>Price:</b> <asp:Label ID="lblPrice" runat="server"></asp:Label></p>
    <p><b>Posted by:</b> <asp:Label ID="lblPoster" runat="server"></asp:Label></p>
</div>
<div>
    <h3>Images</h3>
    <asp:Repeater ID="rptImages" runat="server">
    </asp:Repeater>
</div>
</asp:Content>

