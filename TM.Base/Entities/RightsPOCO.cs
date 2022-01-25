using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.Base.Entities
{
    public class RightsPOCO
    {
        public int Id { get; set; }
        public string ResourceName { get; set; }
        public int ParentId { get; set; }
        public int CrewId { get; set; }
        public int PageId { get; set; }
        public Boolean IsActive { get; set; }
        public Boolean HasAccess { get; set; }
    }
}
