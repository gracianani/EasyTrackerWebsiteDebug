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
            <asp:MultiView ID="mv_forgotPassword" runat="server" ActiveViewIndex="0" >
                <asp:View ID="view_resetPassword" runat="server">
                <span class="failureNotification">
                    <asp:Literal ID="FailureText" runat="server"></asp:Literal>
                </span>
                <div class="accountInfo">
                <asp:Label ID="lb_Email" runat="server" Text="请输入邮箱"></asp:Label>
                <asp:TextBox ID="tb_Email" runat="server" ></asp:TextBox>
                <asp:Button ID="btn_SendPassword" runat="server" Text="确定" OnClick="btn_SendPassword_Click"/>
                </div>
                </asp:View>
                <asp:View ID="view_resetPasswordSuccess" runat="server">
                    密码重设成功 
                    <asp:Button ID="btn_ResendEmail" runat="server" Text="重新发送密码" OnClick="btn_SendPassword_Click" />
                    <asp:LinkButton ID="btn_BackToLogin" runat="server" PostBackUrl="~/Account/Login.aspx" Text="登录"></asp:LinkButton>
                </asp:View>
            </asp:MultiView>
            
        </div>
    </div>
</div>
</asp:Content>