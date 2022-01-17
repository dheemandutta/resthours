using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.Base.Entities
{
    public class CompanyDetailsPOCO
    {
        public int ID { get; set; }
        public string Name { get; set; }
        public string Address { get; set; }
        public string Website { get; set; }
        public string AdminContact { get; set; }
        public string AdminContactEmail { get; set; }
        public string ContactNumber { get; set; }
        public string Domain { get; set; }
        public string SecureKey { get; set; }


        public string OwnerName { get; set; }
        public string OwnerAddress { get; set; }
        public string OwnerWebsite { get; set; }
        public string OwnerAdminContact { get; set; }
        public string OwnerAdminContactEmail { get; set; }
        public string OwnerContactNumber { get; set; }
        public string OwnerDomain { get; set; }
    }
}
