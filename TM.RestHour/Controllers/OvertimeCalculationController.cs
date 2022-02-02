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

namespace TM.RestHour.Controllers
{
    [TraceFilterAttribute]
    public class OvertimeCalculationController : Controller
    {
        [TraceFilterAttribute]
        // GET: OvertimeCalculation
        public ActionResult Index()
        {
            OvertimeCalculationPOCO overtimeCalculationPOCO = new OvertimeCalculationPOCO();
            return View(overtimeCalculationPOCO);
        }

        public JsonResult GetOvertimeCalculation()
        {
            OvertimeCalculationBL overtimeCalculationBL = new OvertimeCalculationBL();
            OvertimeCalculationPOCO overtimeCalculationPOCO = new OvertimeCalculationPOCO();

            overtimeCalculationPOCO = overtimeCalculationBL.GetOvertimeCalculation();

            return Json(overtimeCalculationPOCO, JsonRequestBehavior.AllowGet);
        }

        public JsonResult SaveOvertimeCalculation(OvertimeCalculation overtimeCalculation)
        {
            OvertimeCalculationBL overtimeCalculationBL = new OvertimeCalculationBL();
            OvertimeCalculationPOCO overtimeCalculationPOCO = new OvertimeCalculationPOCO();

            WorkingHoursPOCO workingHoursPOCO = new WorkingHoursPOCO();
            overtimeCalculationPOCO.WorkingHoursPOCO = workingHoursPOCO;

            //if (overtimeCalculation.FixedOvertime.HasValue)
            //{
            //    overtimeCalculationPOCO.IsWeekly = false;
            //}
            //else 
            //{
            //    overtimeCalculationPOCO.IsWeekly = true;
            //}

            overtimeCalculationPOCO.Id = overtimeCalculation.Id;
            overtimeCalculationPOCO.DailyWorkHours = overtimeCalculation.DailyWorkHours;
            overtimeCalculationPOCO.HourlyRate = overtimeCalculation.HourlyRate;
            overtimeCalculationPOCO.HoursPerWeekOrMonth = overtimeCalculation.HoursPerWeekOrMonth;
            overtimeCalculationPOCO.FixedOvertime = overtimeCalculation.FixedOvertime;
            overtimeCalculationPOCO.WorkingHoursPOCO.SunDay = overtimeCalculation.WorkingHours.SunDay;
            overtimeCalculationPOCO.WorkingHoursPOCO.MonDay = overtimeCalculation.WorkingHours.MonDay;
            overtimeCalculationPOCO.WorkingHoursPOCO.TueDay = overtimeCalculation.WorkingHours.TueDay;
            overtimeCalculationPOCO.WorkingHoursPOCO.WedDay = overtimeCalculation.WorkingHours.WedDay;
            overtimeCalculationPOCO.WorkingHoursPOCO.ThuDay = overtimeCalculation.WorkingHours.ThuDay;
            overtimeCalculationPOCO.WorkingHoursPOCO.FriDay = overtimeCalculation.WorkingHours.FriDay;
            overtimeCalculationPOCO.WorkingHoursPOCO.SatDay = overtimeCalculation.WorkingHours.SatDay;
            overtimeCalculationPOCO.WorkingHoursPOCO.RegimeID = int.Parse(Session["Regime"].ToString());
            overtimeCalculationPOCO.IsWeekly = Convert.ToBoolean(Convert.ToInt32(overtimeCalculation.IsWeekly));

            return Json(overtimeCalculationBL.SaveOvertimeCalculation(overtimeCalculationPOCO, int.Parse(Session["VesselID"].ToString())), JsonRequestBehavior.AllowGet);
        }
    }
}