<%@ Page Language="C#" MasterPageFile="Site.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="DivarCloneWebForms.Register" %>

<asp:Content ID="CreateListingID" ContentPlaceHolderID="CreateListingPlaceHolder" runat="server">
    <div class="container register m-3" >
        <div class="row">
            <div class="col-md-3 register-left">
                <h2 style="text-align:end;">خوش آمدید</h2>
                <p style="font-size:25px; text-align:end;">دیوار مرجع اصلی نیازمندی های رایگان و خرید و فروش کالای نو و دست دوم. نیازمندی های املاک، خودرو، استخدام، لوازم خانه، خدمات و سایر بخش های مورد نظر شما.</p>
            </div>

            <div class="col-md-9 register-right">
                <asp:Panel ID="Panel1" runat="server">

                    <input type="hidden" id="hiddenAntiForgeryToken" runat="server" />

                    <div class="tab-content mt-3" id="myTabContent" style="background-color:rgb(220, 53, 69); border-radius:20px;">
                        <div class="tab-pane fade show active" id="register" role="tabpanel">
                            <h3 class="register-heading pt-4" style="text-align:center; color:white; text-shadow:0px 0px 3px white;">عضویت به عنوان کاربر</h3>

                            <div class="row register-form">
                                <div class="col-md-6">
                                    <div class="form-group m-4" style="box-shadow:0px 0px 2px gray;">
                                        <label for="nameField">نام و نام خانوادگی</label>
                                        <asp:TextBox ID="nameField" runat="server" TextMode="SingleLine" CssClass="form-control"></asp:TextBox>
                                    </div>

                                    <div class="form-group m-4" style="box-shadow:0px 0px 2px gray;">
                                        <label for="usernameField">نام کاربری</label>
                                        <asp:TextBox ID="usernameField" runat="server" TextMode="SingleLine" CssClass="form-control"></asp:TextBox>
                                    </div>

                                    <div class="form-group m-4" style="box-shadow:0px 0px 2px gray;">
                                        <label for="passwordFiled">رمز عبور</label>
                                        <asp:TextBox ID="passwordFiled" runat="server" TextMode="Password" CssClass="form-control"></asp:TextBox>
                                    </div>

                                    <div class="form-group m-4" style="box-shadow:0px 0px 2px gray;">
                                        <label for="passwordRepeatField">تکرار پسورد</label>
                                        <asp:TextBox ID="passwordRepeatField" runat="server" TextMode="Password" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-group m-4" style="box-shadow:0px 0px 2px gray;">
                                        <label for="emailFiled">ایمیل</label>
                                        <asp:TextBox ID="emailField" runat="server" TextMode="Email" CssClass="form-control"></asp:TextBox>
                                    </div>

                                    <div class="form-group m-4" style="box-shadow:0px 0px 2px gray;">
                                        <label for="phonenumberFiled">شماره تماس</label>
                                        <asp:TextBox ID="phonenumberField" runat="server" TextMode="Number" CssClass="form-control"></asp:TextBox>
                                    </div>

                                    <asp:Button ID="SubmitButton" runat="server" Text="عضویت" CssClass="btn btn-primary" OnClick="SubmitButton_Click" />
                                </div>
                            </div>
                        </div>
                    </div>
                </asp:Panel>
            </div>

        </div>
    </div>
</asp:Content>
