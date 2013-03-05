<%@ Page Language="C#" AutoEventWireup="True" CodeBehind="View-Store.aspx.cs"  MasterPageFile="~/Site.master" Inherits="EasyTrackerSolution.ViewStore" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <script src="Scripts/jquery.tmpl.js" type="text/javascript"></script>
    <script src="Scripts/lightbox.js"  type="text/javascript"></script>
    <script src="Scripts/highcharts.js"  type="text/javascript"></script>
    <script src="Scripts/modules/exporting.js"  type="text/javascript"></script>
    
    <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAizK-CoOU44u0bTWzVeUlbMkQ2cHagM9s&amp;sensor=true&amp;language=ch"></script>
    <script src="Public/Libs/Leaflet/leaflet.js" type="text/javascript"></script>
    <script src="Public/Libs/Leaflet/google.js" type="text/javascript"></script>
    <link rel="Stylesheet" href="Public/Libs/Leaflet/leaflet.css" />
    <link rel="stylesheet" type="text/css" href="Public/Styles/lightbox.css" />
    <link href="Public/Styles/chosen.css" rel="stylesheet" type="text/css" />
    <style>
    .img{
	    float:left;
	    text-align:center;
border: 1px solid #E5E5E5;
box-shadow: 0 0 5px rgba(0, 0, 0, .1);
-moz-box-shadow: 0 0 5px rgba(0, 0, 0, .1);
-webkit-box-shadow: 0 0 5px rgba(0, 0, 0, .1);
margin: 9px 0px;
padding: 9px;

	}
    .img img{
	    padding:10px;
	    border:1px solid #fff;
    }
    .img:hover{
	    -webkit-box-shadow:0px 0px 30px #ccc;
    }
    .img .from
    {
        color: #484848;
        display: block;
        line-height: normal;
        padding: 11px 0 0;
    }
    .img .time
    {
        color: #B07070;
font-size: 11px;
cursor: default;
padding: 0 0 11px;
    }
    #map_canvas img {
            max-width: none;
        }
        .nav-head
        {
color: #777;
font: bold 14px/34px 'Helvetica Neue', Helvetica, Arial, Sans-Serif;
border-radius: 5px 5px 0 0;
-moz-border-radius: 5px 5px 0 0;
-webkit-border-radius: 5px 5px 0 0;
padding: 0;
display: block;border:1px solid #ddd;
border-bottom:none;
        }
        .nav-head span
        {background: url(../media/icons/main/icon-nav-head-arrow.png) 92% 50% no-repeat;
color: #777;
display: block;
padding: 0 15px;
height: 34px;}
    </style>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">

