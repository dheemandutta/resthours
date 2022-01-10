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
        public ActionResult MedicalAdvice()
        {
            return View();
        }
    }
}