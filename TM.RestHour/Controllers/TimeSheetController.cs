using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using TM.RestHour.BL;
using TM.RestHour.Models;
using TM.Base.Entities;
using System.Globalization;
using System.Web.Script.Serialization;
using System.Collections;
using TM.Compliance;
using System.Text;
using System.IO;
using System.Xml;
using TM.Base.Common;
using System.Web.SessionState;

using System.Configuration;

namespace TM.RestHour.Controllers
{
    [SessionState(SessionStateBehavior.Default)]
    [TraceFilterAttribute]
    public class TimeSheetController : BaseController
    {
		//
		// GET: /TimeSheet/

		[TraceFilterAttribute]
		public ActionResult timesheet()
        {
            GetAllCrewForDrp();
           
            return View();
        }

		[TraceFilterAttribute]
		public ActionResult Index()
		{
            //GetAllCrewForDrp();
            GetAllCrewForTimeSheet();
            Session["TimeModified"] = "+1";
			Session["DateModified"] = "01/25/2018";

			CrewTimesheetViewModel crewtimesheetVM = new CrewTimesheetViewModel();
			Crew c = new Crew();
			crewtimesheetVM.Crew = c;

			if (Convert.ToBoolean(Session["User"]) == true)
			{
				crewtimesheetVM.Crew.ID = int.Parse(System.Web.HttpContext.Current.Session["LoggedInUserId"].ToString());
				crewtimesheetVM.AdminStatus = System.Web.HttpContext.Current.Session["AdminStatus"].ToString();
				crewtimesheetVM.CrewAdminId = 0;

			}
			else
			{
				crewtimesheetVM.Crew.ID = 0;
				crewtimesheetVM.CrewAdminId = int.Parse(System.Web.HttpContext.Current.Session["LoggedInUserId"].ToString());
				crewtimesheetVM.AdminStatus = System.Web.HttpContext.Current.Session["AdminStatus"].ToString();
			}

			return View(crewtimesheetVM);
		}

		[TraceFilterAttribute]
        public ActionResult CrewTimeSheet()
        {
             GetAllCrewForDrp();
            //GetAllCrewForTimeSheet();
            Session["TimeModified"] = "+1";
            Session["DateModified"] = "01/25/2018";

			CrewTimesheetViewModel crewtimesheetVM = new CrewTimesheetViewModel();
			Crew c = new Crew();
			crewtimesheetVM.Crew = c;

			if (Convert.ToBoolean(Session["User"]) == true)
			{
				crewtimesheetVM.Crew.ID = int.Parse(System.Web.HttpContext.Current.Session["LoggedInUserId"].ToString());
				crewtimesheetVM.AdminStatus = System.Web.HttpContext.Current.Session["AdminStatus"].ToString();
			}
			else
				crewtimesheetVM.Crew.ID = 0;

			return View(crewtimesheetVM);
		}

		public JsonResult GetLoggedInUserId()
		{
			var data = int.Parse(System.Web.HttpContext.Current.Session["LoggedInUserId"].ToString());
			return Json(data, JsonRequestBehavior.AllowGet);
		}

		[TraceFilterAttribute]
		public JsonResult GetMinusOneBookStatus(string crewId,string bookDate)
        {
            TimeAdjustmentBL timeadjustment = new TimeAdjustmentBL();
            TimeAdjustmentPOCO _timeadjustmentp = new TimeAdjustmentPOCO();

            
            _timeadjustmentp = timeadjustment.GetLastAdjustmentBookedStatus(int.Parse(crewId), DateTime.ParseExact(bookDate, "MM/dd/yyyy", CultureInfo.InvariantCulture), int.Parse(Session["VesselID"].ToString()));
            
            return Json(_timeadjustmentp, JsonRequestBehavior.AllowGet);
        }

		public TimeAdjustmentPOCO GetMinusOneBookStatusForBatchUpdate(string crewId, string bookDate)
		{
			TimeAdjustmentBL timeadjustment = new TimeAdjustmentBL();
			TimeAdjustmentPOCO _timeadjustmentp = new TimeAdjustmentPOCO();

			_timeadjustmentp = timeadjustment.GetLastAdjustmentBookedStatus(int.Parse(crewId), DateTime.ParseExact(bookDate, "MM/dd/yyyy", CultureInfo.InvariantCulture), int.Parse(Session["VesselID"].ToString()));

			return _timeadjustmentp;
		}

		[TraceFilterAttribute]
		public JsonResult RetrieveTimeChange()
        {
            if (Session["TimeModified"] != null)
            {
                var data = Session["TimeModified"].ToString();
                return Json(data, JsonRequestBehavior.AllowGet);
            }
            else
            {
                return Json(String.Empty, JsonRequestBehavior.AllowGet);
            }
        }

		[TraceFilterAttribute]
		public JsonResult RetrieveTimeChangeDate()
        {
            if (Session["DateModified"] != null)
            {
                var data = Session["DateModified"].ToString();
                return Json(data, JsonRequestBehavior.AllowGet);
            }
            else
            {
                return Json(String.Empty, JsonRequestBehavior.AllowGet);
            }
        }

		[TraceFilterAttribute]
		public ActionResult Time()
        {
            return View();
        }

        [TraceFilterAttribute]
        public void GetAllCrewForTimeSheet()
        {
            TimeSheetBL crewDAL = new TimeSheetBL();
            List<CrewPOCO> crewpocoList = new List<CrewPOCO>();

            crewpocoList = crewDAL.GetAllCrewForTimeSheet(int.Parse(Session["VesselID"].ToString()), int.Parse(System.Web.HttpContext.Current.Session["UserID"].ToString()));

            List<Crew> itmasterList = new List<Crew>();

            foreach (CrewPOCO up in crewpocoList)
            {
                Crew unt = new Crew();
                unt.ID = up.ID;
                unt.Name = up.Name;

                itmasterList.Add(unt);
            }

            ViewBag.Crew = itmasterList.Select(x =>
                                            new SelectListItem()
                                            {
                                                Text = x.Name,
                                                Value = x.ID.ToString()
                                            });

        }

        // for Crew drp
        [TraceFilterAttribute]
		public void GetAllCrewForDrp()
        {
            TimeSheetBL crewDAL = new TimeSheetBL();
            List<CrewPOCO> crewpocoList = new List<CrewPOCO>();

            crewpocoList = crewDAL.GetAllCrewForDrp(int.Parse(Session["VesselID"].ToString()), int.Parse(System.Web.HttpContext.Current.Session["UserID"].ToString()));

            List<Crew> itmasterList = new List<Crew>();

            foreach (CrewPOCO up in crewpocoList)
            {
                Crew unt = new Crew();
                unt.ID = up.ID;
                unt.Name = up.Name;

                itmasterList.Add(unt);
            }

            ViewBag.Crew = itmasterList.Select(x =>
                                            new SelectListItem()
                                            {
                                                Text = x.Name,
                                                Value = x.ID.ToString()
                                            });

        }

