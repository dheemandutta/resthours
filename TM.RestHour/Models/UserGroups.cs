using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TM.RestHour.Models
{
    public class UserGroups
    {
        public Users Users { get; set; }
        public int GroupID { get; set; }
        public string SelectedGroupID { get; set; }
        public int? CrewID { get; set; }

    }
}