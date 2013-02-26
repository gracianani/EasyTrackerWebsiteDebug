<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.master" CodeBehind="Upload-New-Stores.aspx.cs" Inherits="EasyTrackerSolution.Upload_New_Stores" %>

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
       上传店铺
    </h2>
    <div class="row">
        
        <div class="span3">
           <asp:FileUpload ID="fu_UploadStore" runat="server"  />
           <asp:Button ID="btn_UploadStore" runat="server" OnClick="btn_UploadStore_Click" Text="上传" CssClass="btn btn-primary" /> 
        </div>
        <div class="span8">
            <span>上传格式说明</span>
            <table>
                <tr><td>门店系统</td><td>门店编码	</td><td>门店组号</td><td>门店</td><td>地址</td><td>GPS点	</td><td>电话</td><td>业务经理</td><td>一级经理</td>
                <td>二级经理</td><td>三级经理</td></tr>
                <tr><td>物美</td><td>1198</td><td>SG-FM-TJ05</td><td>万达店</td><td>地址</td><td>39.20025,117.195904</td><td>26732167</td><td>小红</td><td>小白</td>
                <td>小青</td><td></td></tr>
            </table>
        </div>
    </div>
    
</asp:Content>
