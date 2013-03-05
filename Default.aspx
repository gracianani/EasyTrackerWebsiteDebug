<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs"  MasterPageFile="~/Site.master"  Inherits="EasyTrackerSolution.Home" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <script src="Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
    <script src="Scripts/bootstrap-tabs.js" type="text/javascript"></script>
    <script src="Scripts/lightbox.js"></script>
    <link rel="stylesheet" type="text/css" href="Public/Styles/lightbox.css" />

    <style type="text/css">
		body {
			padding-top:40px;
		}
		.container-fluid {
			padding:0!important;
		}
		#dashboard {
		}
		#dashboard.row-fluid [class*="span"] {
			margin-left:0;
		}
		#dashboard.row-fluid .span3 {
			width:25%;
		}
		#dashboard.row-fluid .span6 {
			width:50%;
		}
		#storeFilter,#storeSearch,#storeList {
			padding:20px;
			border-right:1px solid #dedede;
			border-bottom:1px solid #dedede;
		}
		#storeFilter {
			background:#f5f5f5;
		}
		#storeList {
			margin-left:0;
			padding:0;
		}
		#storeList li {
			list-style:none;
		}
		.storeItem {
			position:relative;
			padding:10px 10px;
			border-bottom:1px solid #dedede;
		}
		.storeName,.storeClass,.storeEmployee {
			margin-bottom:0.5em;
		}
		.storeName {
			font-size:1.2em;
		}
		.statusLight {
			width:14px;
			height:14px;
			background:#3b9530;
			position:absolute;
			right:20px;
			top:20px;
			-ms-border-radius:7px;
			-moz-border-radius:7px;
			border-radius:7px;
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
<div class="row-fluid" id="dashboard">
<div class="span3">
    <div id="storeFilter">
        <select>
        <option>全部类别<option>
        </select>
        <select>
        <option>全部系统<option>
        </select>
    </div>
    <div id="storeSearch">
    	<p>在以下 305 个店铺中查找</p>
        <div class="form-inline" >
        <input type="text" />
        <a class="btn btn-primary"><i class="icon-search icon-white"></i></a>
        </div>
    </div>
    <ul id="storeList">
    <li class="storeItem">
    <div class="storeName">官员花鸟鱼虫市场</div>
    <div class="storeDesc"><a href="">A类</a> - <a href="">物美</a> | 负责人：<a href="">赵雅琪</a></div>
    <div class="statusLight status-online"></div>
    </li>
    <li class="storeItem">
    <div class="storeName">新街口物美</div>
    <div class="storeDesc"><a href="">A类</a> - <a href="">物美</a> | 负责人：<a href="">赵雅琪</a></div>
    <div class="statusLight status-online"></div>
    </li>
    <li class="storeItem">
    <div class="storeName">上地华联</div>
    <div class="storeDesc"><a href="">A类</a> - <a href="">物美</a> | 负责人：<a href="">赵雅琪</a></div>
    <div class="statusLight status-online"></div>
    </li>
    </ul>
</div>
<div class="span6">
Map
</div>
<div class="span3">
Employee
</div>
</div>
<div class="row clearfix">
	<div class="span6" id="latest">
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