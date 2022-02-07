using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.Base.Entities
{
    public class PsychologicalEvaluationPOCO
    {
        public int Id { get; set; }
        public string Question { get; set; }
        public string Answer { get; set; }
        public int FinalScore { get; set; }
        public string TestResult { get; set; }
        public DateTime TestDate { get; set; }
        public int VesselID { get; set; }
        public int CrewId { get; set; }
        public int IsExport { get; set; }


        public int SAScore { get; set; }
        public string SATestResult { get; set; }
        public int SCScore { get; set; }
        public string SCTestResult { get; set; }
        public int EmpathyScore { get; set; }
        public string EmpathyTestResult { get; set; }
        public int RIScore { get; set; }
        public string RITestResult { get; set; }
    }
}
