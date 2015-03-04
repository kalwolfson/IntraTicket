using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Web;
using System.Web.UI.WebControls;
using IntraTicket.DataAccess;
using IntraTicket.Utilities;

namespace IntraTicket
{
    public partial class Tickets : System.Web.UI.Page
    {
        public void BindEntities(bool showOpen, bool showClosed, bool showInProgress)
        {
            using (var context = new IntraTicketEntities())
            {

                var results = from ticket in context.Tickets
                              where ((ticket.Status == "Open" & showOpen) |
                                    (ticket.Status == "Closed" & showClosed) |
                                    (ticket.Status == "In-Progress" & showInProgress))
                              select ticket;
                GridTicketView.DataSource = results.ToList();
                GridTicketView.DataBind();
            }
        }

        private void RefreshData()
        {
            BindEntities(
                      cblStatus.Items[0].Selected,
                      cblStatus.Items[1].Selected,
                      cblStatus.Items[2].Selected);
        }

        public void BindEditingControls()
        {
            using (var context = new IntraTicketEntities())
            {
                var employees = context.Employees.ToList();

                ddlAssignTo.DataSource = employees;
                ddlAssignTo.DataValueField = "EmployeeID";
                ddlAssignTo.DataTextField = "Name";
                ddlAssignTo.DataBind();

                ddlFromUser.DataSource = employees;
                ddlFromUser.DataValueField = "EmployeeID";
                ddlFromUser.DataTextField = "Name";
                ddlFromUser.DataBind();


            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            RefreshData();
        }

        private void BindFiles(int ticketID)
        {

            GridViewFiles.DataSource = FileUtilites.GetFileList(ticketID);
            GridViewFiles.DataBind();

        }
        private void ShowEditControls(bool isVisible)
        {
            PanelEditControls.Visible = isVisible;
            BindEditingControls();
        }



        protected void btnRefreshStatSelection_Click(object sender, EventArgs e)
        {
            RefreshData();
        }

        protected void btnSaveChanges_Click(object sender, EventArgs e)
        {



            var ticketUnderEdit = GetTicketFromDataRowDataItem(GridTicketView.SelectedIndex);

            using (var context = new IntraTicketEntities())
            {
                // We attach the ticket loaded from another context so the change tracking can pick up the edits.
                var ticket = context.Tickets.Attach(ticketUnderEdit);

                ticket.Priority = rblPriority.SelectedItem.Value;
                ticket.DueDate = Calendar1.SelectedDate;
                ticket.EmployeeIDFrom = Convert.ToInt32(ddlFromUser.SelectedItem.Value);
                ticket.EmployeeIDAssignTo = Convert.ToInt32(ddlAssignTo.SelectedItem.Value);
                ticket.ResolutionMain = txtResolution.Text;
                ticket.Status = rblStatus.SelectedItem.Value;
                ticket.Resolution1 = txtStepResolve.Text;

                context.SaveChanges();
                //SendEmail(ticketUnderEdit);
            }

        }


        //private void SendEmail(Ticket ticket)
        //{
        //    SmtpClient smtpClient = new SmtpClient();

        //    smtpClient.Host = "mail.peterspapers.co.za"; // Should be in web.config settings.
        //    smtpClient.Port = 25;

        //    var message = new MailMessage
        //    {
        //        Body = string.Format("Ticket Contents:{1}{0}{1}{1}Comments:{1}{2}{1}{1}Resolution:{1}{3}{1}Status:{1}{4}{1}",
        //                             ticket.Description,
        //                             Environment.NewLine,
        //                             ticket.Resolution1,
        //                             ticket.ResolutionMain,
        //                             ticket.Status),

        //        Subject = string.Format("RE: Intraticket #{1};Subject : {0}",
        //                                ticket.Subject,
        //                                ticket.TicketID),
        //        From = new MailAddress(ticket.FromUser.EmailAddress),
        //    };

        //    message.To.Add(new MailAddress(ticket.FromUser.EmailAddress));
        //    message.To.Add(new MailAddress(ticket.AssignedTo.EmailAddress));

        //    smtpClient.Send(message);

        //    Response.Redirect("Tickets.aspx");
        //}
        protected void GridTicketView_RowCommand(object sender, GridViewCommandEventArgs e)
        {


            var currentRowIndex = Convert.ToInt32(e.CommandArgument);

            var ticket = GetTicketFromDataRowDataItem(currentRowIndex);

            switch (ticket.Status)
            {
                case "In-Progress":
                    txtStepResolve.Text = ticket.Resolution1;
                    break;
                case "Closed":
                    txtResolution.Text = ticket.ResolutionMain;
                    txtStepResolve.Text = ticket.Resolution1;
                    break;
                default:
                    lblProblemDescription.Text = ticket.Description;
                    break;
            }


            ShowEditControls(true);

            BindFiles(ticket.TicketID);
        }

        private Ticket GetTicketFromDataRowDataItem(int currentRowIndex)
        {
            //TODO Should work need to investigate??
            // var ticket = (Ticket)GridTicketView.Rows[currentRowIndex].DataItem; 
            var list = (IEnumerable<Ticket>)GridTicketView.DataSource;
            var ticket = list.ElementAt(currentRowIndex);
            return ticket;
        }


        protected void btnUpload_Click(object sender, EventArgs e)
        {
            // Although I put only one http file control on the aspx page,
            // the following code can handle multiple file controls in a single aspx page.
            HttpFileCollection files = Request.Files;
            foreach (string fileTagName in files)
            {
                HttpPostedFile file = Request.Files[fileTagName];
                if (file.ContentLength > 0)
                {
                    // Due to the limit of the max for a int type, the largest file can be
                    // uploaded is 2147483647, which is very large anyway.
                    int size = file.ContentLength;
                    string name = file.FileName;
                    int position = name.LastIndexOf("\\");
                    name = name.Substring(position + 1);
                    string contentType = file.ContentType;
                    byte[] fileData = new byte[size];
                    var ticket = GetTicketFromDataRowDataItem(GridTicketView.SelectedIndex);
                    file.InputStream.Read(fileData, 0, size);
                    FileUtilites.SaveFile(name, ticket.TicketID, contentType, size, fileData);
                }
            }
            Response.Redirect("Tickets.aspx");
        }

        protected void GridViewFiles_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            //TODO this is cheating, im using this to load the file list because the DataSource is null
            var ticket = GetTicketFromDataRowDataItem(GridTicketView.SelectedIndex);
            BindFiles(ticket.TicketID);

            var list = (IEnumerable<File>)GridViewFiles.DataSource;
            var file = list.ElementAt(Convert.ToInt32(e.CommandArgument));

            FileUtilites.DeleteFile(file);

            e.Handled = true;
            Response.Redirect("Tickets.aspx");
        }
    }
}