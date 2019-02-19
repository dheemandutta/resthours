using TM.RestHour.DAL;
using TM.Base.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.RestHour.BL
{
    public class CIRMBL
    {
        public int SaveCIRM(CIRMPOCO cIRM /*,int VesselID*/)
        {
            CIRMDAL cIRMDAL = new CIRMDAL();
            return cIRMDAL.SaveCIRM(cIRM /*, VesselID*/);
        }
    }
}
