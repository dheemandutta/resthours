using TM.RestHour.DAL;
using TM.Base.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.RestHour.BL
{
    public class TimeSheetBL
    {



        //for Crew drp
        public List<CrewPOCO> GetAllCrewForDrp(int VesselID, int UserID)
        {
            TimeSheetDAL timesheetdal = new TimeSheetDAL();
            return timesheetdal.GetAllCrewForDrp(VesselID, UserID);
        }

        public List<CrewPOCO> GetAllCrewForTimeSheet(int VesselID, int UserID)
        {
            TimeSheetDAL timesheetdal = new TimeSheetDAL();
            return timesheetdal.GetAllCrewForTimeSheet(VesselID, UserID);
        }

            public CrewTimesheetPOCO GetCrewTimeSheetByDate(int crewId, DateTime bookDate,int VesselID)
        {
            TimeSheetDAL timesheetdal = new TimeSheetDAL();
            return timesheetdal.GetCrewTimeSheetByDate(crewId, bookDate, VesselID);
        }

		public List<CrewTimesheetPOCO> GetNextSixDaysTimesheet(int crewId, DateTime bookDate, int VesselID)
		{
			TimeSheetDAL timesheetdal = new TimeSheetDAL();
			return timesheetdal.GetNextSixDaysTimesheet(crewId, bookDate, VesselID);
		}

			public CrewTimesheetPOCO GetSecondCrewTimeSheetByDate(int crewId, DateTime bookDate,int VesselID)
        {
            TimeSheetDAL timesheetdal = new TimeSheetDAL();
            return timesheetdal.GetSecondCrewTimeSheetByDate(crewId, bookDate, VesselID);
        }
        public CrewTimesheetPOCO GetLastTimeSheet(int crewId,int VesselID,string copydate)
        {
            TimeSheetDAL timesheetdal = new TimeSheetDAL();
            return timesheetdal.GetLastTimeSheet(crewId, VesselID,copydate);
        }

		public List<string> GetPreviousBlankTimesheetDates(int crewId, DateTime bookDate, int VesselID)
		{
			TimeSheetDAL timesheetdal = new TimeSheetDAL();
			return timesheetdal.GetPreviousBlankTimesheetDates(crewId, bookDate, VesselID);
		}

			public int GetWorkDayCountBeforeSevenDays(int crewId, DateTime bookDate, int VesselID)
		{
			TimeSheetDAL timesheetdal = new TimeSheetDAL();
			return timesheetdal.GetWorkDayCountBeforeSevenDays(crewId, bookDate, VesselID);
		}

        public int GetWorkDayCountBeforeOneDays(int crewId, DateTime bookDate, int VesselID)
        {
            TimeSheetDAL timesheetdal = new TimeSheetDAL();
            return timesheetdal.GetWorkDayCountBeforeOneDays(crewId, bookDate, VesselID);
        }

        public CrewTimesheetPOCO GetNCForMonth(int Month, int Year,int CrewId,int VesselID)
        {
            TimeSheetDAL timesheetdal = new TimeSheetDAL();
            return timesheetdal.GetNCForMonth(Month, Year,CrewId, VesselID);
        }

		public CrewTimesheetPOCO GetNoNCForMonth(int Month, int Year, int CrewId, int VesselID)
		{
			TimeSheetDAL timesheetdal = new TimeSheetDAL();
			return timesheetdal.GetNoNCForMonth(Month, Year, CrewId, VesselID);
		}




        public int? GetDaysLeft(int ID)
        {
            TimeSheetDAL timesheetdal = new TimeSheetDAL();
            return timesheetdal.GetDaysLeft(ID);
        }
    }
}