<asp:HiddenField ID="hf_today" runat="server" />
<asp:HiddenField ID="hf_yesterday" runat="server" />
<asp:HiddenField ID="hf_last7days" runat="server" />
<asp:HiddenField ID="hf_thisWeek" runat="server" />
<asp:HiddenField ID="hf_lastWeek" runat="server" />
<asp:HiddenField ID="hf_last30days" runat="server" />
<asp:HiddenField ID="hf_thisMonth" runat="server" />
<asp:HiddenField ID="hf_lastMonth" runat="server" />
<asp:HiddenField ID="hf_stats" runat="server" />

	<div class="topContainer">
    <div class="row-fluid">
    <div class="span4">
        <asp:DropDownList ID="ddl_stores" runat="server" DataSourceID="ds_Store" DataTextField="StoreName" DataValueField="StoreId"  class="chzn-select" AutoPostBack="true" OnSelectedIndexChanged="ddl_stores_SelectedIndexChanged">
        </asp:DropDownList>
    </div>
    <div class="span8 form-inline">
            选择日期：
            <input class=" small w8em highlight-days-67 range-low-today" id="txtDateFrom" />
            到
            <input class=" small w8em highlight-days-67 range-low-today" id="txtDateTo" />
            <asp:Button ID="btnSearch" runat="server"  Text="搜索" CssClass="btn btn-primary" OnClick="btnSearch_Click" />
            <asp:HiddenField ID="hf_txtDateFrom" runat="server" />
            <asp:HiddenField ID="hf_txtDateTo" runat="server" />
    </div>
    </div>
    </div>
    <div class="alert alert-block hidden">
            <a class="close" data-dismiss="alert" href="#">×</a>
            <strong>有{0}个新店铺信息更新，点击查看</strong>
    </div>
    <div class="row-fluid">
        <div class="span4">

        <aside>
        <h3 class="nav-head"> <span> 店铺信息 </span> </h3>
        <asp:DetailsView ID="dv_StoreDetails" runat="server" DataSourceID="ds_StoreDetail" AutoGenerateRows="false"
        CssClass="table table-striped table-bordered table-condensed" >
            <Fields>
                <asp:BoundField DataField="StoreName" HeaderText="店铺名称" />
                <asp:TemplateField HeaderText="负责员工">

                    <ItemTemplate>
                        <asp:Repeater ID="rp_userNames" runat="server" DataSource='<%# Eval("AssignedEmployees") %>' >
                            <ItemTemplate>
                                <span class="label label-info"><%# GetDataItem() %></span>
                            </ItemTemplate>
                        </asp:Repeater>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField>
                    <HeaderTemplate>
                        地址
                    </HeaderTemplate>
                    <ItemTemplate>
                        <strong><%# Eval("StoreAddressFirst.City")%>, <%#Eval("StoreAddressFirst.District")%>, <%#Eval("StoreAddressFirst.AddressLine1")%>, <%#Eval("StoreAddressFirst.AddressLine2")%></strong>  
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="latitude" ShowHeader="false" ItemStyle-CssClass="hidden lat" />
                <asp:BoundField DataField="longitude" ShowHeader="false" ItemStyle-CssClass="hidden lng" />
                <asp:TemplateField ShowHeader="false">
                    <ItemTemplate>
                    <div id="map_canvas" style="width: 100%;height:270px;margin-top:10px;"></div>
                    </ItemTemplate>
                </asp:TemplateField>
                
            </Fields>
        </asp:DetailsView>
        </aside>
        <br />

        <aside>
            <h3 class="nav-head"> <span> 员工签到信息 </span> </h3>
            <asp:GridView ID="gv_CheckInHistory" runat="server" OnDataBinding="gv_CheckInHistory_DataBinding" CssClass="table table-bordered table-striped" AutoGenerateColumns="false">
                <Columns>
                    <asp:BoundField DataField="UserFullName" HeaderText="员工姓名" />
                    <asp:BoundField DataField= "Count" HeaderText="报道次数" />
                </Columns>
            </asp:GridView>
        </aside>
        <br />

        <aside>
            <h3 class="nav-head"> <span> 留言板 </span> </h3>
            <asp:GridView ID="gv_Notes" runat="server" ShowHeader="false" CssClass="table table-bordered table-striped" DataSourceID="ds_TaskNotes" AutoGenerateColumns="false" AllowPaging="true" PageSize="5">
            
            <Columns>
                <asp:BoundField DataField="UserFullName" DataFormatString="{0}说:" />
                <asp:BoundField DataField="Notes" DataFormatString=" '{0}'" />
                <asp:BoundField DataField="CreatedAt" DataFormatString=" <i>{0}</i> " HtmlEncode="false" />
            </Columns>
            <HeaderStyle CssClass="success" />
            </asp:GridView>
        </aside>
             
        </div>
        <div class="span8">
        
        <asp:DataList  ID="dl_StorePhotos" runat="server" DataSourceID="ds_StorePhotos" AutoGenerateColumns="false"  RepeatColumns="4" GridLines="None" CellPadding="4"  >
            <ItemTemplate>
                <div class="img">
                <a class="lnk_StorePhotos" rel="lightbox">
                <asp:Image ID="img" runat="server" ImageUrl='<%#  Eval("ImageURL") %>' Width="150" Height="150"  BorderColor="Transparent" BorderWidth="1" />
                </a>
                    <span class="from">来自： <%#Eval("Employee.FullName") %></span>
                    <span class="time">拍摄时间： <em><%#Eval("CreatedAt")%></em> </span>
                    
                </div>
            </ItemTemplate>
            <ItemStyle Width="220" Wrap="false"/>
   
        </asp:DataList>

        <br />
        <ul id="Navigation" class="pager" runat="server">
            <li class="previous">
                <a id="PreviousPageNav" runat="server">&larr; 上一页</a>
            </li>
            <li class="active">
                <a href="javascript:void(0)"> <asp:Label ID="PagerLocation" runat="server" /></a>
            </li>
            <li class="next">
                <a id="NextPageNav" runat="server">下一页 &rarr;</a>
            </li>
        </ul>
        
    </div>
    </div>


