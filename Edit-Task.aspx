<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Edit-Task.aspx.cs" MasterPageFile="~/Site.master" Inherits="EasyTrackerSolution.Edit_Task" %>

<%@ Register Src="~/Controls/Messager.ascx" TagName="Messager" TagPrefix="EasyTracker" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <script src="Scripts/jquery-ui-1.8.18.custom.min.js" type="text/javascript"></script>
    <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAizK-CoOU44u0bTWzVeUlbMkQ2cHagM9s&amp;sensor=true&amp;language=ch"></script>
    <script src="Public/Libs/Leaflet/leaflet.js"></script>
    <script src="Public/Libs/Leaflet/google.js" type="text/javascript"></script>
    <link rel="Stylesheet" href="Public/Libs/Leaflet/leaflet.css" />
 <!--[if lte IE 8]>
 <link rel="Stylesheet" href="Public/Libs/Leaflet/leaflet.ie.css" />
 <![endif]-->
    <style type="text/css">
	   .table tr:first-child td {
		   border-top:none;
	   }
	

		.ui-widget-content .btn-info,
		.ui-widget-content .btn-info:hover {
		  color: #ffffff;
		  font-weight:bold;
		  text-shadow: 0 -1px 0 rgba(0, 0, 0, 0.25);
		}
		#map_canvas img {
		 max-width: none;
        }
    </style>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">

<div class="row-fluid clearfix" >
<div class="span3">
<span>所有的店</span>
<asp:GridView ID="gv_AllStores" runat="server" DataSourceId="ds_AllStores" ShowHeader="false"  AutoGenerateColumns="false" CssClass="table" style="margin-bottom:0px; border-left:0px transparent; border-right:0px transparent; border-bottom:0px trasparent">
    <Columns>
        <asp:BoundField DataField="ChainStoreName"/>
        <asp:BoundField DataField="StoreName" />
    </Columns>
    
</asp:GridView>
</div>
<div class="span3">
<span>该员工负责的店</span>
<asp:GridView ID="gv_Tasks" runat="server" DataSourceId="ds_Store" AutoGenerateColumns="false" ShowHeader="false" CssClass="table" style="margin-bottom:0px; border-left:0px transparent; border-right:0px transparent; border-bottom:0px trasparent">
    <Columns>
        <asp:BoundField DataField="ChainStoreName" />
        <asp:BoundField DataField="StoreName" />
    </Columns>
</asp:GridView>
</div>
</div>
<asp:ObjectDataSource ID="ds_AllStores" runat="server" TypeName="EasyTrackerDomainModel.StoreLogic" SelectMethod="Fetch">
    <SelectParameters>
        <asp:Parameter Name="storeID" Type="Int32" DefaultValue="0"/>
    </SelectParameters>
</asp:ObjectDataSource>
<asp:ObjectDataSource ID="ds_Store" runat="server" 
    TypeName="EasyTrackerDomainModel.TaskLogic" SelectMethod="FetchByUserId"  >
        <SelectParameters>
            <asp:QueryStringParameter Name="userId" Type="Int32" QueryStringField="userId"/>
        </SelectParameters>
    </asp:ObjectDataSource>
</asp:Content>
