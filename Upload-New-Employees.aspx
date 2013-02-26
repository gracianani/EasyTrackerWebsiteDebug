
<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.master" CodeBehind="Upload-New-Employees.aspx.cs" Inherits="EasyTrackerSolution.Upload_New_Employees" %>

<%@ Register Src="~/Controls/Messager.ascx" TagName="Messager" TagPrefix="EasyTracker" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <script src="Scripts/jquery-ui-1.8.18.custom.min.js" type="text/javascript"></script>
    <script src="Scripts/bootstrap-tabs.js" type="text/javascript"></script>
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
    <asp:ScriptManager ID="scriptManager" runat="server"></asp:ScriptManager>
    <h2>
       上传员工
    </h2>
    <div class="row ">
        <div class="span3">
           <asp:FileUpload ID="fu_UploadStore" runat="server"  />
           <asp:Button ID="btn_UploadStore" CssClass="btn-primary" runat="server" OnClick="btn_UploadEmployee_Click" Text="上传" /> 
        </div>
        <div class="span5">
            <span> 上传格式说明 </span>
            <table class="table table-bordered">
                <tr><td>员工编码</td><td>员工名称</td><td>登录名</td></tr>
                <tr><td>6226220111821228</td><td>小红</td><td>xiao.hong</td></tr>
            </table>
        </div>
        
    </div>
    
</asp:Content>
