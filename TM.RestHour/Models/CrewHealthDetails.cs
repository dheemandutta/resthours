using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TM.RestHour.Models
{
    public class CrewHealthDetails
    {
        public int ID { get; set; }
        public string Name { get; set; }
        public int RankID { get; set; }
        public string RankName { get; set; }
        public string Nationality { get; set; }

        public DateTime DOB { get; set; }
        public DateTime JoinDate { get; set; }
        public string Sex { get; set; }
        public string Adiction { get; set; }
        public string Ethinicity { get; set; }
        public string Frequency { get; set; }
        public string Category { get; set; }
        public string SubCategory { get; set; }
        public string Pulse { get; set; }
        public string SPO2 { get; set; }
        public string Respiratory { get; set; }
        public string Systolic { get; set; }
        public string Diastolic { get; set; }
        public DateTime ObservedDate{ get; set; }
        public string ObservedTime{ get; set; }
        public string IsVomiting { get; set; }
        public string VomitingFrequency{ get; set; }
        public string IsFits { get; set; }
        public string FitsFrequency{ get; set; }
        public string SympDetails { get; set; }
        public string Medicines { get; set; }
        public string OtherInfo{ get; set; }
        public string AccidentDesc{ get; set; }
        public string SeverityPain{ get; set; }
        public string AccidentLocation { get; set; }
        public string InjuryLocation { get; set; }
        public string FrequencyOfPain{ get; set; }
        public string FirstAid  { get; set; }

        public string PercentageOfInjury  { get; set; }

        public string DoctorsMail { get; set; }


    }
}