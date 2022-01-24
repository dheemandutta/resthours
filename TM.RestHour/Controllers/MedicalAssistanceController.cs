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
using System.Configuration;

using System.Net;
using System.Net.Mail;

namespace TM.RestHour.Controllers
{
    public class MedicalAssistanceController : Controller
    {
        // GET: MedicalAssistance
        public ActionResult TeleMedicine()
        {
            return View();
        }
        public ActionResult DoctorVisit()
        {
            return View();
        }
        public ActionResult CIRM()
        {
            //GetAllRanksForDrp();
            //GetAllCountryForDrp();
            //GetAllCrewForDrp();
            //GetAllCrewForTimeSheet();

            //CrewTimesheetViewModel crewtimesheetVM = new CrewTimesheetViewModel();
            return View();
        }



        public ActionResult MediVac()
        {
            return View();
        }
        public ActionResult MediVac_VesselDeatils()
        {
            return PartialView();
        }
        public ActionResult MediVac_VoyageDeatils()
        {
            return PartialView();
        }
        public ActionResult MediVac_WeatherDeatils()
        {
            return PartialView();
        }
        public ActionResult MediVac_PatientDeatils()
        {
            return PartialView();
        }



        public ActionResult MedicalAdvice()
        {
            return View();
        }
    }
}