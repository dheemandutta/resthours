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




        //public List<MentalHealthPostJoiningPOCO> rightsList;
        //public List<MentalHealthPreSignOffPOCO> crewList;

        //public RightsPOCO()
        //{
        //    rightsList = new List<MentalHealthPostJoiningPOCO>();
        //    this.RightsList = rightsList;
        //    crewList = new List<MentalHealthPreSignOffPOCO>();
        //    this.CrewList = crewList;
        //}

        //public List<MentalHealthPostJoiningPOCO> RightsList { get; set; }

        //public List<MentalHealthPreSignOffPOCO> CrewList { get; set; }
    }
}
