<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Edit-Task.aspx.cs" MasterPageFile="~/Site.master" Inherits="EasyTrackerSolution.Edit_Task" %>

<%@ Register Src="~/Controls/Messager.ascx" TagName="Messager" TagPrefix="EasyTracker" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <script src="Scripts/jquery-ui-1.8.18.custom.min.js" type="text/javascript"></script>
    <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAizK-CoOU44u0bTWzVeUlbMkQ2cHagM9s&amp;sensor=true&amp;language=ch"></script>
    <script src="Public/Libs/Leaflet/leaflet.js"></script>
    <script src="Public/Libs/Leaflet/google.js" type="text/javascript"></script>
    <script type="text/javascript" src="Scripts/stupidtable.js?dev"></script>

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
		.btn-danger {
			border-bottom:none;
			border-top:none;
		}
		.table-subTitle p{
			line-height:30px;
		}
		.table-subTitle {
			height:30px;
		}
		.tableContainer {
			overflow-y:scroll;
			width:100%;
			height:500px;
		}
    </style>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
<div class="row-fluid clearfix" >
    <div class="span10">
        <div style="padding-top:8px">员工：<a href="/View-Employee-Leaflet.aspx?userId=" target="_blank">姓名</a>
        </div>
    </div>
    <div class="span2">
    <a href="/Mange-Task.aspx" class="btn btn-primary">返回</a>
    </div>
</div><!--/row-fluid-->
<hr />
<div class="row-fluid clearfix" >
<div class="span4">
<div class="row-fluid table-subTitle">
	<div class="span4"><h3>全部门店</h3></div>
    <div class="span4"><p>已选中<span id="selectCount-add">0</span>个</p></div>
    <div class="span4" style="text-align:right"><asp:Button ID="btn_AddToTask" runat="server" CssClass="btn-primary" Text="添加到任务 »" OnClick="btn_AddToTask_Click" /></div>
</div>
<div class="tableContainer">
<asp:GridView ID="gv_AllStores" runat="server" DataSourceId="ds_AllStores" ShowHeader="true" DataKeyNames="StoreId"  AutoGenerateColumns="false" CssClass="table stupidTable">
    <Columns>
        <asp:BoundField HeaderText="系统" DataField="ChainStoreName">
        <HeaderStyle Width="4em" CssClass="string" />
        </asp:BoundField>
        <asp:BoundField HeaderText="门店" DataField="StoreName" >
        <HeaderStyle CssClass="string" />
        </asp:BoundField>
        <asp:TemplateField  Visible="false">
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
</div>
<div class="span4">

<div class="row-fluid table-subTitle">
    <div class="span4"><asp:Button CssClass="btn-danger" ID="btn_RemoveFromTask" runat="server" Text="« 从任务中删除" OnClick="btn_RemoveFromTask_Click" /></div>
    <div class="span4" style="text-align:right"><p>已选中<span id="selectCount-remove">0</span>个</p></div>
    <div class="span4"><h3 style="text-align:right">负责门店<span id="taskCount">0</span>个</h3></div>
</div>
<div class="tableContainer">
<asp:GridView ID="gv_Tasks" runat="server" DataSourceId="ds_Store" AutoGenerateColumns="false" DataKeyNames="TaskId"   ShowHeader="true" CssClass="table stupidTable">
    <Columns>
        <asp:BoundField HeaderText="系统" DataField="ChainStoreName">
         <HeaderStyle  Width="4em"  CssClass="string" />
         </asp:BoundField>
        <asp:BoundField HeaderText="门店" DataField="StoreName">
        <HeaderStyle CssClass="string" />
        </asp:BoundField>
       <asp:TemplateField Visible="false">
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
<script>
	$(function(){
		$(".table th[class]").each(function(){
			$(this).attr('data-sort',$(this).attr('class'));
		});
		
		var table = $(".table").stupidtable({},true,false);
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
	
		table.on('click','.label-info',function(e) {
			$('.label-info.active').removeClass('active');
			$('.label-info[data-content="'+$(this).html().trim()+'"]').addClass('active');
		});
		
		$('#ctl00_MainContent_gv_Tasks').bind('change','checkbox',function(e){
			$('#selectCount-remove').html(($('#ctl00_MainContent_gv_Tasks :checkbox:checked').size()));
		});
		$('#ctl00_MainContent_gv_AllStores').bind('change','checkbox',function(e){
			$('#selectCount-add').html(($('#ctl00_MainContent_gv_AllStores :checkbox:checked').size()));
		});
		$('.tableContainer').height(parseInt($(window).height()) - 220);
		$('#taskCount').html($('#ctl00_MainContent_gv_Tasks tr').size() -1 );
	});
	</script>
</asp:Content>
