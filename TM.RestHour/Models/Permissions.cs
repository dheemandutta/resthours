using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TM.RestHour.Models
{
    public class Permissions
    {
        public int id { get; set; }
        public string text { get; set; }
        public List<Permissions> children { get; set; }

        public bool @checked { get; set; }
    }
}