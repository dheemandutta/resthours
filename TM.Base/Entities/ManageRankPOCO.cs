using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.Base.Entities
{
    public class ManageRankPOCO
    {
        public int ID { get; set; }
        public string Name { get; set; }
        public int RankID { get; set; }
        public string RankName { get; set; }
        public DateTime CreatedOn { get; set; }
        public string CreatedOn1 { get; set; }
        public DateTime LatestUpdate { get; set; }
        public string LatestUpdate1 { get; set; }
        public string PayNum { get; set; }
        public string EmployeeNumber { get; set; }
        public string Notes { get; set; }
        public Boolean Watchkeeper { get; set; }
        public Boolean OvertimeEnabled { get; set; }
    }
}
