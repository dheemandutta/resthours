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

        public string BMI { get; set; }

        public string Height { get; set; }

        public string Pulse { get; set; }

        public string Haemoglobin { get; set; }

        public string Temperature { get; set; }

        public int? FastingSuger { get; set; }

        public int VesselID { get; set; }

        public string RandomSuger { get; set; }

        public string Systolic { get; set; }

        public string Diastolic { get; set; }

        public string Weight { get; set; }

        public string DietaryRestriction { get; set; }

        public string RespiratoryRate { get; set; }

        public string Creatinine { get; set; }

        public string SPO2 { get; set; }

        public string Bilirubin { get; set; }

        public DateTime TakenDate { get; set; }
    }
}