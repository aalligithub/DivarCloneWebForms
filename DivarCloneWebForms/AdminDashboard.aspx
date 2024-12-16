<%@ Page Language="C#" MasterPageFile="Site.Master" AutoEventWireup="true" CodeBehind="AdminDashboard.aspx.cs" Inherits="DivarCloneWebForms.AdminDashboard" %>

<asp:Content ID="AdminDashboard" ContentPlaceHolderID="AdminDashboardPlaceHolder" runat="server">
    <div class="container mt-4" id="adminDash">
        <div class="card shadow-lg">
            <div class="card-header bg-primary text-white">
                <h4 class="mb-0">User Management</h4>

                <div class="input-group mt-2" style="width:300px;">
                    <input id="username-search" type="text" class="form-control" placeholder="کاربر" aria-label="Recipient's username" aria-describedby="button-addon2">
                    <button class="btn" type="button" id="button-addon2" onclick="SearchForUser(document.getElementById('username-search').value)" style="background-color:red; color:white;">جست و جو</button>
                </div>
                    </div>

            <div class="card-body p-4">
                <ol class="list-group list-group-flush" id="users-container">
                    <%-- Partial --%>

            <li class="list-group-item d-flex justify-content-between align-items-start py-3 border-bottom">
            <div class="ms-2">
                <h5 class="fw-bold">@user.Username</h5>
                <p class="mb-1"><i class="bi bi-envelope-fill"></i>ایمیل : @user.Email</p>
                <p class="mb-1"><i class="bi bi-person-badge-fill"></i> نقش: <span class="badge bg-info text-dark">@user.Role</span></p>

                <div class="mt-2">
                    <h6 class="fw-bold">اجازه ها:</h6>
                    <div class="border rounded p-2" style="background-color:lightgray;">
                        @foreach (var permission in @user.Permissions)
                        {
                            <span class="badge bg-primary text-white me-1" style="font-size: 0.90rem;">@permission</span>
                        }
                    </div>
                </div>

                @if (@user.SpecialPermissions.Count >= 1)
                {
                    <div class="mt-2">
                        <h6 class="fw-bold">اجازه خاص:</h6>
                        <div class="border rounded p-2" style="background-color:lightgray;">
                            @foreach (var specialPermission in @user.SpecialPermissions)
                            {
                                <div class="container">
                                    <span class="badge bg-danger text-white me-1" style="font-size: 0.90rem;">@specialPermission</span>
                                    <button onclick="RemoveUserSpecialPermission('@specialPermission', @user.ID, '@user.Username')">حذف</button>
								</div>
                            }
                        </div>
                    </div>
                }

                <!-- Dropdown for Role Change -->
                <div class="mt-3">
                    <h6 class="fw-bold">تغییر نقش:</h6>
                    <div class="dropdown">
                        <button class="btn btn-secondary dropdown-toggle" type="button" id="roleDropdown-@user.ID" data-bs-toggle="dropdown" aria-expanded="false">
                            انتخاب نقش
                        </button>
                        <ul class="dropdown-menu" aria-labelledby="roleDropdown-@user.ID">
                            @foreach (var role in roles)
                            {
                                <li>
                                    <a class="dropdown-item" href="javascript:void(0)" style="outline:solid;" onclick="ChangeUserRole(@role.Key, @user.ID, '@user.Username')">@role.Value</a>
                                </li>
                            }
                        </ul>
                    </div>
                </div>

                <!-- Dropdown for Special Permissions -->
                <div class="mt-3">
                    <h6 class="fw-bold">دادن اجازه خاص:</h6>
                    <div class="dropdown">
                        <button class="btn btn-secondary dropdown-toggle" type="button" id="permissionDropdown-@user.ID" data-bs-toggle="dropdown" aria-expanded="false">
                            انتخاب اجازه
                        </button>
                        <ul class="dropdown-menu" aria-labelledby="permissionDropdown-@user.ID">
                            @foreach (var permission in permissions)
                            {
                                <li>
                                    <a class="dropdown-item" href="javascript:void(0)" style="outline:solid;" onclick="GiveUserSpecialPermission(@permission.Key, @user.ID, '@user.Username')">@permission.Value</a>
                                </li>
                            }
                        </ul>
                    </div>
                </div>
            </div>
        </li>
                    <%-- Partial --%>
                </ol>
            </div>

        </div>
    </div>
</asp:Content>
