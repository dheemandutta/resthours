using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.Base.Entities
{
    public class ShipPOCO
    {
        public int ID { get; set; }
        public string ShipName { get; set; }
        public string IMONumber { get; set; }
        public string FlagOfShip { get; set; }
        public string Regime { get; set; }

        public string SuperAdminUserName { get; set; }
        public string SuperAdminPassword { get; set; }

        public string Vessel { get; set; }
        public string Flag { get; set; }
        public int IMO { get; set; }
        public string AdminUser { get; set; }
        public string AdminPassword { get; set; }

        public string SmtpServer { get; set; }
        public string Port { get; set; }
        public string MailFrom { get; set; }
        public string MailTo { get; set; }
        public string MailPassword { get; set; }
        public string AttachmentSize { get; set; }
    }
}
