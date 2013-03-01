<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.master" CodeBehind="Edit-Store.aspx.cs" Inherits="EasyTrackerSolution.Edit_Store" %>
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
    </style>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
	<a class="btn pull-right" href="/Manage-Store.aspx">返回店铺列表</a>
    <h2>编辑店铺信息</h2>
    <hr />
    <EasyTracker:Messager id="messager" runat="server" Visible="false" AlertMessage="" />
    <div class="well">
    <asp:DetailsView ID="dv_EditStore" GridLines="None"  cssClass="table table-condensed table-hover" runat="server" DataSourceID="ds_Store" AutoGenerateRows="false" DefaultMode="Edit"  DataKeyNames="storeId" 
    OnDataBound="dv_EditStore_DataBound" CellPadding="12" OnItemUpdating="dv_EditStore_ItemUpdating" OnItemUpdated="dv_EditStore_ItemUpdated" OnItemCommand="dv_EditStore_ItemCommand"  >
        <EditRowStyle BorderWidth="0" />
        <Fields>
            <asp:BoundField HeaderText="店铺名称" DataField="storeName" ItemStyle-Wrap="true"  />
            <asp:BoundField HeaderText="别名" DataField="alias" ItemStyle-Wrap="true" />
            <asp:TemplateField HeaderText="地址">
                <EditItemTemplate>
                    <table>
                        <tr><td>街道</td><td><asp:TextBox ID="tb_Street1" runat="server" Text='<%#Bind("addressLine1") %>'></asp:TextBox></td></tr>
                        <tr><td>门牌号码</td><td><asp:TextBox ID="tb_Street2" runat="server" Text='<%#Bind("addressLine2") %>'></asp:TextBox></td></tr>
                        <tr><td>区县</td><td>
                            <asp:TextBox ID="tb_District" runat="server"  Text='<%#Bind("district") %>' ></asp:TextBox>   
                        </td></tr>
                        <tr><td>城市</td><td><asp:TextBox ID="tb_City" runat="server" Text='<%#Bind("city") %>' ></asp:TextBox></td></tr>
                        <tr><td>省份</td><td><asp:TextBox ID="tb_Provience" runat="server" Text='<%#Bind("provience") %>'></asp:TextBox></td></tr>
                    </table>
                </EditItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="坐标">
                <EditItemTemplate>
                    <div class="form-inline">
                    <asp:TextBox ID="tb_Latitude" runat="server" Text='<%#Bind("latitude") %>'></asp:TextBox>,
                    <asp:TextBox ID="tb_Longitude" runat="server" Text='<%#Bind("longitude") %>'></asp:TextBox>
                    <a type="button" class="btn btn-small btn-primary" id="btn_locateStore2" href='javascript:getLatLng("0")' >
                    <i class="icon-search icon-white"></i> 定位 </a>
                    <div id="map_canvas" style="width: 100%;height:270px;margin-top:10px;"></div>
                    </div>
                </EditItemTemplate>
            </asp:TemplateField>
            
            <asp:BoundField DataField="phoneNumber" InsertVisible="true"  HeaderText="联系电话"/>
            <asp:TemplateField>
                <HeaderTemplate>类别</HeaderTemplate>
                <EditItemTemplate>
                    <asp:HiddenField ID="hf_ImportanceLevel" runat="server" Value='<%# Convert.ToInt32(Eval("ImportanceLevel")) %>' />
                    <asp:DropDownList ID="ddl_ImportanceLevel"  runat="server">
                        <asp:ListItem Text="A类" Value="1"></asp:ListItem>
                        <asp:ListItem Text="B类" Value="2"></asp:ListItem>
                        <asp:ListItem Text="C类" Value="3"></asp:ListItem>
                        <asp:ListItem Text="D类" Value="4"></asp:ListItem>
                    </asp:DropDownList>
                </EditItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField>
                <HeaderTemplate>
                    系统
                </HeaderTemplate>
                <EditItemTemplate>
                    <asp:HiddenField ID="hf_ChainStoreId" runat="server" Value='<%# Bind("ChainStoreId") %>' />
                    <asp:DropDownList ID="ddl_ChainStoreName" runat="server" DataSourceID="ds_ChainStores"  DataTextField="ChainStoreName" 
                    DataValueField="ChainStoreId"  >
                    </asp:DropDownList>
                </EditItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField>
                <HeaderTemplate>
                    负责人
                </HeaderTemplate>
                <EditItemTemplate>
                    <asp:HiddenField ID="hf_ManagerId" runat="server" Value='<%# Bind("ManagerId") %>' />
                    <asp:DropDownList ID="ddl_ManagerName" runat="server" DataSourceID="ds_Employee" DataTextField="FullName" DataValueField="UserID">
                    </asp:DropDownList>
                </EditItemTemplate>
                </asp:TemplateField>
            <asp:TemplateField HeaderText="状态">
                    <EditItemTemplate>
                        <asp:DropDownList ID="ddl_StoreStatusLevel" runat="server" >
                            <asp:ListItem Text="有效" Value="1"></asp:ListItem>
                            <asp:ListItem Text="暂停" Value="2"></asp:ListItem>
                            <asp:ListItem Text="删除" Value="3"></asp:ListItem>
                        </asp:DropDownList>
                    </EditItemTemplate>
                </asp:TemplateField>
            <asp:CommandField UpdateText="更新" ControlStyle-CssClass="btn btn-primary" ShowEditButton="true" CancelText="取消"  />
        </Fields>
    </asp:DetailsView>
    </div>
    <asp:SqlDataSource ID="ds_ChainStores" runat="server"
        ConnectionString="<%$ ConnectionStrings:tracker%>"
        SelectCommand="SELECT * FROM location.chainStore"
        SelectCommandType="Text"
        >
        </asp:SqlDataSource>
    <asp:ObjectDataSource ID="ds_Store" runat="server" 
    TypeName="EasyTrackerDomainModel.StoreLogic" SelectMethod="Fetch" UpdateMethod="Update"  OldValuesParameterFormatString="{0}" >
        <SelectParameters>
            <asp:QueryStringParameter Name="storeId" Type="Int32" QueryStringField="storeId"/>
        </SelectParameters>
    </asp:ObjectDataSource>
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
</asp:Content>