<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Messager.ascx.cs" Inherits="EasyTrackerSolution.Controls.Messager" %>
<script src="Scripts/bootstrap-alert.js" type="text/javascript"></script>
<asp:Panel ID="pnl_Alert" runat="server" class="alert alert-block" Visible='<%# AlertMessagerVisible%>'>
        <a class="close" data-dismiss="alert" href="#">×</a>
        <asp:Label ID="lb_AlertMessager" runat="server" ><%= AlertMessage %></asp:Label>
        <a href='<%= RedirectUrl %>'> 返回</a>
</asp:Panel>

<script type="text/javascript">
    $(".alert").alert();
</script>