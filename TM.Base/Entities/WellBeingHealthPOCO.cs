using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.Base.Entities
{
    public class WellBeingHealthPOCO
    {
        public int CrewId { get; set; }
        public string CrewName { get; set; }
        public Boolean IsJoiningMedical { get; set; }
        public Boolean IsMonthlyMedicalData { get; set; }
        public Boolean IsPrescriptionMedicine { get; set; }
        public Boolean IsMedicalAdvise { get; set; }
        public Boolean IsMedicinePrescribed { get; set; }
        public Boolean IsOthers { get; set; }
    }
}
