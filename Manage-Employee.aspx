<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.master" CodeBehind="Manage-Employee.aspx.cs" Inherits="EasyTrackerSolution.Manage_Employee" %>

<%@ Register Src="~/Controls/Messager.ascx" TagName="Messager" TagPrefix="EasyTracker" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <script src="Scripts/jquery-ui-1.8.18.custom.min.js" type="text/javascript"></script>
    <script type="text/javascript" src="Scripts/stupidtable.js?dev"></script>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:ScriptManager ID="scriptManager" runat="server"></asp:ScriptManager>
    <div class="content">
    <div id="employee">
    <div class="topContainer">
        <h2>
           管理员工
        </h2>
    	<div class="clearfix">
        <div id="fv_SearchEmployee" class="pull-left">
                <asp:MultiView ID="mv_SearchEmployee" runat="server" ActiveViewIndex="0">
                    <asp:View ID="view_Search" runat="server" >
                    <div class="form-inline">
                    <asp:RequiredFieldValidator ID="rfv_SearchEmployeeName" runat="server" ValidationGroup="searchEmployee" ControlToValidate="tb_SearchEmployeeName" ErrorMessage="*请填写检索词"
                             CssClass=""  Display="Dynamic"></asp:RequiredFieldValidator>
                            <asp:TextBox ID="tb_SearchEmployeeName" runat="server" ></asp:TextBox>
                            <asp:Button ID="btn_SearchEmployee" runat="server" Text="搜索" ValidationGroup="searchEmployee" OnClick="btn_SearchEmployeeClick" CssClass="btn btn-primary" />
                            
                        </div>
                    </asp:View>
                    <asp:View ID="view_SearchResult" runat="server">
                    <div class="form-inline">
                        <label style="padding-right:20px;">搜索词: <%= tb_SearchEmployeeName.Text %></label> 
                        <asp:Button ID="btn_SearchEmployeeReset" runat="server" Text="还原" OnClick="btn_EmployeeResetClick" CssClass="btn btn-primary" />
                        </div>
                    </asp:View>
                </asp:MultiView>
        </div><!--fv_SearchEmployee-->
        <div class="pull-right">
      <!--      <a id="btn_CreateUser" href="javascript:void(0)" class="btn btn-primary"><i class="icon-plus icon-white"></i> 创建新员工</a>   
            <button id="btn_ImportEmployees" class="btn" href="#importEmployee" data-toggle="modal"><i class="icon-arrow-up"></i>上传</button>
            <button id="btn_ExportEmployees" class="btn"><i class="icon-arrow-down"></i>下载</button> -->

            <a id="btn_CreateUser" href="javascript:void(0)" class="btn btn-primary"><i class="icon-plus icon-white"></i> 创建新员工</a>   
            <button id="btn_ImportEmployees" class="btn" href="#importEmployee" data-toggle="modal"><i class="icon-arrow-up"></i>上传</button>
            <asp:Button id="btn_ExportEmployees" runat="server" class="btn" Text="下载" OnClick="btn_ExportEmployees_Click" />
            
            
        </div><!--.pull-right-->
        </div><!--.clearfix-->
        </div>
        <p class="pageCount">
        每页显示：
        <asp:DropDownList ID="ddl_ItemsPerPage" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddl_ItemsPerPage_SelectedIndexChanged">
            <asp:ListItem Text="10" Value="10"></asp:ListItem>
            <asp:ListItem Text="50" Value="50"></asp:ListItem>
            <asp:ListItem Text="100" Value="100"></asp:ListItem>
        </asp:DropDownList>
        </p>
        <asp:GridView ID="gv_Employee" runat="server" CssClass="table table-condensed table-bordered stupidTable" 
        AutoGenerateColumns="false" DataKeyNames="UserId" EnableTheming="False" 
        DataSourceID="ds_Employee" AllowPaging="true" PageSize="10" OnRowEditing="gv_Employee_RowEditing"
        OnRowCancelingEdit="gv_Employee_RowEditing"
        OnPageIndexChanged="gv_Employee_RowEditing"
        OnRowCommand="gv_Employee_RowCommand"
        OnRowDataBound="gv_Employee_RowDataBound"
        OnRowUpdating="gv_Employee_RowUpdating"
        OnRowCreated="gv_Employee_RowCreated"
         OnPreRender="gv_Employee_PreRender">
            <Columns>
                <asp:TemplateField HeaderText="#">
                	<ItemStyle CssClass="indexCol" />
                    <ItemTemplate>
                        <%# Container.DisplayIndex + 1 %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField>
                	<HeaderStyle CssClass="string" />
                    <HeaderTemplate>
                        姓名
                    </HeaderTemplate>
                    <ItemTemplate>
                        <%# Eval("LastName") %> <%# Eval("FirstName") %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="employeeCode" HeaderText="员工编码" >
                <HeaderStyle CssClass="string" />
                
                </asp:BoundField>
                <asp:TemplateField>
                    <HeaderTemplate>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <a href='Edit-Employee.aspx?userId=<%# Eval("UserId") %>' class="btn btn-primary btn-edit" title='修改'><i class="icon-pencil icon-white"></i></a>
                        <asp:LinkButton ID="btn_HardDeleteUser" CommandName="hardDelete" CommandArgument='<%# Eval("UserId") %>'  CssClass="btn btn-inverse" runat="server"  Text="<i class='icon-remove icon-white' title='强力删除'></i>"/>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:LinkButton ID="btn_UpdateUser" CommandName="update"  CssClass="btn primary  btn-success" runat="server" Text="更新"/>
                        <asp:LinkButton ID="btn_CancelUpdateUser" CommandName="cancel"  CssClass="btn primary" runat="server" Text="取消"/>
                    </EditItemTemplate>
                </asp:TemplateField>
                
            </Columns>
            <PagerSettings Mode="NumericFirstLast" PreviousPageText="上一页" NextPageText="下一页" Position="Bottom"  />
            <PagerStyle CssClass="gridview-pager" />
            <EmptyDataTemplate>
                没有符合条件的员工，<a id="btn_CreateUser" href="javascript:void(0)" class="btn btn-primary" style="font-size:14px;height:16px;line-height:16px;padding:4px 10px">创建新员工</a>   
            </EmptyDataTemplate>

        </asp:GridView>
        <div id="fv_Employee">
        
        <table cellpadding="10" CssClass="table table-striped table-bordered span3" >
            <tr><td align="right">名字</td><td><asp:TextBox ID="tb_FirstName" ValidationGroup="insertuser" runat="server" CssClass="span2" Text='<%#Bind("FirstName")%>'></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfv_FirstName" ValidationGroup="insertuser" runat="server" ControlToValidate="tb_FirstName" ErrorMessage="*" SetFocusOnError="true" CssClass="label label-important" EnableClientScript="true" Display="Dynamic"></asp:RequiredFieldValidator>
            </td></tr>
            <tr><td align="right">姓氏</td><td><asp:TextBox ID="tb_LastName" ValidationGroup="insertuser" runat="server" CssClass="span2" Text='<%#Bind("LastName")%>'></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfv_LastName" ValidationGroup="insertuser" runat="server" ControlToValidate="tb_LastName" ErrorMessage="*" SetFocusOnError="true" CssClass="label label-important" EnableClientScript="true" Display="Dynamic"></asp:RequiredFieldValidator>
            </td></tr>
            <tr><td align="right">联系方式</td><td><asp:TextBox ID="tb_PhoneNumber" ValidationGroup="insertuser" runat="server" CssClass="span2" Text='<%#Bind("PhoneNumber") %>'></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfv_PhoneNumber" ValidationGroup="insertuser" runat="server" ControlToValidate="tb_PhoneNumber" ErrorMessage="*" SetFocusOnError="true" CssClass="label label-important" EnableClientScript="true" Display="Dynamic"></asp:RequiredFieldValidator>
            </td></tr>
            <tr><td align="right">登录名</td><td><asp:TextBox ID="tb_UserName" ValidationGroup="insertuser" runat="server" CssClass="span2" Text='<%#Bind("UserName") %>'></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfv_UserName" ValidationGroup="insertuser" runat="server" ControlToValidate="tb_UserName" ErrorMessage="*" SetFocusOnError="true" CssClass="label label-important" EnableClientScript="true" Display="Dynamic"></asp:RequiredFieldValidator>
            <asp:CustomValidator ID="cv_UserName" ValidationGroup="insertuser" runat="server" ControlToValidate="tb_UserName" ErrorMessage="这个登录名已经存在了" SetFocusOnError="true" CssClass="label label-important" Display="Dynamic" style="color: white;"></asp:CustomValidator>
            </td></tr>
        </table>
        </div>

        <div class="modal hide" id="importEmployee">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">✕</button>
                <h3>导入店铺</h3>
            </div>
            <div class="modal-body" style="text-align:center;">
                <div class="row-fluid">
                    <div class="span10 offset1">
                        <div id="modalTab">
                            <p><asp:FileUpload ID="fu_UploadEmployee" runat="server"  />
                            <asp:RequiredFieldValidator ID="rfvFileUploader" runat="server" ValidationGroup="upload" ControlToValidate="fu_UploadEmployee" ErrorMessage="请选择要上传的文件" Display="Dynamic"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="revFileUploader" runat="server"  ValidationGroup="upload" ControlToValidate="fu_UploadEmployee" ValidationExpression="^.*\.xlsx$" ErrorMessage="请选择.xlsx后缀的文件" Display="Dynamic"></asp:RegularExpressionValidator>
                            </p>
                            <asp:Button ID="btn_UploadEmployeeFromExcel" runat="server" ValidationGroup="upload" OnClick="btn_UploadEmployeeFromExcel_Click" Text="导入.xlsx文件" CssClass="btn btn-primary" />
                            <asp:LinkButton ID="lnk_DownloadSample" runat="server" Text="下载示例" PostBackUrl="Download-Sample.aspx?type=employee" ></asp:LinkButton>
                        </div>
                    </div>
                </div>
            </div><!--modal-body-->
        </div><!--modal-->
    </div><!--#employee-->
    </div><!--content-->

    <asp:ObjectDataSource ID="ds_Employee" runat="server" SelectMethod="Fetch" 
    TypeName="EasyTrackerDomainModel.UserLogic" UpdateMethod="Update" DeleteMethod="Delete">
    <SelectParameters>
        <asp:Parameter Name="UserId" Type="Int32" DefaultValue="0" />
    </SelectParameters>
    <UpdateParameters>
        <asp:Parameter Name="FirstName" Type="String" />
        <asp:Parameter Name="LastName" Type="String" />
        <asp:Parameter Name="PhoneNumber" Type="String" />
        <asp:Parameter Name="UserName" Type="String" />
        <asp:Parameter Name="Email" Type="String" DefaultValue="" />
        <asp:Parameter Name="UserStatusId" Type="Int32" DefaultValue="1" />
    </UpdateParameters>
    <DeleteParameters>
        <asp:Parameter Name="UserId" Type="Int32" />
    </DeleteParameters>
    </asp:ObjectDataSource>

    <script type="text/javascript" src="Scripts/manage.js"></script>
    <script>
	$(function(){
		$(".table th[class]").each(function(){
			$(this).attr('data-sort',$(this).attr('class'));
		});
        var table = $(".table").stupidtable();
        table.bind('aftertablesort', function (event, data) {
          var th = $(this).find("th");
          th.find(".caret").remove();
          var arrow = data.direction === "asc" ? "&uarr;" : "&darr;";
          th.eq(data.column).prepend('<span class="caret ' + data.direction +'">&nbsp;</span>');
		  	
        });
		table.on('click','tbody tr',function() {
			$('tr.selected').removeClass('selected');
			$(this).addClass('selected');
		});
		table.on('dblclick','tbody tr',function() {
			$(this).find('.btn-edit').get(0).click();
		});
		DropDownListToPills('.pageCount select');
		
    });
	</script>
</asp:Content>