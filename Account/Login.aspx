<%@ Page Title="Log In" Language="C#" MasterPageFile="Account.master" AutoEventWireup="true"
    CodeBehind="Login.aspx.cs" Inherits="EasyTrackerSolution.Account.Login" %>
<%@ Register Src="~/Controls/Messager.ascx" TagName="Messager" TagPrefix="EasyTracker" %>
<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
<div id="login" style="opacity:1">

    <div class="inner">
    <EasyTracker:Messager ID="Messager" runat="server" />
    <h2>
        登陆系统
    </h2>
    <div class="formLogin" >
    
    <asp:Login ID="LoginUser" runat="server" EnableViewState="false" RenderOuterTable="false" OnLoggedIn="LoginUser_LoggedIn"  >
        <LayoutTemplate>
            <span class="failureNotification">
                <asp:Literal ID="FailureText" runat="server"></asp:Literal>
            </span>
            <asp:ValidationSummary ID="LoginUserValidationSummary" runat="server" CssClass="failureNotification" 
                 ValidationGroup="LoginUserValidationGroup"/>
            <div class="accountInfo">
                <fieldset class="login">
                    <p>
                        <asp:Label ID="UserNameLabel" runat="server" AssociatedControlID="UserName">用户名:</asp:Label>
                        <asp:TextBox ID="UserName" runat="server" CssClass="textEntry"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="UserNameRequired" runat="server" ControlToValidate="UserName" 
                             CssClass="failureNotification" ErrorMessage="User Name is required." ToolTip="User Name is required." 
                             ValidationGroup="LoginUserValidationGroup">*</asp:RequiredFieldValidator>
                    </p>
                    <p>
                        <asp:Label ID="PasswordLabel" runat="server" AssociatedControlID="Password">密码:</asp:Label>
                        <asp:TextBox ID="Password" runat="server" CssClass="passwordEntry" TextMode="Password"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" ControlToValidate="Password" 
                             CssClass="failureNotification" ErrorMessage="Password is required." ToolTip="Password is required." 
                             ValidationGroup="LoginUserValidationGroup">*</asp:RequiredFieldValidator>
                    </p>
                    <p>
                        <asp:CheckBox ID="RememberMe" runat="server"/>
                        <asp:Label ID="RememberMeLabel" runat="server" AssociatedControlID="RememberMe" CssClass="inline">保持登陆状态</asp:Label>
                    </p>
                </fieldset>
                <p class="submitButton">
                    <asp:Button ID="LoginButton" runat="server" CommandName="Login" Text="登陆" ValidationGroup="LoginUserValidationGroup"/>
                    <asp:LinkButton ID="ForgetPasswordButton" runat="server" PostBackUrl="~/Account/ForgotPassword.aspx" Text="忘记密码?"></asp:LinkButton>
                </p>
            </div>
        </LayoutTemplate>
    </asp:Login>
    </div>
    </div>
        </div>
</asp:Content>
