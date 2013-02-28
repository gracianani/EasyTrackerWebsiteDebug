<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="View-Store-All.aspx.cs" MasterPageFile="~/Site.master" Inherits="EasyTrackerSolution.View_Store_All" %>
<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <script src="Scripts/jquery.tmpl.js" type="text/javascript"></script>
    <script src="Scripts/lightbox.js"></script>
    <script src="Scripts/highcharts.js"></script>
    <script src="Scripts/modules/exporting.js"></script>
    <script src="Public/Libs/Leaflet/leaflet.js"></script>
    <script src="http://maps.googleapis.com/maps/api/js?key=AIzaSyAizK-CoOU44u0bTWzVeUlbMkQ2cHagM9s&sensor=false&amp;language=ch"  type="text/javascript"></script>  
    <script src="Public/Libs/Leaflet/google.js" type="text/javascript"></script>
    <script scc="Scripts/view-store-all.js" type="text/javascript"></script>
    <link rel="Stylesheet" href="Public/Libs/Leaflet/leaflet.css" />
 <!--[if lte IE 8]>
 <link rel="Stylesheet" href="Public/Libs/Leaflet/leaflet.ie.css" />
 <![endif]-->
    <link rel="stylesheet" type="text/css" href="Public/Styles/lightbox.css" />
    <style>
    .img{
	    float:left;
	}
    .img img{
	    padding:10px;
	    border:1px solid #fff;
    }
    .img:hover{
	    -webkit-box-shadow:0px 0px 30px #ccc;
    }
    .img p
    {
        text-align:center;
    }
    #map_canvas img {
            max-width: none;
        }
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

<div class="row-fluid clearfix well">
    <fieldset>
			<div class="form-inline">
			<label>类别</label>
                <asp:DropDownList ID="ddl_ImportanceLevel" runat="server" >
                    <asp:ListItem Text="全部" Value='0'></asp:ListItem>
                    <asp:ListItem Text="A类" Value='1'></asp:ListItem>
                    <asp:ListItem Text="B类" Value='2'></asp:ListItem>
                    <asp:ListItem Text="C类" Value='3'></asp:ListItem>
                    <asp:ListItem Text="D类" Value='4'></asp:ListItem>
                </asp:DropDownList>

			<label>系统</label>
              <asp:DropDownList ID="ddl_ChainStoreNames" DataTextField="ChainStoreName" DataValueField="ChainStoreId" 
              runat="server" DataSourceID="ds_ChainStores" AppendDataBoundItems="true">
                <asp:ListItem Text="全部" Value="0"> </asp:ListItem>
              </asp:DropDownList>

           <label>关键字</label>
              <asp:TextBox ID="tb_SearchMany" runat="server" ></asp:TextBox>
              <asp:Button ID="btn_SearchMany" runat="server" CssClass="btn btn-info" OnClick="btn_SearchMany_Click"  Text="搜索"/>
          
    		</div>
    </fieldset>

</div>

<div class="row clearfix">
    <div class="span3">
	<h3>店铺列表</h3>
    <div class="well" style="overflow:scroll;height:700px">
    <asp:Literal ID="lt_searchResultDescription" runat="server" Text="没有符合您搜索条件的店铺" Visible="false"></asp:Literal>
    <asp:Repeater ID="rpt_storesMany" runat="server" >
        <ItemTemplate>
            <ul class="storeList">
    	        <li class="storeList-item">
        	        <p><big><a href='View-Store.aspx?StoreId=<%#Eval("StoreId") %>'><i class="icon-home"></i> <%# Eval("StoreName") %></a></big></p>
                    <p class="gray">类别:<a href=""> <%# Eval("ImportanceLevelDescription")%> </a> 系统:<a href='View-Store.aspx?StoreId=<%#Eval("StoreId") %>'><%# Eval("ChainStoreName")%></a> </p>
                    <p class="gray"> 负责人:<a href="View-Employee.aspx?UserId=<%#Eval("ManagerId") %>"><%# Eval("ManagerName") %></a> </p>
                    <p class="hidden"> <lat><%# Eval("Latitude") %></lat><lng><%# Eval("Longitude") %></lng></p>
                </li>
            </ul>
        </ItemTemplate>
    </asp:Repeater>
    </div>
    </div>
    <div class="span9">
        
        <ul class="nav nav-tabs" id="storesTabs">
          <li class="active"><a href="#map" id="tab_map">地图</a></li>
          <li><a href="#info" id="tab_info">统计信息</a></li>
        </ul>
        
        <div class="tab-content">
          <div class="tab-pane active" id="map">
            <div id="map_canvas"  style="width: 100%;height:700px"></div>
          </div>
          <div class="tab-pane" id="info">
          <h3>统计范围</h3>
          <p>店铺数：<asp:Label ID="lb_SearchedCount" runat="server"></asp:Label></p>
          <h3>近期统计</h3>
          <table id="summary" class="table table-bordered table-striped">
          </table>
          <script id="summaryTemplate" type="text/x-jquery-tmpl">
              <thead>
                <tr>
                  <th>#</th>
                  <th>时间范围</th>
                  <th>报道次数</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td rowspan="2">日统计</td>
                  <td>今日</td>
                  <td>${Today}</td>
                </tr>
                <tr>
                  <td>昨日</td>
                  <td>${Yesterday}</td>
                </tr>
                <tr>
                  <td rowspan="3">周统计</td>
                  <td>最近7天</td>
                  <td>${Last7Days}</td>
                </tr>
                <tr>
                  <td>本自然周</td>
                  <td>${ThisWeek}</td>
                </tr>
                <tr>
                  <td>上一自然周</td>
                  <td>${LastWeek}</td>
                </tr>
                <tr>
                  <td rowspan="3">月统计</td>
                  <td>最近30天</td>
                  <td>${Last30Days}</td>
                </tr>
                <tr>
                  <td>本自然月</td>
                  <td>${ThisMonth}</td>
                </tr>
                <tr>
                  <td>上一自然月</td>
                  <td>${LastMonth}</td>
                </tr>
              </tbody>
            </script>
            <h3>历史统计</h3>
       		<p><a href="" class="btn btn-success">点击获取</a></p>
            <div id="flowchart" style="width:100%"></div>
          </div>
        </div> 
    </div>
</div>


<asp:ObjectDataSource ID="ds_Store" runat="server"
TypeName="EasyTrackerDomainModel.StoreRepository"
SelectMethod="FetchAll">
</asp:ObjectDataSource>

<asp:ObjectDataSource ID="ds_StoreMany" runat="server"
TypeName="EasyTrackerDomainModel.StoreLogic"
SelectMethod="FetchByCategory"
OnSelected="ds_StoreMany_Selected"
>
    <SelectParameters>
        <asp:ControlParameter Name="StoreImportanceLevel" Type="Int16" ControlID="ddl_ImportanceLevel" PropertyName="SelectedValue" DefaultValue="4" />
        <asp:ControlParameter Name="ChainStoreId" ControlID="ddl_ChainStoreNames" PropertyName="SelectedValue" Type="Int32" DefaultValue="1" />
        <asp:Parameter Name="StoreName" Type="String" DefaultValue="" /> 
    </SelectParameters>
</asp:ObjectDataSource>

<asp:SqlDataSource ID="ds_ChainStores" runat="server"
ConnectionString="<%$ ConnectionStrings:tracker%>"
SelectCommand="SELECT * FROM location.chainStore"
SelectCommandType="Text"
>
</asp:SqlDataSource>

<script src="Scripts/leaflet/view-store-leaflet.js"></script>
</asp:Content>