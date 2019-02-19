using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.Base.Entities
{
    public class TimeAdjustmentPOCO
    {
        public DateTime AdjustmentDate { get; set; }
        public string AdjustmentValue { get; set; }
        public string AdjustmentDate1 { get; set; }

        public DateTime BookDate { get; set; }
        public int CrewID { get; set; }

        public int BookCount { get; set; }

        public string LastBookDate { get; set; }



    }
}
