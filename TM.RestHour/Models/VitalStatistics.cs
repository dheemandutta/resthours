using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TM.RestHour.Models
{
    public class VitalStatistics
    {
        public int ID { get; set; }
        public int CIRMId { get; set; }
        public String ObservationDate { get; set; }
        public String ObservationTime { get; set; }
        public string Pulse { get; set; }
        public string RespiratoryRate { get; set; }
        public string OxygenSaturation { get; set; }
        public string Himoglobin { get; set; }
        public string Creatinine { get; set; }
        public string Bilirubin { get; set; }
        public string Temperature { get; set; }
        public string Systolic { get; set; }
        public string Diastolic { get; set; }
        public string Fasting { get; set; }
        public string Regular { get; set; }
        


    }
}