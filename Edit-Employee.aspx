<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.master" CodeBehind="Edit-Employee.aspx.cs" Inherits="EasyTrackerSolution.Edit_Employee" %>
<%@ Register Src="~/Controls/Messager.ascx" TagName="Messager" TagPrefix="EasyTracker" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">

    <style type="text/css">
	
		.table td {
			border-width:0;
		}
    </style>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
<a class="btn pull-right" href="/Manage-Employee.aspx">返回员工列表</a>
    <h2>编辑员工信息</h2>
    <hr />
    <EasyTracker:Messager id="messager" runat="server" Visible="false" AlertMessage="" />
    <div class="well span10">
    <asp:DetailsView ID="dv_EditEmployee" GridLines="None"  AutoGenerateRows="false"  CssClass="table" 
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
            <asp:BoundField DataField="deviceId" HeaderText="设备号" />
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
    <script>
	$(function(){
		$(':submit,:button').addClass('btn big').css('padding','4px 10px').css('font-size','16px');
		$(':submit').addClass('btn-primary');
	});
	</script>
    
</asp:Content>