using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.Base.Entities
{
    public class ExaminationForMedicalAdvisePOCO
    {
        public int Id { get; set; }
        public string Examination { get; set; }
        public string ExaminationPath { get; set; }
        public DateTime ExaminationDate { get; set; }
    }
}
