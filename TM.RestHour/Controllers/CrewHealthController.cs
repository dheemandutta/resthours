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
using ExcelDataReader;

namespace TM.RestHour.Controllers
{
    [TraceFilterAttribute]
    public class CrewHealthController : BaseController
    {
        public ActionResult test()
        {
            return View();
        }
        public ActionResult TestBody()
        {
            return View();
        }
        public ActionResult HumanBody()
        {
            return View();
        }
        public ActionResult UploadJoiningMedical()
        {
            // GetAllCrewForTimeSheet();
            GetAllCrewForDrp();
            GetAllCrewForTimeSheet();
            CrewTimesheetViewModel crewtimesheetVM = new CrewTimesheetViewModel();
            Crew c = new Crew();
            crewtimesheetVM.Crew = c;

            if (Convert.ToBoolean(Session["User"]) == true)
            {
                crewtimesheetVM.Crew.ID = int.Parse(System.Web.HttpContext.Current.Session["LoggedInUserId"].ToString());
                crewtimesheetVM.AdminStatus = System.Web.HttpContext.Current.Session["AdminStatus"].ToString();
                crewtimesheetVM.CrewAdminId = 0;

            }
            else
            {
                crewtimesheetVM.Crew.ID = 0;
                crewtimesheetVM.CrewAdminId = int.Parse(System.Web.HttpContext.Current.Session["LoggedInUserId"].ToString());
                crewtimesheetVM.AdminStatus = System.Web.HttpContext.Current.Session["AdminStatus"].ToString();
            }
            return View(crewtimesheetVM);
        }

        [HttpPost]
        [TraceFilterAttribute]
        public ActionResult UploadJoiningMedical(HttpPostedFileBase postedFile,FormCollection formCollection)
        {
            //AdmissionFormBL admissionBl = new AdmissionFormBL();

            if(postedFile !=null)
            { 
            //upload images
            string fileName = Path.GetFileNameWithoutExtension(postedFile.FileName);
                fileName = fileName + "_" + formCollection["ID"].ToString();

            //To Get File Extension
                string FileExtension = Path.GetExtension(postedFile.FileName);
             fileName = fileName + FileExtension;

            if (FileExtension != ".pdf" && FileExtension != ".jpeg" && FileExtension != ".gif")
            {
                ViewBag.UploadMessage = "You can only upload files of type pdf/jpef/gif";
                return View();
            }

            //Get Upload path from Web.Config file AppSettings.
            string path = Server.MapPath(ConfigurationManager.AppSettings["JoiningMedicalUploadPath"].ToString());
                if (!Directory.Exists(path))
                {
                    Directory.CreateDirectory(path);
                }
                if (System.IO.File.Exists(path + fileName))
                {
                    System.IO.File.Delete(path + fileName);
                }

                //To copy and save file into server.
                postedFile.SaveAs(path + fileName);
                
                ViewBag.UploadMessage = "File Uploaded Successfully";
        }
            GetAllCrewForTimeSheet();
            //admissionBl.SaveOrUpdate(admissionForm);
            return View();
        }


        // GET: CrewHealth
        [TraceFilterAttribute]
        public ActionResult JoiningMedicalReport()
        {
            GetAllCrewForDrp();
			CrewTimesheetViewModel crewtimesheetVM = new CrewTimesheetViewModel();
			Crew crew = new Crew();
			crew.ID = int.Parse(Session["LoggedInUserId"].ToString());
			crewtimesheetVM.Crew = crew;
            return View(crewtimesheetVM);
        }

        [TraceFilterAttribute]
        public ActionResult CrewServiceTerms()
        {
            GetAllCrewForDrp();
            CrewTimesheetViewModel crewtimesheetVM = new CrewTimesheetViewModel();
            Crew crew = new Crew();
            crew.ID = int.Parse(Session["LoggedInUserId"].ToString());
            crewtimesheetVM.Crew = crew;
            return View(crewtimesheetVM);
        }

