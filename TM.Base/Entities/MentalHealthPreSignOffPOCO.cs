using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.Base.Entities
{
    public class MentalHealthPreSignOffPOCO
    {
        public int CrewId { get; set; }
        public string CrewName { get; set; }
        public string PreSignOffDate { get; set; }
        public Boolean IsLocusTested { get; set; }
        public Boolean IsMassTested { get; set; }
        public Boolean IsPSQ30Tested { get; set; }
        public Boolean IsBeckTested { get; set; }
        public Boolean IsZ1Tested { get; set; }
        public Boolean IsZ2Tested { get; set; }
        public Boolean IsRoseTested { get; set; }
        public Boolean IsEmotionalTested { get; set; }
    }
}
