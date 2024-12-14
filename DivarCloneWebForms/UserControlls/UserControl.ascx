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
        <a href="#" class="list-group-item list-group-item-action user-control-menu">آگهی های من</a>

		<a href="#" class="list-group-item list-group-item-action user-control-menu">آگهی های خاص</a>

        <a href="#" class="list-group-item list-group-item-action user-control-menu">داشبورد ادمین</a>

	</div>
</div>