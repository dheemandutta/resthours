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
using TM.Base.Common;

using System.Configuration;

using System.IO;

namespace TM.RestHour.Controllers
{
    public class WellBeingController : Controller
    {
        // GET: WellBeing
        public ActionResult WellBeingHealth()
        {
            return View();
        }

        public ActionResult WellBeingMentalHealth()
        {
            return View();
        }

        [TraceFilterAttribute]
        public ActionResult WellBeingWorkAndRestHours()
        {
            return View();
        }

        [TraceFilterAttribute]
        public ActionResult MonthlyWorkHours(string crewId, string monthYear)
        {
            //GetAllCrewForTimeSheet();

            if(Request.QueryString["crew"] != null && String.IsNullOrEmpty(crewId))
                crewId = Request.QueryString["crew"].ToString();

            if (Request.QueryString["monthYear"] != null && String.IsNullOrEmpty(monthYear))
                monthYear = Request.QueryString["monthYear"];

            CrewTimesheetViewModel crewtimesheetVM = new CrewTimesheetViewModel();
            Crew c = new Crew();
            c.ID = int.Parse(crewId);

            crewtimesheetVM.Crew = c;
            crewtimesheetVM.SelectedMonthYear = monthYear;


            return View(crewtimesheetVM);
           
        }

        public JsonResult GetNCDetails(string monthyear)
        {
            ReportsBL reportsBL = new ReportsBL();
            ReportsPOCO reportsPC = new ReportsPOCO();
            Reports reports = new Reports();

            string month = monthyear.Substring(0, monthyear.Length - 4);

            int mon = (int)((Months)Enum.Parse(typeof(Months), month.Trim()));
            //reportsPC.MonthName = month;
            int year = int.Parse(Utilities.GetLast(monthyear, 4));


            //string month = reports.SelectedMonthYear.Substring(0, reports.SelectedMonthYear.Length - 4);

            //reportsPC.Month = (int)((Months)Enum.Parse(typeof(Months), month.Trim()));
            //reportsPC.MonthName = month;
            //reportsPC.Year = int.Parse(Utilities.GetLast(reports.SelectedMonthYear, 4));
            //reportsPC.CrewID = reports.CrewID;
            reportsPC.NCDetailsID = reports.NCDetailsID;

            List<ReportsPOCO> reportsList = new List<ReportsPOCO>();
            reportsList = reportsBL.GetNCDetails(mon, year, int.Parse(Session["VesselID"].ToString()), int.Parse(Session["UserID"].ToString()));
            //string[] bookedHours = new string[31];
            //int row = 0;
            //foreach (ReportsPOCO item in reportsList)
            //{
            //    bookedHours[row] = item.Hours;
            //    row++;
            //}
            var data = reportsList;



            return Json(data, JsonRequestBehavior.AllowGet);
            //return Json(new { BookedHours = data }, JsonRequestBehavior.AllowGet);
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




        public JsonResult GetMonthlyDataForWeb(Reports reports)
        {
            ReportsBL reportsBL = new ReportsBL();
            ReportsPOCO reportsPC = new ReportsPOCO();

            string month = reports.SelectedMonthYear.Substring(0, reports.SelectedMonthYear.Length - 4);

            reportsPC.Month = (int)((Months)Enum.Parse(typeof(Months), month.Trim()));
            reportsPC.MonthName = month;
            reportsPC.Year = int.Parse(Utilities.GetLast(reports.SelectedMonthYear, 4));
            reportsPC.CrewID = reports.CrewID;

            List<ReportsPOCO> reportsList = new List<ReportsPOCO>();
            reportsList = reportsBL.GetCrewIDFromWorkSessionsForWeb(reportsPC, int.Parse(Session["VesselID"].ToString()));
            //32 to 36
            string[] bookedHours = new string[62];
            int row = 0;
            foreach (ReportsPOCO item in reportsList)
            {
                bookedHours[row] = item.Hours;


                row++;
            }


            var data = reportsList;



            // return Json(data, JsonRequestBehavior.AllowGet);
            return Json(new { BookedHours = data }, JsonRequestBehavior.AllowGet);
        }




    }
}