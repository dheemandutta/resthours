using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.Base.Entities
{
    public class ExaminationByDoctorAdvisePOCO
    {

        public int ExaminationId { get; set; }
        public int AdviseId { get; set; }
        public string ExaminationName { get; set; }
        public string ExaminationFilePath { get; set; }

    }
}
