<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.master" CodeBehind="Manage-Store.aspx.cs" Inherits="EasyTrackerSolution.Manage_Store" %>
<%@ Register Src="~/Controls/Messager.ascx" TagName="Messager" TagPrefix="EasyTracker" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
<script src="Scripts/jquery-ui-1.8.18.custom.min.js" type="text/javascript"></script>
    <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAizK-CoOU44u0bTWzVeUlbMkQ2cHagM9s&amp;sensor=true&amp;language=ch"></script>
    <script src="Public/Libs/Leaflet/leaflet.js"></script>
    <script src="Public/Libs/Leaflet/google.js" type="text/javascript"></script>
    <link rel="Stylesheet" href="Public/Libs/Leaflet/leaflet.css" />
    <link href="Public/Styles/jquery-ui-1.8.18.custom.css" rel="stylesheet" type="text/css" />
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
    <script type="text/javascript" src="Scripts/stupidtable.js?dev"></script>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:ScriptManager ID="scriptManager" runat="server"></asp:ScriptManager>
   <div id="store">
   <div class="topContainer clearfix">
        <h2>
           管理店铺信息
        </h2>
		<div id="fv_SearchStore" class="pull-left form-inline">
                <asp:MultiView ID="mv_SearchStore" runat="server" ActiveViewIndex="0">
                    <asp:View ID="view_SearchStore" runat="server" >
                        <label>检索：</label> 
                            <asp:TextBox ID="tb_SearchStore" runat="server" ></asp:TextBox>
                            <asp:Button ID="btn_SearchStore" runat="server" Text="搜索" OnClick="btn_SearchStoreClick" CssClass="btn btn-primary" />
                    </asp:View>
                    <asp:View ID="view_SearchStoreResult" runat="server">
                        <asp:RequiredFieldValidator ID="rfv_SearchStore" runat="server" ValidationGroup="searchStore" ControlToValidate="tb_SearchStore" ErrorMessage="*"
                             CssClass="label label-warning" Display="Dynamic"></asp:RequiredFieldValidator>
                        <label style="padding-right:20px"><span class="label label-info">搜索词:</span> <%= tb_SearchStore.Text%></label>
