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
            return View();
        }

        public JsonResult GetOvertimeCalculation(int Id)
        {
            OvertimeCalculationBL overtimeCalculationBL = new OvertimeCalculationBL();
            OvertimeCalculationPOCO overtimeCalculationPOCO = new OvertimeCalculationPOCO();

            overtimeCalculationPOCO = overtimeCalculationBL.GetOvertimeCalculation(Id, int.Parse(Session["VesselID"].ToString()));

            OvertimeCalculation dept = new OvertimeCalculation();

            dept.Id = overtimeCalculationPOCO.Id;
            dept.DailyWorkHours = overtimeCalculationPOCO.DailyWorkHours;
            dept.HourlyRate = overtimeCalculationPOCO.HourlyRate;
            dept.HoursPerWeekOrMonth = overtimeCalculationPOCO.HoursPerWeekOrMonth;
            dept.FixedOvertime = overtimeCalculationPOCO.FixedOvertime;
            //dept.SunDay = overtimeCalculationPOCO.SunDay;
            //dept.MonDay = overtimeCalculationPOCO.MonDay;
            //dept.TueDay = overtimeCalculationPOCO.TueDay;
            //dept.WedDay = overtimeCalculationPOCO.WedDay;
            //dept.ThuDay = overtimeCalculationPOCO.ThuDay;
            //dept.FriDay = overtimeCalculationPOCO.FriDay;
            //dept.SatDay = overtimeCalculationPOCO.SatDay;

            var data = dept;

            return Json(data, JsonRequestBehavior.AllowGet);
        }

        public JsonResult SaveOvertimeCalculation(OvertimeCalculation overtimeCalculation)
        {
            OvertimeCalculationBL overtimeCalculationBL = new OvertimeCalculationBL();
            OvertimeCalculationPOCO overtimeCalculationPOCO = new OvertimeCalculationPOCO();

            WorkingHoursPOCO workingHoursPOCO = new WorkingHoursPOCO();
            overtimeCalculationPOCO.WorkingHoursPOCO = workingHoursPOCO;

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

            return Json(overtimeCalculationBL.SaveOvertimeCalculation(overtimeCalculationPOCO, int.Parse(Session["VesselID"].ToString())), JsonRequestBehavior.AllowGet);
        }
    }
}