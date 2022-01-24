using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

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