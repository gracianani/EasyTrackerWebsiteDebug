<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs"  MasterPageFile="~/Site.master"  Inherits="EasyTrackerSolution.Home" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <script src="Scripts/lightbox.js"></script>
    <script src="Scripts/jquery.tmpl.js"></script>
    <script src="Public/Libs/Leaflet/leaflet.js"  type="text/javascript"> </script>   
    <script src="http://maps.googleapis.com/maps/api/js?key=AIzaSyAizK-CoOU44u0bTWzVeUlbMkQ2cHagM9s&sensor=false&amp;language=ch"  type="text/javascript"></script>  
    <script src="Public/Libs/Leaflet/google.js" type="text/javascript"></script>
    <link rel="Stylesheet" href="Public/Libs/Leaflet/leaflet.css" />
    <link rel="stylesheet" type="text/css" href="Public/Styles/lightbox.css" />
     <!--[if lte IE 8]>
     <link rel="Stylesheet" href="Public/Libs/Leaflet/leaflet.ie.css" />
     <![endif]-->
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
		#dashboard.row-fluid .span7 {
			width:58.33333333%;
		}
		#dashboard.row-fluid .span2 {
			width:16.66666667%;
		}
		#storeFilter,#storeSearch,#storeList {
			padding:20px;
			border-right:1px solid #dedede;
			border-bottom:1px solid #dedede;
		}
		#employeeList {
			border-left:1px solid #dedede;
		}
		#storeFilter {
			background:#f5f5f5;
		}
		#storeList,#employeeList {
			margin-left:0;
			padding:0;
		}
		.storeItem,.employeeItem {
			position:relative;
			padding:10px 10px;
			border-bottom:1px solid #dedede;
			list-style:none;
		}
		.employeeItem {
			padding-left:30px;
		}
		.storeName,.storeClass,.storeEmployee {
			margin-bottom:0.5em;
		}
		.storeName {
			font-size:1.2em;
		}
		.statusLight {
			width:12px;
			height:12px;
			position:absolute;
			left:10px;
			top:12px;
			-ms-border-radius:6px;
			-moz-border-radius:6px;
			border-radius:6px;
			background:whitesmoke
		}
		.employeeIcons,.storeIcons{
			position:absolute;
			top:10px;
			right:10px;
		}
		#map_canvas img {
            max-width: none;
        }
		#map_canvas input {
			display:inline;
		}
		.status-active {
			background:#3b9530;
		}
		.status-online {
			background:#ffc801;
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
    <select id="ImportanceLevel">
        <option selected="selected" value="0">全部</option>
        <option value="1">A类</option>
        <option value="2">B类</option>
        <option value="3">C类</option>
        <option value="4">D类</option>
    
    </select>
    <select id="ChainStoreNames">
	<option selected="selected" value="0">全部</option>
	<option value="1">物美</option>
	<option value="2">京客隆</option>
	<option value="3">乐购</option>
	<option value="4">永辉</option>
	<option value="5">华普</option>
	<option value="6">天虹</option>
	<option value="7">世纪联华</option>
	<option value="8">华润万家</option>
	<option value="9">7-Eleven</option>
	<option value="10">超市发</option>
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
    </ul>
</div>
<div class="span7">
<div id="map_canvas" style="width: 100%;height:500px">
</div>
</div>
<div class="span2">
	<ul id="employeeList">
    </ul>
</div>
</div>
<script id="employeeListTemplate" type="text/x-jquery-tmpl">
<li class="employeeItem"
{{if !show}}
 	style="display:none"
{{/if}}
>
{{if status>0 }}
<div class="statusLight status-active"></div>
{{else check>0 }}
<div class="statusLight status-online"></div>
{{else}}
<div class="statusLight status-offline"></div>
{{/if}}
<div class="employeeName">${name}</div>
<div class="employeeIcons">
	{{if check>0}}
		<i class="icon-ok"></i> 
	{{/if}}
	{{if photo>0}}
		<i class="icon-picture"></i> 
	{{/if}}
	{{if msg>0}}
		<i class="icon-comment"></i> 
	{{/if}}
	</div>
</li>
</script>
<script id="storeListTemplate" type="text/x-jquery-tmpl">
<li class="storeItem"
{{if !show}}
 	style="display:none"
{{/if}}
>
    <div class="storeName">${name}</div>
    <div class="storeDesc"><a href="">${lvl}</a> | <a href="">${chn}</a> | 
	{{each manager}}
	<a href="">${name}</a> 
	{{/each}}
	</div>
	<div class="storeIcons">
	{{if check>0}}
		<i class="icon-ok"></i> 
	{{/if}}
	{{if photo>0}}
		<i class="icon-picture"></i> 
	{{/if}}
	{{if msg>0}}
		<i class="icon-comment"></i> 
	{{/if}}
	</div>
</li>
</script>
<script type="text/javascript" src="Scripts/default.js"></script>
<script type="text/javascript" src="Scripts/leaflet/default-leaflet.js"></script>

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
    
    
</div>
</asp:Content>
