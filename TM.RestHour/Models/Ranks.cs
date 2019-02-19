using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TM.RestHour.Models
{
    public class Ranks
    {
        public int ID { get; set; }
        public string RankName { get; set; }
        public string Description { get; set; }
        public Boolean Scheduled { get; set; }

        public int Order { get; set; }

       
    }
}