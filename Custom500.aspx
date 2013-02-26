<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Custom500.aspx.cs" MasterPageFile="~/Site.master"  Inherits="EasyTrackerSolution.Custom500" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
<div class="row clearfix">
    <div class="span10" style="padding:100px 0">
        <div class="span4 right">
            <img src="Public/Images/404-img.png" style="float:right"/>
        </div>
        <div class="span5 left" style="padding-top:40px">
            <h2>页面出错了！</h2>
            <p>
                <h4>对不起，页面出错了！</h4>
            </p>
            <a class="btn btn-large btn-danger" href="Default.aspx">返回</a>
        </div>
    </div>
</div>
</asp:Content>