using System.Web.UI.WebControls;
using IntraTicket.DataAccess;
using IntraTicket.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Web;

namespace IntraTicket.Pages
{
    public partial class NewTicket : System.Web.UI.Page
    {
        protected void GridViewFiles_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            BindFiles();

            List<File> files = (List<File>)Session["TempFiles"];
            var file = files.ElementAt(Convert.ToInt32(e.CommandArgument));
            files.Remove(file);
            Session["TempFiles"] = files;


            e.Handled = true;
            
        }


        public void BindControls()
        {
            rblPriority.Enabled = true;

            using (var context = new IntraTicketEntities())
            {
                var categories = context.TicketCategories.ToList();
                var employees = context.Employees.ToList();

                ddlCategory.DataSource = categories;
                ddlCategory.DataValueField = "CategoryID";
                ddlCategory.DataTextField = "Category";
                ddlCategory.DataBind();

                ddlAssignTo.DataSource = employees;
                ddlAssignTo.DataValueField = "EmployeeID";
                ddlAssignTo.DataTextField = "Name";
                ddlAssignTo.DataBind();

                ddlFromUser.DataSource = employees;
                ddlFromUser.DataValueField = "EmployeeID";
                ddlFromUser.DataTextField = "Name";
                ddlFromUser.DataBind();
                BindFiles();
            }
        }


        private void BindFiles()
        {
            GridViewFiles.DataSource = Session["TempFiles"];
            GridViewFiles.DataBind();
        }


        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {

                SaveTicket();

                SaveFiles();

                Response.Redirect("Tickets.aspx");
            }

        }

        private void SaveFiles()
        {
            List<File> files = (List<File>)Session["TempFiles"];

            foreach (var file in files)
                FileUtilites.SaveFile(file.Name, file.TicketID, file.ContentType, file.Size, file.Data);
        }

        private void SaveTicket()
        {
            BindControls();


            Employee fromUser = ((List<Employee>)ddlFromUser.DataSource).ElementAt(ddlFromUser.SelectedIndex);
            Employee assignedTo = ((List<Employee>)ddlAssignTo.DataSource).ElementAt(ddlAssignTo.SelectedIndex);
            TicketCategory category = ((List<TicketCategory>)ddlCategory.DataSource).ElementAt(ddlCategory.SelectedIndex);

            string priority = rblPriority.SelectedItem.Value;
            string subject = txtSubject.Text;
            string description = txtBody.Text;
            var dateAdded = DateTime.Now;
            var dueDate = Calendar1.SelectedDate;

            using (var context = new IntraTicketEntities())
            {

                var newTicket = context.Tickets.Add(new Ticket()
                {
                    EmployeeIDAssignTo = assignedTo.EmployeeID,
                    CategoryID = category.CategoryID,
                    DateAdded = dateAdded,
                    Description = description,
                    DueDate = dueDate,
                    Priority = priority,
                    Subject = subject,
                    EmployeeIDFrom = fromUser.EmployeeID,
                    Status = "Open"
                });


                context.SaveChanges();

                //Assign the files saved in session to the new TicketID
                List<File> files = (List<File>)Session["TempFiles"];
                foreach (var file in files)
                {
                    file.TicketID = newTicket.TicketID;
                }

                //SendEmail(newTicket, fromUser, assignedTo);
            }

        }


        protected void btnUpload_Click(object sender, EventArgs e)
        {
            // Although I put only one http file control on the aspx page,
            // the following code can handle multiple file controls in a single aspx page.
            HttpFileCollection requestFiles = Request.Files;
            foreach (string fileTagName in requestFiles)
            {
                HttpPostedFile file = Request.Files[fileTagName];
                if (file != null && file.ContentLength > 0)
                {
                    // Due to the limit of the max for a int type, the largest file can be
                    // uploaded is 2147483647, which is very large anyway.
                    int size = file.ContentLength;
                    string name = file.FileName;
                    int position = name.LastIndexOf("\\");
                    name = name.Substring(position + 1);
                    string contentType = file.ContentType;
                    byte[] fileData = new byte[size];

                    file.InputStream.Read(fileData, 0, size);

                    List<File> files = (List<File>)Session["TempFiles"];

                    files.Add(new File()
                    {
                        ContentType = contentType,
                        Data = fileData,
                        Name = name,
                        Size = size,
                        TicketID = 0
                    });

                }
                BindFiles();
            }
        }

        //private void SendEmail(Ticket ticket, Employee from, Employee to)
        //{
        //    SmtpClient smtpClient = new SmtpClient();

        //    smtpClient.Host = "mail.peterspapers.co.za"; // Should be in web.config settings.
        //    smtpClient.Port = 25;

        //    var message = new MailMessage
        //    {
        //        Body = string.Format("Ticket Contents:{1}{0}{1}{1}Status:{1}{2}{1}",
        //                             ticket.Description,
        //                             Environment.NewLine,
        //                             ticket.Status),

        //        Subject = string.Format("RE: New Intraticket created. #{1};Subject : {0}",
        //                                ticket.Subject,
        //                                ticket.TicketID),

        //        From = new MailAddress(from.EmailAddress)
        //    };

        //    message.To.Add(new MailAddress(from.EmailAddress));
        //    message.To.Add(new MailAddress(to.EmailAddress));

        //    smtpClient.Send(message);
        //}

        protected void Page_Load(object sender, EventArgs e)
        {
            CheckTempSession();
            BindControls();

        }

        private void CheckTempSession()
        {
            if (Session["TempFiles"] == null)
            {
                Session["TempFiles"] = new List<File>();
            }
        }

    }
}