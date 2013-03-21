<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.master" CodeBehind="Manage-Single-CheckIns.aspx.cs" Inherits="EasyTrackerSolution.Manage_Single_CheckIns" %>

<%@ Register Src="~/Controls/Messager.ascx" TagName="Messager" TagPrefix="EasyTracker" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <script src="Scripts/jquery-ui-1.8.18.custom.min.js" type="text/javascript"></script>
    <script type="text/javascript" src="Scripts/stupidtable.js?dev"></script>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:ScriptManager ID="scriptManager" runat="server"></asp:ScriptManager>
    <div class="content">
        <div class="topContainer">
        <h2>
           待解决的问题
        </h2>
        </div>
        <p class="pageCount">
        每页显示：
        <asp:DropDownList ID="ddl_ItemsPerPage" runat="server" AutoPostBack="true">
            <asp:ListItem Text="10" Value="10"></asp:ListItem>
            <asp:ListItem Text="50" Value="50"></asp:ListItem>
            <asp:ListItem Text="100" Value="100"></asp:ListItem>
        </asp:DropDownList>
        </p>
        <asp:GridView ID="gv_SingleCheckIn" runat="server" CssClass="table table-condensed table-bordered " 
        OnDataBinding="gv_SingleCheckIn_DataBinding" AutoGenerateColumns="false" OnRowCommand="gv_SingleCheckIn_RowCommand">
            <Columns>
                <asp:TemplateField HeaderText="#">
                	<ItemStyle CssClass="indexCol" />
                    <ItemTemplate>
                        <%# Container.DisplayIndex + 1 %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="UserFullName" HeaderText="员工名称"/>
                <asp:BoundField DataField="StoreName" HeaderText="门店名称"/>
                <asp:BoundField DataField="CreatedAt" DataFormatString="{0:yyyy-MM-dd HH:mm:ss}" HeaderText="日期"/>
                <asp:BoundField DataField="CheckInId" Visible="false" />
                <asp:TemplateField HeaderText="问题描述">
                    <ItemTemplate>
                         未将门店加入到员工的任务列表
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField>
                    <HeaderTemplate>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <asp:LinkButton ID="btn_AddToTask" CommandName="addToTask" CommandArgument='<%# Eval("checkInId") %>' CssClass="btn btn-primary btn-edit" runat="server" Text="<i class='icon-pencil icon-white' title='加入任务列表'></i>" ></asp:LinkButton>
                        <asp:LinkButton ID="btn_Delete" CommandName="Delete" CommandArgument='<%# Eval("checkInId") %>'  CssClass="btn btn-inverse" runat="server"  Text="<i class='icon-remove icon-white' title='删除'></i>"/>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>