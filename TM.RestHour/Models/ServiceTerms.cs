using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TM.RestHour.Models
{
    public class ServiceTerms
    {
        public int ID { get; set; }
        public DateTime ActiveFrom { get; set; }
        public DateTime? ActiveTo { get; set; }
        public int CrewID { get; set; }
        public int OvertimeID { get; set; }
        public int ScheduleID { get; set; }
        public int RankID { get; set; }
        public Boolean Deleted { get; set; }
        public String ActiveFrom1 { get; set; }

        public String ActiveTo1 { get; set; }

        
    }
}