using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.Base.Entities
{
    public class MentalHealthPOCO
    {
        public List<MentalHealthPostJoiningPOCO> MentalHealthPostJoiningList { get; set; }
        public List<MentalHealthPreSignOffPOCO> MentalHealthPreSignOffList { get; set; }
    }
}
