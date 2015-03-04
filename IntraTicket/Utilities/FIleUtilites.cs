using System.Collections.Generic;
using System.Linq;
using IntraTicket.DataAccess;

namespace IntraTicket.Utilities
{
    public class FileUtilites
    {


        // Get the list of the files in the database
        public static List<File> GetFileList(int ticketID)
        {
            using (var context = new IntraTicketEntities())
            {

                var results = from file in context.Files
                              where file.TicketID == ticketID
                              select file;

                return results.ToList();
            }
        }

        // Save a file into the database
        public static void SaveFile(string name, int ticketID, string contentType,
                                    int size, byte[] data)
        {

            using (var context = new IntraTicketEntities())
            {

                context.Files.Add(new File()
                {
                    ContentType = contentType,
                    Data = data,
                    Name = name,
                    Size = size,
                    TicketID = ticketID
                });

                context.SaveChanges();

            }
        }


        // Get a file from the database by ID
        public static File GetAFile(int fileID)
        {
            using (var context = new IntraTicketEntities())
            {

                var file = context.Files.SingleOrDefault(f => f.FileID == fileID);

                return file;
            }
        }

        public static void DeleteFile(File file)
        {
            using (var context = new IntraTicketEntities())
            {

                var bouldFile = context.Files.Attach(file);
                context.Files.Remove(bouldFile);
                context.SaveChanges();
            }
        }
    }
}