<asp:Button ID="tb_SearchStoreReset" runat="server" Text="还原" OnClick="btn_SearchStoreResetClick" ValidationGroup="searchStore" CssClass="btn" />
                    </asp:View>
                </asp:MultiView>
        </div> 
        <EasyTracker:Messager id="messager" runat="server" Visible="false" AlertMessage="" />
        <div class="pull-right">
            <a id="btn_CreateStore" href="javascript:void(0)" class="btn btn-primary"><i class="icon-plus icon-white"></i> 创建新店铺</a>
            <a id="btn_ImportStores" data-toggle="modal" class="btn" href="#loginModal" ><i class="icon-arrow-up"></i>上传</a>

            <asp:Button ID="btn_ExportStores" runat="server" CssClass="btn" Text="导出" OnClick="btn_ExportStores_Click" />
        </div>
    </div>
    <p class="pageCount">每页显示： <asp:DropDownList ID="ddl_ChangePageCount" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddl_ChangePageCount_SelectedIndexChanged">
                <asp:ListItem Text="10" Value="10"></asp:ListItem>
                <asp:ListItem Text="50" Value="50"></asp:ListItem>
                <asp:ListItem Text="100" Value="100"></asp:ListItem>
            </asp:DropDownList>
     </p>
        <asp:GridView ID="gv_Store" runat="server" CssClass="table table-condensed table-bordered stupidTable" 
          DataSourceID="ds_Store" OnRowUpdating="gv_Store_RowUpdating" 
          AutoGenerateColumns="false" OnRowCommand="gv_Store_RowCommand" 
          EnableTheming="false" PageSize="10" AllowPaging="true" DataKeyNames="storeId" 
          OnRowEditing="gv_Store_RowEditing" OnRowCancelingEdit="gv_Store_RowCancelingEdit" 
          OnPageIndexChanged="gv_Store_PageIndexChanged" 
          OnRowCreated="gv_Store_RowCreated"
          OnRowDeleted="gv_Store_RowDeleted" >
            
            <Columns>
                <asp:TemplateField HeaderText="#">
                	<ItemStyle CssClass="indexCol" />
                    <ItemTemplate>
                        <%# Container.DisplayIndex + 1%>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField>
                	<HeaderStyle CssClass="string" />
                    <HeaderTemplate>
                        门店系统
                    </HeaderTemplate>
                    <ItemTemplate>
                        <%#Eval("ChainStoreName")%>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField HeaderText="门店编码" DataField="alias" ItemStyle-Wrap="true" ControlStyle-Width="50" >
                <HeaderStyle CssClass="string" />
                </asp:BoundField>
                <asp:BoundField HeaderText="门店组号" DataField="storeCode" ItemStyle-Wrap="true" ControlStyle-Width="50">
                <HeaderStyle CssClass="string" />
                </asp:BoundField>
                <asp:BoundField HeaderText="门店" DataField="storeName" ItemStyle-Wrap="true" ControlStyle-Width="100" >
                <HeaderStyle CssClass="string" />
                </asp:BoundField>
                <asp:TemplateField>
                    <HeaderStyle CssClass="string" />
                    <HeaderTemplate>
                        地址
                    </HeaderTemplate>
                    <ItemTemplate>
                        <%# Eval("StoreAddressFirst")%>
                    </ItemTemplate>
                </asp:TemplateField>
                
                <asp:TemplateField>
                	<HeaderStyle CssClass="string" />
                    <HeaderTemplate>
                        一级经理
                    </HeaderTemplate>
                    <ItemTemplate>
                         <%#Eval("ManagerName")%>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField >
                    
                    <ItemTemplate>
                        <a href='/Edit-Store.aspx?storeId=<%# Eval("StoreId")%>'  class="btn btn-primary  btn-edit" title='修改'><i class="icon-pencil icon-white"></i></a>
                        <asp:LinkButton ID="btn_HardDeleteStore" CommandName="hardDelete" CommandArgument='<%# Eval("StoreId") %>' CssClass="btn btn-inverse" runat="server" style="display:inline-block" Text="<i class='icon-remove icon-white' title='强力删除'></i>"/>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <PagerSettings Mode="NumericFirstLast" PreviousPageText="上一页" NextPageText="下一页" Position="Bottom" />
            <PagerStyle CssClass="gridview-pager" />
            <EmptyDataTemplate>
                您现在还没有店铺，<a id="btn_CreateStore" href="javascript:void(0)" class="btn btn-primary" style="font-size:14px;height:16px;line-height:16px;padding:4px 10px">创建新店铺</a>   
            </EmptyDataTemplate>
        </asp:GridView>
        
        <div id="fv_Store" >     
             <div class="form-inline span7" style="padding-bottom:15px;"><input type="text" id="ipt_RawAddress" class="span5" /><a id="btn_GetAddress" class="btn">自动识别地址</a></div>
            <table cellpadding="10" style="float:left" class="table table-condensed table-bordered span3">
                <tr><td align="right">门店</td><td ><asp:TextBox ID="tb_StoreName" runat="server" CssClass="span2" ValidationGroup="insertstore" ></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfv_StoreName" ValidationGroup="insertstore"  runat="server" ControlToValidate="tb_StoreName" ErrorMessage="*" SetFocusOnError="true" CssClass="label label-important" EnableClientScript="true" Display="Dynamic"></asp:RequiredFieldValidator>
                </td></tr>
                <tr><td align="right">门店编码</td><td ><asp:TextBox ID="tb_Alias" runat="server" CssClass="span2" ValidationGroup="insertstore" ></asp:TextBox></td></tr>
                <tr><td align="right">门店组号</td><td ><asp:TextBox ID="TextBox1" runat="server" CssClass="span2" ValidationGroup="insertstore" ></asp:TextBox></td></tr>
                <tr><td align="right">省份</td><td><asp:TextBox ID="tb_Provience" ValidationGroup="insertstore" runat="server" Text="北京市"   CssClass="span2"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfv_Provience" ValidationGroup="insertstore" runat="server" ControlToValidate="tb_Provience" ErrorMessage="*" SetFocusOnError="true" CssClass="label label-important" EnableClientScript="true" Display="Dynamic"></asp:RequiredFieldValidator>
                </td></tr>
                <tr><td align="right">城市</td><td><asp:TextBox ID="tb_City" ValidationGroup="insertstore" runat="server" Text="北京市"  CssClass="span2" ></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfv_City" ValidationGroup="insertstore" runat="server" ControlToValidate="tb_City" ErrorMessage="*" SetFocusOnError="true" CssClass="label label-important" EnableClientScript="true" Display="Dynamic"></asp:RequiredFieldValidator>
                </td></tr>
                <tr><td align="right">区县</td><td >
                    <asp:TextBox ID="tb_District" runat="server" ValidationGroup="insertstore" CssClass="span2" ></asp:TextBox>   
                    <asp:RequiredFieldValidator ID="rfv_District" ValidationGroup="insertstore" runat="server" ControlToValidate="tb_District" ErrorMessage="*" SetFocusOnError="true" CssClass="label label-important" EnableClientScript="true" Display="Dynamic"></asp:RequiredFieldValidator>
                </td></tr>
                <tr><td align="right">街道</td><td ><asp:TextBox ID="tb_Street1" ValidationGroup="insertstore" runat="server"  CssClass="span2" ></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfv_Street1" ValidationGroup="insertstore" runat="server" ControlToValidate="tb_Street1" ErrorMessage="*" SetFocusOnError="true" CssClass="label label-important" EnableClientScript="true" Display="Dynamic"></asp:RequiredFieldValidator>
                </td></tr>
                <tr><td align="right">门牌号码</td><td><asp:TextBox  ID="tb_Street2" runat="server"  CssClass="span2"></asp:TextBox></td></tr>
                <tr><td align="right">联系电话</td><td><asp:TextBox ID="tb_StorePhoneNumber" runat="server"  CssClass="span2"></asp:TextBox></td></tr>
                <tr><td align="right">类别</td><td><asp:DropDownList  ID="ddl_ImportanceLevel" runat="server"  CssClass="span2" >
                            <asp:ListItem Text="请选择类别" ></asp:ListItem>
                            <asp:ListItem Text="A类" Value="1"></asp:ListItem>
                            <asp:ListItem Text="B类" Value="2"></asp:ListItem>
                            <asp:ListItem Text="C类" Value="3"></asp:ListItem>
                            <asp:ListItem Text="D类" Value="4"></asp:ListItem>
                </asp:DropDownList></td></tr>
                <tr><td align="right">系统</td><td><asp:DropDownList ID="ddl_ChainStoreId" runat="server"  CssClass="span2" DataSourceID="ds_ChainStores" AppendDataBoundItems="true"  DataTextField="ChainStoreName" 
                        DataValueField="ChainStoreId" >
                        <asp:ListItem Text="请选择系统"></asp:ListItem>
                        </asp:DropDownList></td></tr>
                <tr><td align="right">一级经理</td><td><asp:DropDownList AppendDataBoundItems="true" ID="ddl_ManagerId" runat="server"  DataSourceID="ds_Employee" DataTextField="FullName" DataValueField="UserID" CssClass="span2"><asp:ListItem Text="请选择负责人"></asp:ListItem></asp:DropDownList></td></tr>
            </table>
            <div class="span4" style="float:left" >
                    <table> 
                        <tr><td class="form-inline"><asp:TextBox ID="tb_Latitude" ValidationGroup="insertstore"  CssClass="span1" runat="server" ></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfv_Latitude" ValidationGroup="insertstore"  runat="server" ControlToValidate="tb_Latitude" ErrorMessage="*" SetFocusOnError="true" CssClass="label label-important" EnableClientScript="true" Display="Dynamic"></asp:RequiredFieldValidator>
                        ,
                        <asp:TextBox ID="tb_Longitude" ValidationGroup="insertstore" CssClass="span1" runat="server" ></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfv_Longitude" ValidationGroup="insertstore"  runat="server" ControlToValidate="tb_Longitude" ErrorMessage="*" SetFocusOnError="true" CssClass="label label-important" EnableClientScript="true" Display="Dynamic"></asp:RequiredFieldValidator>
                            <a class="btn btn-info" id="btn_locateStore" href="javascript:void(0)">
                            <i class="icon-search icon-white"></i> 定位 </a></td>
                        </tr>
                    </table>
                <div id="map_canvas" style="width: 100%;height:270px;margin-top:10px;"></div>
            </div>
            <div style="clear:both"></div>
        </div> 

        <div class="modal hide" id="loginModal">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">✕</button>
                <h3>导入店铺</h3>
            </div>
                <div class="modal-body" style="text-align:center;">
                <div class="row-fluid">
                    <div class="span10 offset1">
                        <div id="modalTab">
                            <p><asp:FileUpload ID="fu_UploadStore" runat="server"  />
                            <asp:RequiredFieldValidator ID="rfvFileUploader" runat="server"  ControlToValidate="fu_UploadStore" ValidationGroup="upload" ErrorMessage="请选择要上传的文件" Display="Dynamic"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="revFileUploader" runat="server" ControlToValidate="fu_UploadStore" ValidationGroup="upload"  ValidationExpression="^.*\.xlsx$" ErrorMessage="请选择.xlsx后缀的文件" Display="Dynamic"></asp:RegularExpressionValidator>
                            
                            </p>
                            <asp:Button ID="btn_UploadStoreFromExcel" runat="server" OnClick="btn_UploadStoreFromExcel_Click" ValidationGroup="upload"  OnClientClick="" Text="上传.xlsx文件" CssClass="btn btn-primary"  />
                            <asp:LinkButton ID="lnk_DownloadSample" runat="server" Text="下载示例" PostBackUrl="Download-Sample.aspx?type=store" ></asp:LinkButton>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <asp:ObjectDataSource ID="ds_Store" runat="server" 
    TypeName="EasyTrackerDomainModel.StoreLogic" SelectMethod="Fetch" UpdateMethod="Update" DeleteMethod="Delete" OldValuesParameterFormatString="{0}" 
    OnDeleted="ds_Store_Deleted" >
        <SelectParameters>
            <asp:Parameter Name="storeId" Type="Int32" DefaultValue="0" />
        </SelectParameters>
        <DeleteParameters>
            <asp:Parameter Direction="ReturnValue" Name="AffectedRows" />
        </DeleteParameters>
    </asp:ObjectDataSource>

    <asp:SqlDataSource ID="ds_ChainStores" runat="server"
        ConnectionString="<%$ ConnectionStrings:tracker%>"
        SelectCommand="SELECT * FROM location.chainStore"
        SelectCommandType="Text"
        >
        </asp:SqlDataSource>
    <asp:ObjectDataSource ID="ds_Employee" runat="server" SelectMethod="Fetch" 
    TypeName="EasyTrackerDomainModel.UserLogic" UpdateMethod="Update" DeleteMethod="Delete">
    <SelectParameters>
        <asp:Parameter Name="UserId" Type="Int32" DefaultValue="0" />
    </SelectParameters>
    <UpdateParameters>
        <asp:Parameter Name="FirstName" Type="String" />
        <asp:Parameter Name="LastName" Type="String" />
        <asp:Parameter Name="Email" Type="String" />
        <asp:Parameter Name="PhoneNumber" Type="String" />
        <asp:Parameter Name="UserName" Type="String" />
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

