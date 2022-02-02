using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TM.RestHour.Models
{
    public class CIRMMedicationTaken
    {
        public int MedicationId { get; set; }
        public int CIRMId { get; set; }
        public string PrescriptionName { get; set; }
        public string MedicalConditionBeingTreated { get; set; }

        public string HowOftenMedicationTaken { get; set; }
    }
}