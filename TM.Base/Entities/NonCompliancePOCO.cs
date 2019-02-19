using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.Base.Entities
{
    public class NonCompliancePOCO
    {
        public int CrewID { get; set; }
        public DateTime OccuredOn { get; set; }
        public string  ComplianceInfo { get; set; }
        public float TotalNCHours { get; set; }
       
    }
}
