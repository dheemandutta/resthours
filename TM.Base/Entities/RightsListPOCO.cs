using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.Base.Entities
{
    public class RightsListPOCO
    {
        public int Id { get; set; }
        public string ResourceName { get; set; }
        public int? ParentId { get; set; }
        public Boolean HasAccess { get; set; }
    }
}
