<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.master" CodeBehind="Edit-Employee.aspx.cs" Inherits="EasyTrackerSolution.Edit_Employee" %>
<%@ Register Src="~/Controls/Messager.ascx" TagName="Messager" TagPrefix="EasyTracker" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <script src="Scripts/jquery-ui-1.8.18.custom.min.js" type="text/javascript"></script>
    <script src="Scripts/bootstrap-tabs.js" type="text/javascript"></script>
    <script src="Scripts/bootstrap-dropdown.js" type="text/javascript"></script>
    <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAizK-CoOU44u0bTWzVeUlbMkQ2cHagM9s&amp;sensor=true&amp;language=ch"></script>
    <script src="Public/Libs/Leaflet/leaflet.js"></script>
    <script src="Public/Libs/Leaflet/google.js" type="text/javascript"></script>
    <link rel="Stylesheet" href="Public/Libs/Leaflet/leaflet.css" />
 <!--[if lte IE 8]>
 <link rel="Stylesheet" href="Public/Libs/Leaflet/leaflet.ie.css" />
 <![endif]-->
    <style type="text/css">
        #employee table input
        {
            max-width:100px;
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
    
    <EasyTracker:Messager id="messager" runat="server" Visible="false" AlertMessage="" />
    <div class="well span10">
    <asp:DetailsView ID="dv_EditEmployee" GridLines="None"  AutoGenerateRows="false"  CssClass="table table-condensed table-hover" 
                    runat="server" DataSourceID="ds_Employee" DefaultMode="Edit"  DataKeyNames="userId"  CellPadding="12" 
                     OnItemUpdating="dv_EditEmployee_ItemUpdating" OnItemUpdated="dv_EditStore_ItemUpdated" OnItemCommand="dv_EditEmployee_ItemCommand" >
        <Fields>
            <asp:TemplateField>
                <HeaderTemplate>
                    姓名
                </HeaderTemplate>
                <EditItemTemplate>
                    <asp:TextBox ID="tb_FullName" Text='<%# Eval("FullName")%>' runat="server"></asp:TextBox>
                </EditItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="employeeCode" HeaderText="员工编码" />
            <asp:BoundField DataField="userName" HeaderText="登陆名" />
            <asp:BoundField DataField="email" HeaderText="电子邮箱" />
            <asp:BoundField DataField="phoneNumber" HeaderText="电话号码" />
            <asp:BoundField DataField="deviceId" HeaderText="设备号" ReadOnly="true" />
            <asp:CommandField ButtonType="Button" ShowEditButton="true" UpdateText="更新" Visible="true"  CancelText="取消" />
        </Fields>
    </asp:DetailsView>
    </div>
    <asp:ObjectDataSource ID="ds_Employee" runat="server" SelectMethod="Fetch" 
    TypeName="EasyTrackerDomainModel.UserLogic" UpdateMethod="Update" DeleteMethod="Delete">
    <SelectParameters>
        <asp:QueryStringParameter Name="UserId" Type="Int32" QueryStringField="UserId" DefaultValue="0" />
    </SelectParameters>
    <UpdateParameters>
        <asp:Parameter Name="FirstName" Type="String" />
        <asp:Parameter Name="LastName" Type="String" />
        <asp:Parameter Name="Email" Type="String" />
        <asp:Parameter Name="PhoneNumber" Type="String" />
        <asp:Parameter Name="UserName" Type="String" />
        <asp:Parameter Name="EmployeeCode" Type="String" />
    </UpdateParameters>
    <DeleteParameters>
        <asp:Parameter Name="UserId" Type="Int32" />
    </DeleteParameters>
    </asp:ObjectDataSource>
      
    <script type="text/javascript" src="Scripts/manage.js"></script>
    
</asp:Content>