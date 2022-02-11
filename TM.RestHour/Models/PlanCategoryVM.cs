using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TM.RestHour.Models
{
    public class PlanCategoryVM
    {
        public Plan PlanCategory { get; set; }
        public Plan Plan { get; set; }

        public List<Plan> PlanCategoryList { get; set; }

        public List<Plan> PlanList { get; set; }
    }
}