<%@ Page Language="C#" MasterPageFile="Site.Master" AutoEventWireup="true" CodeBehind="EditListing.aspx.cs" Inherits="DivarCloneWebForms.EditListing" %>

<asp:Content ID="EditListingID" ContentPlaceHolderID="EditListingPlaceHolder" runat="server">
    <style>
        .custom-file-upload {
            display: inline-block;
            position: relative;
            margin-bottom: 10px;
        }

        .custom-file-upload button {
            background-color: #dc3545;
            color: white;
            padding: 8px 16px;
            border: none;
            cursor: pointer;
            border-radius: 5px;
        }

        .custom-file-upload label {
            margin-left: 10px;
            font-size: 14px;
            color: #555;
        }
    </style>
    <script>
        function updateLabel(index) {
            var fileInput = document.getElementById('ImageFile' + index);
            var label = document.getElementById('customLabel' + index);

            if (fileInput.files.length > 0) {
                label.innerText = fileInput.files.length > 1
                    ? fileInput.files.length + ' فایل انتخاب شد'
                    : fileInput.files[0].name;
            } else {
                label.innerText = 'هیچ فایلی انتخاب نشده است';
            }
        }
    </script>

    <div class="container">
        <asp:Panel ID="Panel1" runat="server">

        <div class="row">
            <div class="col">
            
            <asp:Label ID="lblError" runat="server" ForeColor="Red"></asp:Label> 

            <asp:Label ID="ErrorLabel" runat="server"></asp:Label>
            <asp:Label ID="SuccessLabel" runat="server"></asp:Label>

            <div class="mb-3">
                <label for="Name">تیتر آگهی</label>
                <asp:TextBox ID="Name" runat="server" CssClass="form-control"></asp:TextBox>
            </div>

            <div class="mb-3">
                <label for="Description">توضیحات آگهی</label>
                <asp:TextBox ID="Description" runat="server" TextMode="MultiLine" CssClass="form-control"></asp:TextBox>
            </div>

            <div class="mb-3">
                <label for="Price">قیمت</label>
                <asp:TextBox ID="Price" runat="server" CssClass="form-control"></asp:TextBox>
            </div>


            <div class="mb-3">

                <label for="Category">دسته بندی</label>
                <asp:DropDownList ID="Category" runat="server" CssClass="form-select">
                    <asp:ListItem Value="null" Text="انتخاب کنید"></asp:ListItem>
                    <asp:ListItem Value="0" Text="وسایل برقی"></asp:ListItem>
                    <asp:ListItem Value="1" Text="املاک"></asp:ListItem>
                    <asp:ListItem Value="2" Text="وسایل نقلیه"></asp:ListItem>
                </asp:DropDownList>
            </div>

            <!-- File Uploads -->
            <div class="mb-3">
                <% for (int i = 1; i <= 6; i++) { %>
                    <div class="custom-file-upload">
                        <label for="ImageFile<%= i %>" id="customLabel<%= i %>">فایل را انتخاب کنید</label>
                        <input type="file" id="ImageFile<%= i %>" name="ImageFile<%= i %>" style="display: none;" onchange="updateLabel(<%= i %>)" />
                        <button type="button" onclick="document.getElementById('ImageFile<%= i %>').click()">انتخاب فایل</button>
                    </div>
                <% } %>
            </div>

            </div>

            <div class="col">
            <h3>عکس ها</h3>
            <asp:Repeater ID="rptImages" runat="server">
                <ItemTemplate>
                    <div class="row">
                        <div class="col-4 card m-2" id="image-@id" style="width: 18rem; box-shadow:0px 0px 2px gray;">
                            <img src='<%# Eval("ImageData") %>' id="<%# Eval("ImageId") %>" class="card-img-top" style="margin-top:25px; width: 100%; height: auto; object-fit:contain; box-shadow:0px 0px 2px black" alt="No image"/>
                            <div class="card-body">
							    <asp:Button ID="btnDelete" runat="server" Text="حذف عکس" OnClick="DeleteImageButton_Click" CommandArgument='<%# Eval("ImageId") %>' CssClass="btn btn-danger" />
						    </div>
                        </div>
                    </div>

                </ItemTemplate>
            </asp:Repeater>
            </div>
        </div>

            <asp:Button ID="SubmitEditButton" runat="server" Text="ثبت آگهی" CssClass="btn btn-primary" OnClick="SubmitEditButton_Click" />
        </asp:Panel>
    </div>
</asp:Content>