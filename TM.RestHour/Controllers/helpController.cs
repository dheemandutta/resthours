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

namespace TM.RestHour.Controllers
{
    [TraceFilterAttribute]
    public class helpController : BaseController
    {
        // GET: help
        [TraceFilterAttribute]
        public ActionResult index()
        {
            return View();
        }
    }
}