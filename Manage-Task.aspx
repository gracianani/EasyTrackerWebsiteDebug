<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.master" CodeBehind="Manage-Task.aspx.cs" Inherits="EasyTrackerSolution.Manage_Task" %>
<%@ Register Src="~/Controls/Messager.ascx" TagName="Messager" TagPrefix="EasyTracker" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAizK-CoOU44u0bTWzVeUlbMkQ2cHagM9s&amp;sensor=true&amp;language=ch"></script>
    <script src="Scripts/map.js" type="text/javascript"></script>
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
		#employeeTask td .label {
			font-size:12px;
			font-weight:normal;
			padding:5px;
			margin:5px 0;
			display:inline-block;
		}
		#employeeTask td .label .icon-remove {
			cursor:pointer;
		}
    </style>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:ScriptManager ID="scriptManager" runat="server"></asp:ScriptManager>

    <div class="content">
    <div id="employeeTask" >
    <div style="background:#f5f5f5;margin:-20px -20px 0;padding:20px 20px 0">
        <h2>
           管理任务
        </h2>
    	<div class="clearfix">
        <div id="fv_SearchTask" class="pull-left" >
                <asp:MultiView ID="mv_SearchTask" runat="server" ActiveViewIndex="0">
                    <asp:View ID="view_SearchTask" runat="server" >
                    <div class="row-fluid clearfix well">
                     <div class="form-search">   
                        	<label>检索</label>
                            <asp:TextBox ID="tb_SearchTask" runat="server" CssClass="search-query" ></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfv_SearchTask" runat="server" ValidationGroup="searchTask" ControlToValidate="tb_SearchTask" ErrorMessage="*"
                             CssClass="label label-warning" Display="Dynamic"></asp:RequiredFieldValidator>
                            <asp:Button ID="btn_SearchTask" runat="server" Text="搜索" ValidationGroup="searchTask"  OnClick="btn_SearchTaskClick" CssClass="btn" />
                        </div>
                        </div>
                    </asp:View>
                    <asp:View ID="view_SearchTaskResult" runat="server">
                        <div class="row-fluid clearfix well">
                        <label class="span3"><span class="label label-info">搜索词:</span> <%= tb_SearchTask.Text %></label>
                        <asp:Button ID="btn_SearchTaskReset" runat="server" Text="还原" OnClick="btn_SearchTaskResetClick" ValidationGroup="searchStore" CssClass="btn span1" />
                        </div>
                    </asp:View>
                </asp:MultiView>
        </div><!--fv_SearchTask-->
        <div class="pull-right">
            <a id="btn_CreateUserTask" href="javascript:void(0)" class="btn" style="display:inline-block">布置新任务</a>
            <button id="btn_ImportTasks" class="btn btn-primary" href="#importTask" data-toggle="modal">导入</button>
            <asp:Button id="btn_ExportTasks" runat="server" class="btn btn-primary"  OnClick="btn_ExportTasks_Click" Text="导出"></asp:Button>
        </div><!--.pull-right-->
        <EasyTracker:Messager id="messager_Task" runat="server" Visible="false" AlertMessage="" />
        </div><!--.clearfix-->
        <hr />
      </div>
     
        <asp:GridView ID="gv_UserTaskByUserId" CssClass="table table-striped table-bordered" runat="server" DataKeyNames="UserId" AutoGenerateColumns="false" 
            OnDataBinding="gv_UserTaskByUserId_DataBinding"
            OnRowEditing="gv_UserTaskByUserId_RowEditing" 
            OnRowCancelingEdit="gv_UserTaskByUserId_RowCancelingEdit" 
            OnRowUpdating="gv_UserTaskByUserId_RowUpdating">
            <EmptyDataTemplate>
                您还没有给员工布置任务. 
                <a id="btn_CreateUserTask" runat="server" class="btn btn-info" >开始布置任务</a> 
            </EmptyDataTemplate>
            <Columns>
                <asp:TemplateField HeaderText="#">
                	<ItemStyle CssClass="indexCol" />
                    <ItemTemplate>
                        <%# Container.DisplayIndex + 1 %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField HeaderText="员工姓名" DataField="UserFullName" ReadOnly="true" />
                <asp:BoundField Visible="false" DataField="UserId" />
                <asp:TemplateField HeaderText="店铺列表" >
                    <HeaderStyle Width="60%" />
                    <ItemTemplate>
                        <asp:ListView ID="lv_StoreNames" runat="server"  DataSource='<%# Eval("Stores") %>'>
                            <EmptyDataTemplate>
                                还没有给这个员工布置任务
                            </EmptyDataTemplate>
                            <ItemTemplate>
                                <span class="label label-info">  <%# Eval("StoreName") %> </span> &nbsp;
                            </ItemTemplate>
                        </asp:ListView>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:HiddenField ID="hf_storeIdAll" Value='<%# Eval("StoreIdAll") %>' runat="server" />
                        <div class="storeNames">
                        <asp:Repeater ID="rp_StoreNames" runat="server" DataSource='<%# Eval("Stores") %>'>
                            <ItemTemplate>
                                <span class="label label-warning">  <%# Eval("StoreName") %> <i class="icon-remove icon-white"></i> </span> &nbsp;
                            </ItemTemplate>
                        </asp:Repeater>
                        </div>
                        <br />
                        <div class="controls">
                            <div class="input-prepend">
                                <span class="add-on" style="margin-right:-5px"><i class="icon-search"></i></span>
                                <asp:TextBox ID="tb_Store" runat="server" CssClass="span2" data-value="" ></asp:TextBox>
                            </div>
                        </div>
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:LinkButton ID="btn_EditUserTask" CommandName="edit" CssClass="btn primary btn-info  " style="display:inline-block" runat="server"  Text="修改"/>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:LinkButton ID="btn_UpdateUserTask" CommandName="update" CssClass="btn primary btn-success" runat="server" style="display:inline-block" Text="更新"/>
                        <asp:LinkButton ID="btn_CancelUpdateUserTask" CommandName="cancel" CssClass="btn primary " style="display:inline-block" runat="server" Text="取消"/>
                    </EditItemTemplate>
                </asp:TemplateField>
            </Columns>
            
        </asp:GridView>
        


    <div  id="fv_EmployeeTask">
            <table class="table table-bordered table-condensed" >

            <tr>
                <td align="right">员工姓名</td>
                <td>
                <asp:TextBox ID="tb_EmployeeName" runat="server" CssClass="span2" data-value="" ></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td align="right">店铺名称</td>
                <td>
                <asp:HiddenField ID="hf_storeIdAll"  runat="server" />
                <div class="storeNames" style="width:200px;display:block;overflow:hidden;clear:both">
                </div>
                <div class="controls">
                    <span class="add-on" style="margin-right:-5px"><i class="icon-search"></i></span>
                    <asp:TextBox ID="tb_Store" runat="server" CssClass="span2" data-value="" ></asp:TextBox>
                </div>
                </td>
            </tr>
            <tr>
                <td align="right">任务描述</td>
                <td>
                <textarea rows="8" cols="5" id="txt_UserTaskDescription"></textarea>
                </td>
            </tr>
            </table>
        </div>


        <div class="modal hide" id="importTask">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">✕</button>
                <h3>导入店铺</h3>
            </div>
                <div class="modal-body" style="text-align:center;">
                <div class="row-fluid">
                    <div class="span10 offset1">
                        <div id="modalTab">
                            <p><asp:FileUpload ID="fu_UploadTask" runat="server"  /></p> 
                            <asp:Button ID="btn_UploadStoreFromExcel" runat="server" OnClick="btn_UploadTaskFromExcel_Click" Text="上传.xlsx文件" CssClass="btn btn-primary"  />
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>
    </div>
    <asp:ObjectDataSource ID="ds_UserTask" runat="server" 
    TypeName="EasyTrackerDomainModel.TaskLogic" SelectMethod="Fetch" UpdateMethod="Update" DeleteMethod="Delete" 
    OnDeleted="ds_UserTask_Deleted" >
    <SelectParameters>
        <asp:Parameter Name="TaskId" Type="Int32" DefaultValue="0" />
        
    </SelectParameters>
    </asp:ObjectDataSource>   
    <script type="text/javascript" src="Scripts/manage.js"></script>
</asp:Content>