		[TraceFilterAttribute]
		private CrewTimesheetPOCO ConvertTimesheetHoursForComplainceCheck(string timesheetjsondata, string crewId, string selectedDate)
        {
            CrewTimesheetPOCO crewPC = new CrewTimesheetPOCO();
            CrewTimesheetPOCO crewtimesheetP = new CrewTimesheetPOCO();
            CrewBL crewBL = new CrewBL();

            string[,] bookedtimesheetData = new string[24, 2];
            JavaScriptSerializer JsonSerializer = new JavaScriptSerializer();
            IDictionary<string, object> tsdict = (IDictionary<string, object>)JsonSerializer.DeserializeObject(timesheetjsondata);

            string actualHrs = string.Empty;
            string sttime= string.Empty;
            string endtime = string.Empty ;
            object[] objwf = (object[])tsdict["WF"];

            foreach (object item in objwf)
            {
                Dictionary<string, object> timesheetDictionaryObject = (Dictionary<string, object>)item;
                if (!String.IsNullOrEmpty(timesheetDictionaryObject["d"].ToString()))
                {
                    //Dictionary<string, object> xyz = (Dictionary<string, object>)timesheetDictionaryObject["d"];
                    //bookedtimesheetData = ToStringArray(timesheetDictionaryObject["d"]);

                    //string[] arr = new string[2] ;

                    for (int q = 0; q < ((object[])timesheetDictionaryObject["d"]).ToList().Count; q++)
                    {
                        if(((object[])(((object[])timesheetDictionaryObject["d"]).ToList()[q]))[0] != null)
                         sttime = ((object[])(((object[])timesheetDictionaryObject["d"]).ToList()[q]))[0].ToString();
                        if(((object[])(((object[])timesheetDictionaryObject["d"]).ToList()[q]))[1] != null )
                         endtime = ((object[])(((object[])timesheetDictionaryObject["d"]).ToList()[q]))[1].ToString();
                        
                        
                        actualHrs = actualHrs + sttime + "," + endtime + ",";

                        bool isFilled = false;

                        for (int i = q; i < bookedtimesheetData.GetUpperBound(0); i++)
                        {
                            isFilled = false;
                            for (int j = 0; j < 2; j++)
                            {
                                if (j < 1)
                                    bookedtimesheetData[i, j] = sttime;
                                else
                                {
                                    //check if 23:59
                                    if (endtime == "2400") endtime = "2400";

                                    bookedtimesheetData[i, j] = endtime;
                                    isFilled = true;
                                    break;
                                }
                            }

                            if (isFilled) break;
                        }

                    }

                }


            } //end main for


            ///todaysbookedHours contains the array of timesheet that will 
            /////be processed by regime engine.
            int[] todaysbookedHours = GetHours(bookedtimesheetData);


			//get last 7 days data if any
			
			int index = 0;
			 
            crewtimesheetP = crewBL.GetLastSevenDaysWorkSchedule(int.Parse(crewId), DateTime.ParseExact(selectedDate, "MM/dd/yyyy", CultureInfo.InvariantCulture), int.Parse(Session["VesselID"].ToString()),todaysbookedHours); 
            //DateTime dt9 = selectedDate.FormatDate
            //           (ConfigurationManager.AppSettings["InputDateFormat"].ToString(), ConfigurationManager.AppSettings["InputDateSeperator"].ToString(),
            //            ConfigurationManager.AppSettings["OutputDateFormat"].ToString(), ConfigurationManager.AppSettings["OutputDateSeperator"].ToString());

            //crewtimesheetP = crewBL.GetLastSevenDaysWorkSchedule(int.Parse(crewId), dt9, int.Parse(Session["VesselID"].ToString()), todaysbookedHours);



            crewtimesheetP.BookedHours = todaysbookedHours;
            crewtimesheetP.ActualHours = actualHrs;
			//populating the latest day strating at the zeroth index

			
			
			////populating reverse values array
			//for (int k = 336, m = 0; k < 384; k++, m++)
			//{
			//	crewtimesheetP.last7DaysBookedHoursReversed[k] = todaysbookedHours[m].ToString();

			//}


			return crewtimesheetP;
        }

		private CrewTimesheetPOCO ConvertTimesheetHoursForComplainceCheckForUpdate(string[,] bookedtimesheetData, string crewId, string selectedDate)
		{
			CrewTimesheetPOCO crewPC = new CrewTimesheetPOCO();
			CrewTimesheetPOCO crewtimesheetP = new CrewTimesheetPOCO();
			CrewBL crewBL = new CrewBL();

			//string[,] bookedtimesheetData = new string[24, 2];
			//JavaScriptSerializer JsonSerializer = new JavaScriptSerializer();
			//IDictionary<string, object> tsdict = (IDictionary<string, object>)JsonSerializer.DeserializeObject(timesheetjsondata);

			//string actualHrs = string.Empty;
			//string sttime = string.Empty;
			//string endtime = string.Empty;
			//object[] objwf = (object[])tsdict["WF"];

			//foreach (object item in objwf)
			//{
			//	Dictionary<string, object> timesheetDictionaryObject = (Dictionary<string, object>)item;
			//	if (!String.IsNullOrEmpty(timesheetDictionaryObject["d"].ToString()))
			//	{
			//		//Dictionary<string, object> xyz = (Dictionary<string, object>)timesheetDictionaryObject["d"];
			//		//bookedtimesheetData = ToStringArray(timesheetDictionaryObject["d"]);

			//		//string[] arr = new string[2] ;

			//		for (int q = 0; q < ((object[])timesheetDictionaryObject["d"]).ToList().Count; q++)
			//		{
			//			if (((object[])(((object[])timesheetDictionaryObject["d"]).ToList()[q]))[0] != null)
			//				sttime = ((object[])(((object[])timesheetDictionaryObject["d"]).ToList()[q]))[0].ToString();
			//			if (((object[])(((object[])timesheetDictionaryObject["d"]).ToList()[q]))[1] != null)
			//				endtime = ((object[])(((object[])timesheetDictionaryObject["d"]).ToList()[q]))[1].ToString();


			//			actualHrs = actualHrs + sttime + "," + endtime + ",";

			//			bool isFilled = false;

			//			for (int i = q; i < bookedtimesheetData.GetUpperBound(0); i++)
			//			{
			//				isFilled = false;
			//				for (int j = 0; j < 2; j++)
			//				{
			//					if (j < 1)
			//						bookedtimesheetData[i, j] = sttime;
			//					else
			//					{
			//						//check if 23:59
			//						if (endtime == "2400") endtime = "2400";

			//						bookedtimesheetData[i, j] = endtime;
			//						isFilled = true;
			//						break;
			//					}
			//				}

			//				if (isFilled) break;
			//			}

			//		}

			//	}


			//} //end main for


			 


			///todaysbookedHours contains the array of timesheet that will 
			/////be processed by regime engine.
			int[] todaysbookedHours = GetHours(bookedtimesheetData);


			//get last 7 days data if any

			int index = 0;

			crewtimesheetP = crewBL.GetLastSevenDaysWorkSchedule(int.Parse(crewId), DateTime.ParseExact(selectedDate, "MM/dd/yyyy", CultureInfo.InvariantCulture), int.Parse(Session["VesselID"].ToString()), todaysbookedHours);
			//DateTime dt9 = selectedDate.FormatDate
			//           (ConfigurationManager.AppSettings["InputDateFormat"].ToString(), ConfigurationManager.AppSettings["InputDateSeperator"].ToString(),
			//            ConfigurationManager.AppSettings["OutputDateFormat"].ToString(), ConfigurationManager.AppSettings["OutputDateSeperator"].ToString());

			//crewtimesheetP = crewBL.GetLastSevenDaysWorkSchedule(int.Parse(crewId), dt9, int.Parse(Session["VesselID"].ToString()), todaysbookedHours);



			crewtimesheetP.BookedHours = todaysbookedHours;
			//todo:uncomment
			//crewtimesheetP.ActualHours = actualHrs;

			//populating the latest day strating at the zeroth index



			////populating reverse values array
			//for (int k = 336, m = 0; k < 384; k++, m++)
			//{
			//	crewtimesheetP.last7DaysBookedHoursReversed[k] = todaysbookedHours[m].ToString();

			//}


			return crewtimesheetP;
		}


