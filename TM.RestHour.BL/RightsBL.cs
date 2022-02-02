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

        public void SaveAccess(string pageId, string hasAccess, int crewId)
        {
            RightsDAL rightsDAL = new RightsDAL();
            rightsDAL.SaveAccess(pageId, hasAccess, crewId);

        }


        public bool GetRightsByCrewIdAndPageName(int CrewId, string PageName)
        {
            RightsDAL rightsDAL = new RightsDAL();
            return rightsDAL.GetRightsByCrewIdAndPageName(CrewId, PageName);
        }


        public RightsPOCO GetRightsByCrewIdAndPageId(int CrewId, int PageId)
        {
            RightsDAL rightsDAL = new RightsDAL();
            return rightsDAL.GetRightsByCrewIdAndPageId(CrewId, PageId);
        }


        public List<AccessRightsPOCO> GetAccessRightsByCrewId(int CrewId)
        {
            RightsDAL rightsDAL = new RightsDAL();
            return rightsDAL.GetAccessRightsByCrewId(CrewId);
        }
    }
}
