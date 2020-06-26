using TM.RestHour.DAL;
using TM.Base.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.RestHour.BL
{
    public class VesselDetailsBL
    {
        public int SaveVesselDetails(VesselDetailsPOCO vesselDetails/*, int VesselID*/)
        {
            VesselDetailsDAL vesselDetailsDAL = new VesselDetailsDAL();
            return vesselDetailsDAL.SaveVesselDetails(vesselDetails/*, VesselID*/);
        }
    }
}
