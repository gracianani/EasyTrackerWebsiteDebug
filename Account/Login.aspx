<%@ Page Title="Log In" Language="C#" MasterPageFile="Account.master" AutoEventWireup="true"
    CodeBehind="Login.aspx.cs" Inherits="EasyTrackerSolution.Account.Login" %>
<%@ Register Src="~/Controls/Messager.ascx" TagName="Messager" TagPrefix="EasyTracker" %>
<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <style>
	
	
	</style>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
<div class="container">
	<div class="row" id="login" style="opacity:1">
		<div class="span4 offset4 well">
			<legend>Please Sign In</legend>
          	<EasyTracker:Messager ID="Messager" runat="server" />
			
            <asp:Login ID="LoginUser" runat="server" EnableViewState="false" RenderOuterTable="false" OnLoggedIn="LoginUser_LoggedIn"  >
        <LayoutTemplate>
            <p class="failureNotification">
                <asp:Literal ID="FailureText" runat="server"></asp:Literal>
            </p>
            <asp:ValidationSummary ID="LoginUserValidationSummary" runat="server" CssClass="alert alert-error" 
                 ValidationGroup="LoginUserValidationGroup"/>
            <div class="accountInfo">
                <fieldset class="login">
                    <p class="form-inline">
                        <asp:Label ID="UserNameLabel" runat="server" AssociatedControlID="UserName" CssClass="span1">用户名:</asp:Label>
                        <asp:TextBox ID="UserName" runat="server" CssClass="textEntry"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="UserNameRequired" runat="server" ControlToValidate="UserName" 
                             CssClass="failureNotification" ErrorMessage="User Name is required." ToolTip="User Name is required." 
                             ValidationGroup="LoginUserValidationGroup">*</asp:RequiredFieldValidator>
                    </p>
                    <p  class="form-inline">
                        <asp:Label ID="PasswordLabel" runat="server" AssociatedControlID="Password" CssClass="span1">密码:</asp:Label>
                        <asp:TextBox ID="Password" runat="server" CssClass="passwordEntry" TextMode="Password"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" ControlToValidate="Password" 
                             CssClass="failureNotification" ErrorMessage="Password is required." ToolTip="Password is required." 
                             ValidationGroup="LoginUserValidationGroup">*</asp:RequiredFieldValidator>
                    </p>
                    <p  class="form-inline">
                    	<label class="span1"></label>
                        <asp:CheckBox ID="RememberMe" runat="server"/>
                        <asp:Label ID="RememberMeLabel" runat="server" AssociatedControlID="RememberMe" CssClass="inline">保持登陆状态</asp:Label>
                    </p>
                </fieldset>
                <p class="submitButton">
                	<label class="span1"></label>
                    <asp:Button ID="LoginButton" runat="server" CommandName="Login" Text="&nbsp;&nbsp;登陆&nbsp;&nbsp;" ValidationGroup="LoginUserValidationGroup" CssClass="btn btn-primary"/> &nbsp;&nbsp;&nbsp;
                    <asp:LinkButton ID="ForgetPasswordButton" runat="server" PostBackUrl="~/Account/ForgotPassword.aspx" Text="忘记密码?" CssClass="btn btn-inverse"></asp:LinkButton>
                </p>
            </div>
        </LayoutTemplate>
    </asp:Login> 
		</div>
	</div>
</div>

</asp:Content>
