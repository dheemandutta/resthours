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
using System.Threading.Tasks;
using System.IO;
using System.Net;

namespace TM.RestHour.Controllers
{
    [TraceFilterAttribute]
    public class HealthManagementController : BaseController
    {
        // GET: HealthManagement
        [TraceFilterAttribute]
        public ActionResult StressManagement()
        {
            return View();
        }

        [TraceFilterAttribute]
        public ActionResult HealthTips()
        {
            return View();
        }

        [TraceFilterAttribute]
        public ActionResult DoctorVisit()
        {
            return View();
        }

        
    }
}