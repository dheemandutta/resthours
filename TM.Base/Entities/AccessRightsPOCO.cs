using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.Base.Entities
{
    public class AccessRightsPOCO
    {
        public int CrewId { get; set; }
        public Boolean HasAccess { get; set; }
        public string ResourceName { get; set; }
    }
}
