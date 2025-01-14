﻿<%@ Page Language="C#" MasterPageFile="Site.Master" AutoEventWireup="true" CodeBehind="AdminDashboard.aspx.cs" Inherits="DivarCloneWebForms.AdminDashboard" %>

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
<asp:Repeater ID="rptUsers" runat="server">
    <ItemTemplate>
        <li class="list-group-item d-flex justify-content-between align-items-start py-3 border-bottom">
            <div class="ms-2">
                <h5 class="fw-bold"><%# Eval("Username") %></h5>
                <p class="mb-1">
                    <i class="bi bi-envelope-fill"></i> ایمیل: <%# Eval("Email") %>
                </p>
                <p class="mb-1">
                    <i class="bi bi-person-badge-fill"></i> نقش: 
                    <span class="badge bg-info text-dark"><%# Eval("Role") %></span>
                </p>

                <!-- Permissions -->
                <div class="mt-2">
                    <h6 class="fw-bold">اجازه ها:</h6>
                    <div class="border rounded p-2" style="background-color:lightgray;">
                        <%# 
                            string.Join(" ", 
                            ((List<string>)Eval("Permissions")).Select(p =>
                                $"<span class='badge bg-primary text-white me-1' style='font-size: 0.90rem;'>{p}</span>"
                            ))
                        %>
                    </div>
               
                    <asp:Button ID="btnAdmin" runat="server" Text="Admin"
                        OnClick="ChangeUserRole_Click" CommandArgument='<%# Eval("Id") + ",Admin" %>' />

                    <asp:Button ID="btnRegularUser" runat="server" Text="Regular User"
                        OnClick="ChangeUserRole_Click" CommandArgument='<%# Eval("Id") + ",RegularUser" %>' />

                    <asp:Button ID="btnPrivilegedUser" runat="server" Text="Privileged User"
                        OnClick="ChangeUserRole_Click" CommandArgument='<%# Eval("Id") + ",PrivilegedUser" %>' />

                    <asp:Button ID="btnBlankUser" runat="server" Text="Blank User"
                        OnClick="ChangeUserRole_Click" CommandArgument='<%# Eval("Id") + ",BlankUser" %>' />

                </div>
            </div>
        </li>
    </ItemTemplate>
</asp:Repeater>


    </ol>
</div>


        </div>
    </div>
</asp:Content>
