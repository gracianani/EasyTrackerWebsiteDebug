<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs"  MasterPageFile="~/Site.master"  Inherits="EasyTrackerSolution.Home" %>
<%@ Register Assembly="EasyTrackerServerControl" TagPrefix="ET" 
        Namespace="EasyTrackerServerControl"%>
<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <script src="Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
    <script src="Scripts/bootstrap-tabs.js" type="text/javascript"></script>
    <script src="Scripts/lightbox.js"></script>
    <link rel="stylesheet" type="text/css" href="Public/Styles/lightbox.css" />

    <style type="text/css">
        #employee table input
        {
            max-width:100px;
        }
		.latest_block {
			margin:10px 0;
			padding:15px 150px 15px 15px;
			background:whiteSmoke;
			position:relative;
			overflow:hidden;
			border:1px solid #eee;
		  	-webkit-border-radius: 4px;
			 -moz-border-radius: 4px;
				  border-radius: 4px;
		}
		.latest_block:nth-child(odd) {
			background:#F9F9F9;
		}
		.latest_block p {
			font-size:1.2em;
		}
		.latestPhoto_img {
			float:right;
			display:inline-block;
			max-width:100px;
			max-height:100px;
			_width:150px;
			_height:90px;
			position:absolute;
			top:5px;
			right:15px;
			background-color:white;
			padding:3px;
			border:1px solid #DEDEDE;
	  		-webkit-box-shadow:  0 1px 1px rgba(0, 0, 0, 0.05);
			 -moz-box-shadow:  0 1px 1px rgba(0, 0, 0, 0.05);
				  box-shadow:  0 1px 1px rgba(0, 0, 0, 0.05);
			transform: rotate(10deg);
				-o-transform: rotate(10deg);
				-webkit-transform: rotate(10deg);
 				-moz-transform: rotate(10deg);
		}
		.time {
			font-size:0.6666em;
			color:#999;
		}
    </style>

    <script>
        $(document).ready(function () {
            $('.lnk_StorePhotos').each(function () {
                var imgSrc = $(this).children("img").attr('src');
                $(this).attr('href', imgSrc);
            });
        });
    </script>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
<div class="row clearfix">
	<div class="span6" id="latest">
    	<h2>最新动态</h2>
        <asp:Repeater ID="rpt_Latest1" runat="server" OnItemDataBound="rpt_Latest_ItemDataBound" >
            <ItemTemplate>
            <div class="latest_block checkin">
        	    <p>
                <asp:Literal ID="lt_icon" runat="server" Mode="PassThrough" Text='<i class="icon-flag"></i>'></asp:Literal> 
                <a href='View-Employee-Leaflet.aspx?EmployeeId=<%#Eval("UserId")%>'><%#Eval("UserFullName")%></a> 
                <asp:Literal ID="lt_description1" runat="server" ClientIDMode="Static" Text=" 在 "></asp:Literal>
                <a href='View-Store.aspx?StoreId=<%#Eval("StoreId")%>'><%#Eval("StoreName")%></a>
                <asp:Literal ID="lt_description2" runat="server" ClientIDMode="Static" Text=" 踩点 "></asp:Literal>
                <span class="time"><%#Eval("CreatedAt")%></span>
                </p>
                <asp:LinkButton ID="photo" runat="server" ClientIDMode="Static" rel="lightBox" PostBackUrl='<%#Eval("PhotoUrl") %>' Visible="false" CssClass="lnk_StorePhotos" >
                    <img class="latestPhoto_img" src='<%#Eval("PhotoUrl") %>' />
                </asp:LinkButton>
            </div>
        </ItemTemplate>
        </asp:Repeater>
    </div>
    <div class="span6">
        <div class="well">
            <p><big>快捷操作</big></p>
            <hr />
            <div>
            <a href="Manage-Employee.aspx" class="btn"><i class="icon-user"></i> 员工管理</a>
            <a href="Manage-Store.aspx" class="btn"><i class="icon-home"></i> 店铺管理</a>
            <a href="Manage-Task.aspx" class="btn"><i class="icon-list-alt"></i> 任务管理</a>
            </div>
        </div>
    </div>
    <div class="span6">
        <div class="well">
           <p><big>相关下载</big></p>
            <hr />
            <div>
                <strong> Android 客户端程序 </strong>
                <p>更新日期 : 2012年10月17日</p>
                <asp:LinkButton ID="btn_download" runat="server" CssClass="btn btn-primary btn-large"  OnClick="btn_download_Click"><i class="icon-download-alt icon-white"></i>立即下载</asp:LinkButton>
            </div>
        </div>
    </div>
</div>
</asp:Content>