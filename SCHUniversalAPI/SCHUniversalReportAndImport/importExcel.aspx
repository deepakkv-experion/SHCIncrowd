<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="importExcel.aspx.cs" Inherits="SCHUniversalReportAndImport.ImportExcel" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link rel="stylesheet" href="Style/style.css" type="text/css" media="screen" />
    <link href="Styles/report.css" rel="stylesheet" type="text/css" />

    <link href="Scripts/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script src="Scripts/jquery-ui.js" type="text/javascript"></script>
    <script src="Scripts/jquery.js" type="text/javascript"></script>
    <link href="Styles/report.css" rel="stylesheet" type="text/css" />
    <script src="Scripts/jquery-1.4.1.min.js" type="text/javascript"></script>
    <script src="Scripts/jquery-1.4.1.js" type="text/javascript"></script>
    <script src="Scripts/jquery-1.4.1-vsdoc.js" type="text/javascript"></script>
    <script src="Scripts/jquery-ui.min.js" type="text/javascript"></script>

    <script type="text/javascript">
        $(document).ready(function () {
            $("#btnSampleTemplate").click(function () {
                var type = document.getElementById("ddlImportType").value;
                if (type == "1") {
                    window.location.href = "PanelistTemplate.csv";
                } else if (type == "5") {
                    window.location.href = "CloseProject.xlsx";
                } 
                else if (type == "5") {
                    window.location.href = "CloseProject.xlsx";
                }
                else {
                    window.location.href = "Panelist.xlsx";
                }

            });

        });
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <table cellpadding="0" cellspacing="0" width="900px" align="center">
            <tr>
                <td>
                    <table width="100%" cellspacing="0" cellpadding="0">
                        <tr>
                            <td>
                                <table width="100%" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td rowspan="2" align="left" valign="bottom">
                                            <div id="logo">
                                                <img src="OpinionSite.jpg" width="500px;" alt="" />
                                                <br />
                                                <br />
                                            </div>
                                        </td>
                                        <td align="right" rowspan="2" valign="bottom">
                                            <div style="padding:5px;font-weight:bold;" class="toplinks">
                                            <asp:LinkButton ID="lnkBack" class="lnkGrn" runat="server" ForeColor="#567db0" OnClick="lnkBack_Click">Reports</asp:LinkButton>&nbsp;&nbsp;
                                            <asp:LinkButton ID="logOut" class="lnkGrn" runat="server" ForeColor="#567db0" OnClick="logOut_Click">Log Out</asp:LinkButton>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" rowspan="2">
                                            &nbsp;
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td bgcolor="#f3f1ec">
                    <table width="100%" >
                        <tbody>
                            <tr class="rounded" style="background-color: #567db0;">
                                <td style="color: White; font-size: 16px; font-weight: bold; font-family: Verdana;"
                                    colspan="2">
                                    <div style="padding:5px">Manage Panelists/Projects</div>
                                </td>
                            </tr>
                            <tr id="Import" class="rounded">
                            
                                <td>
                                    <table  width="100%" border="0" cellspacing="10" >                                       
                                        <tr class="trStyle">
                                            <td width="100px">
                                             <strong>Import Type :</strong>   
                                            </td>
                                            <td width="200px">
                                                <asp:DropDownList ID="ddlImportType" runat="server" Width="200px">
                                                    <asp:ListItem Value="0" Text="---Select---"></asp:ListItem>
                                                    <asp:ListItem Value="1" Text="Add New Panelists"></asp:ListItem>
                                                    <asp:ListItem Value="2" Text="Suspend Panelists"> </asp:ListItem> 
                                                    <asp:ListItem Value="3" Text="Blacklist Panelists"> </asp:ListItem>                                                   
                                                    <asp:ListItem Value="4" Text="Resume Panelists"></asp:ListItem>
                                                    <asp:ListItem Value="5" Text="Close Project"></asp:ListItem>
                                                </asp:DropDownList>
                                                <asp:RequiredFieldValidator ID="rqvImportType" runat="server" ValidationGroup="upload" ForeColor="Red"
                                                    ErrorMessage="Please select a import type " InitialValue="0" ControlToValidate="ddlImportType"
                                                    Display="Dynamic"></asp:RequiredFieldValidator>
                                            </td>
                                          <td valign="top">
                                          <input type="button" name="btnSampleTemplate" id="btnSampleTemplate" value="Download Template" />
                                             </td>
                                        </tr>                                        
                                        <tr class="trStyle">
                                            <td style="font-weight: bold">
                                                Select File : </td>
                                            <td colspan="2">
                                                <asp:FileUpload ID="flUpload" runat="server" />
                                            </td>                                            
                                        </tr>
                                        <tr>
                                        <td>&nbsp;</td>
                                        <td align="left">
                                                <asp:Button ID="btnFileUpload" runat="server" Text="Upload" ValidationGroup="upload"
                                                    OnClick="btnFileUpload_Click" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2">
                                                <asp:Label ID="lblMessage" runat="server" Text=""></asp:Label>
                                                <br /> <br />
                                                <asp:Label ID="lblResult" runat="server" Text="" ForeColor="#567db0" Font-Bold="true"></asp:Label>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </td>
            </tr>
                              
        </table>
    </div>
    </form>
</body>
</html>
