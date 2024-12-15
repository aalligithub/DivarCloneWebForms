<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Listings.aspx.cs" Inherits="DivarCloneWebForms.Listings"%>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <h3 class="mb-3">آگهی ها</h3>

        <asp:Repeater ID="rptListings" runat="server">
            <ItemTemplate>
                <div class="col-md-4" style="margin-bottom:25px;">

                    <div class="card h-100">

                        <img src='<%# GetImageData(Eval("Images") as Dictionary<int, (string, string)>) %>' class="card-img-top" style="width:100%; height:300px; object-fit:contain; alt="no img"/>

                        <div class="card-body">
                            <h5 class="card-title">
                                <asp:HyperLink ID="LinkToListing" 
                                    runat="server" 
                                    NavigateUrl='<%# "~/ListingDetail.aspx?Id=" + Eval("Id") %>' 
                                    Text=<%# Eval("Name") %>>
                                </asp:HyperLink>
                            </h5>
                            <p class="card-text"><%# Eval("Description") %></p>
                        </div>

                        <ul class="list-group list-group-flush">
                            <li class="list-group-item">قیمت : <%# Eval("Price") %></li>
                            <li class="list-group-item">دسته بندی : <%# Eval("Category") %></li>
                            <li class="list-group-item">صاحب آگهی : <%# Eval("Poster") %></li>
                        </ul>

                        <div class="card-body">
                            <small class="text-muted"><%# Eval("DateTimeOfPosting", "{0:yyyy-MM-dd}") %></small>
                        </div>

                        <div class="card-footer">
                            <a class="btn btn-danger ms-2"> حذف</a>
                            <a class="btn btn-danger ms-2">ویرایش</a>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
</asp:Content>

