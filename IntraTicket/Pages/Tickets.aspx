<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Tickets.aspx.cs" Inherits="IntraTicket.Tickets" %>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h1 style="color: #000099">Ticket Finder</h1>
    <table style="background-color: #E32F02" style="z-index: 999">
        <tr style="border-style: none; background-color: #E32F02">
            <td>Ticket Status:</td>
            <td>
                <asp:CheckBoxList ID="cblStatus" runat="server" RepeatDirection="Horizontal">
                    <asp:ListItem Selected="True">Open</asp:ListItem>
                    <asp:ListItem Selected="True">Closed</asp:ListItem>
                    <asp:ListItem Selected="True">In Progress</asp:ListItem>
                </asp:CheckBoxList>
            </td>
            <td>&nbsp;</td>
            <td>
                <asp:Button ID="btnRefreshStatSelection" runat="server" Text="Refresh"
                    BackColor="#000099" BorderColor="Blue" Font-Bold="True" ForeColor="#E32F02"
                    OnClick="btnRefreshStatSelection_Click"
                    PostBackUrl="~/Pages/Tickets.aspx" />
            </td>
        </tr>
    </table>
    <table>
        <tr>
            <td colspan="5">

                <asp:GridView ID="GridTicketView" runat="server" CellPadding="4"
                    ForeColor="#333333" AutoGenerateColumns="False" GridLines="None" DataKeyNames="TicketID"
                    OnRowCommand="GridTicketView_RowCommand">
                    <AlternatingRowStyle BackColor="White" />
                    <Columns>
                        <asp:CommandField HeaderText="Select" ShowCancelButton="False" ShowSelectButton="True" />
                        <asp:BoundField DataField="TicketID" HeaderText="TicketID" />
                        <asp:BoundField HeaderText="From Employee" DataField="FromUser.Name" />
                        <asp:BoundField HeaderText="Assigned To" DataField="AssignedTo.Name" />
                        <asp:BoundField HeaderText="Category" DataField="Category.Category" />
                        <asp:BoundField DataField="Subject" HeaderText="Subject" />
                        <asp:BoundField DataField="Priority" HeaderText="Priority" />
                        <asp:BoundField DataField="DateAdded" HeaderText="Date Added" />
                        <asp:BoundField DataField="DueDate" HeaderText="Due Date" />
                        <asp:BoundField DataField="Status" HeaderText="Status" />
                    </Columns>
                    <FooterStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
                    <HeaderStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
                    <PagerStyle BackColor="#FFCC66" ForeColor="#333333" HorizontalAlign="Center" />
                    <RowStyle BackColor="#FFFBD6" ForeColor="#333333" />
                    <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="Navy" />
                </asp:GridView>

            </td>
        </tr>
    </table>

    <asp:Panel ID="PanelEditControls" runat="server" Visible="False">

        <asp:Label ID="lblProblem" runat="server" Font-Bold="True" Text="Problem Description : "></asp:Label>

        <asp:Label ID="lblProblemDescription" runat="server" Font-Bold="True"></asp:Label>
        <br />
        <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
        <br />

        <table style="width: 100%">
            <tr>
                <td colspan="4">
                    <asp:Label ID="lblResolutionStep" runat="server" Text="What progress has been made so far?"></asp:Label>
                    <br />
                    <asp:RequiredFieldValidator Enabled="False" ID="rfvResolveStep" runat="server" ControlToValidate="txtStepResolve"
                        ErrorMessage="Please describe how the ticket is being resolved"></asp:RequiredFieldValidator>
                    <br />
                    <asp:TextBox ID="txtStepResolve" runat="server" TextMode="MultiLine"
                        Height="150px" Width="90%" BorderStyle="Solid" Style="margin-right: 2px"></asp:TextBox>
                </td>
                <td>
                    <asp:RequiredFieldValidator ID="rfvResolvesStep" runat="server" ErrorMessage="Please Describe what progress has been made so far"
                        ControlToValidate="txtStepResolve" ForeColor="Red"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td>From User:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:DropDownList ID="ddlFromUser" runat="server"></asp:DropDownList>
                </td>
                <td>Assign To User:
                    <asp:DropDownList ID="ddlAssignTo" runat="server">
                    </asp:DropDownList>
                </td>
                <td class="auto-style6">Priority:<br />
                    <asp:RadioButtonList ID="rblPriority" Enabled="True" runat="server" RepeatDirection="Horizontal">
                        <asp:ListItem Value="Low">Low</asp:ListItem>
                        <asp:ListItem Value="Medium">Medium</asp:ListItem>
                        <asp:ListItem Value="Urgent">Urgent</asp:ListItem>
                    </asp:RadioButtonList>
                </td>
                <td class="auto-style8">Pick a Due Date<asp:Calendar ID="Calendar1" runat="server"
                    BackColor="White" BorderColor="#3366CC" BorderWidth="1px" CellPadding="1" DayNameFormat="Shortest"
                    Font-Names="Verdana" Font-Size="8pt" ForeColor="#003399" Height="95px" Width="220px"
                    ValidateRequestMode="Enabled">
                    <DayHeaderStyle BackColor="#99CCCC" ForeColor="#336666" Height="1px" />
                    <NextPrevStyle Font-Size="8pt" ForeColor="#CCCCFF" />
                    <OtherMonthDayStyle ForeColor="#999999" />
                    <SelectedDayStyle BackColor="#009999" Font-Bold="True" ForeColor="#CCFF99" />
                    <SelectorStyle BackColor="#99CCCC" ForeColor="#336666" />
                    <TitleStyle BackColor="#003399" BorderColor="#3366CC" BorderWidth="1px" Font-Bold="True"
                        Font-Size="10pt" ForeColor="#CCCCFF" Height="25px" />
                    <TodayDayStyle BackColor="#99CCCC" ForeColor="White" />
                    <WeekendDayStyle BackColor="#CCCCFF" />
                </asp:Calendar>
                    <br />
                </td>
                <td>

                    <asp:RequiredFieldValidator ID="rfvFromUser" runat="server" ForeColor="Red" ErrorMessage="Please Select the person the ticket is from"
                        ControlToValidate="ddlFromUser"></asp:RequiredFieldValidator>
                    <br />
                    <asp:RequiredFieldValidator ID="rfvAssignedTo" runat="server" ForeColor="Red" ErrorMessage="Please Select the person the ticket is being assigned to"
                        ControlToValidate="ddlAssignTo"></asp:RequiredFieldValidator>
                    <br />
                    <asp:RequiredFieldValidator ID="rfvPriority" runat="server" ForeColor="Red" ErrorMessage="Please Select the ticket priority"
                        ControlToValidate="rblPriority"></asp:RequiredFieldValidator>
                    <br />

                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <asp:RequiredFieldValidator ID="rfvStatus" runat="server" Enabled="False" ErrorMessage="Please Select a status"
                        ControlToValidate="rblStatus"></asp:RequiredFieldValidator>
                    <br />
                    <asp:RadioButtonList ID="rblStatus" runat="server" RepeatDirection="Horizontal" Width="246px">
                        <asp:ListItem>Open</asp:ListItem>
                        <asp:ListItem>In-Progress</asp:ListItem>
                        <asp:ListItem>Closed</asp:ListItem>
                    </asp:RadioButtonList>
                </td>
                <td class="auto-style2" colspan="2">
                    <asp:GridView ID="GridViewFiles" runat="server" AutoGenerateColumns="False"
                        OnRowCommand="GridViewFiles_RowCommand">
                        <Columns>
                            <asp:BoundField DataField="Name" HeaderText="Name" />
                            <asp:BoundField DataField="ContentType" HeaderText="ContentType" />
                            <asp:BoundField DataField="Size" HeaderText="Size" />
                            <asp:TemplateField ShowHeader="False">
                                <ItemTemplate>
                                    <a href='../getFile.do?File=<%# Eval("FileID") %>'>Download</a>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:CommandField ShowDeleteButton="True" />
                        </Columns>
                    </asp:GridView>
                    <asp:FileUpload ID="FileUpload1" runat="server" />
                    <asp:Button ID="btnUpload" runat="server" BackColor="#FF3300" Font-Bold="True"
                        ForeColor="#000099" OnClick="btnUpload_Click" Text="Upload "
                        Width="109px" />
                </td>
                <td>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ErrorMessage="Please Select a Ticket Status"
                        ControlToValidate="rblStatus" ForeColor="Red"></asp:RequiredFieldValidator>
                </td>

            </tr>
            <tr>
                <td></td>
                <td>
                    <asp:Button ID="btnSaveChanges" runat="server" Text="Save Ticket Changes"
                        Width="152px" BackColor="#FF3300" Font-Bold="True" ForeColor="#000099" OnClick="btnSaveChanges_Click" />
                </td>

            </tr>

        </table>
        <table style="width: 100%">
            <tr>
                <td colspan="3">
                    <asp:Label ID="lblResolution" runat="server" Text="How was the Ticket Resolved?"></asp:Label>
                    &nbsp;&nbsp;
                    <asp:RequiredFieldValidator ID="rfvResolved" runat="server"
                        ControlToValidate="txtResolution" Enabled="False"
                        ErrorMessage="Please describe how the Ticket was resolved "></asp:RequiredFieldValidator>
                    <br />
                    <asp:TextBox ID="txtResolution" runat="server" BorderStyle="Solid"
                        Height="200px" TextMode="MultiLine" Width="64%"></asp:TextBox>

                    <br />

                </td>

            </tr>
        </table>
    </asp:Panel>

</asp:Content>


