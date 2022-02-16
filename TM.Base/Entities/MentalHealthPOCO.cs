using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.Base.Entities
{
    public class MentalHealthPOCO
    {
        public List<MentalHealthPostJoiningPOCO> rightsList;
        public List<MentalHealthPreSignOffPOCO> crewList;

        public MentalHealthPOCO()
        {
            rightsList = new List<MentalHealthPostJoiningPOCO>();
            this.MentalHealthPostJoiningList = rightsList;
            crewList = new List<MentalHealthPreSignOffPOCO>();
            this.MentalHealthPreSignOffList = crewList;
        }

        public List<MentalHealthPostJoiningPOCO> MentalHealthPostJoiningList { get; set; }

        public List<MentalHealthPreSignOffPOCO> MentalHealthPreSignOffList { get; set; }
    }
}
