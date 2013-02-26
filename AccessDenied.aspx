<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AccessDenied.aspx.cs" Inherits="EasyTrackerSolution.AccessDenied" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        您没有权限。
        <asp:HyperLink runat="server" NavigateUrl="~/Account/Logout.aspx"> 退出登录 </asp:HyperLink>
    </div>
    </form>
</body>
</html>
