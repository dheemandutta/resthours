using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TM.RestHour.Models
{
    public class PsychologicalEvaluation
    {
        public int CrewId { get; set; }
        public string Mode { get; set; }
        public int JoiningCondition { get; set; }
    }
}