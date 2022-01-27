using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.Base.Entities
{
    public class RightsPOCO
    {
        //public int Id { get; set; }
        //public string ResourceName { get; set; }
        //public int? ParentId { get; set; }
        public int CrewId { get; set; }
        public int PageId { get; set; }
        public Boolean IsActive { get; set; }
        //public Boolean HasAccess { get; set; }

        public List<RightsListPOCO> rightsList;
        public List<CrewPOCO> crewList;

        public RightsPOCO()
        {
            rightsList = new List<RightsListPOCO>();
            this.RightsList = rightsList;
            crewList = new List<CrewPOCO>();
            this.CrewList = crewList;
        }
        public string PageName { get; set; }

        public List<RightsListPOCO> RightsList { get; set; }

        public List<CrewPOCO> CrewList { get; set; }

    }
}
