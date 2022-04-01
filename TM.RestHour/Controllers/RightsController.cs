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
        [HttpGet]
        public ActionResult Index()
        {
            RightsBL rightsBL = new RightsBL();
            RightsPOCO rightsPC = new RightsPOCO();
            int? CrewId = 0;
            string PageName = "";
            int? UserId = 0;
            string UserName = string.Empty;
            if (Request.QueryString["crew"] != null)
            {
                CrewId = int.Parse(Request.QueryString["crew"].ToString());
                UserId = rightsBL.GetUserIdByCrewID(CrewId.Value);
            }
            else
            {
                UserId = int.Parse(Session["UserId"].ToString());
                CrewId = int.Parse(Session["LoggedInUserId"].ToString());
            }

            rightsPC = rightsBL.GetRightsByCrewId(CrewId, PageName, int.Parse(Session["VesselID"].ToString()), UserId);

            ViewBag.Crew = rightsPC.CrewList.Select(x =>
                                            new SelectListItem()
                                            {
                                                Text = x.Name,
                                                Value = x.ID.ToString()
                                            });

            return View(rightsPC);
        }

        [HttpPost]
        [AllowMultipleButton(Name = "action", Argument = "Save")]
        public ActionResult Save(RightsPOCO pOCO)
        {
            RightsBL rightsBL = new RightsBL();
            RightsPOCO rightsPC = new RightsPOCO();

            int? CrewId = 0;
            string PageName = "";
            int? UserId = 0;
            string UserName = string.Empty;
            if (Request.QueryString["crew"] != null)
            {
                CrewId = int.Parse(Request.QueryString["crew"].ToString());
                UserId = rightsBL.GetUserIdByCrewID(CrewId.Value);
            }
            else
            {
                UserId = int.Parse(Session["UserId"].ToString());
                CrewId = int.Parse(Session["LoggedInUserId"].ToString());
            }

            PageName = pOCO.PageName;
            ViewBag.CrewId = CrewId;
            ViewBag.PageName = PageName;

            //save data
            string pageIds = string.Join(",", pOCO.RightsList.Select(x => x.Id.ToString()).ToArray());
            string accessString = string.Join(",", pOCO.RightsList.Select(x => x.HasAccess.ToString()).ToArray());

            rightsBL.SaveAccess(pageIds, accessString, CrewId.Value, UserId.Value);

            rightsPC = rightsBL.GetRightsByCrewId(ViewBag.CrewId, ViewBag.PageName, int.Parse(Session["VesselID"].ToString()), UserId);

            var cm = rightsPC;

            ViewBag.Crew = rightsPC.CrewList.Select(x =>
                                           new SelectListItem()
                                           {
                                               Text = x.Name,
                                               Value = x.ID.ToString()
                                           });

            return View(rightsPC);
        }



        [HttpPost]
        [AllowMultipleButton(Name = "action", Argument = "Index")]
        public ActionResult Index(RightsPOCO pOCO)
        {
            



            RightsBL rightsBL = new RightsBL();
            RightsPOCO rightsPC = new RightsPOCO();
            int? CrewId = 0;
            string PageName = "";
            int? UserId = 0;
            string UserName = string.Empty;
            if (Request.QueryString["crew"] != null)
            {
                CrewId = int.Parse(Request.QueryString["crew"].ToString());
                UserId = rightsBL.GetUserIdByCrewID(CrewId.Value);
            }
            else
            {
                UserId = int.Parse(Session["UserId"].ToString());
                CrewId = int.Parse(Session["LoggedInUserId"].ToString());
            }

            PageName = pOCO.PageName;

            rightsPC = rightsBL.GetRightsByCrewId(CrewId, PageName, int.Parse(Session["VesselID"].ToString()), UserId);

            ViewBag.Crew = rightsPC.CrewList.Select(x =>
                                            new SelectListItem()
                                            {
                                                Text = x.Name,
                                                Value = x.ID.ToString()
                                            });

            return View(rightsPC);
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