using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.Base.Entities
{
    public class CIRMMedicationTakenPOCO
    {
        
        public int MedicationId { get; set; }
        public int CIRMId { get; set; }
        public string PrescriptionName { get; set; }
        public string MedicalConditionBeingTreated { get; set; }

        public string HowOftenMedicationTaken { get; set; }

    }
}
