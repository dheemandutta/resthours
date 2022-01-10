using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace TM.RestHour.Controllers
{
    public class HealthController : Controller
    {
        // GET: Health
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult MentalHealth()
        {
            return View();
        }

        public ActionResult WorkAndRestHours()
        {
            return View();
        }
    }
}