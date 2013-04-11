<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs"  MasterPageFile="~/Site.master"  Inherits="EasyTrackerSolution.Home" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
  <script src="Scripts/lightbox.js"></script>
  <script src="Scripts/jquery.tmpl.js"></script>
  <script src="Public/Libs/Leaflet/leaflet.js"  type="text/javascript"> </script>
  <script src="http://maps.googleapis.com/maps/api/js?key=AIzaSyAizK-CoOU44u0bTWzVeUlbMkQ2cHagM9s&sensor=false&amp;language=ch"  type="text/javascript"></script>
  <script src="Public/Libs/Leaflet/google.js" type="text/javascript"></script>
  <script src="Scripts/jsonpath-0.8.0.js"></script>
  <link rel="Stylesheet" href="Public/Libs/Leaflet/leaflet.css" />
  <link rel="stylesheet" type="text/css" href="Public/Styles/lightbox.css" />
  <!--[if lte IE 8]>
     <link rel="Stylesheet" href="Public/Libs/Leaflet/leaflet.ie.css" />
     <![endif]-->
  <style type="text/css">
html {
	height:100%;
	overflow:hidden;
}
body {
	padding-top:0;
	padding-bottom:0;
}
form {
	margin-bottom:0!important;
}
.container-fluid {
	padding:0!important;
}
body, .container-fluid, .row-fluid {
	min-width:1000px;
}
.navbar-fixed-top {
	position:static!important;
	margin-bottom:0!important;
}
#employeeContainer, #storeList {
	overflow-y:scroll;
}
#dashboard {
}
 #dashboard.row-fluid [class*="span"] {
 margin-left:0;
 float:left;
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
#storeFilter, #storeSearch, #storeList {
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
#storeList, #employeeList {
	margin-left:0;
	padding:0;
}
.storeItem, .employeeItem {
	position:relative;
	padding:10px 10px;
	border-bottom:1px solid #dedede;
	list-style:none;
	cursor:pointer;
}
.employeeItem {
	padding-left:30px;
}
.employeeItem h4 {
	color:#333;
}
.storeName, .storeClass, .storeEmployee {
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
.employeeIcons, .storeIcons {
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
#latest {
	position:absolute;
	right:5px;
	top:5px;
	z-index:9999;
	width:30%;
	overflow:hidden;
}
#latest .alert-block {
	margin-bottom:0;
}
.latest_block {
	margin:5px 0;
	padding:5px;
	background:rgba(255, 255, 255, 0.9);
	position:relative;
	overflow:hidden;
	border:1px solid #eee;
	-webkit-border-radius: 4px;
	-moz-border-radius: 4px;
	border-radius: 4px;
}
 .latest_block:nth-child(odd) {
 background:rgba(255, 255, 255, 0.8);
}
.latest_block p {
	padding-right:50px;
}
.latestPhoto_img {
	float:right;
	display:inline-block;
	max-width:60px;
	max-height:60px;
	_width:100px;
	_height:60px;
	position:absolute;
	top:5px;
	right:5px;
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
.highLight {
	background:#ecf4fa;
}
.leaflet-container a.btn-primary {
	color:#FFF;
}
.info {
	padding: 6px 8px;
	font: 14px/16px Arial, Helvetica, sans-serif;
	background: white;
	background: rgba(255, 255, 255, 0.8);
	box-shadow: 0 0 15px rgba(0, 0, 0, 0.2);
	border-radius: 5px;
}
.info h4 {
	margin: 0 0 5px;
	color: #777;
}
.leaflet-popup-content p {
	margin:10px 0;
}
#popup-storeDetail p {
	margin:5px 0 0;
}
#popup-storeDetail-photos {
	height:60px;
}
#popup-storeDetail-photos img {
	float:left;
	display:inline-block;
	height:60px;
	margin-right:5px;
	border:2px solid #FFF;
	box-shadow:0 0 4px #999;
}
.employeeDetail {
	margin-top:5px;
	display:none;
}
.highLight .employeeDetail {
	display:block;
}
.employeeDetail p {
	margin-bottom:5px;
}
</style>
  <script>

    </script>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
