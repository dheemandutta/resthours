using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

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

        public ActionResult WellBeingWorkAndRestHours()
        {
            return View();
        }
    }
}