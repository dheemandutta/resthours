using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using TM.RestHour.BL;
using TM.RestHour.Models;
using TM.Base.Entities;
using System.Globalization;
using System.IO;
using System.Configuration;
using ExcelDataReader;

namespace TM.RestHour.Controllers
{
    public class RightsController : Controller
    {
        // GET: Rights
        public ActionResult Index()
        {
            return View();
        }


        [HttpGet]
        public JsonResult GetRightsByCrewId(int CrewId)
        {
            RightsBL shipBL = new RightsBL();
            RightsPOCO shipPC = new RightsPOCO();

            shipPC = shipBL.GetRightsByCrewId(CrewId);

            Rights um = new Rights();

            um.Id = shipPC.Id;
            um.ResourceName = shipPC.ResourceName;
            um.ParentId = shipPC.ParentId;
            um.HasAccess = shipPC.HasAccess;

            var cm = um;

            return Json(cm, JsonRequestBehavior.AllowGet);
        }
    }
}