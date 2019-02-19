using TM.RestHour.DAL;
using TM.Base.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.RestHour.BL
{
    public class TimeAdjustmentBL
    {
        public TimeAdjustmentPOCO GetLastAdjustmentBookedStatus(int CrewID, DateTime BookDate, int VesselID)
        {
            TimeAdjustmentDAL timeAdjustmentDAL = new TimeAdjustmentDAL();
            return timeAdjustmentDAL.GetLastAdjustmentBookedStatus(CrewID, BookDate, VesselID).FirstOrDefault();
        }

        public List<OneDayTimeAdjustmentPOCO> GetPlusOneDayAdjustmentDays(int Month, int Year,int VesselID)
        {
            TimeAdjustmentDAL timeAdjustmentDAL = new TimeAdjustmentDAL();
            return timeAdjustmentDAL.GetPlusOneDayAdjustmentDays(Month, Year, VesselID);
        }

        public List<OneDayTimeAdjustmentPOCO> GetMinusOneDayAdjustmentDays(int Month, int Year, int crewId,int VesselID)
        {
            TimeAdjustmentDAL timeAdjustmentDAL = new TimeAdjustmentDAL();
            return timeAdjustmentDAL.GetMinusOneDayAdjustmentDays(Month, Year, crewId, VesselID);
        }
        public List<TimeAdjustmentPOCO> GetTimeAdjustmentDetailsPageWise(int pageIndex, ref int recordCount, int length, int VesselID)
        {
            TimeAdjustmentDAL TimeAdjustmentDAL = new TimeAdjustmentDAL();
            return TimeAdjustmentDAL.GetTimeAdjustmentDetailsPageWise(pageIndex, ref recordCount, length, VesselID);
        }

        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        public List<OneDayTimeAdjustmentPOCO> GetPlusOneDayAdjustmentDaysForUser(int Month, int Year)
        {
            TimeAdjustmentDAL timeAdjustmentDAL = new TimeAdjustmentDAL();
            return timeAdjustmentDAL.GetPlusOneDayAdjustmentDaysForUser(Month, Year);
        }

        public List<OneDayTimeAdjustmentPOCO> GetMinusOneDayAdjustmentDaysForUser(int Month, int Year, int crewId)
        {
            TimeAdjustmentDAL timeAdjustmentDAL = new TimeAdjustmentDAL();
            return timeAdjustmentDAL.GetMinusOneDayAdjustmentDaysForUser(Month, Year, crewId);
        }
    }
}
