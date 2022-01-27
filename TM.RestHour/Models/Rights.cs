using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TM.RestHour.Models
{
    public class Rights
    {
        //public int Id { get; set; }
        //public string ResourceName { get; set; }
        //public int? ParentId { get; set; }
        public int CrewId { get; set; }
        public int PageId { get; set; }
        public Boolean IsActive { get; set; }
        //public Boolean HasAccess { get; set; }

        public List<RightsList> rightsList;
        public List<Crew> crewList;
        public Rights()
        {
            rightsList = new List<RightsList>();
            this.RightsList = rightsList;
            crewList = new List<Crew>();
            this.CrewList = crewList;
        }
        public string PageName { get; set; }

        public List<RightsList> RightsList { get; set; }

        public List<Crew> CrewList { get; set; }
    }
}