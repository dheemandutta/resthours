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
using System.IO;
using System.Configuration;

using System.Net;
using System.Net.Mail;

namespace TM.RestHour.Controllers
{
    public class MentalHealthController : Controller
    {
        // GET: MentalHealth
        public ActionResult Index()
        {
            GetAllCrewForDrp();
            //CrewTimesheetViewModel crewtimesheetVM = new CrewTimesheetViewModel();
            //Crew crew = new Crew();
            //crew.ID = int.Parse(Session["LoggedInUserId"].ToString());
            //crewtimesheetVM.Crew = crew;
            return View();
        }

        public ActionResult MentalHealthReport()
        {
            return View();
        }

        public ActionResult PsychologicalEvaluationForms()
        {
            return View();
        }

        public ActionResult PsychologicalEvaluationScore()
        {
            return View();
        }



        public void GetAllCrewForDrp()
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

            ViewBag.Crew = itmasterList.Select(x =>
                                            new SelectListItem()
                                            {
                                                Text = x.Name,
                                                Value = x.ID.ToString()
                                            });

        }


        public JsonResult LoadData()
        {
            int draw, start, length;
            int pageIndex = 0;

            if (null != Request.Form.GetValues("draw"))
            {
                draw = int.Parse(Request.Form.GetValues("draw").FirstOrDefault().ToString());
                start = int.Parse(Request.Form.GetValues("start").FirstOrDefault().ToString());
                length = int.Parse(Request.Form.GetValues("length").FirstOrDefault().ToString());
            }
            else
            {
                draw = 1;
                start = 0;
                length = 10;
            }

            if (start == 0)
            {
                pageIndex = 1;
            }
            else
            {
                pageIndex = (start / length) + 1;
            }

            MentalHealthBL mentalHealthBL = new MentalHealthBL();
            int totalrecords = 0;

            List<MentalHealthPOCO> mentalHealthPOCO = new List<MentalHealthPOCO>();
            mentalHealthPOCO = mentalHealthBL.GetMentalHealthPageWise(pageIndex, ref totalrecords, length, int.Parse(Session["VesselID"].ToString()));
            List<MentalHealthPOCO> mentalHealthList = new List<MentalHealthPOCO>();
            foreach (MentalHealthPOCO mentalHealthPC in mentalHealthPOCO)
            {
                MentalHealthPOCO mentalHealth = new MentalHealthPOCO();
                //mentalHealth.MentalHealthPostJoiningList.CrewId = mentalHealthPC.CrewId;
                //mentalHealth.Name = mentalHealthPC.Name;
                //mentalHealth.RankName = mentalHealthPC.RankName;
                //mentalHealth.StartDate = mentalHealthPC.StartDate;

                mentalHealthList.Add(mentalHealth);
            }
            var data = mentalHealthList;
            return Json(new { draw = draw, recordsFiltered = totalrecords, recordsTotal = totalrecords, data = data }, JsonRequestBehavior.AllowGet);
        }
    }
}