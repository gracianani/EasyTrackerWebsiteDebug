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
<asp:Button ID="btn_AddToTask" runat="server" Text="添加选中的店" OnClick="btn_AddToTask_Click" />
<asp:GridView ID="gv_AllStores" runat="server" DataSourceId="ds_AllStores" ShowHeader="false" DataKeyNames="StoreId"  AutoGenerateColumns="false" CssClass="table" style="margin-bottom:0px; border-left:0px transparent; border-right:0px transparent; border-bottom:0px trasparent">
    <Columns>
        <asp:BoundField DataField="ChainStoreName"/>
        <asp:BoundField DataField="StoreName" />
        <asp:TemplateField >
            <ItemTemplate>
                <asp:HiddenField ID="hf_Latitude" runat="server" Value='<%# Eval("Latitude") %>' />
                <asp:HiddenField ID="hf_Longitude" runat="server" Value='<%# Eval("Longitude") %>' />
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField>
            <ItemTemplate>
                <asp:CheckBox ID="cbk_AddToTask" runat="server" />
            </ItemTemplate>
        </asp:TemplateField>

    </Columns>
    
</asp:GridView>
</div>
<div class="span3">
<span>该员工负责的店</span>
<asp:Button ID="btn_RemoveFromTask" runat="server" Text="删除选中的店" OnClick="btn_RemoveFromTask_Click" />
<asp:GridView ID="gv_Tasks" runat="server" DataSourceId="ds_Store" AutoGenerateColumns="false" DataKeyNames="TaskId"   ShowHeader="false" CssClass="table" style="margin-bottom:0px; border-left:0px transparent; border-right:0px transparent; border-bottom:0px trasparent">
    <Columns>
        <asp:BoundField DataField="ChainStoreName" />
        <asp:BoundField DataField="StoreName" />
       <asp:TemplateField >
            <ItemTemplate>
                <asp:HiddenField ID="hf_Latitude" runat="server" Value='<%# Eval("Latitude") %>' />
                <asp:HiddenField ID="hf_Longitude" runat="server" Value='<%# Eval("Longitude") %>' />
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField>
            <ItemTemplate>
                <asp:CheckBox ID="cbk_RemoveFromTask" runat="server" />
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
</asp:GridView>
</div>
</div>
<asp:ObjectDataSource ID="ds_AllStores" runat="server" TypeName="EasyTrackerDomainModel.StoreLogic" SelectMethod="FetchByUserId">
    <SelectParameters>
        <asp:QueryStringParameter Name="userId" Type="Int32" QueryStringField="userId"/>
        <asp:Parameter Name="excludeExsiting" Type="Boolean" DefaultValue="true" />
    </SelectParameters>
</asp:ObjectDataSource>
<asp:ObjectDataSource ID="ds_Store" runat="server" 
    TypeName="EasyTrackerDomainModel.TaskLogic" SelectMethod="FetchByUserId"  >
        <SelectParameters>
            <asp:QueryStringParameter Name="userId" Type="Int32" QueryStringField="userId"/>
        </SelectParameters>
    </asp:ObjectDataSource>
</asp:Content>
