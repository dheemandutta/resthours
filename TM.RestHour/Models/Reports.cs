using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TM.RestHour.Models
{
    public class Reports
    {
        public int ID { get; set; }
        public int CrewID { get; set; }
        public DateTime ValidOn { get; set; }
        public string Hours { get; set; }

        public string SelectedMonthYear { get; set; }

        public int Month { get; set; }

        public int Year { get; set; }

        public string FirstName { get; set; }

        public string LastName { get; set; }

        public string RankName { get; set; }

        public string MonthName { get; set; }



        public string DateNumber { get; set; }

        public int NCDetailsID { get; set; }
    }
}