<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Account/Account.Master" CodeBehind="ForgotPassword.aspx.cs" Inherits="EasyTrackerSolution.Account.ForgotPassword" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
<div id="login" style="opacity:1">
    <div class="inner">
        <h2>
            找回密码
        </h2>
        <div class="formLogin" >
            <div class="accountInfo">
            <asp:Label ID="lb_Email" runat="server" Text="请输入邮箱"></asp:Label>
            <asp:TextBox ID="tb_Email" runat="server" ></asp:TextBox>
            <asp:Button ID="btn_SendPassword" runat="server" Text="确定" OnClick="btn_SendPassword_Click"/>
            </div>
        </div>
    </div>
</div>
</asp:Content>