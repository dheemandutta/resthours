using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace TM.RestHour.Controllers
{
    public class PlansController : Controller
    {
        // GET: Plans
        public ActionResult Index()
        {
            return View();
        }
    }
}