		[TraceFilterAttribute]
		public JsonResult AddCrewTimeSheet(string timesheetjsondata, string crewId, string selectedDate, string comments,string adjustmentFactor,string ID,string NcdetailsId)
        {
            CrewBL crewBL = new CrewBL();
            CrewTimesheetPOCO crewPC = new CrewTimesheetPOCO();
            CrewTimesheetPOCO crewtimesheetP = new CrewTimesheetPOCO();
            TimeSheetBL timeSheetBL = new TimeSheetBL();

            crewtimesheetP = ConvertTimesheetHoursForComplainceCheck(timesheetjsondata, crewId, selectedDate);

            // Start - Compliance Integration
            //ToDo: Get Regime set by Admin
            Compliance24Hrs comp24hrs = new Compliance24Hrs();
            Compliance7Days comp7days = new Compliance7Days();
            RegimesPOCO currentRegime = new RegimesPOCO();
           
            
            currentRegime = Utility.GetRegimeById(int.Parse(Session["Regime"].ToString())/*, int.Parse(Session["VesselID"].ToString())*/);

			////modified by Dheeman replaced the array for last seven days containing data in order - 1,2,3,4,5,6,7 with 7,6,5,4,3,2,1
			//string[] last7DaysSession = Utility.TrimTrailingNulls(crewtimesheetP.last7DaysBookedHoursReversed.ToArray<string>());
			////string[] last7DaysSession = Utility.TrimTrailingNulls(crewtimesheetP.last7DaysBookedHours.ToArray<string>());
			//string[] last48HrsSessions = Utility.GetSessionsFromLastDay(2, last7DaysSession);
			//         string[] last7DaysSessionForAny7Days = crewtimesheetP.last7DaysBookedHoursReversedWithZeroValues.ToArray<string>();
			//         ////bool _isFirstSevenDays = timeSheetBL.GetWorkDayCountBeforeSevenDays(int.Parse(crewId), DateTime.Parse(selectedDate), int.Parse(Session["VesselID"].ToString())) > 0 ? false : true;
			//           bool _isFirstSevenDays = timeSheetBL.GetWorkDayCountBeforeSevenDays(int.Parse(crewId), DateTime.ParseExact(selectedDate, "MM/dd/yyyy", CultureInfo.InvariantCulture), int.Parse(Session["VesselID"].ToString())) > 0 ? false : true;

			//         comp24hrs = HoursCalculation.Check24hrsRestHrs(last48HrsSessions, currentRegime);
			//         comp7days = HoursCalculation.Check7DaysRestHrs(last7DaysSessionForAny7Days, currentRegime,_isFirstSevenDays);

			//         ComplianceInfo complianceInfo = GetComplianceInfo(comp24hrs, comp7days, DateTime.Now);

			// START - NEW CODE CHANGES
			string[] last7DaysSessionForAny7Days = crewtimesheetP.last7DaysBookedHoursReversedWithZeroValues.ToArray<string>();
			string[] last48HrsSessions = Utility.GetSessionsFromLastDay(2, last7DaysSessionForAny7Days);
			bool _isFirstSevenDays = timeSheetBL.GetWorkDayCountBeforeSevenDays(int.Parse(crewId),
																				DateTime.ParseExact(selectedDate, "MM/dd/yyyy", CultureInfo.InvariantCulture),
																				int.Parse(Session["VesselID"].ToString())) > 0 ? false : true;
			bool _isFirstDay = timeSheetBL.GetWorkDayCountBeforeOneDays(int.Parse(crewId),
																				DateTime.ParseExact(selectedDate, "MM/dd/yyyy", CultureInfo.InvariantCulture),
																				int.Parse(Session["VesselID"].ToString())) > 0 ? false : true;
			comp24hrs = HoursCalculation.ProcessAny24HrsSession(last48HrsSessions, currentRegime, _isFirstDay);
			comp7days = HoursCalculation.ProcessAny7DaysSession(last7DaysSessionForAny7Days, currentRegime, _isFirstSevenDays);
            ComplianceInfo complianceInfo = HoursCalculation.GetComplianceInfo(last48HrsSessions, last7DaysSessionForAny7Days, DateTime.Now, currentRegime, _isFirstDay, _isFirstSevenDays);
            //ComplianceInfo complianceInfo = GetComplianceInfo(comp24hrs, comp7days, DateTime.Now);
            // END - NEW CODE CHANGES


            // End - Compliance Integration
            crewPC.RegimeID = int.Parse(Session["Regime"].ToString());       

            crewPC.BookedHours = crewtimesheetP.BookedHours;
            crewPC.BookDate = DateTime.ParseExact(selectedDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            


            crewPC.Comment = comments;
            CrewPOCO crew = new CrewPOCO();
            crew.ID = int.Parse(crewId);
			if (!String.IsNullOrEmpty(crewtimesheetP.ActualHours))
				crewPC.ActualHours = crewtimesheetP.ActualHours.TrimEnd(',');
			else
				crewPC.ActualHours = "0000,0000,0000,0000,0000,0000";

			crewPC.AdjustmentFactor = adjustmentFactor;
            crewPC.Crew = crew;

			CrewBL crewbl = new CrewBL();
			bool hasOvertime = crewbl.GetCrewOvertimeValue(int.Parse(crewId), int.Parse(Session["VesselID"].ToString()));


            // get total working hours
            string[] arr = Array.ConvertAll(crewPC.BookedHours, m => m.ToString());
            double overtimeHours = 0;

            double totalworkedHours = CalculateWorkHoursandOvertimeHours(DateTime.ParseExact(selectedDate, "MM/dd/yyyy", CultureInfo.InvariantCulture), arr, out overtimeHours ,hasOvertime);
            

            // adding NC Details 
            string ncdetailsxml = String.Empty;
            MemoryStream localMemoryStream = new MemoryStream();
            XmlTextWriter writer = null;
            writer = new XmlTextWriter(localMemoryStream, System.Text.Encoding.UTF8);
           
                writer.WriteStartElement("ncdetails");
                writer.WriteElementString("maxnrrestperiodstatus", complianceInfo.TwentyFourHourCompliance.MaxNrOfRestPeriodStatus);
                writer.WriteElementString("maxrestperiodstatus", complianceInfo.TwentyFourHourCompliance.MaxRestPeriodStatus);
                writer.WriteElementString("sevendaysstatus", complianceInfo.SevenDaysCompliance.StatusMessage);
                writer.WriteElementString("twentyfourhourresthoursstatus", complianceInfo.TwentyFourHourCompliance.TotalRestHoursStatus);
                writer.WriteElementString("minsevendaysrest", complianceInfo.SevenDaysCompliance.TotalRestHours.ToString()); // max 7 days
                writer.WriteElementString("mintwentyfourhoursrest", complianceInfo.TwentyFourHourCompliance.TotalRestHours.ToString());  //rest
                writer.WriteElementString("maxrestperiodintewntyfourhours", complianceInfo.TwentyFourHourCompliance.MaxRestPeriod.ToString());  // min 24
                writer.WriteElementString("maxnrofrestperiod", complianceInfo.TwentyFourHourCompliance.MaxNrOfRestPeriod.ToString());
                writer.WriteElementString("totalworkedhours", totalworkedHours.ToString());
                writer.WriteElementString("overtimeHours", overtimeHours.ToString());
                
                //writer.WriteElementString("",complianceInfo.r);
                writer.WriteEndElement();
                writer.Flush();
                
              
           

            localMemoryStream.Position = 0;
            StreamReader reader = new StreamReader(localMemoryStream);
            ncdetailsxml = reader.ReadToEnd();

            writer.Close();
            reader.Close();

            //if(string.IsNullOrEmpty(complianceInfo.TwentyFourHourCompliance.MaxNrOfRestPeriodStatus) 
            //    && string.IsNullOrEmpty(complianceInfo.TwentyFourHourCompliance.MaxRestPeriodStatus) 
            //    && string.IsNullOrEmpty(complianceInfo.SevenDaysCompliance.StatusMessage) 
            //    && string.IsNullOrEmpty(complianceInfo.TwentyFourHourCompliance.TotalRestHoursStatus))
            //{
            //    crewPC.isNonCompliant = 0;
            //}
            //else
            //{
            //    crewPC.isNonCompliant = 1;
            //}

            crewPC.isNonCompliant = complianceInfo.IsCompliant ? 0 : 1;
            crewPC.IsTechnicalNC = complianceInfo.IsTechnicalNC;
            crewPC.Is24HoursCompliant = complianceInfo.Is24HoursCompliant;
            crewPC.IsSevenDaysCompliant = complianceInfo.IsSevenDaysCompliant;
            crewPC.PaintOrange = complianceInfo.PaintOrange;
            crewPC.NCDetails.ComplianceInfo = ncdetailsxml;
            crewPC.NCDetails.OccuredOn = DateTime.ParseExact(selectedDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
           


            crewPC.NCDetails.CrewID = int.Parse(crewId);

			bool isUpdate = false;

            if (!String.IsNullOrEmpty(ID))
            {
                crewPC.ID = int.Parse(ID);
                crewPC.NCDetailsID = int.Parse(NcdetailsId);
                crewPC.DayUpdate = 1;
				isUpdate = true;
            }
            else
            {
                crewPC.ID = 0;
                crewPC.NCDetailsID = 0;
                crewPC.DayUpdate = 0;
            }
            //TODO:
            // +1D: not allowed -1D: dual booking

            int[] saveStatus = new int[2];
		    saveStatus = crewBL.AddCrewTimeSheet(crewPC, int.Parse(Session["VesselID"].ToString()));

			//populate blank timesheet
			TimeSheetBL timesheetBL = new TimeSheetBL();
			List<string> _blankDates = new List<string>();

			_blankDates = timesheetBL.GetPreviousBlankTimesheetDates(int.Parse(crewId), DateTime.ParseExact(selectedDate, "MM/dd/yyyy", CultureInfo.InvariantCulture), int.Parse(Session["VesselID"].ToString()));

			if (_blankDates.Count > 0)
			{
				foreach (String item in _blankDates)
				{
					UpdateTimeSheetWithZero(crewId, item, selectedDate);
				}

			}

			//get next 6 days data if present and update
			if (isUpdate)
			{
				//TimeSheetBL timesheetBL = new TimeSheetBL();
				List<CrewTimesheetPOCO> timesheetList = new List<CrewTimesheetPOCO>();

				timesheetList =  timeSheetBL.GetNextSixDaysTimesheet(int.Parse(crewId), DateTime.ParseExact(selectedDate, "MM/dd/yyyy", CultureInfo.InvariantCulture), int.Parse(Session["VesselID"].ToString()));

				foreach (CrewTimesheetPOCO item in timesheetList)
				{
					
					UpdateTimeSheet(crewId, item.ValidOn,item, selectedDate);
				}


			}
			//else
			//{
				
			//}


            return Json(saveStatus, JsonRequestBehavior.AllowGet);

        }

		/// <summary>
		/// Batch Update
		/// </summary>
		/// <param name="crewId"></param>
		/// <param name="selectedDate"></param>
		private void UpdateTimeSheet(string crewId, string selectedDate,CrewTimesheetPOCO crewtimesheet,string validOnDate )
		{
			CrewBL crewBL = new CrewBL();
			CrewTimesheetPOCO crewPC = new CrewTimesheetPOCO();
			CrewTimesheetPOCO crewtimesheetP = new CrewTimesheetPOCO();
			TimeSheetBL timeSheetBL = new TimeSheetBL();


			//step 1 : check adjustment factor 
			string adjustmentFactor = GetAdjustmentFactorForBatchUpdate(selectedDate);

			//step 2:  check minus one adjustment factor
			TimeAdjustmentPOCO minusOneAdjustmentFactor = GetMinusOneBookStatusForBatchUpdate(crewId, selectedDate);

			string[,] bookedtimesheetData = new string[24, 2];

			string[] acthours = crewtimesheet.ActualHours.Split(',');
			int counter = 0;
			int length0 = bookedtimesheetData.GetUpperBound(0);
			int length1 = bookedtimesheetData.GetUpperBound(1);
			int oneDlength = acthours.Length;

			for (int i = 0; i <= length0; i++)
			{
				for (int j = 0; j <= length1; j++)
				{

					if (counter < oneDlength)
						bookedtimesheetData[i, j] = acthours[counter++];
					else
						break;
				}
			}

			//step 3: load data
			crewtimesheetP = ConvertTimesheetHoursForComplainceCheckForUpdate(bookedtimesheetData, crewId, selectedDate);//

			//step 4:get crew data
			CrewTimesheetPOCO crewtimesheetPoco = new CrewTimesheetPOCO();
			crewtimesheetPoco = GetCrewBookedHoursForBatchUpdate(crewId, selectedDate);

			//start processing
			Compliance24Hrs comp24hrs = new Compliance24Hrs();
			Compliance7Days comp7days = new Compliance7Days();
			RegimesPOCO currentRegime = new RegimesPOCO();


			currentRegime = Utility.GetRegimeById(crewtimesheet.RegimeID)/*, int.Parse(Session["Regime"].ToString()*/;

			//modified by Dheeman replaced the array for last seven days containing data in order - 1,2,3,4,5,6,7 with 7,6,5,4,3,2,1
			//string[] last7DaysSession = Utility.TrimTrailingNulls(crewtimesheetP.last7DaysBookedHoursReversed.ToArray<string>());
			////string[] last7DaysSession = Utility.TrimTrailingNulls(crewtimesheetP.last7DaysBookedHours.ToArray<string>());
			//string[] last48HrsSessions = Utility.GetSessionsFromLastDay(2, last7DaysSession);

			//string[] last7DaysSessionForAny7Days = crewtimesheetP.last7DaysBookedHoursReversedWithZeroValues.ToArray<string>();
			//bool _isFirstSevenDays = timeSheetBL.GetWorkDayCountBeforeSevenDays(int.Parse(crewId), DateTime.ParseExact(selectedDate, "MM/dd/yyyy", CultureInfo.InvariantCulture), int.Parse(Session["VesselID"].ToString())) > 0 ? false : true;

			//comp24hrs = HoursCalculation.Check24hrsRestHrs(last48HrsSessions, currentRegime);
			//comp7days = HoursCalculation.Check7DaysRestHrs(last7DaysSessionForAny7Days, currentRegime, _isFirstSevenDays);
			//ComplianceInfo complianceInfo = GetComplianceInfo(comp24hrs, comp7days, DateTime.Now);


			// START - NEW CODE CHANGES
			string[] last7DaysSessionForAny7Days = crewtimesheetP.last7DaysBookedHoursReversedWithZeroValues.ToArray<string>();
			string[] last48HrsSessions = Utility.GetSessionsFromLastDay(2, last7DaysSessionForAny7Days);
			bool _isFirstSevenDays = timeSheetBL.GetWorkDayCountBeforeSevenDays(int.Parse(crewId),
																				DateTime.ParseExact(selectedDate, "MM/dd/yyyy", CultureInfo.InvariantCulture),
																				int.Parse(Session["VesselID"].ToString())) > 0 ? false : true;
			bool _isFirstDay = timeSheetBL.GetWorkDayCountBeforeOneDays(int.Parse(crewId),
																				DateTime.ParseExact(selectedDate, "MM/dd/yyyy", CultureInfo.InvariantCulture),
																				int.Parse(Session["VesselID"].ToString())) > 0 ? false : true;
			comp24hrs = HoursCalculation.ProcessAny24HrsSession(last48HrsSessions, currentRegime, _isFirstDay);
			comp7days = HoursCalculation.ProcessAny7DaysSession(last7DaysSessionForAny7Days, currentRegime, _isFirstSevenDays);
            //ComplianceInfo complianceInfo = GetComplianceInfo(comp24hrs, comp7days, DateTime.Now);
		    ComplianceInfo complianceInfo = HoursCalculation.GetComplianceInfo(last48HrsSessions, last7DaysSessionForAny7Days, DateTime.Now, currentRegime, _isFirstDay, _isFirstSevenDays);
            // END - NEW CODE CHANGES


            crewPC.RegimeID = crewtimesheet.RegimeID; //int.Parse(Session["Regime"].ToString());

			crewPC.BookedHours = crewtimesheetP.BookedHours;
			crewPC.BookDate = DateTime.ParseExact(selectedDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
		
			if (!String.IsNullOrEmpty(crewtimesheetPoco.Comment))
				crewPC.Comment = crewtimesheetPoco.Comment;
			else
				crewPC.Comment = String.Empty;
			CrewPOCO crew = new CrewPOCO();
			crew.ID = int.Parse(crewId);
			crewPC.ActualHours = crewtimesheet.ActualHours.TrimEnd(',');
			crewPC.AdjustmentFactor = adjustmentFactor;
			crewPC.Crew = crew;

			CrewBL crewbl = new CrewBL();
			bool hasOvertime = crewbl.GetCrewOvertimeValue(int.Parse(crewId), int.Parse(Session["VesselID"].ToString()));
			// get total working hours
			string[] arr = Array.ConvertAll(crewPC.BookedHours, m => m.ToString());
			double overtimeHours = 0;
			double totalworkedHours = CalculateWorkHoursandOvertimeHours(DateTime.ParseExact(selectedDate, "MM/dd/yyyy", CultureInfo.InvariantCulture), arr, out overtimeHours, hasOvertime);

			// adding NC Details 
			string ncdetailsxml = String.Empty;
			MemoryStream localMemoryStream = new MemoryStream();
			XmlTextWriter writer = null;
			writer = new XmlTextWriter(localMemoryStream, System.Text.Encoding.UTF8);

			writer.WriteStartElement("ncdetails");
			writer.WriteElementString("maxnrrestperiodstatus", complianceInfo.TwentyFourHourCompliance.MaxNrOfRestPeriodStatus);
			writer.WriteElementString("maxrestperiodstatus", complianceInfo.TwentyFourHourCompliance.MaxRestPeriodStatus);
			writer.WriteElementString("sevendaysstatus", complianceInfo.SevenDaysCompliance.StatusMessage);
			writer.WriteElementString("twentyfourhourresthoursstatus", complianceInfo.TwentyFourHourCompliance.TotalRestHoursStatus);
			writer.WriteElementString("minsevendaysrest", complianceInfo.SevenDaysCompliance.TotalRestHours.ToString()); // max 7 days
			writer.WriteElementString("mintwentyfourhoursrest", complianceInfo.TwentyFourHourCompliance.TotalRestHours.ToString());  //rest
			writer.WriteElementString("maxrestperiodintewntyfourhours", complianceInfo.TwentyFourHourCompliance.MaxRestPeriod.ToString());  // min 24
			writer.WriteElementString("maxnrofrestperiod", complianceInfo.TwentyFourHourCompliance.MaxNrOfRestPeriod.ToString());
			writer.WriteElementString("totalworkedhours", totalworkedHours.ToString());
			writer.WriteElementString("overtimeHours", overtimeHours.ToString());

			//writer.WriteElementString("",complianceInfo.r);
			writer.WriteEndElement();
			writer.Flush();
			localMemoryStream.Position = 0;
			StreamReader reader = new StreamReader(localMemoryStream);
			ncdetailsxml = reader.ReadToEnd();
			writer.Close();
			reader.Close();
						

			if (string.IsNullOrEmpty(complianceInfo.TwentyFourHourCompliance.MaxNrOfRestPeriodStatus)
				&& string.IsNullOrEmpty(complianceInfo.TwentyFourHourCompliance.MaxRestPeriodStatus)
				&& string.IsNullOrEmpty(complianceInfo.SevenDaysCompliance.StatusMessage)
				&& string.IsNullOrEmpty(complianceInfo.TwentyFourHourCompliance.TotalRestHoursStatus))
			{
				crewPC.isNonCompliant = 0;
			}
			else
			{
				crewPC.isNonCompliant = 1;
			}

		    crewPC.IsTechnicalNC = complianceInfo.IsTechnicalNC;
		    crewPC.Is24HoursCompliant = complianceInfo.Is24HoursCompliant;
		    crewPC.IsSevenDaysCompliant = complianceInfo.IsSevenDaysCompliant;
		    crewPC.PaintOrange = complianceInfo.PaintOrange;

            crewPC.NCDetails.ComplianceInfo = ncdetailsxml;
			crewPC.NCDetails.OccuredOn = DateTime.ParseExact(selectedDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);



			crewPC.NCDetails.CrewID = int.Parse(crewId);

			if (crewtimesheetPoco.WorkSessionId.HasValue)
			{
				crewPC.ID = crewtimesheetPoco.WorkSessionId.Value;
				crewPC.NCDetailsID = crewtimesheetPoco.NCDetailsID;
				crewPC.DayUpdate = 1;
			}
			else
			{
				crewPC.ID = 0;
				crewPC.NCDetailsID = 0;
				crewPC.DayUpdate = 0;
			}

			crewBL.AddCrewTimeSheet(crewPC, int.Parse(Session["VesselID"].ToString()));
		}

		private void UpdateTimeSheetWithZero(string crewId, string selectedDate, string validOnDate) // CrewTimesheetPOCO crewtimesheet,
		{
			CrewBL crewBL = new CrewBL();
			CrewTimesheetPOCO crewPC = new CrewTimesheetPOCO();
			CrewTimesheetPOCO crewtimesheetP = new CrewTimesheetPOCO();
			TimeSheetBL timeSheetBL = new TimeSheetBL();


			//step 1 : check adjustment factor 
			string adjustmentFactor = "0"; //GetAdjustmentFactorForBatchUpdate(selectedDate);

			//step 2:  check minus one adjustment factor
			TimeAdjustmentPOCO minusOneAdjustmentFactor = GetMinusOneBookStatusForBatchUpdate(crewId, selectedDate);

			string[,] bookedtimesheetData = new string[24, 2];

			//string[] acthours = crewtimesheet.ActualHours.Split(',');
			int counter = 0;
			int length0 = bookedtimesheetData.GetUpperBound(0);
			int length1 = bookedtimesheetData.GetUpperBound(1);
			//int oneDlength = acthours.Length;

			for (int i = 0; i <= 2; i++)
			{
				for (int j = 0; j <= length1; j++)
				{

					
						bookedtimesheetData[i, j] = "0000";
					
				}
			}

			//step 3: load data
			crewtimesheetP = ConvertTimesheetHoursForComplainceCheckForUpdate(bookedtimesheetData, crewId, selectedDate);//

			//step 4:get crew data
			CrewTimesheetPOCO crewtimesheetPoco = new CrewTimesheetPOCO();
			crewtimesheetPoco = GetCrewBookedHoursForBatchUpdate(crewId, selectedDate);

			//start processing
			Compliance24Hrs comp24hrs = new Compliance24Hrs();
			Compliance7Days comp7days = new Compliance7Days();
			RegimesPOCO currentRegime = new RegimesPOCO();


			currentRegime = Utility.GetRegimeById(int.Parse(Session["Regime"].ToString())/*, int.Parse(Session["VesselID"].ToString())*/);

			//modified by Dheeman replaced the array for last seven days containing data in order - 1,2,3,4,5,6,7 with 7,6,5,4,3,2,1
			//string[] last7DaysSession = Utility.TrimTrailingNulls(crewtimesheetP.last7DaysBookedHoursReversed.ToArray<string>());
			////string[] last7DaysSession = Utility.TrimTrailingNulls(crewtimesheetP.last7DaysBookedHours.ToArray<string>());
			//string[] last48HrsSessions = Utility.GetSessionsFromLastDay(2, last7DaysSession);

			//string[] last7DaysSessionForAny7Days = crewtimesheetP.last7DaysBookedHoursReversedWithZeroValues.ToArray<string>();
			//bool _isFirstSevenDays = timeSheetBL.GetWorkDayCountBeforeSevenDays(int.Parse(crewId), DateTime.ParseExact(selectedDate, "MM/dd/yyyy", CultureInfo.InvariantCulture), int.Parse(Session["VesselID"].ToString())) > 0 ? false : true;

			//comp24hrs = HoursCalculation.Check24hrsRestHrs(last48HrsSessions, currentRegime);
			//comp7days = HoursCalculation.Check7DaysRestHrs(last7DaysSessionForAny7Days, currentRegime, _isFirstSevenDays);
			//ComplianceInfo complianceInfo = GetComplianceInfo(comp24hrs, comp7days, DateTime.Now);


			// START - NEW CODE CHANGES
			string[] last7DaysSessionForAny7Days = crewtimesheetP.last7DaysBookedHoursReversedWithZeroValues.ToArray<string>();
			string[] last48HrsSessions = Utility.GetSessionsFromLastDay(2, last7DaysSessionForAny7Days);
			bool _isFirstSevenDays = timeSheetBL.GetWorkDayCountBeforeSevenDays(int.Parse(crewId),
																				DateTime.ParseExact(selectedDate, "MM/dd/yyyy", CultureInfo.InvariantCulture),
																				int.Parse(Session["VesselID"].ToString())) > 0 ? false : true;
            bool _isFirstDay = false; /*timeSheetBL.GetWorkDayCountBeforeOneDays(int.Parse(crewId),
																				DateTime.ParseExact(selectedDate, "MM/dd/yyyy", CultureInfo.InvariantCulture),
																				int.Parse(Session["VesselID"].ToString())) > 0 ? false : true;*/
			comp24hrs = HoursCalculation.ProcessAny24HrsSession(last48HrsSessions, currentRegime, _isFirstDay);
			comp7days = HoursCalculation.ProcessAny7DaysSession(last7DaysSessionForAny7Days, currentRegime, _isFirstSevenDays);
            //ComplianceInfo complianceInfo = GetComplianceInfo(comp24hrs, comp7days, DateTime.Now);
		    ComplianceInfo complianceInfo = HoursCalculation.GetComplianceInfo(last48HrsSessions, last7DaysSessionForAny7Days, DateTime.Now, currentRegime, _isFirstDay, _isFirstSevenDays);
            // END - NEW CODE CHANGES


            crewPC.RegimeID = int.Parse(Session["Regime"].ToString());

			crewPC.BookedHours = crewtimesheetP.BookedHours;
			crewPC.BookDate = DateTime.ParseExact(selectedDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);

			if (!String.IsNullOrEmpty(crewtimesheetPoco.Comment))
				crewPC.Comment = crewtimesheetPoco.Comment;
			else
				crewPC.Comment = String.Empty;
			CrewPOCO crew = new CrewPOCO();
			crew.ID = int.Parse(crewId);
			//if (!String.IsNullOrEmpty(crewtimesheet.ActualHours))
			//	crewPC.ActualHours = crewtimesheet.ActualHours.TrimEnd(',');
			//else
				crewPC.ActualHours = "0000,0000,0000,0000,0000,0000";
			crewPC.AdjustmentFactor = adjustmentFactor;
			crewPC.Crew = crew;

			CrewBL crewbl = new CrewBL();
			bool hasOvertime = crewbl.GetCrewOvertimeValue(int.Parse(crewId), int.Parse(Session["VesselID"].ToString()));
			// get total working hours
			string[] arr = Array.ConvertAll(crewPC.BookedHours, m => m.ToString());
			double overtimeHours = 0;
			double totalworkedHours = CalculateWorkHoursandOvertimeHours(DateTime.ParseExact(selectedDate, "MM/dd/yyyy", CultureInfo.InvariantCulture), arr, out overtimeHours, hasOvertime);

			// adding NC Details 
			string ncdetailsxml = String.Empty;
			MemoryStream localMemoryStream = new MemoryStream();
			XmlTextWriter writer = null;
			writer = new XmlTextWriter(localMemoryStream, System.Text.Encoding.UTF8);

			writer.WriteStartElement("ncdetails");
			writer.WriteElementString("maxnrrestperiodstatus", complianceInfo.TwentyFourHourCompliance.MaxNrOfRestPeriodStatus);
			writer.WriteElementString("maxrestperiodstatus", complianceInfo.TwentyFourHourCompliance.MaxRestPeriodStatus);
			writer.WriteElementString("sevendaysstatus", complianceInfo.SevenDaysCompliance.StatusMessage);
			writer.WriteElementString("twentyfourhourresthoursstatus", complianceInfo.TwentyFourHourCompliance.TotalRestHoursStatus);
			writer.WriteElementString("minsevendaysrest", complianceInfo.SevenDaysCompliance.TotalRestHours.ToString()); // max 7 days
			writer.WriteElementString("mintwentyfourhoursrest", complianceInfo.TwentyFourHourCompliance.TotalRestHours.ToString());  //rest
			writer.WriteElementString("maxrestperiodintewntyfourhours", complianceInfo.TwentyFourHourCompliance.MaxRestPeriod.ToString());  // min 24
			writer.WriteElementString("maxnrofrestperiod", complianceInfo.TwentyFourHourCompliance.MaxNrOfRestPeriod.ToString());
			writer.WriteElementString("totalworkedhours", totalworkedHours.ToString());
			writer.WriteElementString("overtimeHours", overtimeHours.ToString());

			//writer.WriteElementString("",complianceInfo.r);
			writer.WriteEndElement();
			writer.Flush();
			localMemoryStream.Position = 0;
			StreamReader reader = new StreamReader(localMemoryStream);
			ncdetailsxml = reader.ReadToEnd();
			writer.Close();
			reader.Close();


			if (string.IsNullOrEmpty(complianceInfo.TwentyFourHourCompliance.MaxNrOfRestPeriodStatus)
				&& string.IsNullOrEmpty(complianceInfo.TwentyFourHourCompliance.MaxRestPeriodStatus)
				&& string.IsNullOrEmpty(complianceInfo.SevenDaysCompliance.StatusMessage)
				&& string.IsNullOrEmpty(complianceInfo.TwentyFourHourCompliance.TotalRestHoursStatus))
			{
				crewPC.isNonCompliant = 0;
			}
			else
			{
				crewPC.isNonCompliant = 1;
			}

		    crewPC.IsTechnicalNC = complianceInfo.IsTechnicalNC;
		    crewPC.Is24HoursCompliant = complianceInfo.Is24HoursCompliant;
		    crewPC.IsSevenDaysCompliant = complianceInfo.IsSevenDaysCompliant;
		    crewPC.PaintOrange = complianceInfo.PaintOrange;

            crewPC.NCDetails.ComplianceInfo = ncdetailsxml;
			crewPC.NCDetails.OccuredOn = DateTime.ParseExact(selectedDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);



			crewPC.NCDetails.CrewID = int.Parse(crewId);

			if (crewtimesheetPoco.WorkSessionId.HasValue)
			{
				crewPC.ID = crewtimesheetPoco.WorkSessionId.Value;
				crewPC.NCDetailsID = crewtimesheetPoco.NCDetailsID;
				crewPC.DayUpdate = 1;
			}
			else
			{
				crewPC.ID = 0;
				crewPC.NCDetailsID = 0;
				crewPC.DayUpdate = 0;
			}

			crewBL.AddCrewTimeSheet(crewPC, int.Parse(Session["VesselID"].ToString()));
		}

		[TraceFilterAttribute]
		public JsonResult CheckTimeSheetComplance(string timesheetjsondata, string crewId, string selectedDate)
        {
            CrewBL crewBL = new CrewBL();
            CrewTimesheetPOCO crewPC = new CrewTimesheetPOCO();
            CrewTimesheetPOCO crewtimesheetP = new CrewTimesheetPOCO();
            Compliance24Hrs comp24hrs = new Compliance24Hrs();
            Compliance7Days comp7days = new Compliance7Days();
            RegimesPOCO currentRegime = new RegimesPOCO();
            TimeSheetBL timeSheetBL = new TimeSheetBL();

            crewtimesheetP = ConvertTimesheetHoursForComplainceCheck(timesheetjsondata, crewId, selectedDate);

            currentRegime = Utility.GetRegimeById(int.Parse(Session["Regime"].ToString())/*, int.Parse(Session["VesselID"].ToString())*/);
			////modified by Dheeman replaced the array for last seven days containing data in order - 1,2,3,4,5,6,7 with 7,6,5,4,3,2,1
			//string[] last7DaysSession = Utility.TrimTrailingNulls(crewtimesheetP.last7DaysBookedHoursReversed.ToArray<string>());
			////string[] last7DaysSession = Utility.TrimLeadingZeros(crewtimesheetP.last7DaysBookedHours.ToArray<string>());
			//string[] last48HrsSessions = Utility.GetSessionsFromLastDay(2, last7DaysSession);
			//         string[] last7DaysSessionForAny7Days = crewtimesheetP.last7DaysBookedHoursReversedWithZeroValues.ToArray<string>();
			//          bool _isFirstSevenDays = timeSheetBL.GetWorkDayCountBeforeSevenDays(int.Parse(crewId),
			//                                                                             DateTime.ParseExact(selectedDate, "MM/dd/yyyy", CultureInfo.InvariantCulture),
			//                                                                             int.Parse(Session["VesselID"].ToString())) > 0 ? false : true;

			//         comp24hrs = HoursCalculation.Check24hrsRestHrs(last48HrsSessions, currentRegime);
			//         comp7days = HoursCalculation.Check7DaysRestHrs(last7DaysSessionForAny7Days, currentRegime, _isFirstSevenDays);

			//         ComplianceInfo complianceInfo = GetComplianceInfo(comp24hrs, comp7days, DateTime.Now);

			// START - NEW CODE CHANGES
			string[] last7DaysSessionForAny7Days = crewtimesheetP.last7DaysBookedHoursReversedWithZeroValues.ToArray<string>();
			string[] last48HrsSessions = Utility.GetSessionsFromLastDay(2, last7DaysSessionForAny7Days);
			bool _isFirstSevenDays = timeSheetBL.GetWorkDayCountBeforeSevenDays(int.Parse(crewId),
																				DateTime.ParseExact(selectedDate, "MM/dd/yyyy", CultureInfo.InvariantCulture),
																				int.Parse(Session["VesselID"].ToString())) > 0 ? false : true;
            bool _isFirstDay = timeSheetBL.GetWorkDayCountBeforeOneDays(int.Parse(crewId),
																				DateTime.ParseExact(selectedDate, "MM/dd/yyyy", CultureInfo.InvariantCulture),
																				int.Parse(Session["VesselID"].ToString())) > 0 ? false : true;
            //comp24hrs = HoursCalculation.ProcessAny24HrsSession(last48HrsSessions, currentRegime, _isFirstDay);
            //         comp7days = HoursCalculation.ProcessAny7DaysSession(last7DaysSessionForAny7Days, currentRegime, _isFirstSevenDays);
            //ComplianceInfo complianceInfo = GetComplianceInfo(comp24hrs, comp7days, DateTime.Now);
            //ComplianceInfo complianceInfo = HoursCalculation.GetComplianceInfo(last48HrsSessions,last7DaysSessionForAny7Days, DateTime.Now, currentRegime,_isFirstDay,_isFirstSevenDays);
            ComplianceInfo complianceInfo = HoursCalculation.GetComplianceInfo(last48HrsSessions, last7DaysSessionForAny7Days, DateTime.Now, currentRegime, _isFirstDay, _isFirstSevenDays);
            // END - NEW CODE CHANGES


            // End - Compliance Integration



            bool isnoncompliant = false;
            StringBuilder complianceString = new StringBuilder();
            complianceString.Append("<ul>");
            if (!string.IsNullOrEmpty(complianceInfo.TwentyFourHourCompliance.MaxNrOfRestPeriodStatus))
            {
                complianceString.Append("<li>");
                complianceString.Append(complianceInfo.TwentyFourHourCompliance.MaxNrOfRestPeriodStatus);
                complianceString.Append("</li>");
                isnoncompliant = true;
            }
            if (!string.IsNullOrEmpty(complianceInfo.TwentyFourHourCompliance.MaxRestPeriodStatus))
            {
                complianceString.Append("<li>");
                complianceString.Append(complianceInfo.TwentyFourHourCompliance.MaxRestPeriodStatus);
                complianceString.Append("</li>");
                isnoncompliant = true;
            }
            if (!string.IsNullOrEmpty(complianceInfo.SevenDaysCompliance.StatusMessage))
            {
                complianceString.Append("<li>");
                complianceString.Append(complianceInfo.SevenDaysCompliance.StatusMessage);
                complianceString.Append("</li>");
                isnoncompliant = true;
            }

            if (!String.IsNullOrEmpty(complianceInfo.TwentyFourHourCompliance.TotalRestHoursStatus))
            {
                complianceString.Append("<li>");
                complianceString.Append(complianceInfo.TwentyFourHourCompliance.TotalRestHoursStatus);
                complianceString.Append("</li>");
                isnoncompliant = true;
            }
            complianceString.Append("</ul>");

            string data = String.Empty;

            if (isnoncompliant)
                data = complianceString.ToString();


            return Json(data, JsonRequestBehavior.AllowGet);

        }

		[TraceFilterAttribute]
		public JsonResult GetCrewBookedHours(string crewId,string bookDate)
        {
            TimeSheetBL timesheetBL = new TimeSheetBL();
            CrewTimesheetPOCO crewPC = new CrewTimesheetPOCO();
             crewPC = timesheetBL.GetCrewTimeSheetByDate(int.Parse(crewId), DateTime.ParseExact(bookDate, "MM/dd/yyyy", CultureInfo.InvariantCulture), int.Parse(Session["VesselID"].ToString()));
            


            // var data="";
            if (crewPC != null)
            {
                var data = new { ActualHours = crewPC.ActualHours, Comments = crewPC.Comment,ID = crewPC.ID, NCDetailsID = crewPC.NCDetailsID };
                return Json(data, JsonRequestBehavior.AllowGet);
            }
            else
            {
                var data = "null";
                return Json(data, JsonRequestBehavior.AllowGet);
            }

            
        }


		public CrewTimesheetPOCO GetCrewBookedHoursForBatchUpdate(string crewId, string bookDate)
		{
			TimeSheetBL timesheetBL = new TimeSheetBL();
			CrewTimesheetPOCO crewPC = new CrewTimesheetPOCO();
			crewPC = timesheetBL.GetCrewTimeSheetByDate(int.Parse(crewId), DateTime.ParseExact(bookDate, "MM/dd/yyyy", CultureInfo.InvariantCulture), int.Parse(Session["VesselID"].ToString()));

			return crewPC;

			


		}

		[TraceFilterAttribute]
		public JsonResult GetSecondCrewBookedHours(string crewId, string bookDate)
        {
            TimeSheetBL timesheetBL = new TimeSheetBL();
            CrewTimesheetPOCO crewPC = new CrewTimesheetPOCO();

            crewPC = timesheetBL.GetSecondCrewTimeSheetByDate(int.Parse(crewId), DateTime.ParseExact(bookDate, "MM/dd/yyyy", CultureInfo.InvariantCulture), int.Parse(Session["VesselID"].ToString()));
           



            // var data="";
            if (crewPC != null)
            {
                var data = new { ActualHours = crewPC.ActualHours, Comments = crewPC.Comment, ID = crewPC.ID, NCDetailsID = crewPC.NCDetailsID };
                return Json(data, JsonRequestBehavior.AllowGet);
            }
            else
            {
                var data = "null";
                return Json(data, JsonRequestBehavior.AllowGet);
            }


        }

		[TraceFilterAttribute]
		public JsonResult GetAdjustmentFactor(string selectedDate)
        {
            OptionsPOCO options = new OptionsPOCO();
            OptionsBL optionsbl = new OptionsBL();

            //   if (String.IsNullOrEmpty(selectedDate)) selectedDate   = System.DateTime.Today.ToString("MM/dd/yyyy");

            DateTime z = DateTime.ParseExact(selectedDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            //DateTime dt3 = selectedDate.FormatDate
            //         (ConfigurationManager.AppSettings["InputDateFormat"].ToString(), ConfigurationManager.AppSettings["InputDateSeperator"].ToString(),
            //          ConfigurationManager.AppSettings["OutputDateFormat"].ToString(), ConfigurationManager.AppSettings["OutputDateSeperator"].ToString());

            //DateTime z = dt3;

            options = optionsbl.GetTimeAdjustment(z, int.Parse(Session["VesselID"].ToString()));

            return Json(options.AdjustmentValue, JsonRequestBehavior.AllowGet);

        }

		public string GetAdjustmentFactorForBatchUpdate(string selectedDate)
		{
			OptionsPOCO options = new OptionsPOCO();
			OptionsBL optionsbl = new OptionsBL();

			//   if (String.IsNullOrEmpty(selectedDate)) selectedDate   = System.DateTime.Today.ToString("MM/dd/yyyy");

			DateTime z = DateTime.ParseExact(selectedDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);

			//DateTime z = selectedDate.FormatDate("dd/MM/yyyy",
			//			"/",
			//			ConfigurationManager.AppSettings["OutputDateFormat"].ToString(),
			//			ConfigurationManager.AppSettings["OutputDateSeperator"].ToString());


			options = optionsbl.GetTimeAdjustment(z, int.Parse(Session["VesselID"].ToString()));

			return options.AdjustmentValue; //Json(options.AdjustmentValue, JsonRequestBehavior.AllowGet);

		}


		private ComplianceInfo GetComplianceInfo(Compliance24Hrs comp24hrs, Compliance7Days comp7days, DateTime currentDate)
        {
            ComplianceInfo compInfo = new ComplianceInfo
            {
                ComplianceDate = currentDate,
                IsCompliant = comp7days.IsCompliant && (comp24hrs.IsTechnicalNC || comp24hrs.IsCompliant),
                IsTechnicalNC = comp24hrs.IsTechnicalNC,
                Is24HoursCompliant = comp24hrs.IsCompliant,
                IsSevenDaysCompliant = comp7days.IsCompliant,
                TwentyFourHourCompliance = comp24hrs,
                SevenDaysCompliance = comp7days
            };

            return compInfo;
        }

        private ComplianceInfo GetComplianceInfo(Compliance24Hrs comp24hrs, Compliance7Days comp7days, DateTime currentDate, RegimesPOCO currentRegime)
        {
            ComplianceInfo compInfo;
            if (currentRegime.RegimeName.ToLower() == "ocimf")
            {
                compInfo = new ComplianceInfo
                {
                    ComplianceDate = currentDate,
                    IsCompliant = comp7days.IsCompliant && (comp24hrs.IsTechnicalNC || comp24hrs.IsCompliant),
                    IsTechnicalNC = comp24hrs.IsTechnicalNC,
                    PaintOrange = comp24hrs.IsTechnicalNC && comp24hrs.IsCompliant ? false:true,
                    Is24HoursCompliant = comp24hrs.IsCompliant,
                    IsSevenDaysCompliant = comp7days.IsCompliant,
                    TwentyFourHourCompliance = comp24hrs,
                    SevenDaysCompliance = comp7days
                };
            }
            else
            {
                compInfo = new ComplianceInfo
                {
                    ComplianceDate = currentDate,
                    IsCompliant = comp7days.IsCompliant && (comp24hrs.IsTechnicalNC || comp24hrs.IsCompliant),
                    IsTechnicalNC = comp24hrs.IsTechnicalNC,
                    PaintOrange = false,
                    Is24HoursCompliant = comp24hrs.IsCompliant,
                    IsSevenDaysCompliant = comp7days.IsCompliant,
                    TwentyFourHourCompliance = comp24hrs,
                    SevenDaysCompliance = comp7days
                };
            }

            return compInfo;
        }


        private int[] GetHours(string[,] bookedhrs)
        {
            int[] hrs = new int[48];

            // string[,] bookedhrs = new string[,] { { "10:00", "10:30" }, { "11:00", "12:00" }, { "14:00", "16:30" }, { "20:00", "04:00" } };

            int index = IndexOf(bookedhrs, "1200");

            for (int i = 0; i < hrs.Length; i++)
            {
                hrs[i] = 0;
            }

            // temphrs = string.Empty;
            int cellStartValue = 0, cellEndvalue = 0;
            bool hasStarted = false, hasEnded = false;

            string[] temphrs = new string[2]; ;
            for (int i = 0; i < bookedhrs.GetLength(0); i++)
            {

                cellEndvalue = 0;
                cellStartValue = 0;
                hasStarted = false;
                hasEnded = false;
                for (int q = 0; q < bookedhrs.GetLength(1); q++)
                {
                    Array.Clear(temphrs, 0, temphrs.Length);

                    if (bookedhrs[i, q] != null)
                    {

                        if (bookedhrs[0, 0] == "")
                        {
                            bookedhrs[0, 0] = "0000";
                        }

                        //read start time
                        //temphrs = bookedhrs[i, q].Split(':');
                        temphrs[0] = bookedhrs[i, q].Substring(0, 2);
						temphrs[1] = bookedhrs[i, q].Substring(bookedhrs[i, q].Length - 2);

                        double hrspart = double.Parse(temphrs[0]);

                        if (int.Parse(temphrs[1]) > 0)
                        {
                            hrspart = hrspart + 0.5;
                        }

                        //if (hrspart == 24)
                        //    hrspart = 0;
                         if (hrspart == 24.5)
                            hrspart = 0.5;

                        if (cellStartValue == 0 && hasStarted == false)
                        {
                            cellStartValue = (int)(hrspart * 2);
                            hasStarted = true;
                        }
                        else
                        {
                            cellEndvalue = Convert.ToInt16((hrspart * 2));
                            hasEnded = true;
                        }


                        //    //set 1 value to booked hours
                        if (!(cellStartValue == 0 && cellEndvalue == 0))
                            if (hasStarted && hasEnded)
                            {
                                if (cellEndvalue > cellStartValue)
                                {
                                    for (int j = cellStartValue; j < cellEndvalue; j++) // removing = based on Koushik's calc
                                    {
                                        hrs[j] = 1;
                                    }
                                }
                                else if (cellEndvalue <= cellStartValue)
                                {
                                    for (int j = cellStartValue; j < 47; j++)
                                    {
                                        hrs[j] = 1;
                                    }

                                    for (int j = 0; j <= cellEndvalue; j++)
                                    {
                                        hrs[j] = 1;
                                    }
                                }
                            }//
                    }
                    else
                    {
                        break;
                    }
                }
            }

            return hrs;

        }

        private int IndexOf<T>(T[,] array, T toFind)
        {
            int i = -1;
            foreach (T item in array)
            {
                ++i;
                if (toFind.Equals(item))
                    break;
            }
            return i;
        }

		[TraceFilterAttribute]
		public JsonResult GetCrewLastBookedHours(string crewId,string copydate)
        {
            TimeSheetBL timesheetBL = new TimeSheetBL();
            CrewTimesheetPOCO crewPC = new CrewTimesheetPOCO();
            crewPC = timesheetBL.GetLastTimeSheet(int.Parse(crewId), int.Parse(Session["VesselID"].ToString()),copydate);
            var data="";
            if (crewPC != null)
                data = crewPC.ActualHours;
            else
                data = "null";

            return Json(data, JsonRequestBehavior.AllowGet);
        }

        private double CalculateWorkHoursandOvertimeHours(DateTime bookdate, string[] bookedHours, out double overtimeHours,bool hasOverTime)
        {
            double totalWorkedHourshrs = TotalWorkHours(bookedHours);
            //int overtimeHours = 0;


            DayOfWeek dayOfWeek = bookdate.DayOfWeek;
			if (hasOverTime)
			{
				if (dayOfWeek == DayOfWeek.Saturday)
				{
					if (totalWorkedHourshrs > Constants.ILOSaturdayWorkingHours)
						overtimeHours = totalWorkedHourshrs - Constants.ILOSaturdayWorkingHours;
					else
						overtimeHours = 0;
				}
				else if (dayOfWeek == DayOfWeek.Sunday)
				{
					if (totalWorkedHourshrs > Constants.ILOSundayWorkingHours)
						overtimeHours = totalWorkedHourshrs;
					else
						overtimeHours = 0;
				}
				else
				{
					if (totalWorkedHourshrs > Constants.ILOWeekDayWorkingHours)
						overtimeHours = totalWorkedHourshrs - Constants.ILOWeekDayWorkingHours;
					else
						overtimeHours = 0;
				}
			}
			else
			{
				overtimeHours = 0;
			}





            return totalWorkedHourshrs;
        }

        private double TotalWorkHours(string[] workSessions)
        {
            if (workSessions == null)
            {
                throw new ArgumentNullException();
            }

            double _workHours = 0;
            for (int i = 0; i < workSessions.Length; i++)
            {
                if (workSessions[i] == "1")
                {
                    _workHours += 1;
                }
            }
            return _workHours/2;
        }



        [HttpGet]
        public JsonResult GetNCForMonth(string bookDate, string CrewId)
        {
			int Month=0;
			int Year=0;
			if (bookDate == null || bookDate == string.Empty)
			{
				Month = System.DateTime.Today.Month;
				Year = System.DateTime.Today.Year;
			}
			else
			{
				Month = DateTime.ParseExact(bookDate, "MM/dd/yyyy", CultureInfo.InvariantCulture).Month;
                //DateTime dt1 = bookDate.FormatDate
                //    (ConfigurationManager.AppSettings["InputDateFormat"].ToString(), ConfigurationManager.AppSettings["InputDateSeperator"].ToString(),
                //     ConfigurationManager.AppSettings["OutputDateFormat"].ToString(), ConfigurationManager.AppSettings["OutputDateSeperator"].ToString());

                //Month = dt1.Month;


                Year = DateTime.ParseExact(bookDate, "MM/dd/yyyy", CultureInfo.InvariantCulture).Year;
                //DateTime dt = bookDate.FormatDate
                //     (ConfigurationManager.AppSettings["InputDateFormat"].ToString(), ConfigurationManager.AppSettings["InputDateSeperator"].ToString(),
                //      ConfigurationManager.AppSettings["OutputDateFormat"].ToString(), ConfigurationManager.AppSettings["OutputDateSeperator"].ToString());

                //Year = dt.Year;
            }

			
			TimeSheetBL timesheetBL = new TimeSheetBL();
            CrewTimesheetPOCO crewPC = new CrewTimesheetPOCO();

            crewPC = timesheetBL.GetNCForMonth(Month, Year,int.Parse(CrewId), int.Parse(Session["VesselID"].ToString()));

			var data = crewPC.NcDay;

            return Json(data, JsonRequestBehavior.AllowGet);
        }


		public JsonResult GetNoNCForMonth(string bookDate, string CrewId)
		{
			int Month = 0;
			int Year = 0;
			if (bookDate == null || bookDate == string.Empty)
			{
				Month = System.DateTime.Today.Month;
				Year = System.DateTime.Today.Year;
			}
			else
			{
				Month = DateTime.ParseExact(bookDate, "MM/dd/yyyy", CultureInfo.InvariantCulture).Month;
				


				Year = DateTime.ParseExact(bookDate, "MM/dd/yyyy", CultureInfo.InvariantCulture).Year;
				
			}


			TimeSheetBL timesheetBL = new TimeSheetBL();
			CrewTimesheetPOCO crewPC = new CrewTimesheetPOCO();

			crewPC = timesheetBL.GetNoNCForMonth(Month, Year, int.Parse(CrewId), int.Parse(Session["VesselID"].ToString()));

			var data = crewPC.NcDay;

			return Json(data, JsonRequestBehavior.AllowGet);
		}
	}
}