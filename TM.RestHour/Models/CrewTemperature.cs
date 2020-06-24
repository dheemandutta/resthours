using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TM.RestHour.Models
{
    public class CrewTemperature
    {
        public int ID { get; set; }
        public int CrewID { get; set; }
        public decimal Temperature { get; set; }
        public string Unit { get; set; }
        public DateTime ReadingDate { get; set; }
        public DateTime ReadingTime { get; set; }
        public string Comment { get; set; }
    }
}