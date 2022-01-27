using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TM.RestHour.Models
{
    public class RightsList
    {
        public int Id { get; set; }
        public string ResourceName { get; set; }
        public int? ParentId { get; set; }
        public Boolean HasAccess { get; set; }
    }
}