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

namespace TM.RestHour.Controllers
{
    [TraceFilterAttribute]
    public class PatientProblemController : BaseController
    {
        // GET: PatientProblem
        [TraceFilterAttribute]
        public ActionResult Index()
        {
            GetAllSpecialityForDrp();
            return View();
        }

        // for Speciality drp
        public void GetAllSpecialityForDrp()
        {
            ConsultantBL consultantBL = new ConsultantBL();
            List<ConsultantPOCO> consultantpocoList = new List<ConsultantPOCO>();

            consultantpocoList = consultantBL.GetAllSpecialityForDrp(/*int.Parse(Session["VesselID"].ToString())*/);

            List<Consultant> consultantList = new List<Consultant>();

            foreach (ConsultantPOCO up in consultantpocoList)
            {
                Consultant consult = new Consultant();
                consult.SpecialityID = up.SpecialityID;
                consult.SpecialityName = up.SpecialityName;

                consultantList.Add(consult);
            }

            ViewBag.Consultant = consultantList.Select(x =>
                                            new SelectListItem()
                                            {
                                                Text = x.SpecialityName,
                                                Value = x.SpecialityID.ToString()
                                            });

        }

        public JsonResult GetDoctorBySpecialityID(string SpecialityID)
        {
            ConsultantBL consultantBL = new ConsultantBL();
            List<ConsultantPOCO> consultantpocoList = new List<ConsultantPOCO>();

            consultantpocoList = consultantBL.GetDoctorBySpecialityID(SpecialityID);
            List<Consultant> consultantList = new List<Consultant>();

            foreach (ConsultantPOCO up in consultantpocoList)
            {
                Consultant comp = new Consultant();
                comp.DoctorName = up.DoctorName;
                comp.DoctorID = up.DoctorID;

                consultantList.Add(comp);
            }
            var data = consultantList;
            return Json(data, JsonRequestBehavior.AllowGet);
        }

        public JsonResult SaveConsultation(Consultant consultant)
        {
            ConsultantBL consultantBL = new ConsultantBL();
            ConsultantPOCO consultantPC = new ConsultantPOCO();
            consultantPC.DoctorID = consultant.DoctorID;
            consultantPC.Problem = consultant.Problem;
            return Json(consultantBL.SaveConsultation(consultantPC  /*, int.Parse(Session["VesselID"].ToString())*/  ), JsonRequestBehavior.AllowGet);
        }
    }
}