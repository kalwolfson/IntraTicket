//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace IntraTicket.DataAccess
{
    using System;
    using System.Collections.Generic;
    
    public partial class TicketCategory
    {
        public TicketCategory()
        {
            this.Tickets = new HashSet<Ticket>();
        }
    
        public int CategoryID { get; set; }
        public string Category { get; set; }
    
        public virtual ICollection<Ticket> Tickets { get; set; }
    }
}