<asp:ObjectDataSource ID="ds_StorePhotos" runat="server" 
TypeName="EasyTrackerDomainModel.PhotoLogic" 
SelectMethod="FetchPhotosByStoreId" OnSelected="ds_StorePhotos_Selected" OnSelecting="ds_StorePhotos_Selecting">
    <SelectParameters>
        <asp:ControlParameter Name="storeId" ControlID="ddl_stores" PropertyName="SelectedValue" Type="Int32" DefaultValue="5" />
        <asp:QueryStringParameter Name="StartItemIndex" QueryStringField="pageIndex" DefaultValue="0" Type="Int32" />
        <asp:Parameter Name="MaximumItems" Type="Int32" DefaultValue="12" />
        <asp:Parameter Name="StorePhotosCount" Direction="Output" Type="Int32" />
        <asp:ControlParameter ControlID="hf_txtDateFrom"  Name="FromDate" Type="DateTime" PropertyName="Value" />
        <asp:ControlParameter ControlID="hf_txtDateTo"  Name="ToDate" Type="DateTime" PropertyName="Value"  />
    </SelectParameters>
</asp:ObjectDataSource>
<asp:ObjectDataSource ID="ds_StoreDetail" runat="server" 
TypeName="EasyTrackerDomainModel.StoreRepository" 
SelectMethod="Fetch" >
    <SelectParameters>
        <asp:ControlParameter Name="StoreId" ControlID="ddl_stores" PropertyName="SelectedValue" Type="Int32" DefaultValue="5" />
        
    </SelectParameters>
</asp:ObjectDataSource>
<asp:ObjectDataSource ID="ds_Store" runat="server"
TypeName="EasyTrackerDomainModel.StoreRepository"
SelectMethod="FetchAll">
</asp:ObjectDataSource>


<asp:SqlDataSource ID="ds_ChainStores" runat="server"
ConnectionString="<%$ ConnectionStrings:tracker%>"
SelectCommand="SELECT * FROM location.chainStore"
SelectCommandType="Text"
>
</asp:SqlDataSource>


<asp:ObjectDataSource ID="ds_TaskNotes" runat="server"
TypeName="EasyTrackerDomainModel.CheckInLogic"
SelectMethod="FetchTaskCheckInByStoreId"
 OnSelecting="ds_TaskNotes_Selecting"
>
    <SelectParameters>
        <asp:ControlParameter Name="StoreId" Type="Int32" ControlID="ddl_stores" PropertyName="SelectedValue" DefaultValue="5" />
        <asp:Parameter Name="from" Type="DateTime" /> 
        <asp:Parameter Name="to" Type="DateTime" /> 
    </SelectParameters>
</asp:ObjectDataSource>

<script src="Scripts/view-store.js"></script>
    <script src="Scripts/chosen.jquery.min.js" type="text/javascript"></script>
 <script type="text/javascript">     $(".chzn-select").chosen(); $(".chzn-select-deselect").chosen({ allow_single_deselect: true }); </script>
 
</asp:Content>