        [TraceFilterAttribute]
        public ActionResult MonthlyMedicalAdvisory()
        {
            GetAllCrewForDrp();
            CrewTimesheetViewModel crewtimesheetVM = new CrewTimesheetViewModel();
            Crew crew = new Crew();
            crew.ID = int.Parse(Session["LoggedInUserId"].ToString());
            crewtimesheetVM.Crew = crew;
            return View(crewtimesheetVM);
        }

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

        [TraceFilterAttribute]
        public ActionResult MedicalHistory()
        {
            return View();
        }
      

        [TraceFilterAttribute]
        public ActionResult MedicalTreatment()
        {
            GetAllCrewForDrp();
            GetAllCrewForTimeSheet();
            //Session["TimeModified"] = "";
            //Session["DateModified"] = "";

            CrewTimesheetViewModel crewtimesheetVM = new CrewTimesheetViewModel();
            Crew c = new Crew();
            crewtimesheetVM.Crew = c;

            if (Convert.ToBoolean(Session["User"]) == true)
            {
                crewtimesheetVM.Crew.ID = int.Parse(System.Web.HttpContext.Current.Session["LoggedInUserId"].ToString());
                crewtimesheetVM.AdminStatus = System.Web.HttpContext.Current.Session["AdminStatus"].ToString();
                crewtimesheetVM.CrewAdminId = 0;

            }
            else
            {
                crewtimesheetVM.Crew.ID = 0;
                crewtimesheetVM.CrewAdminId = int.Parse(System.Web.HttpContext.Current.Session["LoggedInUserId"].ToString());
                crewtimesheetVM.AdminStatus = System.Web.HttpContext.Current.Session["AdminStatus"].ToString();
            }

            return View(crewtimesheetVM);
        }

        public JsonResult LoadData(/*int CrewID*/)
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
                length = 50;
            }

            if (start == 0)
            {
                pageIndex = 1;
            }
            else
            {
                pageIndex = (start / length) + 1;
            }

            ConsultantBL consultantBL = new ConsultantBL();
            int totalrecords = 0;

            List<ConsultantPOCO> consultantpocoList = new List<ConsultantPOCO>();
            consultantpocoList = consultantBL.GetMedicalAdvisoryPageWise(pageIndex, ref totalrecords, length, int.Parse(Session["LoggedInUserId"].ToString()));
            List<Consultant> consultantList = new List<Consultant>();
            foreach (ConsultantPOCO consultantPC in consultantpocoList)
            {
                Consultant consultant = new Consultant();
                consultant.MedicalAdvisoryID = consultantPC.MedicalAdvisoryID;
                consultant.CrewName = consultantPC.CrewName;
                consultant.Weight = consultantPC.Weight;
                consultant.BMI = consultantPC.BMI;
               // consultant.BP = consultantPC.BP;
                consultant.BloodSugarLevel = consultantPC.BloodSugarLevel;
                consultant.Systolic = consultantPC.Systolic;
                consultant.Diastolic = consultantPC.Diastolic;
                consultant.UrineTest = consultantPC.UrineTest;

                consultant.UnannouncedAlcohol = consultantPC.UnannouncedAlcohol;
                consultant.AnnualDH = consultantPC.AnnualDH;
                consultant.Month = consultantPC.Month;
                

                consultantList.Add(consultant);
            }

            var data = consultantList;

