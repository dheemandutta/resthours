using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using TM.Base.Entities;
using TM.RestHour.BL;

namespace TM.RestHour.Common
{
    public static class AccessControl
    {
        public static bool CheckResourceAccess(int CrewId, string PageName)
        {
            RightsBL rightsBL = new RightsBL();
            return rightsBL.GetRightsByCrewIdAndPageName(CrewId, PageName);
        }

        public static bool CheckResourceReadAccess(string PageName)
        {
            List<AccessRightsPOCO> accessRightsPOCOs = new List<AccessRightsPOCO>();
            accessRightsPOCOs = (List<AccessRightsPOCO>)System.Web.HttpContext.Current.Session["AccessRights"];
            int match = accessRightsPOCOs.Where(p => String.Equals(p.ResourceName, PageName, StringComparison.CurrentCulture) && p.HasAccess).ToList().Count;
            if (match > 0)
                return true;
            else
                return false;
        }
    }
}