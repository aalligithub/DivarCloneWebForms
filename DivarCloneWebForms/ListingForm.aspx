<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ListingForm.aspx.cs" Inherits="DivarCloneWebForms.Listings" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>Listings</title>
</head>
<body>
    <form id="form1" runat="server">
        <h1>آگهی</h1>
        <asp:GridView ID="gvListings" runat="server" AutoGenerateColumns="False">
            <Columns>
                <asp:BoundField DataField="Id" HeaderText="ID" />
                <asp:BoundField DataField="Name" HeaderText="Name" />
                <asp:BoundField DataField="Description" HeaderText="Description" />
                <%--<asp:BoundField DataField="Price" HeaderText="Price" />--%>
                <%--<asp:BoundField DataField="Poster" HeaderText="Poster" />--%>
                <asp:BoundField DataField="category" HeaderText="Category" />
                <asp:BoundField DataField="DateTimeOfPosting" HeaderText="Posted On" />
            </Columns>
        </asp:GridView>
    </form>
</body>
</html>
