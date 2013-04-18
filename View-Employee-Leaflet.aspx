<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.master"  CodeBehind="View-Employee-Leaflet.aspx.cs" Inherits="EasyTrackerSolution.View_Employee_Leaflet" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <script src="Public/Libs/Leaflet/leaflet.js"  type="text/javascript"> </script>   
    <script src="http://maps.googleapis.com/maps/api/js?key=AIzaSyAizK-CoOU44u0bTWzVeUlbMkQ2cHagM9s&sensor=false&amp;language=ch"  type="text/javascript"></script>  
    <script src="Public/Libs/Leaflet/google.js" type="text/javascript"></script>
    <link href="Public/Styles/chosen.css" rel="stylesheet" type="text/css" />
    <link rel="Stylesheet" href="Public/Libs/Leaflet/leaflet.css" />
 <!--[if lte IE 8]>
 <link rel="Stylesheet" href="Public/Libs/Leaflet/leaflet.ie.css" />
 <![endif]-->
    <style type="text/css">
        html {
	height:100%;
	overflow:hidden;
}
    form {
	margin-bottom:0!important;
}body {
	padding-bottom:0;
}
#locationsContainer {
	overflow-y:scroll;
	margin:0;
	padding:0;
	border-width:1px 1px 0px 0;
	border-style:solid;
	border-color:#dedede;
}
#locations 
{
	margin:0;
	padding:0;
	overflow:visible;

}
    	#locations .nav-header {

			cursor:pointer;

			font-size:14px;

			padding:0;
			margin:0;
            border:none;
			border-bottom:1px solid #dedede;
            
		}

		#locations .nav-header:hover {

			color:#333;

		}
		#locations .nav-header>a {
			padding:10px;
			margin:0;
			text-shadow:none;
		}
		#locations .nav-header>a:hover {
			background:#187fcb;
			color:#FFF;
			text-shadow:none!important;
		}

		#locations .nav-header .nav-list {

			font-size:12px;

			padding-right:0;

			padding-left:0;

		}

		#locations .nav-header .nav-list li {

			padding-bottom:5px;

			margin-bottom:5px;

			border-bottom:1px dotted #DCDCDC;

		}

		#locations .nav-header .nav-list li a {

			padding-right:0;

		}
	#map_canvas {
		border-top:1px solid #dedede;
	}
		#map_canvas img {

            max-width: none;

        }
		#map_canvas input {
			display:inline;
		}
        .checkInIndex {

	        display: inline-block;
	        float: left;
	        width: 30px;
	        height: 40px;
	        overflow: hidden;
	        line-height: 30px;
	        font-size: 24px;
	        font-style: italic;
	        color: #999;
	        text-align: left;


        }
        .info {
    padding: 6px 8px;
    font: 14px/16px Arial, Helvetica, sans-serif;
    background: white;
    background: rgba(255,255,255,0.8);
    box-shadow: 0 0 15px rgba(0,0,0,0.2);
    border-radius: 5px;
}
.info h4 {
    margin: 0 0 5px;
    color: #777;
}
 
 #userTaskContainer 
 {
     border: 1px solid #ddd;
	 overflow-y:scroll;
	 border-bottom:none;
 }
 #userTask td
 {
     border-bottom: 1px solid #ddd;
     padding:10px;
 }
