using System;
using System.Web;
using IntraTicket.Utilities;

namespace IntraTicket.Pages
{
    public class FileHandler : IHttpHandler
    {

        #region IHttpHandler Members

        public bool IsReusable
        {
            get { return true; }
        }

        public void ProcessRequest(HttpContext context)
        {

            var fileID = Convert.ToInt32(context.Request.QueryString["File"]);

            var file = FileUtilites.GetAFile(fileID);
            context.Response.Clear();
            context.Response.ContentType = file.ContentType;
            context.Response.AddHeader("content-disposition", string.Format(@"attachment;filename=""{0}""", file.Name));
            context.Response.BinaryWrite(file.Data);
            context.Response.Flush();
            context.Response.End();

        }

        #endregion
    }
}
