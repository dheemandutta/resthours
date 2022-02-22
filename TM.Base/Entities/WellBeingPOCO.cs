using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.Base.Entities
{
    public class WellBeingPOCO
    {
        public List<WellBeingHealthPOCO> wbHealthList;

        public WellBeingPOCO()
        {
            wbHealthList = new List<WellBeingHealthPOCO>();
            this.WellBeingHealthList = wbHealthList;
        }

        public List<WellBeingHealthPOCO> WellBeingHealthList { get; set; }
    }
}
