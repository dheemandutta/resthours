using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.Base.Entities
{
    public class PlanPOCO
    {
        public int CategoryId { get; set; }
        public string CategoryName { get; set; }

        public int PlanId { get; set; }
        public string PlanName { get; set; }
        public string PlanImagePath { get; set; }

        public string CreatedAt { get; set; }
        public int CreatedBy { get; set; }
        public string UpdatedAt { get; set; }
        public int UpdatedBy { get; set; }

        
    }
}
