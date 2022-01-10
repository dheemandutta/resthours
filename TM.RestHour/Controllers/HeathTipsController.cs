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

using System.Configuration;
using TM.Base.Common;
namespace TM.RestHour.Controllers
{
    public class HeathTipsController : BaseController
    {
        // GET: HeathTips
        public ActionResult Maintainingahealthydietonboard()
        {
            return View();
        }

        public ActionResult Maintainingfitnessonboard()
        {
            return View();
        }

        public ActionResult Foodsafetyonboard()
        {
            return View();
        }

        public ActionResult Maintainingahealthyweightonboard()
        {
            return View();
        }

        public ActionResult Protectingyourskinonboard()
        {
            return View();
        }

        public ActionResult Maintainingdentalhygiene()
        {
            return View();
        }

        public ActionResult Maintainingmentalwellbeing()
        {
            return View();
        }

        public ActionResult Adviceforsafesex()
        {
            return View();
        }

        public ActionResult Malariaprevention()
        {
            return View();
        }

        public ActionResult Adviseforsafetravel()
        {
            return View();
        }
    }
}