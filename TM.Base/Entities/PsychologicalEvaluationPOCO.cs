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
        public int VesselID { get; set; }
        public int CrewId { get; set; }
    }
}
