<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Custom404.aspx.cs" MasterPageFile="~/Site.master"  Inherits="EasyTrackerSolution.Custom404" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
<div class="row clearfix">
    <div class="span10" style="padding:100px 0">
        <div class="span4 right">
            <img src="Public/Images/404-img.png" style="float:right"/>
        </div>
        <div class="span5 left" style="padding-top:40px">
            <h2>不好意思，您所访问的页面不存在！</h2>
            <p>
                <h4>您也许只是想：</h4>
                <ul>
                    <li><a href="Manage-Employee.aspx" ><i class="icon-user"></i> 员工管理</a></li>
                    <li><a href="Manage-Store.aspx"><i class="icon-home"></i> 店铺管理</a></li>
                    <li><a href="Manage-Task.aspx"><i class="icon-list-alt"></i> 任务管理</a></li>
                </ul>
            </p>
        </div>
    </div>
</div>
</asp:Content>