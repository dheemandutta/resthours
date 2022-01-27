using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.Base.Entities
{
    public class MedicalChestPOCO
    {
        public int ChestID { get; set; }
        public int VesselId { get; set; }
        public string IssuingAuthorityName { get; set; }
        public string IssueDate { get; set; }
        public string ExpiryDate { get; set; }
        public string CertificateImageName { get; set; }

        public string CertificateImagePath { get; set; }
    }
}
