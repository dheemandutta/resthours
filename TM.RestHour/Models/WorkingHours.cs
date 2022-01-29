using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TM.RestHour.Models
{
    public class WorkingHours
    {
        public int SunDay { get; set; }
        public int MonDay { get; set; }
        public int TueDay { get; set; }
        public int WedDay { get; set; }
        public int ThuDay { get; set; }
        public int FriDay { get; set; }
        public int SatDay { get; set; }



        public int DayNumber { get; set; }
        public int RegimeID { get; set; }
        public int WorkHours { get; set; }
    }
}