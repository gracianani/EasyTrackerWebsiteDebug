<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.master" CodeBehind="Manage-Task.aspx.cs" Inherits="EasyTrackerSolution.Manage_Task" %>
<%@ Register Src="~/Controls/Messager.ascx" TagName="Messager" TagPrefix="EasyTracker" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <script type="text/javascript" src="Scripts/stupidtable.js?dev"></script>
    <link href="Public/Styles/jquery-ui-1.8.18.custom.css" rel="stylesheet" type="text/css" />
    <style type="text/css">


	
		#employeeTask td .label {
			font-size:12px;
			font-weight:normal;
			margin:5px 0;
			cursor:pointer;
			display:inline-block;
		}
		#employeeTask .label-info.active {
			background:#ff7640;
			color:#FFF;
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
    <div class="topContainer">
        <h2>
           管理任务
        </h2>
    	<div class="clearfix">
        <div id="fv_SearchTask" class="pull-left" >
                <asp:MultiView ID="mv_SearchTask" runat="server" ActiveViewIndex="0">
                    <asp:View ID="view_SearchTask" runat="server" >
                     <div class="form-inline">   
                            <asp:TextBox ID="tb_SearchTask" runat="server" ></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfv_SearchTask" runat="server" ValidationGroup="searchTask" ControlToValidate="tb_SearchTask" ErrorMessage="*请填写检索词"
                             Display="Dynamic"></asp:RequiredFieldValidator>
                            <asp:Button ID="btn_SearchTask" runat="server" Text="搜索" ValidationGroup="searchTask"  OnClick="btn_SearchTaskClick" CssClass="btn btn-primary" />
                     </div>
                    </asp:View>
                    <asp:View ID="view_SearchTaskResult" runat="server">
                       <div class="form-inline">  
                       <label style="padding-right:20px;"><span class="label label-info">搜索词:</span> <%= tb_SearchTask.Text %></label>
                        <asp:Button ID="btn_SearchTaskReset" runat="server" Text="还原" OnClick="btn_SearchTaskResetClick" ValidationGroup="searchStore" CssClass="btn btn-primary" />
                        </div>
                    </asp:View>
                </asp:MultiView>
        </div><!--fv_SearchTask-->
        <div class="pull-right">
            <a id="btn_CreateUserTask" href="javascript:void(0)" class="btn btn-primary"><i class="icon-plus icon-white"></i> 布置新任务</a>
            <button id="btn_ImportTasks" class="btn" href="#importTask" data-toggle="modal"><i class="icon-arrow-up"></i>上传</button>
            <asp:Button id="btn_ExportTasks" runat="server" class="btn"  OnClick="btn_ExportTasks_Click" Text="下载"></asp:Button>
        </div><!--.pull-right-->
        <EasyTracker:Messager id="messager_Task" runat="server" Visible="false" AlertMessage="" />
        </div><!--.clearfix-->
      </div>
     
        <asp:GridView ID="gv_UserTaskByUserId" CssClass="table table-condensed table-bordered stupidTable" runat="server" DataKeyNames="UserId" AutoGenerateColumns="false" 
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
                <asp:BoundField HeaderText="员工姓名" DataField="UserFullName" ReadOnly="true">
                <HeaderStyle CssClass="string" />
                </asp:BoundField>
                <asp:BoundField Visible="false" DataField="UserId" />
                <asp:TemplateField HeaderText="店铺列表" >
                    <HeaderStyle Width="60%" CssClass="string" />
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
                        <a href='Edit-Task.aspx?userId=<%#Eval("UserId") %>' class="btn-primary btn btn-edit"><i class="icon-pencil icon-white"   title="编辑"></i></a>
                        <asp:LinkButton ID="btn_EditUserTask"  CommandName="edit" CssClass="btn-primary btn btn-edit" runat="server"  Text='<i class="icon-pencil icon-white"   title="编辑"></i>' />
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:LinkButton ID="btn_UpdateUserTask" CommandName="update" CssClass="btn btn-success" runat="server" Text="<i class='icon-ok icon-white'  title='确认'></i>"/>
                        <asp:LinkButton ID="btn_CancelUpdateUserTask" CommandName="cancel" CssClass="btn btn-inverse " runat="server" Text="<i class='icon-remove icon-white' title='取消'></i>"/>
                    </EditItemTemplate>
                </asp:TemplateField>
            </Columns>
            
        </asp:GridView>
        


    <div  id="fv_EmployeeTask">
            <table class="table table-condensed" >

            <tr>
                <td align="right">员工姓名</td>
                <td>
                <span class="add-on"><i class="icon-search"></i></span>
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
                    <span class="add-on"><i class="icon-search"></i> </span>
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
                            <p><asp:FileUpload ID="fu_UploadTask" runat="server"  />
                            <asp:RequiredFieldValidator ID="rfvFileUploader" runat="server" ControlToValidate="fu_UploadTask" ValidationGroup="upload" ErrorMessage="请选择要上传的文件" Display="Dynamic"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="revFileUploader" runat="server" ControlToValidate="fu_UploadTask" ValidationGroup="upload" ValidationExpression="^.*\.xlsx$" ErrorMessage="请选择.xlsx后缀的文件" Display="Dynamic"></asp:RegularExpressionValidator>
                            </p> 
                            <asp:Button ID="btn_UploadStoreFromExcel" runat="server" OnClick="btn_UploadTaskFromExcel_Click" ValidationGroup="upload" Text="上传.xlsx文件" CssClass="btn btn-primary"  />
                            <asp:LinkButton ID="lnk_DownloadSample" runat="server" Text="下载示例" PostBackUrl="Download-Sample.aspx?type=task" ></asp:LinkButton>
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
    <script>
	$(function(){
		$(".table th[class]").each(function(){
			$(this).attr('data-sort',$(this).attr('class'));
		});
		$(".label-info").each(function(){
			$(this).attr('data-content',$(this).html().trim());
		});
        var hasPager = true;
		var hasHeader =true;
		if ($('.gridview-pager').size()< 1) {
			hasPager = false;
		}
		var table = $(".table").stupidtable({},hasHeader,hasPager);
        table.bind('aftertablesort', function (event, data) {
          var th = $(this).find("th");
          th.find(".caret").remove();
          var arrow = data.direction === "asc" ? "&uarr;" : "&darr;";
          th.eq(data.column).prepend('<span class="caret ' + data.direction +'">&nbsp;</span>');
		  	
        });
		table.on('click','tbody tr',function(e) {
			$('tr.selected').removeClass('selected');
			$(this).addClass('selected');
		});
		table.on('dblclick','tbody tr',function(e) {
			$(this).find('.btn-edit').get(0).click();
		});
		table.on('click','.label-info',function(e) {
			$('.label-info.active').removeClass('active');
			$('.label-info[data-content="'+$(this).html().trim()+'"]').addClass('active');
		});
		
	});
	</script>
</asp:Content>