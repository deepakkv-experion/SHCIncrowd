<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="reports.aspx.cs" Inherits="SCHUniversalReportAndImport.reports" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
    <link rel="stylesheet" href="Styles/style.css" type="text/css" media="screen" />
    <link href="Styles/report.css" rel="stylesheet" type="text/css" />
    <link href="Scripts/jquery-ui.css" rel="stylesheet" type="text/css" />
    <link href="Styles/report.css" rel="stylesheet" type="text/css" />
     <link href="Styles/metallic.css" rel="stylesheet" type="text/css" />
     <script src="Scripts/jquery-1.11.1.js" type="text/javascript"></script>
    
  <%--  <script src="Scripts/jquery-1.4.1.min.js" type="text/javascript"></script>
    <script src="Scripts/jquery-1.4.1.js" type="text/javascript"></script>
    <script src="Scripts/jquery-1.4.1-vsdoc.js" type="text/javascript"></script>
    <script src="Scripts/jquery-ui.min.js" type="text/javascript"></script>--%>
    <script type="text/javascript" src="Scripts/zebra_datepicker.js"></script>
    <script type="text/javascript" language="javascript">
        $(document).ready(function () {
            $("#txtDateFrom").Zebra_DatePicker({ format: 'm/d/Y', default_position: 'below' });
            $("#txtDateTo").Zebra_DatePicker({ format: 'm/d/Y', default_position: 'below' });
            //            $("#txtDateFrom").datepicker();
            //            $("#txtDateTo").datepicker();
            $(".trGrid").slideToggle("slow");
            $("#searchCollapse").hide();

            $("#searchExpand").click(function () {
                $(".trGrid").slideToggle("slow");
                $("#searchExpand").hide();
                $("#searchCollapse").show();
            });

            $("#searchCollapse").click(function () {
                $(".trGrid").slideToggle("slow");

                $("#searchExpand").show();
                $("#searchCollapse").hide();
            });
        });

        function divexpandcollapse(divname) {
            var img = "img" + divname;
            if ($("#" + img).attr("src") == "images/plus.png") {
                $("#" + img)
				.closest("tr")
				.after("<tr><td></td><td colspan = '100%'>" + $("#" + divname)
				.html() + "</td></tr>");
                $("#" + img).attr("src", "images/minus.png");
            } else {
                $("#" + img).closest("tr").next().remove();
                $("#" + img).attr("src", "images/plus.png");
            }
        }

    </script>