<div class="row-fluid" id="dashboard">
<div class="span3" id="storeContainer">
    <div id="storeFilter">
    <select id="ImportanceLevel">
        <option selected="selected" value="0">全部类别</option>
        <option value="1">A类</option>
        <option value="2">B类</option>
        <option value="3">C类</option>
        <option value="4">D类</option>
    
    </select>
    <select id="ChainStoreNames">
	<option selected="selected" value="0">全部系统</option>
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
    <option value="11">美廉美</option>
    </select>
    </div>
    <ul id="storeList">
    <li class="storeItem"><img src="Public/Styles/images/loading.gif"> 正在获取数据</li>
    </ul>
</div>
<div class="span7" style="position:relative">
<div id="map_canvas" style="width: 100%;height:500px"></div>
<div id="latest">
<div class="alert" style="display:none">有3条新数据</div>
        <asp:Repeater ID="rpt_Latest1" runat="server" OnItemDataBound="rpt_Latest_ItemDataBound" >
            <ItemTemplate>
            <div class="latest_block checkin">
            	<div class="time"><%#Eval("CreatedAt")%></div>
        	    <p>
                <asp:Literal ID="lt_icon" runat="server" Mode="PassThrough" Text='<i class="icon-flag"></i>'></asp:Literal> 
                <a target="_blank" href='View-Employee-Leaflet.aspx?EmployeeId=<%#Eval("UserId")%>'><%#Eval("UserFullName")%></a> 
                <asp:Literal ID="lt_description1" runat="server" ClientIDMode="Static" Text=" 在 "></asp:Literal>
                <a target="_blank" href='View-Store.aspx?StoreId=<%#Eval("StoreId")%>'><%#Eval("StoreName")%></a>
                <asp:Literal ID="lt_description2" runat="server" ClientIDMode="Static" Text=" 踩点 "></asp:Literal>
                </p>
                <asp:LinkButton ID="photo" runat="server" ClientIDMode="Static" rel="lightBox" PostBackUrl='<%#Eval("PhotoUrl") %>' Visible="false" CssClass="lnk_StorePhotos" >
                    <img class="latestPhoto_img" src='<%#Eval("PhotoUrl") %>' />
                </asp:LinkButton>
            </div>
        </ItemTemplate>
        </asp:Repeater>
</div>
</div>
<div class="span2" id="employeeContainer">
	<ul id="employeeList">
    	<li class="employeeItem"><img src="Public/Styles/images/loading.gif"> 正在获取数据</li>
    </ul>
</div>
</div>
<script id="employeeListTemplate" type="text/x-jquery-tmpl">
<li class="employeeItem" data-id="${id}">
{{if status>1 }}
<div class="statusLight status-active"></div>
{{else check>0 }}
<div class="statusLight status-active"></div>
{{else}}
<div class="statusLight status-offline"></div>
{{/if}}
<div class="employeeName">${name}</div>
<div class="employeeDetail">
<p>今日地理位置${check}个，提交图片${photo}张</p>
<p>负责店铺：${store.length} 个</p>
<p><a href="/View-Employee-Leaflet.aspx?EmployeeId=${id}" class="btn btn-primary"  target="_blank" title="详细信息"><i class="icon-list-alt icon-white"></i></a> <a href="/Edit-Employee.aspx?userId=${id}" target="_blank" class="btn btn-inverse" title="编辑资料"><i class="icon-pencil icon-white"></i></a> <a href="/Manage-Task.aspx" class="btn btn-inverse" target="_blank" title="添加任务"><i class="icon-plus icon-white"></i></a></p>
</div>
<div class="employeeIcons">
	{{if check>0}}
		<i class="icon-ok" title="足迹${check}个"></i> 
	{{/if}}
	{{if photo>0}}
		<i class="icon-picture" title="已提交${photo}张图片"></i> 
	{{/if}}
</div>
</li>
</script>
<script id="storeListTemplate" type="text/x-jquery-tmpl">
<li class="storeItem" data-id="${id}">
    <div class="storeName">${name}</div>
    <div class="storeDesc">${lvl} | ${chn} | 
	{{each manager}}
	<a href="/View-Employee-Leaflet.aspx?EmployeeId=${id}" target="_blank">${name}</a> 
	{{/each}}
	</div>
	<div class="storeIcons">
	{{if check>0}}
		<i class="icon-ok"></i> 
	{{/if}}
	{{if photo>0}}
		<i class="icon-picture"></i> 
	{{/if}}
	</div>
</li>
</script>
<script type="text/javascript" src="Scripts/default.js"></script>
<script type="text/javascript" src="Scripts/leaflet/default-leaflet.js"></script>

</asp:Content>
