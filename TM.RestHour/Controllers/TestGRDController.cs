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
    public class TestGRDController : Controller
    {
        // GET: TestGRD
        public ActionResult Index()
        {
            return View();
        }
    }
}