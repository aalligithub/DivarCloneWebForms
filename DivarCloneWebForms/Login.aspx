<%@ Page Language="C#" MasterPageFile="Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="DivarCloneWebForms.Login" %>

<asp:Content ID="CreateListingID" ContentPlaceHolderID="CreateListingPlaceHolder" runat="server">
                <asp:Label ID="ErrorLabel" runat="server"></asp:Label>
            <asp:Label ID="SuccessLabel" runat="server"></asp:Label>
    <div class="mb-3">
        <label for="Email">ایمیل</label>
        <asp:TextBox ID="Email" runat="server" CssClass="form-control"></asp:TextBox>

        <label for="Password">پسورد</label>
        <asp:TextBox ID="Password" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
    </div>

    <asp:Button ID="SubmitButton" runat="server" Text="ورود" CssClass="btn btn-primary" OnClick="SubmitButton_Click" />

</asp:Content>
