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
    
    public class CrewHealthController : BaseController
    {
        public ActionResult VesselDetails()
        {
            GetVesselTypeForDrp();

            GetAllRanksForDrp();
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


        //for Ranks drp
        public void GetAllRanksForDrp()
        {
            CrewBL crewDAL = new CrewBL();
            List<CrewPOCO> crewpocoList = new List<CrewPOCO>();

            crewpocoList = crewDAL.GetAllRanksForDrp(int.Parse(Session["VesselID"].ToString()));


            List<Crew> itmasterList = new List<Crew>();

            foreach (CrewPOCO up in crewpocoList)
            {
                Crew unt = new Crew();
                unt.RankID = up.RankID;
                unt.RankName = up.RankName;

                itmasterList.Add(unt);
            }

            ViewBag.Ranks = itmasterList.Select(x =>
                                            new SelectListItem()
                                            {
                                                Text = x.RankName,
                                                Value = x.RankID.ToString()
                                            });

        }

        public JsonResult SaveVesselDetails(VesselDetails vesselDetails)
        {
            VesselDetailsBL vesselDetailsBL = new VesselDetailsBL();
            VesselDetailsPOCO vesselDetailsPC = new VesselDetailsPOCO();

            vesselDetailsPC.ID = vesselDetails.ID;
            vesselDetailsPC.VesselName = vesselDetails.VesselName;
            vesselDetailsPC.CallSign = vesselDetails.CallSign;

            vesselDetailsPC.DateOfReportingGMT = vesselDetails.DateOfReportingGMT;

            vesselDetailsPC.TimeOfReportingGMT = vesselDetails.TimeOfReportingGMT;
            vesselDetailsPC.PresentLocation = vesselDetails.PresentLocation;
            vesselDetailsPC.Course = vesselDetails.Course;
            vesselDetailsPC.Speed = vesselDetails.Speed;
            vesselDetailsPC.PortOfDeparture = vesselDetails.PortOfDeparture;
            vesselDetailsPC.PortOfArrival = vesselDetails.PortOfArrival;

            vesselDetailsPC.ETADateGMT = vesselDetails.ETADateGMT;

            vesselDetailsPC.ETATimeGMT = vesselDetails.ETATimeGMT;
            vesselDetailsPC.AgentDetails = vesselDetails.AgentDetails;

            vesselDetailsPC.NearestPortETADateGMT = vesselDetails.NearestPortETADateGMT;

            vesselDetailsPC.NearestPortETATimeGMT = vesselDetails.NearestPortETATimeGMT;
            vesselDetailsPC.WindSpeed = vesselDetails.WindSpeed;
            vesselDetailsPC.Sea = vesselDetails.Sea;
            vesselDetailsPC.Visibility = vesselDetails.Visibility;
            vesselDetailsPC.Swell = vesselDetails.Swell;

            return Json(vesselDetailsBL.SaveVesselDetails(vesselDetailsPC  /*, int.Parse(Session["VesselID"].ToString())*/  ), JsonRequestBehavior.AllowGet);
        }


        public ActionResult PatientDetails()
        {
            GetAllRanksForDrp();
            GetAllCountryForDrp();
            GetAllCrewForDrp();
            GetAllCrewForTimeSheet();

            CrewTimesheetViewModel crewtimesheetVM = new CrewTimesheetViewModel();
            //Crew c = new Crew();
            //crewtimesheetVM.Crew = c;

            //if (Convert.ToBoolean(Session["User"]) == true)
            //{
            //    crewtimesheetVM.Crew.ID = int.Parse(System.Web.HttpContext.Current.Session["LoggedInUserId"].ToString());
            //    crewtimesheetVM.AdminStatus = System.Web.HttpContext.Current.Session["AdminStatus"].ToString();
            //    crewtimesheetVM.CrewAdminId = 0;

            //}
            //else
            //{
            //    crewtimesheetVM.Crew.ID = 0;
            //    crewtimesheetVM.CrewAdminId = int.Parse(System.Web.HttpContext.Current.Session["LoggedInUserId"].ToString());
            //    crewtimesheetVM.AdminStatus = System.Web.HttpContext.Current.Session["AdminStatus"].ToString();
            //}

            return View(crewtimesheetVM);
        }

        //for CountryMaster drp
        public void GetAllCountryForDrp()
        {
            CrewBL crewDAL = new CrewBL();
            List<CrewPOCO> crewpocoList = new List<CrewPOCO>();

            crewpocoList = crewDAL.GetAllCountryForDrp(/*int.Parse(Session["VesselID"].ToString())*/);


            List<Crew> itmasterList = new List<Crew>();

            foreach (CrewPOCO up in crewpocoList)
            {
                Crew unt = new Crew();
                unt.CountryID = up.CountryID;
                unt.CountryName = up.CountryName;

                itmasterList.Add(unt);
            }

            ViewBag.CountryMaster = itmasterList.Select(x =>
                                            new SelectListItem()
                                            {
                                                Text = x.CountryName,
                                                Value = x.CountryID.ToString()
                                            });

        }

        public ActionResult DailyTemperatureReading()
        {
            GetAllCrewForDrp();
            GetAllTemperatureModeForDrp();
            return View();
        }

        public ActionResult ReportDailyTemperature()
        {
            GetAllCrewForDrp();
            return View();
        }

        public ActionResult MailCIRM()
        {
            GetAllCrewForDrp();
            return View();
        }

        //[HttpPost]
        //public ActionResult MailCIRM(FormCollection formCollection)
        //{

        //    CIRMBL cIRMBL = new CIRMBL();
        //    CIRMPOCO cIRMPOCO = new CIRMPOCO();

        //    cIRMPOCO = cIRMBL.GetCIRMByCrewId(Convert.ToInt32(formCollection[0].ToString()));

        //    //Session["Role"] = CrewId[0].ToString();          
            
        //    //CIRM cIRM = new CIRM();

        //    //cIRM.IsEquipmentUploaded = cIRMPOCO.IsEquipmentUploaded;
        //    //cIRM.IsJoiningReportUloaded = cIRMPOCO.IsJoiningReportUloaded;
        //    //cIRM.IsMedicalHistoryUploaded = cIRMPOCO.IsMedicalHistoryUploaded;
        //    //cIRM.IsmedicineUploaded = cIRMPOCO.IsmedicineUploaded;




        //    //var fromAddress = new MailAddress("cableman24x7@gmail.com", "From Name");
        //    //var toAddress = new MailAddress("prasenjitpaul100@gmail.com", "To Name");
        //    //const string fromPassword = "cableman24x712345";
        //    //const string subject = "Subject";
        //    //const string body = "Body";

        //    //var smtp = new SmtpClient
        //    //{
        //    //    Host = "smtp.gmail.com",
        //    //    Port = 587,
        //    //    EnableSsl = true,
        //    //    DeliveryMethod = SmtpDeliveryMethod.Network,
        //    //    UseDefaultCredentials = false,
        //    //    Credentials = new NetworkCredential(fromAddress.Address, fromPassword)
        //    //};
        //    //using (var message = new MailMessage(fromAddress, toAddress)
        //    //{
        //    //    Subject = subject,
        //    //    Body = body
        //    //})
        //    //{
        //    //    smtp.Send(message);
        //    //}
        //    return View();
        //}




        public JsonResult LoadData22()
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
                length = 1000;
            }

            if (start == 0)
            {
                pageIndex = 1;
            }
            else
            {
                pageIndex = (start / length) + 1;
            }

            EquipmentsBL equipmentsBL = new EquipmentsBL();
            int totalrecords = 0;

            List<EquipmentsPOCO> equipmentspocoList = new List<EquipmentsPOCO>();
            equipmentspocoList = equipmentsBL.GetMedicinePageWise(pageIndex, ref totalrecords, length/*, int.Parse(Session["VesselID"].ToString())*/);
            List<Equipments> equipmentsList = new List<Equipments>();
            foreach (EquipmentsPOCO equipmentsPC in equipmentspocoList)
            {
                Equipments equipments = new Equipments();
                equipments.MedicineID = equipmentsPC.MedicineID;
                equipments.MedicineName = equipmentsPC.MedicineName;
                equipments.Quantity = equipmentsPC.Quantity;
                equipments.ExpiryDate = equipmentsPC.ExpiryDate;
                equipments.Location = equipmentsPC.Location;

                equipmentsList.Add(equipments);
            }

            var data = equipmentsList;

            return Json(new { draw = draw, recordsFiltered = totalrecords, recordsTotal = totalrecords, data = data }, JsonRequestBehavior.AllowGet);
        }


        public JsonResult LoadData33()
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
                length = 1000;
            }

            if (start == 0)
            {
                pageIndex = 1;
            }
            else
            {
                pageIndex = (start / length) + 1;
            }

            EquipmentsBL equipmentsBL = new EquipmentsBL();
            int totalrecords = 0;

            List<EquipmentsPOCO> equipmentspocoList = new List<EquipmentsPOCO>();
            equipmentspocoList = equipmentsBL.GetEquipmentsPageWise(pageIndex, ref totalrecords, length/*, int.Parse(Session["VesselID"].ToString())*/);
            List<Equipments> equipmentsList = new List<Equipments>();
            foreach (EquipmentsPOCO equipmentsPC in equipmentspocoList)
            {
                Equipments equipments = new Equipments();
                equipments.EquipmentsID = equipmentsPC.EquipmentsID;
                equipments.EquipmentsName = equipmentsPC.EquipmentsName;
                equipments.Comment = equipmentsPC.Comment;
                equipments.Quantity = equipmentsPC.Quantity;
                equipments.ExpiryDate = equipmentsPC.ExpiryDate;
                equipments.Location = equipmentsPC.Location;

                equipmentsList.Add(equipments);
            }

            var data = equipmentsList;

            return Json(new { draw = draw, recordsFiltered = totalrecords, recordsTotal = totalrecords, data = data }, JsonRequestBehavior.AllowGet);
        }


        public JsonResult LoadData44(/*int CrewID*/)
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
                length = 1000;
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
            consultantpocoList = consultantBL.stpGetMedicalAdvisoryListPageWise2(pageIndex, ref totalrecords, length/*int.Parse(Session["LoggedInUserId"].ToString())*/);
            List<Consultant> consultantList = new List<Consultant>();
            foreach (ConsultantPOCO consultantPC in consultantpocoList)
            {
                Consultant consultant = new Consultant();
                consultant.MedicalAdvisoryID = consultantPC.MedicalAdvisoryID;
                //consultant.CrewName = consultantPC.CrewName;
                consultant.Weight = consultantPC.Weight;
                consultant.BMI = consultantPC.BMI;
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

        [HttpPost]
        public ActionResult JoiningMedicalReport(FormCollection formCollection)
        {

            FileStream fs = new FileStream(Server.MapPath("~/MedicalHistory/Medical Fermin.pdf"), FileMode.Open, FileAccess.Read);
            return File(fs, "application/pdf");


            //GetAllCrewForDrp();
            //CrewTimesheetViewModel crewtimesheetVM = new CrewTimesheetViewModel();
            //Crew crew = new Crew();
            //crew.ID = int.Parse(Session["LoggedInUserId"].ToString());
            //crewtimesheetVM.Crew = crew;
            //return View(crewtimesheetVM);
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
        public ActionResult MonthlyMedicalAdvisory(FormCollection collection)
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

        [HttpPost]
        public ActionResult MedicalTreatment(HttpPostedFileBase postedFile)
        {

            if (postedFile != null)
            {
                string path = Server.MapPath("~/UploadsTest/");
                if (!Directory.Exists(path))
                {
                    Directory.CreateDirectory(path);
                }

                postedFile.SaveAs(path + Path.GetFileName(postedFile.FileName));
                ViewBag.Message = "File uploaded successfully.";
            }

            return View();
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

            um.JoiningMedicalReportPath = GetJoininingMedicalByCrewId(crewID);
            

            var cm = um;

            return Json(cm, JsonRequestBehavior.AllowGet);
        }

        public FileStreamResult GetPDF(string file) //
        {
            FileStream fs = new FileStream(Server.MapPath("~/MedicalHistory/Medical Fermin.pdf"), FileMode.Open, FileAccess.Read); //    ~/MedicalHistory/Medical Fermin.pdf
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

        public JsonResult SaveCIRM(CIRMPOCO cIRM)
        {
            CIRMBL CIRMBL = new CIRMBL();
            //CIRMPOCO CIRMPC = new CIRMPOCO();

            //CIRMPC.CIRMId = cIRM.CIRMId;

            //CIRMPC.CrewId = cIRM.CrewId;
            /////////CIRMPC.NameOfVessel = Session["ShipName"].ToString();
            //CIRMPC.RadioCallSign = cIRM.RadioCallSign;
            //CIRMPC.RadioCallSign = cIRM.RadioCallSign;
            //CIRMPC.RadioCallSign = cIRM.RadioCallSign;
            //CIRMPC.RadioCallSign = cIRM.RadioCallSign;

            return Json(CIRMBL.SaveCIRM(cIRM, int.Parse(Session["VesselID"].ToString())), JsonRequestBehavior.AllowGet);
        }

        public JsonResult SaveCrewTemperature(CrewTemperaturePOCO crewTemperature)
        {
            CrewBL crewBl = new CrewBL();
            //CrewTemperaturePOCO crewTemperaturePC = new CrewTemperaturePOCO();

            //crewTemperaturePC.CrewID = crewTemperature.CrewID;
            //crewTemperaturePC.ReadingDate = crewTemperature.ReadingDate;
            //crewTemperaturePC.ReadingTime = crewTemperature.ReadingTime;

            //crewTemperaturePC.Unit = crewTemperature.Unit;
            //crewTemperaturePC.Temperature = crewTemperature.Temperature;
            //crewTemperaturePC.TemperatureModeID = crewTemperature.TemperatureModeID;

            //crewTemperaturePC.Comment = crewTemperature.Comment;
            return Json(crewBl.SaveCrewTemperature(crewTemperature, int.Parse(Session["VesselID"].ToString())), JsonRequestBehavior.AllowGet);
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

        private string GetJoininingMedicalByCrewId(int CrewId)
        {
            CrewBL crewBL = new CrewBL();
            string path = ConfigurationManager.AppSettings["JoiningPdfRelativePath"].ToString();

            //crewPC = crewBL.GetJoiningMedicalFileDatawByID(int.Parse(CrewId));
            string fileName = crewBL.GetJoiningMedicalFileDatawByID(CrewId);

            path = path + fileName;

                       

            return path;
            
        }

        public JsonResult GetPdfFileLocation(int CrewId)
        {

            string filePath = GetJoininingMedicalByCrewId(CrewId);
            filePath = filePath.Replace('~', ' ');
            //FileStream fs = new FileStream(Server.MapPath(filePath), FileMode.Open, FileAccess.Read);
            var cm = filePath;

            return Json(cm, JsonRequestBehavior.AllowGet);
        }
        
        public void GetAllTemperatureModeForDrp()
        {
            CrewBL crewDAL = new CrewBL();
            List<CrewPOCO> crewpocoList = new List<CrewPOCO>();

            crewpocoList = crewDAL.GetAllTemperatureModeForDrp();


            List<Crew> itmasterList = new List<Crew>();

            foreach (CrewPOCO up in crewpocoList)
            {
                Crew unt = new Crew();
                unt.TemperatureModeID= up.TemperatureModeID;
                unt.TemperatureMode= up.TemperatureMode;

                itmasterList.Add(unt);
            }

            ViewBag.TemperatureModeList = itmasterList.Select(x =>
                                            new SelectListItem()
                                            {
                                                Text = x.TemperatureMode,
                                                Value = x.TemperatureModeID.ToString()
                                            });

        }

        public JsonResult GetCrewTemperaturePageWiseByCrewID(int CrewID)
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
                length = 15;
            }

            if (start == 0)
            {
                pageIndex = 1;
            }
            else
            {
                pageIndex = (start / length) + 1;
            }

            CrewBL CrewBL = new CrewBL();
            int totalrecords = 0;

            List<CrewTemperaturePOCO> CrewTemperaturePOCOList = new List<CrewTemperaturePOCO>();
            CrewTemperaturePOCOList = CrewBL.GetCrewTemperaturePageWiseByCrewID(pageIndex, ref totalrecords, length, CrewID); 
            List<CrewTemperature> crewList = new List<CrewTemperature>();
            foreach (CrewTemperaturePOCO crewPC in CrewTemperaturePOCOList)
            {
                CrewTemperature crewTemp = new CrewTemperature();
               
                crewTemp.ID = crewPC.ID;

                crewTemp.Temperature = crewPC.Temperature;
                crewTemp.ReadingDate = crewPC.ReadingDate;
                crewTemp.ReadingTime = crewPC.ReadingTime;
                crewTemp.Unit = crewPC.Unit;
                crewTemp.TemperatureMode = crewPC.TemperatureMode;

                crewList.Add(crewTemp);
            }

            var data = crewList;

            return Json(new { draw = draw, recordsFiltered = totalrecords, recordsTotal = totalrecords, data = data }, JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetCrewTemperaturePageWiseByCrewID2(int CrewID)
        {
            int draw, start, length;
            int pageIndex = 0;

            if (null != Request.Form.GetValues("draw"))
            {
                draw = int.Parse(Request.Form.GetValues("draw").FirstOrDefault().ToString());
                start = int.Parse(Request.Form.GetValues("start").FirstOrDefault().ToString());
                length = 1000;//int.Parse(Request.Form.GetValues("length").FirstOrDefault().ToString());
            }
            else
            {
                draw = 1;
                start = 0;
                length = 1000;
            }

            if (start == 0)
            {
                pageIndex = 1;
            }
            else
            {
                pageIndex = (start / length) + 1;
            }

            CrewBL CrewBL = new CrewBL();
            int totalrecords = 0;

            List<CrewTemperaturePOCO> CrewTemperaturePOCOList = new List<CrewTemperaturePOCO>();
            CrewTemperaturePOCOList = CrewBL.GetCrewTemperaturePageWiseByCrewID2(pageIndex, ref totalrecords, length, CrewID);
            List<CrewTemperature> crewList = new List<CrewTemperature>();
            foreach (CrewTemperaturePOCO crewPC in CrewTemperaturePOCOList)
            {
                CrewTemperature crewTemp = new CrewTemperature();

                crewTemp.ID = crewPC.ID;

                crewTemp.Temperature = crewPC.Temperature;
                crewTemp.ReadingDate = crewPC.ReadingDate;
                crewTemp.ReadingTime = crewPC.ReadingTime;
                crewTemp.Unit = crewPC.Unit;
                crewTemp.TemperatureMode = crewPC.TemperatureMode;

                crewList.Add(crewTemp);
            }

            var data = crewList;

            return Json(new { draw = draw, recordsFiltered = totalrecords, recordsTotal = totalrecords, data = data }, JsonRequestBehavior.AllowGet);
        }



        //////////////////////////////////////////////////////////////////////////////////////////////////////
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
        public ActionResult UploadJoiningMedical(HttpPostedFileBase postedFile, FormCollection formCollection)
        {
            //AdmissionFormBL admissionBl = new AdmissionFormBL();
            if (postedFile != null)
            {
                //upload images
                string fileName = String.Empty; //Path.GetFileNameWithoutExtension(postedFile.FileName);
                fileName = "JoiningMedical" + "_" + formCollection["ID"].ToString();

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
                ////BL call..............
                CrewBL crewBL = new CrewBL();

                crewBL.SaveJoiningMedicalFilePath(int.Parse(formCollection["ID"].ToString()), fileName);

                ViewBag.UploadMessage = "File Uploaded Successfully";
            }
            GetAllCrewForTimeSheet();
            //admissionBl.SaveOrUpdate(admissionForm);   ID,fileName,
            return View();
        }



        public ActionResult MedicineAvailableOnBoard()
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
        public ActionResult MedicineAvailableOnBoard(HttpPostedFileBase postedFile, FormCollection formCollection)
        {
            //AdmissionFormBL admissionBl = new AdmissionFormBL();
            if (postedFile != null)
            {
                //upload images
                string fileName = String.Empty; //Path.GetFileNameWithoutExtension(postedFile.FileName);
                fileName = "MedicineAvailableOnBoard" + "_" + formCollection["ID"].ToString();

                //To Get File Extension
                string FileExtension = Path.GetExtension(postedFile.FileName);
                fileName = fileName + FileExtension;

                if (FileExtension != ".pdf" && FileExtension != ".jpeg" && FileExtension != ".gif")
                {
                    ViewBag.UploadMessage = "You can only upload files of type pdf/jpef/gif";
                    return View();
                }

                //Get Upload path from Web.Config file AppSettings.
                string path = Server.MapPath(ConfigurationManager.AppSettings["MedicineAvailableOnBoardUploadPath"].ToString());
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
                ////BL call..............
                CrewBL crewBL = new CrewBL();

                // crewBL.SaveMedicineAvailableOnBoardFilePath(int.Parse(formCollection["ID"].ToString()), fileName);  ///// do it

                ViewBag.UploadMessage = "File Uploaded Successfully";
            }
            GetAllCrewForTimeSheet();
            //admissionBl.SaveOrUpdate(admissionForm);   ID,fileName,
            return View();
        }



        public ActionResult MedicalEquipmentOnBoard()
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
        public ActionResult MedicalEquipmentOnBoard(HttpPostedFileBase postedFile, FormCollection formCollection)
        {
            //AdmissionFormBL admissionBl = new AdmissionFormBL();
            if (postedFile != null)
            {
                //upload images
                string fileName = String.Empty; //Path.GetFileNameWithoutExtension(postedFile.FileName);
                fileName = "MedicalEquipmentOnBoard" + "_" + formCollection["ID"].ToString();

                //To Get File Extension
                string FileExtension = Path.GetExtension(postedFile.FileName);
                fileName = fileName + FileExtension;

                if (FileExtension != ".pdf" && FileExtension != ".jpeg" && FileExtension != ".gif")
                {
                    ViewBag.UploadMessage = "You can only upload files of type pdf/jpef/gif";
                    return View();
                }

                //Get Upload path from Web.Config file AppSettings.
                string path = Server.MapPath(ConfigurationManager.AppSettings["MedicalEquipmentOnBoardUploadPath"].ToString());
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
                ////BL call..............
                CrewBL crewBL = new CrewBL();

                // crewBL.SaveMedicalEquipmentOnBoardFilePath(int.Parse(formCollection["ID"].ToString()), fileName);  ///// do it

                ViewBag.UploadMessage = "File Uploaded Successfully";
            }
            GetAllCrewForTimeSheet();
            //admissionBl.SaveOrUpdate(admissionForm);   ID,fileName,
            return View();
        }



        public ActionResult MedicalHistoryUpload()
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
        public ActionResult MedicalHistoryUpload(HttpPostedFileBase postedFile, FormCollection formCollection)
        {
            //AdmissionFormBL admissionBl = new AdmissionFormBL();
            if (postedFile != null)
            {
                //upload images
                string fileName = String.Empty; //Path.GetFileNameWithoutExtension(postedFile.FileName);
                fileName = "MedicalHistoryUpload" + "_" + formCollection["ID"].ToString();

                //To Get File Extension
                string FileExtension = Path.GetExtension(postedFile.FileName);
                fileName = fileName + FileExtension;

                if (FileExtension != ".pdf" && FileExtension != ".jpeg" && FileExtension != ".gif")
                {
                    ViewBag.UploadMessage = "You can only upload files of type pdf/jpef/gif";
                    return View();
                }

                //Get Upload path from Web.Config file AppSettings.
                string path = Server.MapPath(ConfigurationManager.AppSettings["MedicalHistoryUploadUploadPath"].ToString());
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
                ////BL call..............
                CrewBL crewBL = new CrewBL();

                //crewBL.SaveMedicalHistoryUploadFilePath(int.Parse(formCollection["ID"].ToString()), fileName);  ///// do it

                ViewBag.UploadMessage = "File Uploaded Successfully";
            }
            GetAllCrewForTimeSheet();
            //admissionBl.SaveOrUpdate(admissionForm);   ID,fileName,
            return View();
        }



        public ActionResult WorkAndRestHourLatestRecord()
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
        public ActionResult WorkAndRestHourLatestRecord(HttpPostedFileBase postedFile, FormCollection formCollection)
        {
            //AdmissionFormBL admissionBl = new AdmissionFormBL();
            if (postedFile != null)
            {
                //upload images
                string fileName = String.Empty; //Path.GetFileNameWithoutExtension(postedFile.FileName);
                fileName = "WorkAndRestHourLatestRecord" + "_" + formCollection["ID"].ToString();

                //To Get File Extension
                string FileExtension = Path.GetExtension(postedFile.FileName);
                fileName = fileName + FileExtension;

                if (FileExtension != ".pdf" && FileExtension != ".jpeg" && FileExtension != ".gif")
                {
                    ViewBag.UploadMessage = "You can only upload files of type pdf/jpef/gif";
                    return View();
                }

                //Get Upload path from Web.Config file AppSettings.
                string path = Server.MapPath(ConfigurationManager.AppSettings["WorkAndRestHourLatestRecordUploadPath"].ToString());
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
                ////BL call..............
                CrewBL crewBL = new CrewBL();

                //crewBL.SaveWorkAndRestHourLatestRecordFilePath(int.Parse(formCollection["ID"].ToString()), fileName);  ///// do it

                ViewBag.UploadMessage = "File Uploaded Successfully";
            }
            GetAllCrewForTimeSheet();
            //admissionBl.SaveOrUpdate(admissionForm);   ID,fileName,
            return View();
        }



        public ActionResult PreExistingMedicationPrescription()
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
        public ActionResult PreExistingMedicationPrescription(HttpPostedFileBase postedFile, FormCollection formCollection)
        {
            //AdmissionFormBL admissionBl = new AdmissionFormBL();
            if (postedFile != null)
            {
                //upload images
                string fileName = String.Empty; //Path.GetFileNameWithoutExtension(postedFile.FileName);
                fileName = "PreExistingMedicationPrescription" + "_" + formCollection["ID"].ToString();

                //To Get File Extension
                string FileExtension = Path.GetExtension(postedFile.FileName);
                fileName = fileName + FileExtension;

                if (FileExtension != ".pdf" && FileExtension != ".jpeg" && FileExtension != ".gif")
                {
                    ViewBag.UploadMessage = "You can only upload files of type pdf/jpef/gif";
                    return View();
                }

                //Get Upload path from Web.Config file AppSettings.
                string path = Server.MapPath(ConfigurationManager.AppSettings["PreExistingMedicationPrescriptionUploadPath"].ToString());
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
                ////BL call..............
                CrewBL crewBL = new CrewBL();

                //crewBL.SavePreExistingMedicationPrescriptionFilePath(int.Parse(formCollection["ID"].ToString()), fileName);  ///// do it

                ViewBag.UploadMessage = "File Uploaded Successfully";
            }
            GetAllCrewForTimeSheet();
            //admissionBl.SaveOrUpdate(admissionForm);   ID,fileName,
            return View();
        }







        [HttpGet]
        public JsonResult GetCrewForCIRMPatientDetails()
        {
            CIRMBL shipBL = new CIRMBL();
            ShipPOCO shipPC = new ShipPOCO();

            shipPC = shipBL.GetCrewForCIRMPatientDetails();

            Vessel um = new Vessel();

            um.ID = shipPC.ID;

            um.CrewName = shipPC.CrewName;
            um.RankID = shipPC.RankID;
            um.Gender = shipPC.Gender;
            um.CountryID = shipPC.CountryID;
            um.DOB = shipPC.DOB;

            var cm = um;

            return Json(cm, JsonRequestBehavior.AllowGet);
        }










        public JsonResult GetVesselTypeForDrp()
        {
            ShipBL shipBL = new ShipBL();
            List<ShipPOCO> blockpocoList = new List<ShipPOCO>();

            blockpocoList = shipBL.GetVesselTypeForDrp();

            List<Vessel> blockList = new List<Vessel>();

            foreach (ShipPOCO up in blockpocoList)
            {
                Vessel comp = new Vessel();
                comp.Description = up.Description;
                comp.VesselTypeID = up.VesselTypeID;

                blockList.Add(comp);
            }
            var data = blockList;

            return Json(data, JsonRequestBehavior.AllowGet);
        }

        //for VesselSubTypeByVesselTypeIDForDrp drp
        public JsonResult GetVesselSubTypeByVesselTypeIDForDrp(string VesselTypeID)
        {
            ShipBL shipBL = new ShipBL();
            List<ShipPOCO> blockpocoList = new List<ShipPOCO>();

            blockpocoList = shipBL.GetVesselSubTypeByVesselTypeIDForDrp(VesselTypeID);

            List<Vessel> blockList = new List<Vessel>();

            foreach (ShipPOCO up in blockpocoList)
            {
                Vessel comp = new Vessel();
                comp.SubTypeDescription = up.SubTypeDescription;
                comp.VesselSubTypeID = up.VesselSubTypeID;

                blockList.Add(comp);
            }
            var data = blockList;

            return Json(data, JsonRequestBehavior.AllowGet);
        }


        //for VesselSubSubTypeByVesselSubTypeIDForDrp drp
        public JsonResult GetVesselSubSubTypeByVesselSubTypeIDForDrp(string VesselSubTypeID)
        {
            ShipBL shipBL = new ShipBL();
            List<ShipPOCO> blockpocoList = new List<ShipPOCO>();

            blockpocoList = shipBL.GetVesselSubSubTypeByVesselSubTypeIDForDrp(VesselSubTypeID);

            List<Vessel> blockList = new List<Vessel>();

            foreach (ShipPOCO up in blockpocoList)
            {
                Vessel comp = new Vessel();
                comp.VesselSubSubTypeDecsription = up.VesselSubSubTypeDecsription;
                comp.VesselSubSubTypeID = up.VesselSubSubTypeID;

                blockList.Add(comp);
            }
            var data = blockList;

            return Json(data, JsonRequestBehavior.AllowGet);
        }





        public JsonResult GetVesselTypeIDFromShip()
        {
            ShipBL shipBL = new ShipBL();
            List<ShipPOCO> blockpocoList = new List<ShipPOCO>();

            blockpocoList = shipBL.GetVesselTypeIDFromShip();
            List<Vessel> blockList = new List<Vessel>();

            foreach (ShipPOCO up in blockpocoList)
            {
                Vessel comp = new Vessel();
                comp.VesselTypeID = up.VesselTypeID;

                blockList.Add(comp);
            }
            var data = blockList;

            return Json(data, JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetVesselSubTypeIDFromShip()
        {
            ShipBL shipBL = new ShipBL();
            List<ShipPOCO> blockpocoList = new List<ShipPOCO>();

            blockpocoList = shipBL.GetVesselSubTypeIDFromShip();
            List<Vessel> blockList = new List<Vessel>();

            foreach (ShipPOCO up in blockpocoList)
            {
                Vessel comp = new Vessel();
                comp.VesselSubTypeID = up.VesselSubTypeID;

                blockList.Add(comp);
            }
            var data = blockList;

            return Json(data, JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetVesselSubSubTypeIDFromShip()
        {
            ShipBL shipBL = new ShipBL();
            List<ShipPOCO> blockpocoList = new List<ShipPOCO>();

            blockpocoList = shipBL.GetVesselSubSubTypeIDFromShip();
            List<Vessel> blockList = new List<Vessel>();

            foreach (ShipPOCO up in blockpocoList)
            {
                Vessel comp = new Vessel();
                comp.VesselSubSubTypeID = up.VesselSubSubTypeID;

                blockList.Add(comp);
            }
            var data = blockList;

            return Json(data, JsonRequestBehavior.AllowGet);
        }
    }
}