.wrapper-fluid .row-fluid [class*="span"] {
 margin-left:0;
 float:left;
}
.wrapper-fluid .row-fluid .span3 {
	width:25%;
}
.wrapper-fluid .row-fluid .span7 {
	width:58.33333333%;
}
.wrapper-fluid .row-fluid .span2 {
	width:16.66666667%;
}
.alert-block {
	margin-bottom:0;
}
#locations .nav-header .nav-list li:last-child {
	border-bottom:none;
}
#locations .nav-header>a {
	background:#ededed;
	color:#333;
}
#locations .nav-header>a i {
	margin-top:3px;
	margin-left:5px;
}
#locations .nav-header>a:hover i {
	background-image:url("App_Themes/img/glyphicons-halflings-white.png");
}
.recordDetails {
	font-size:12px;
	font-weight:normal;
	padding-left:20px;
}
#userTask td {
	position:relative;
}
.storeIcons {
	position:absolute;
	right:5px;
	top:10px;
	font-size:11px;
	line-height:14px;
}
.infoWindowPhotos {
	padding:10px 0;
}
.infoWindowPhotos a {
	margin-right:10px;
	display:inline-block;
}
.infoWindowPhotos img {
	width:50px;
	height:50px;
}
    </style>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:ScriptManager ID="scriptManager" runat="server"></asp:ScriptManager>
    <div class="topContainer">
    <div class="row-fluid">
        <div class="span3">
        <asp:DropDownList ID="ddl_Employee" runat="server" CssClass="medium chzn-select" DataSourceID="ds_Employee"  AutoPostBack="true" DataTextField="FullName" DataValueField="UserId">
        </asp:DropDownList>
        </div>
        <div class="span9 form-inline">
        选择日期：
            <asp:HiddenField ID="hf_txtDateFrom"  runat="server"/>
           <input class="small w8em highlight-days-67 range-low-today" type="text" id="txtDateFrom" maxlength="10"/> 
        到
            <asp:HiddenField ID="hf_txtDateTo"  runat="server"/>
            <input class="small w8em highlight-days-67 range-low-today" type="text" id="txtDateTo" maxlength="10" /> 
        <input type="button" class="btn btn-primary"  style="margin-right:20px" value="搜索" id="btnSearch"/>

        <asp:LinkButton ID="lnk_DownloadReport" runat="server" CssClass="btn btn-inverse" OnClick="btn_DownloadReport_Click"><i class="icon-file icon-white" title="导出报表"></i>导出报表</asp:LinkButton>
        <a class="btn btn-inverse" href="/Edit-Task.aspx?userId=" target="_blank"><i class="icon-pencil icon-white" title="编辑任务"></i>编辑任务</a> 
        <a id="viewAllShops" class="btn btn-inverse" ><i title="在地图中显示全部店铺" class=" icon-resize-full icon-white"></i></a>


        </div>

        
    </div>
    </div>
    <div class="wrapper-fluid">
    <div class="alert alert-block hidden">
            <a class="close" data-dismiss="alert" href="#">×</a>
            <strong>有{0}个新位置更新，点击查看</strong>
    </div>
    <div class="row-fluid clearfix" >
        <div class="span3" >
            <script id="employeeLocationTemplate" type="text/x-jquery-tmpl">

                <li><a href="javascript:void(0)">
                <span class="checkInIndex">${index}</span> <i class="icon-time"></i>时间：${CreatedAt}<br />
                {{if CheckInType == 2 }}
                <i class="icon-home"></i>${Store[0].StoreName}</a>
                {{else}}
				<i class="icon-map-marker"></i>( ${CheckInCoordinate.Latitude}, ${CheckInCoordinate.Longitude} )</a>
				</li>
				{{/if}}
            </script>
            
        <div id="locationsContainer">
            <ul id="locations" class="nav nav-list  accordion">
                    
            </ul>
        </div>

        </div>
        <div class="span7">
            <div id="map_canvas"  style="width: 100%;height:500px"></div>
        </div>
        <div class="span2  ">
                    <asp:UpdatePanel ID="upd_tasks" runat="server">
                <ContentTemplate>
                  <div  id="userTaskContainer">
                  <div id="userTask" class="accordion-body in collapse" >
                    <div >
                      
                     <asp:GridView ID="gv_UserTask" CssClass="table " EnableTheming="false" runat="server" DataSourceID="ds_UserTask" CellPadding="10" CellSpacing="10"
                     DataKeyNames="StoreId" OnDataBound="gv_UserTask_DataBound" AutoGenerateColumns="false" ShowHeader="false" 
                     style="margin-bottom:0px; border-left:0px transparent; border-right:0px transparent; border-bottom:0px trasparent"
                        >
                        <EmptyDataTemplate>
                            您还没有给该员工布置任务. 
                        </EmptyDataTemplate>
                        <Columns>
                            <asp:TemplateField HeaderText="店铺名称" >
                                <ItemTemplate>
                                <div class="storeName">
                                <%# Eval("StoreName") %>
                                </div>
                                <div class="storeIcons" >
                                    <span style='<%# Convert.ToInt32(Eval("TaskCheckInCount") ) > 0 ? "display:inline-block" : "display:none" %>'><i class="icon-ok"></i><%# Eval("TaskCheckInCount")%></span>
                                    <span style='<%# Convert.ToInt32(Eval("PhotoCount") ) > 0 ? "display:inline-block" : "display:none" %>'><i class="icon-picture"></i><%# Eval("PhotoCount")%></span>
                                </div>
                                       
                                <asp:HiddenField ID="hd_StoreId" runat="server" Value='<%# Eval("StoreId") %>' />
                                <asp:HiddenField ID="hd_StoreLatitude" runat="server" Value='<%# Eval("Latitude") %>'/>
                                <asp:HiddenField ID="hd_StoreLongitude" runat="server" Value='<%# Eval("Longitude") %>'/>

                                
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <RowStyle />
                    </asp:GridView>
                    </div>
                  </div>
                </div>
                </ContentTemplate>
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="ddl_Employee" EventName="SelectedIndexChanged"/>
                </Triggers>
            </asp:UpdatePanel>
         </div>
    </div>
    </div>

    <script id="infoWindowTemplate" type="text/x-jquery-tmpl">
        <li> <p><i class="icon-time"></i>${CreatedAt}<br />
		( ${CheckInCoordinate.Latitude}, ${CheckInCoordinate.Longitude} ) </p> </li>
    </script>

    <asp:ObjectDataSource ID="ds_Employee" runat="server" SelectMethod="FetchAll" 
    TypeName="EasyTrackerDomainModel.UserRepository" UpdateMethod="Update" InsertMethod="Insert" DeleteMethod="Delete">
    <UpdateParameters>
        <asp:Parameter Name="FirstName" Type="String" />
        <asp:Parameter Name="LastName" Type="String" />
        <asp:Parameter Name="Email" Type="String" />
        <asp:Parameter Name="PhoneNumber" Type="String" />
        <asp:Parameter Name="UserId" Type="Int32" />
    </UpdateParameters>
    <InsertParameters>
        <asp:Parameter Name="FirstName" Type="String" />
        <asp:Parameter Name="LastName" Type="String" />
        <asp:Parameter Name="Email" Type="String" />
        <asp:Parameter Name="PhoneNumber" Type="String" />
    </InsertParameters>
    <DeleteParameters>
        <asp:Parameter Name="UserId" Type="Int32" />
    </DeleteParameters>
    </asp:ObjectDataSource>

    <asp:ObjectDataSource ID="ds_Photo" runat="server" SelectMethod="FetchPhotoByUserId" TypeName="EasyTrackerDomainModel.PhotoRepository">
        <SelectParameters>
            <asp:ControlParameter Name="UserId" ControlID="ddl_Employee" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:ObjectDataSource>

    <asp:ObjectDataSource ID="ds_UserTask" runat="server" 
    TypeName="EasyTrackerDomainModel.CheckInLogic" SelectMethod="FetchCheckInsStatByUserId" OnSelecting="ds_UserTask_Selecting"  >
        <SelectParameters>
            <asp:ControlParameter ControlID="ddl_Employee" Name="userId" Type="Int32" PropertyName="SelectedValue" />
            <asp:Parameter Type="DateTime" Name="from" />
            <asp:Parameter Type="DateTime" Name="to"/>
        </SelectParameters>
    </asp:ObjectDataSource>    

      <script type="text/javascript" src="Scripts/leaflet/employee-leaflet.js"></script>
      <script src="Scripts/chosen.jquery.min.js" type="text/javascript"></script>
        <script type="text/javascript">     $(".chzn-select").chosen(); $(".chzn-select-deselect").chosen({ allow_single_deselect: true }); </script>
</asp:Content>
