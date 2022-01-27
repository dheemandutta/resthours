using TM.RestHour.DAL;
using TM.Base.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.RestHour.BL
{
    public class RightsBL
    {
        public RightsPOCO GetRightsByCrewId(int CrewId, string PageName, int VesselID, int UserID)
        {
            RightsDAL rightsDAL = new RightsDAL();
            return rightsDAL.GetRightsByCrewId(CrewId, PageName, VesselID, UserID);
        }
    }
}
