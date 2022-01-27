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
using Newtonsoft.Json;

namespace TM.RestHour.Controllers
{
    public class RightsController : Controller
    {
        // GET: Rights
        public ActionResult Index()
        {
            RightsBL rightsBL = new RightsBL();
            RightsPOCO rightsPC = new RightsPOCO();
            int CrewId = 0;
            string PageName = "";
            rightsPC = rightsBL.GetRightsByCrewId(CrewId, PageName, int.Parse(Session["VesselID"].ToString()), int.Parse(System.Web.HttpContext.Current.Session["UserID"].ToString()));

            ViewBag.Crew = rightsPC.CrewList.Select(x =>
                                            new SelectListItem()
                                            {
                                                Text = x.Name,
                                                Value = x.ID.ToString()
                                            });

            return View(rightsPC);
        }

        [HttpPost]
        public ActionResult Index(RightsPOCO pOCO)
        {
            RightsBL rightsBL = new RightsBL();
            RightsPOCO rightsPC = new RightsPOCO();
            int CrewId = pOCO.CrewId;
            string PageName = pOCO.PageName;

            rightsPC = rightsBL.GetRightsByCrewId(CrewId, PageName, int.Parse(Session["VesselID"].ToString()), int.Parse(System.Web.HttpContext.Current.Session["UserID"].ToString()));

            //Rights um = new Rights();

            var cm = rightsPC;

            ViewBag.Crew = rightsPC.CrewList.Select(x =>
                                           new SelectListItem()
                                           {
                                               Text = x.Name,
                                               Value = x.ID.ToString()
                                           });

            return View(cm);

            //GetAllCrewForTimeSheet();

            //CrewTimesheetViewModel crewtimesheetVM = new CrewTimesheetViewModel();
            //Crew c = new Crew();
            //crewtimesheetVM.Crew = c;

            //if (Convert.ToBoolean(Session["User"]) == true)
            //{
            //    crewtimesheetVM.Crew.ID = int.Parse(System.Web.HttpContext.Current.Session["LoggedInUserId"].ToString());
            //}
            //else
            //    crewtimesheetVM.Crew.ID = 0;

            //return View(crewtimesheetVM);


        }


        //[HttpGet]
        //public JsonResult GetRightsByCrewId(int CrewId)
        //{
        //    RightsBL rightsBL = new RightsBL();
        //    List<RightsPOCO> rightsPC = new List<RightsPOCO>();

        //    rightsPC = rightsBL.GetRightsByCrewId(CrewId);

        //    //Rights um = new Rights();

        //    var cm = rightsPC;

        //    return Json(cm, JsonRequestBehavior.AllowGet);
        //}

        [TraceFilterAttribute]
        public void GetAllCrewForTimeSheet()
        {
            TimeSheetBL crewDAL = new TimeSheetBL();
            List<CrewPOCO> crewpocoList = new List<CrewPOCO>();

            crewpocoList = crewDAL.GetAllCrewForTimeSheet(int.Parse(Session["VesselID"].ToString()), int.Parse(System.Web.HttpContext.Current.Session["UserID"].ToString()));

            List<Crew> itmasterList = new List<Crew>();

            foreach (CrewPOCO up in crewpocoList)
            {
                Crew unt = new Crew();
                unt.ID = up.ID;
                unt.Name = up.Name;

                itmasterList.Add(unt);
            }

            ViewBag.Crew = itmasterList.Select(x =>
                                            new SelectListItem()
                                            {
                                                Text = x.Name,
                                                Value = x.ID.ToString()
                                            });

        }

        // for Crew drp
        public JsonResult GetAllCrewForDrp()
        {
            TimeSheetBL crewDAL = new TimeSheetBL();
            List<CrewPOCO> crewpocoList = new List<CrewPOCO>();

            crewpocoList = crewDAL.GetAllCrewForDrp(int.Parse(Session["VesselID"].ToString()), int.Parse(System.Web.HttpContext.Current.Session["UserID"].ToString()));

            List<Crew> itmasterList = new List<Crew>();

            foreach (CrewPOCO up in crewpocoList)
            {
                Crew unt = new Crew();
                unt.ID = up.ID;
                unt.Name = up.Name;

                itmasterList.Add(unt);
            }

            string json = JsonConvert.SerializeObject(itmasterList);

            //ViewBag.Crew = itmasterList.Select(x =>
            //                                new SelectListItem()
            //                                {
            //                                    Text = x.Name,
            //                                    Value = x.ID.ToString()
            //                                });
            return Json(json, JsonRequestBehavior.AllowGet); 
        }
    }
}