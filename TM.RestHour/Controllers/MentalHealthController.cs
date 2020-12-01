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

    }
}