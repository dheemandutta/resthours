using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.RestHour.Entities
{
    public class RanksPOCO
    {
        public int ID { get; set; }
        public string RankName { get; set; }
        public string Description { get; set; }
        public Boolean Scheduled { get; set; }
    }
}
