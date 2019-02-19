using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TM.RestHour.Models
{
    public class Consultant
    {
        public int SpecialityID { get; set; }
        public string SpecialityName { get; set; }

        public int DoctorID { get; set; }
        public string DoctorName { get; set; }
        public string DoctorEmail { get; set; }
        public string Comment { get; set; }

        public string Problem { get; set; }

        public int ID { get; set; }
        public DateTime DOB { get; set; }
        public string DOB1 { get; set; }

        public int MedicalAdvisoryID { get; set; }

        public string Weight { get; set; }
        public string BMI { get; set; }
        public string BP { get; set; }
        public string BloodSugarLevel { get; set; }
        public Boolean UrineTest { get; set; }

        public string Height { get; set; }
        public string Age { get; set; }
        public string BloodSugarUnit { get; set; }
        public string BloodSugarTestType { get; set; }
        public string Systolic { get; set; }
        public string Diastolic { get; set; }

        public Boolean UnannouncedAlcohol { get; set; }
        public Boolean AnnualDH { get; set; }
        public string Month { get; set; }
        public string CrewName { get; set; }

        public Crew Crew { get; set; }

        public string PulseRatebpm { get; set; }
        public string AnyDietaryRestrictions { get; set; }
        public string MedicalProductsAdministered { get; set; }
        public string UploadExistingPrescriptions { get; set; }
        public string UploadUrineReport { get; set; }

        public int CrewID { get; set; }
    }
}