<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Messager.ascx.cs" Inherits="EasyTrackerSolution.Controls.Messager" %>

<asp:Panel ID="pnl_Alert" runat="server" class="alert alert-block" >
        <a class="close" data-dismiss="alert" href="#">×</a>
        <asp:Label ID="lb_AlertMessager" runat="server" ><%= AlertMessage %></asp:Label>
        <a href='<%= RedirectUrl %>'  style='<%= string.IsNullOrEmpty( RedirectUrl ) ? "display:none" : "" %>'> 返回</a>
</asp:Panel>

<script type="text/javascript">
    $(document).ready(function () {
        $(".alert").alert();
    });
</script>