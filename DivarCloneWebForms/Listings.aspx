<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Listings.aspx.cs" Inherits="DivarCloneWebForms.Listings"%>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <h3 class="mb-3">آگهی ها</h3>

        <asp:Repeater ID="rptListings" runat="server">
            <ItemTemplate>
                <div class="col-md-4" style="margin-bottom:25px;">

                    <asp:UpdatePanel ID="UpdatePanelListing" runat="server">
                        <ContentTemplate>

                            <div class="card h-100">

                                <img src='<%# GetFirstImageData(Eval("Images") as Dictionary<int, (string, string)>) %>' class="card-img-top" style="width:100%; height:300px; object-fit:contain;" alt="بدون عکس" onerror="this.src='ImageCache/no_img.jpg';"/>

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
                                    <asp:Button runat="server" ID="deleteListing_btn" OnClick="DeleteListingButton_Click" CommandArgument='<%# Eval("Id") %>' Text="حذف" Visible="false"/>
                                    <asp:Button runat="server" ID="editListing_btn" Text="ویرایش" PostBackUrl='<%# "~/EditListing.aspx?Id=" + Eval("Id") %>' Visible="false"/>
                                </div>
                            </div>
                        
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </ItemTemplate>
        </asp:Repeater>

</asp:Content>

