<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.master" CodeBehind="Manage-Single-CheckIns.aspx.cs" Inherits="EasyTrackerSolution.Manage_Single_CheckIns" %>

<%@ Register Src="~/Controls/Messager.ascx" TagName="Messager" TagPrefix="EasyTracker" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <script src="Scripts/jquery-ui-1.8.18.custom.min.js" type="text/javascript"></script>
    <script type="text/javascript" src="Scripts/stupidtable.js?dev"></script>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:ScriptManager ID="scriptManager" runat="server"></asp:ScriptManager>
    <div class="content">

        <asp:GridView ID="gv_SingleCheckIn" runat="server" OnDataBinding="gv_SingleCheckIn_DataBinding"></asp:GridView>
    </div>
</asp:Content>