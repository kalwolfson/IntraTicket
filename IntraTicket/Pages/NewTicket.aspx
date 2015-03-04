<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="NewTicket.aspx.cs" Inherits="IntraTicket.Pages.NewTicket" %>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h1 style="color: #00006C">New Ticket</h1>
    <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
    <table>
        <tr>
            <td>From User:<br />
                <asp:DropDownList ID="ddlFromUser" runat="server"></asp:DropDownList>
            </td>
            <td></td>
            <td>Assign To User:<br />
                <asp:DropDownList ID="ddlAssignTo" runat="server"></asp:DropDownList>
            </td>

            <td></td>
            <td>Priority:<br />
                <asp:RadioButtonList ID="rblPriority" Enabled="True" runat="server" RepeatDirection="Horizontal">
                    <asp:ListItem Value="Low">Low</asp:ListItem>
                    <asp:ListItem Value="Medium">Medium</asp:ListItem>
                    <asp:ListItem Value="Urgent">Urgent</asp:ListItem>
                </asp:RadioButtonList>
            </td>
            <td class="auto-style1">
                <asp:RequiredFieldValidator ID="rfvFromUser" runat="server" ErrorMessage="Please Select the person the Ticket is being issued for"
                    ControlToValidate="ddlFromUser"></asp:RequiredFieldValidator>
                <br />
                <asp:RequiredFieldValidator ID="rfvAssignTo" runat="server" ErrorMessage="Please Select the person the Ticket is being assigned to"
                    ControlToValidate="ddlAssignTo"></asp:RequiredFieldValidator>
                <br />
                <asp:RequiredFieldValidator ID="rfvPriority" runat="server" ErrorMessage="Please select the Prioriy"
                    ControlToValidate="rblPriority"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td>Subject:<br />
                <asp:TextBox ID="txtSubject" runat="server"></asp:TextBox>
            </td>
            <td></td>
            <td>Query Type:<br />
                <asp:DropDownList ID="ddlCategory" runat="server"></asp:DropDownList>
            </td>
            <td></td>
            <td>Pick a Due Date<asp:Calendar ID="Calendar1" runat="server" BackColor="White" BorderColor="#3366CC" BorderWidth="1px" CellPadding="1" DayNameFormat="Shortest" Font-Names="Verdana" Font-Size="8pt" ForeColor="#003399" Height="200px" Width="220px">
                <DayHeaderStyle BackColor="#99CCCC" ForeColor="#336666" Height="1px" />
                <NextPrevStyle Font-Size="8pt" ForeColor="#CCCCFF" />
                <OtherMonthDayStyle ForeColor="#999999" />
                <SelectedDayStyle BackColor="#009999" Font-Bold="True" ForeColor="#CCFF99" />
                <SelectorStyle BackColor="#99CCCC" ForeColor="#336666" />
                <TitleStyle BackColor="#003399" BorderColor="#3366CC" BorderWidth="1px" Font-Bold="True" Font-Size="10pt" ForeColor="#CCCCFF" Height="25px" />
                <TodayDayStyle BackColor="#99CCCC" ForeColor="White" />
                <WeekendDayStyle BackColor="#CCCCFF" />
            </asp:Calendar>
                <br />
                <asp:ScriptManager ID="ScriptManager1" runat="server" />
            </td>
            <td class="auto-style1">
                <asp:RequiredFieldValidator ID="rfvSubject" runat="server" ErrorMessage="Please provide a subject for the Ticket"
                    ControlToValidate="txtSubject"></asp:RequiredFieldValidator>
                <br />
                <asp:RequiredFieldValidator ID="rfvCategory" runat="server" ErrorMessage="Please select a query Type"
                    ControlToValidate="ddlCategory"></asp:RequiredFieldValidator>
                <br />
             
            </td>
        </tr>
        <tr>
            <td colspan="5">
                <asp:TextBox ID="txtBody" runat="server" Width="497px" Height="144px" TextMode="MultiLine"></asp:TextBox>

                
            </td>
            <td class="auto-style1">
                <asp:RequiredFieldValidator ID="rfvBody" runat="server" ErrorMessage="Please describe in full the problem that the user is experiencing"
                    ControlToValidate="txtBody"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td colspan="5">
                <asp:Label ID="lblUpload" runat="server" Text="Upload file here"></asp:Label>
                    <asp:GridView ID="GridViewFiles" runat="server" AutoGenerateColumns="False" 
                        OnRowCommand="GridViewFiles_RowCommand">
                        <Columns>
                            <asp:BoundField DataField="Name" HeaderText="Name" />
                            <asp:BoundField DataField="ContentType" HeaderText="ContentType" />
                            <asp:BoundField DataField="Size" HeaderText="Size" />
                            <asp:CommandField ShowDeleteButton="True"   />
                        </Columns>
                    </asp:GridView>
                <asp:FileUpload ID="FileUpload1" runat="server" />

                <asp:Button ID="btnUpload" runat="server" Text="Upload" BackColor="#FF3300"
                    Font-Bold="True" ForeColor="#000099" OnClick="btnUpload_Click" />
            </td>
            <td class="auto-style1">
                <asp:RequiredFieldValidator ID="rfvUpload" runat="server" ErrorMessage="Please Upload a file "
                    ControlToValidate="FileUpload1" Enabled="False"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td colspan="5">

                <asp:Button ID="btnSubmit" runat="server" Text="Submit Ticket" Width="115px" BackColor="#FF3300"
                    Font-Bold="True" ForeColor="#000099" OnClick="btnSubmit_Click" />
                <br />
                <asp:Label ID="dbErrorMessage" runat="server" ForeColor="Red"></asp:Label>
            </td>
            <td class="auto-style1">
                <asp:Label ID="lblSendSuccess" runat="server" Visible="False"></asp:Label>
                <br />
                <asp:Label ID="lblSendErrorMsg" runat="server" Visible="False"></asp:Label>
            </td>
        </tr>


    </table>
</asp:Content>