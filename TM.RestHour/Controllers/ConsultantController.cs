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
    public class ConsultantController : BaseController
    {
        // GET: Consultant
        [TraceFilterAttribute]
        public ActionResult Index()
        {
            GetAllSpecialityForDrp();
            return View();
        }
        
        [TraceFilterAttribute]
        public ActionResult IndexNew()
        {         
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

        public JsonResult SaveDoctorMaster(Consultant consultant)
        {
            ConsultantBL consultantBL = new ConsultantBL();
            ConsultantPOCO consultantPC = new ConsultantPOCO();
            //consultantPC.DoctorID = consultant.DoctorID;
            consultantPC.DoctorName = consultant.DoctorName;
            consultantPC.DoctorEmail = consultant.DoctorEmail;
            consultantPC.SpecialityID = consultant.SpecialityID;
            consultantPC.Comment = consultant.Comment;

            

            return Json(consultantBL.SaveDoctorMaster(consultantPC  /*, int.Parse(Session["VesselID"].ToString())*/  ), JsonRequestBehavior.AllowGet);
        }


        public JsonResult SaveMedicalAdvisory(Consultant consultant)
        {
            ConsultantBL consultantBL = new ConsultantBL();
            ConsultantPOCO consultantPC = new ConsultantPOCO();
            //consultantPC.DoctorID = consultant.DoctorID;

            
            consultantPC.CrewID = consultant.CrewID;

            consultantPC.Weight = consultant.Weight;
            consultantPC.BMI = consultant.BMI;
           // consultantPC.BP = consultant.BP;
            consultantPC.BloodSugarLevel = consultant.BloodSugarLevel;
            consultantPC.UrineTest = consultant.UrineTest;

            consultantPC.Height = consultant.Height;
            consultantPC.Age = consultant.Age;
            consultantPC.BloodSugarUnit = consultant.BloodSugarUnit;
            consultantPC.BloodSugarTestType = consultant.BloodSugarTestType;
            consultantPC.Systolic = consultant.Systolic;
            consultantPC.Diastolic = consultant.Diastolic;

            consultantPC.UnannouncedAlcohol = consultant.UnannouncedAlcohol;
            consultantPC.AnnualDH = consultant.AnnualDH;
            consultantPC.Month = consultant.Month;
            consultantPC.CrewNameID = consultant.CrewNameID;
            consultantPC.CrewName = consultant.CrewName;
            consultantPC.PulseRatebpm = consultant.PulseRatebpm;
            consultantPC.AnyDietaryRestrictions = consultant.AnyDietaryRestrictions;
            consultantPC.MedicalProductsAdministered = consultant.MedicalProductsAdministered;
            consultantPC.UploadExistingPrescriptions = consultant.UploadExistingPrescriptions;
            consultantPC.UploadUrineReport = consultant.UploadUrineReport;

            return Json(consultantBL.SaveMedicalAdvisory(consultantPC, int.Parse(Session["LoggedInUserId"].ToString())  /*, int.Parse(Session["VesselID"].ToString())*/  ), JsonRequestBehavior.AllowGet);
        }
    }
}