</head>
<body>
    <div id="container">
        <form id="form1" runat="server">
        <table cellpadding="0" cellspacing="0" width="1000px" align="center">
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
                                            <div style="padding: 5px; font-weight: bold;" class="toplinks">
                                                <asp:LinkButton ID="lnkUpload" class="lnkGrn" runat="server" ForeColor="#567db0"
                                                    OnClick="lnkUpload_Click">Manage</asp:LinkButton>&nbsp;&nbsp;
                                                <asp:LinkButton ID="logOut" class="lnkGrn" runat="server" Visible="false" ForeColor="#567db0"
                                                    OnClick="logOut_Click">Log Out</asp:LinkButton>
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
                    <table width="100%" cellspacing="0" cellpadding="0">
                        <tr>
                            <td valign="top" style="background: #f3f1ec" colspan="2">
                            </td>
                        </tr>
                        <tr>
                            <td valign="top" style="background: #f3f1ec" colspan="2">
                                <table width="100%" cellpadding="0" cellspacing="0" style="background-color: #F5F6F7;">
                                    <tr>
                                        <td>
                                        </td>
                                    </tr>
                                    <tr class="rounded" style="background-color: #567db0;">
                                        <td style="color: White; font-size: 20px; font-weight: bold; font-family: Verdana;">
                                            <div style="padding: 5px;">
                                                SCH Universal Report</div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div id="divSearch" class="rounded buckets" align="left">
                                                <table width="100%" cellpadding="0" cellspacing="0" border="0" style="padding: 15px;">
                                                    <tr>
                                                        <td colspan="4">
                                                            &nbsp;
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td style="color: #000000; font-family: Verdana; font-size: 12px; font-weight: normal;">
                                                            <span style="color: #567db0; font-family: Verdana; font-size: 12px; font-weight: bold;">
                                                                Date From</span>
                                                            <asp:TextBox ID="txtDateFrom" runat="server"></asp:TextBox>
                                                          <%--  <input type="text" id="dateFrom" />--%>
                                                        </td>
                                                        <td>
                                                            <span style="color: #567db0; font-family: Verdana; font-size: 12px; font-weight: bold;">
                                                                Date To</span>
                                                            <asp:TextBox ID="txtDateTo" runat="server"></asp:TextBox>
                                                        </td>
                                                        <td>
                                                            <span style="color: #567db0; font-family: Verdana; font-size: 12px; font-weight: bold;">
                                                               Status</span>
                                                            <asp:DropDownList ID="ddlProjectStatus" runat="server" Width="170px">
                                                                <asp:ListItem Value="0">---Select---</asp:ListItem>
                                                                <asp:ListItem Value="1">Active</asp:ListItem>
                                                                <asp:ListItem Value="2">Draft</asp:ListItem>
                                                                <asp:ListItem Value="3">Inactive</asp:ListItem>
                                                                <asp:ListItem Value="4">Closed</asp:ListItem>
                                                            </asp:DropDownList>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <br />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td align="left" colspan="3">
                                                            <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click" />&nbsp;&nbsp;&nbsp;
                                                            <asp:Button ID="btnClear" runat="server" Text="Clear" OnClick="btnClear_Click" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div id="divCounts" class="rounded buckets">
                                                <table cellpadding="3" cellspacing="3" width="100%" style="color: #567db0; font-family: Verdana;
                                                    font-size: 12px; font-weight: bold;">
                                                    <tr class="rounded" style="background-color: #567db0; color: White">
                                                        <td>
                                                            <asp:Label ID="lblLastDataMsg" runat="server" Text="Last 24 Hrs Details"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            Total Projects &nbsp; &nbsp;&nbsp;&nbsp;&nbsp; :
                                                            <asp:Label ID="lblTotProject" runat="server" Text="0"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            Total Respondents :
                                                            <asp:Label ID="lblTotRespondent" runat="server" Text="0"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            Total Completes &nbsp; &nbsp;:
                                                            <asp:Label ID="lblTotComplete" runat="server" Text="0"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td style="padding-left: 400px; color:Green;">
                                                            <asp:Label ID="lblMessage" runat="server"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr class="rounded" style="background-color: #567db0; color: White">
                                                        <td align="left">
                                                            <span id="searchExpand" style="text-align: left; font-size: 12px; cursor: pointer;
                                                                font-weight: bold;">+ More Details </span><span id="searchCollapse" style="text-align: left;
                                                                    font-size: 12px; cursor: pointer; font-weight: bold;">- Hide Details </span>
                                                        </td>
                                                    </tr>
                                                    <tr class="trGrid">
                                                        <td valign="top" colspan="2" style="font-family: tahoma; font-size: 13px;">
                                                            <asp:GridView ID="grdSearch" runat="server" Width="100%" AutoGenerateColumns="false" OnRowDataBound="grdSearch_RowDataBound" DataKeyNames="ProjectId">
                                                                <HeaderStyle CssClass="gridHeading" />
                                                                <AlternatingRowStyle CssClass="gridAltRowStyle" />
                                                                <RowStyle CssClass="gridRowStyle" />
                                                                <Columns>
                                                                    <asp:BoundField HeaderText="Project Id" DataField="ProjectId" ItemStyle-BorderStyle="Solid" />
                                                                    <asp:BoundField HeaderText="Kinesis Project Name" DataField="Kinesis Project Name"
                                                                        ItemStyle-BorderStyle="Solid" />
                                                                    <asp:BoundField HeaderText="Total Respondents" DataField="Total Respondents" ItemStyle-BorderStyle="Solid" />
                                                                    <asp:BoundField HeaderText="Kinesis Project Id" DataField="Kinesis Project Id" ItemStyle-BorderStyle="Solid" />
                                                                    <asp:BoundField HeaderText="Length of the Survey" DataField="Length of the Survey"
                                                                        ItemStyle-BorderStyle="Solid" />
                                                                    <asp:BoundField HeaderText="Completes Count" DataField="Completes Count" ItemStyle-BorderStyle="Solid" />
                                                                    <asp:BoundField HeaderText="Quota Count" DataField="Quota Count" ItemStyle-BorderStyle="Solid" />
                                                                    <asp:BoundField HeaderText="Terminate Count" DataField="Terminate Count" ItemStyle-BorderStyle="Solid" />
                                                                    <asp:BoundField HeaderText="Total Clicks" DataField="Total Clicks" ItemStyle-BorderStyle="Solid" />
                                                                    <asp:BoundField HeaderText="Create Date" DataField="Create Date" ItemStyle-BorderStyle="Solid" />
                                                                    <asp:BoundField HeaderText="Incidence" DataField="Incidence" ItemStyle-BorderStyle="Solid" />                                                                  
                                                                    <asp:BoundField HeaderText="Status" DataField="Project Status" ItemStyle-BorderStyle="Solid" />
                                                                    <asp:BoundField HeaderText="InActivated Date" DataField="InactiveDate" ItemStyle-BorderStyle="Solid" />
                                                                    <asp:TemplateField HeaderText="Close Project" HeaderStyle-HorizontalAlign="Center"
                                                                        ItemStyle-HorizontalAlign="Center">
                                                                        <ItemTemplate>
                                                                            <asp:HiddenField ID="hdnProjectId" runat="server" Value='<%# Bind("ProjectId")%>' />
                                                                            <asp:CheckBox ID="chkClose" runat="server" ToolTip="Close" />
                                                                            <%--<asp:ImageButton ID="imgClose" runat="server" CommandName="Close" ToolTip="Close" ImageUrl="~/images/close.gif"  CommandArgument='<%# Eval("Project Id")%>' />--%>
                                                                        </ItemTemplate>
                                                                    </asp:TemplateField>
                                                                    <asp:TemplateField HeaderText="Query Details" HeaderStyle-HorizontalAlign="Center"
                                                                        ItemStyle-HorizontalAlign="Center">
                                                                        <ItemTemplate>
                                                                            <a href="JavaScript:divexpandcollapse('div<%# Eval("ProjectId") %>');">
                                                                                <img alt="Details" id="imgdiv<%# Eval("ProjectId") %>" src="images/plus.png" />
                                                                            </a>
                                                                            <div id="div<%# Eval("ProjectId") %>" style="display: none;">
                                                                                <asp:GridView ID="grdQuery" runat="server" Width="99%"  AutoGenerateColumns="false" >
                                                                                    <HeaderStyle  />
                                                                                    <AlternatingRowStyle  BackColor="#F8F8F8" />
                                                                                    <RowStyle  BackColor="#D0D0D0 " />
                                                                                    <Columns>
                                                                                        <asp:BoundField HeaderText="Query Id" DataField="QueryId" ItemStyle-BorderStyle="Solid" />
                                                                                        <asp:BoundField HeaderText="Total Respondents" DataField="Total Respondents" ItemStyle-BorderStyle="Solid" />
                                                                                        <asp:BoundField HeaderText="Completes Count" DataField="Completes Count" ItemStyle-BorderStyle="Solid" />
                                                                                        <asp:BoundField HeaderText="Quota Count" DataField="Quota Count" ItemStyle-BorderStyle="Solid" />
                                                                                        <asp:BoundField HeaderText="Terminate Count" DataField="Terminate Count" ItemStyle-BorderStyle="Solid" />
                                                                                        <asp:BoundField HeaderText="Total Clicks" DataField="Total Clicks" ItemStyle-BorderStyle="Solid" />
                                                                                        <asp:BoundField HeaderText="Create Date" DataField="Create Date" ItemStyle-BorderStyle="Solid" />
                                                                                        <asp:BoundField HeaderText="Specialty Id" DataField="SpecialityId" ItemStyle-BorderStyle="Solid" />
                                                                                        <asp:BoundField HeaderText="Specialty" DataField="SpecialityOptionName" ItemStyle-BorderStyle="Solid" />
                                                                                        <asp:BoundField HeaderText="Sample Ratio" DataField="SampleRatio" ItemStyle-BorderStyle="Solid" />
                                                                                        <asp:BoundField HeaderText="Group" DataField="CompleteGroup" ItemStyle-BorderStyle="Solid" />
                                                                                        <asp:BoundField HeaderText="Requested N" DataField="ReqN" ItemStyle-BorderStyle="Solid" />
                                                                                    </Columns>
                                                                                </asp:GridView>
                                                                                </div>
                                                                        </ItemTemplate>
                                                                    </asp:TemplateField>
                                                                </Columns>
                                                            </asp:GridView>
                                                          
                                                        </td>
                                                    </tr>
                                                    <tr class="trGrid">
                                                        <td valign="top" colspan="2" style="font-family: tahoma; font-size: 13px; padding-left: 400px;">
                                                            <asp:Button runat="server" ID="btnClose" Text="Close Project" OnClick="btnClose_Click" />
                                                        </td>
                                                    </tr>                                                  
                                                </table>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        </form>
    </div>
</body>
</html>
