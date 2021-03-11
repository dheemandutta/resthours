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

namespace TM.RestHour.Controllers
{
    public class PsychometricsController : Controller
    {
        // GET: Psychometrics
        public ActionResult Index()
        {
            return View();
        }
    }
}