using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TM.RestHour.Models
{
    public class AccessRights
    {
        public int CrewId { get; set; }
        public Boolean HasAccess { get; set; }
        public string ResourceName { get; set; }
    }
}