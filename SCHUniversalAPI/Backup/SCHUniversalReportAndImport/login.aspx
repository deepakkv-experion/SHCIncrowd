<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="SCHUniversalReportAndImport.login" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Login </title>
 
    <link href="Styles/report.css" rel="stylesheet" type="text/css" />
    <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; minimum-scale=1.0; user-scalable=0;" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
</head>
<body>
    <form id="form1" runat="server">
     <table width="100%" cellpadding="0" cellspacing="0" style="padding-top:100px" >
        <tr>
            <td align="center">
                <table class="rounded" width="25%" style="background-color: #ffffff" cellpadding="0"
                    cellspacing="5" border="0">
                    <tr>
                        <td class="rightlogo" align="center">
                            <img src="OpinionSite.jpg" alt="Ideashifters" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="rounded">
                                <table width="85%" cellpadding="1" cellspacing="1" align="center">
                                    <tr>
                                        <td align="center" colspan="2">
                                            <span class="uploader" style="color: #000066; font-weight: bold;">SCH Universal API Report </span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <br />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <span class="uploader" style="color: #000066; font-weight: bold;">User Name</span>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtUserName" Width="200px" MaxLength="100" runat="server"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="rqvtxtEmailId" ErrorMessage="Please enter your Username."
                                                Display="Dynamic" ValidationGroup="login" ControlToValidate="txtUserName" runat="server">
                                            </asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <span class="uploader" style="color: #000066; font-weight: bold;">Password</span>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtPassword" Width="200px" MaxLength="100" runat="server" TextMode="Password"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="rqvtxtPassword" ErrorMessage="Please enter your Password."
                                                Display="Dynamic" ValidationGroup="login" ControlToValidate="txtPassword" runat="server">
                                            </asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <br />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <asp:Button ID="btnLogin" CssClass="loginbutton rounded" ValidationGroup="login"
                                                runat="server" Text="Login" OnClick="btnLogin_Click" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <br />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <asp:Label ID="lblMessage" runat="server" CssClass="uploader" ForeColor="red"></asp:Label>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td align="center" style="font-size: 10px;color:#000066">
                Copyright © 2015
            </td>
        </tr>
    </table>
    </form>
</body>
</html>