            return Json(new { draw = draw, recordsFiltered = totalrecords, recordsTotal = totalrecords, data = data }, JsonRequestBehavior.AllowGet);
        }


        public JsonResult LoadData2(/*int CrewID*/)
        {
            int draw, start, length;
            int pageIndex = 0;

            if (null != Request.Form.GetValues("draw"))
            {
                draw = int.Parse(Request.Form.GetValues("draw").FirstOrDefault().ToString());
                start = int.Parse(Request.Form.GetValues("start").FirstOrDefault().ToString());
                //length = int.Parse(Request.Form.GetValues("length").FirstOrDefault().ToString());
                length = 1000;
            }
            else
            {
                draw = 1;
                start = 0;
                length = 50;
            }

            if (start == 0)
            {
                pageIndex = 1;
            }
            else
            {
                pageIndex = (start / length) + 1;
            }

            ConsultantBL consultantBL = new ConsultantBL();
            int totalrecords = 0;

            List<ConsultantPOCO> consultantpocoList = new List<ConsultantPOCO>();
            consultantpocoList = consultantBL.GetMedicalAdvisoryPageWise2(pageIndex, ref totalrecords, length/*int.Parse(Session["LoggedInUserId"].ToString())*/);
            List<Consultant> consultantList = new List<Consultant>();
            foreach (ConsultantPOCO consultantPC in consultantpocoList)
            {
                Consultant consultant = new Consultant();
                consultant.MedicalAdvisoryID = consultantPC.MedicalAdvisoryID;
                consultant.CrewName = consultantPC.CrewName;
                consultant.Weight = consultantPC.Weight;
                consultant.BMI = consultantPC.BMI;
                // consultant.BP = consultantPC.BP;
                consultant.BloodSugarLevel = consultantPC.BloodSugarLevel;
                consultant.Systolic = consultantPC.Systolic;
                consultant.Diastolic = consultantPC.Diastolic;
                consultant.UrineTest = consultantPC.UrineTest;

                consultant.UnannouncedAlcohol = consultantPC.UnannouncedAlcohol;
                consultant.AnnualDH = consultantPC.AnnualDH;
                consultant.Month = consultantPC.Month;


                consultantList.Add(consultant);
            }

            var data = consultantList;

            return Json(new { draw = draw, recordsFiltered = totalrecords, recordsTotal = totalrecords, data = data }, JsonRequestBehavior.AllowGet);
        }


        [HttpGet]
        public JsonResult GetCrewDetailsForHealthByID(int crewID)
        {
            EquipmentsBL consultantBL = new EquipmentsBL();
            EquipmentsPOCO consultantPC = new EquipmentsPOCO();

            consultantPC = consultantBL.GetCrewDetailsForHealthByID(crewID);

            Equipments um = new Equipments();

            //um.ID = consultantPC.ID;
            um.Name = consultantPC.Name;
            um.DOB = consultantPC.DOB;
            um.RankName = consultantPC.RankName;

            um.ActiveFrom = consultantPC.ActiveFrom;

            var cm = um;

            return Json(cm, JsonRequestBehavior.AllowGet);
        }



        public FileStreamResult GetPDF()
        {
            FileStream fs = new FileStream(Server.MapPath("~/MedicalHistory/Medical Fermin.pdf"), FileMode.Open, FileAccess.Read);
            return File(fs, "application/pdf");
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


        public JsonResult SaveCIRM(CIRM cIRM)
        {
            CIRMBL CIRMBL = new CIRMBL();
            CIRMPOCO CIRMPC = new CIRMPOCO();

            CIRMPC.CIRMId = cIRM.CIRMId;
            //CIRMPC.NameOfVessel = cIRM.NameOfVessel;
            CIRMPC.NameOfVessel = Session["ShipName"].ToString();
            CIRMPC.RadioCallSign = cIRM.RadioCallSign;
            CIRMPC.PortofDestination = cIRM.PortofDestination;
            CIRMPC.Route = cIRM.Route;
            CIRMPC.LocationOfShip = cIRM.LocationOfShip;
            CIRMPC.PortofDeparture = cIRM.PortofDeparture;
            CIRMPC.EstimatedTimeOfarrivalhrs = cIRM.EstimatedTimeOfarrivalhrs;
            CIRMPC.Speed = cIRM.Speed;
            CIRMPC.Nationality = cIRM.Nationality;
            CIRMPC.Qualification = cIRM.Qualification;
            CIRMPC.RespiratoryRate = cIRM.RespiratoryRate;
            CIRMPC.Pulse = cIRM.Pulse;
            CIRMPC.Temperature = cIRM.Temperature;
            CIRMPC.Systolic = cIRM.Systolic;
            CIRMPC.Diastolic = cIRM.Diastolic;
            CIRMPC.Symptomatology = cIRM.Symptomatology;
            CIRMPC.LocationAndTypeOfPain = cIRM.LocationAndTypeOfPain;
            CIRMPC.RelevantInformationForDesease = cIRM.RelevantInformationForDesease;
            CIRMPC.WhereAndHowAccidentIsCausedCHK = cIRM.WhereAndHowAccidentIsCausedCHK;
            CIRMPC.UploadMedicalHistory = cIRM.UploadMedicalHistory;
            CIRMPC.UploadMedicinesAvailable = cIRM.UploadMedicinesAvailable;
            CIRMPC.MedicalProductsAdministered = cIRM.MedicalProductsAdministered;
            CIRMPC.WhereAndHowAccidentIsausedARA = cIRM.WhereAndHowAccidentIsausedARA;
            CIRMPC.CrewId = cIRM.CrewId;

            

            return Json(CIRMBL.SaveCIRM(CIRMPC), JsonRequestBehavior.AllowGet);
        }


        [HttpGet]
        public JsonResult GetCrewDetailsForHealthByID2(int crewID)
        {
            EquipmentsBL consultantBL = new EquipmentsBL();
            EquipmentsPOCO consultantPC = new EquipmentsPOCO();

            consultantPC = consultantBL.GetCrewDetailsForHealthByID2(crewID);

            Equipments um = new Equipments();

            //um.ID = consultantPC.ID;
            um.Name = consultantPC.Name;
            um.DOB = consultantPC.DOB;
            um.RankName = consultantPC.RankName;

            um.ActiveFrom = consultantPC.ActiveFrom;
            um.LatestUpdate = consultantPC.LatestUpdate;

            um.FirstName = consultantPC.FirstName;
            um.MiddleName = consultantPC.MiddleName;
            um.LastName = consultantPC.LastName;
            um.PassportSeamanPassportBook = consultantPC.PassportSeamanPassportBook;
            um.Seaman = consultantPC.Seaman;
            um.POB = consultantPC.POB;

            var cm = um;

            return Json(cm, JsonRequestBehavior.AllowGet);
        }


        public JsonResult SaveServiceTerms(EquipmentsPOCO equipmentsPOCO)
        {
            EquipmentsBL consultantBL = new EquipmentsBL();
            EquipmentsPOCO consultantPC = new EquipmentsPOCO();
            
            //consultantPC.VesselID = equipmentsPOCO.VesselID;
            consultantPC.CrewID = equipmentsPOCO.CrewID;
            consultantPC.ActiveTo = equipmentsPOCO.ActiveTo;

            return Json(consultantBL.SaveServiceTerms(consultantPC, int.Parse(Session["VesselID"].ToString())), JsonRequestBehavior.AllowGet);
        }

        public JsonResult LoadDataServiceTerms(/*int CrewID*/)
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
                length = 50;
            }

            if (start == 0)
            {
                pageIndex = 1;
            }
            else
            {
                pageIndex = (start / length) + 1;
            }

            EquipmentsBL consultantBL = new EquipmentsBL();
            int totalrecords = 0;

            List<EquipmentsPOCO> consultantpocoList = new List<EquipmentsPOCO>();
            consultantpocoList = consultantBL.GetServiceTermsListPageWise(pageIndex, ref totalrecords, length/*, int.Parse(Session["LoggedInUserId"].ToString())*/);
            List<Equipments> consultantList = new List<Equipments>();
            foreach (EquipmentsPOCO consultantPC in consultantpocoList)
            {
                Equipments consultant = new Equipments();
                consultant.Name = consultantPC.Name;
                consultant.ActiveFrom = consultantPC.ActiveFrom;
                consultant.ActiveTo = consultantPC.ActiveTo;

                consultantList.Add(consultant);
            }

            var data = consultantList;

            return Json(new { draw = draw, recordsFiltered = totalrecords, recordsTotal = totalrecords, data = data }, JsonRequestBehavior.AllowGet);
        }
    }
}

