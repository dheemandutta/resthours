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

        [HttpGet]
        public JsonResult GetShipByID()
        {
            ShipBL shipBL = new ShipBL();
            ShipPOCO shipPC = new ShipPOCO();

            shipPC = shipBL.GetShipByID();

            Vessel um = new Vessel();

            um.ID = shipPC.ID;

            um.ShipName = shipPC.ShipName;

            var cm = um;

            return Json(cm, JsonRequestBehavior.AllowGet);
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




        public JsonResult LoadData22(string Country, string Category, string NoOfCrew)
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
            equipmentspocoList = equipmentsBL.GetMedicinePageWise(pageIndex, ref totalrecords, length, Country, Category, NoOfCrew/*, int.Parse(Session["VesselID"].ToString())*/);
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


        public JsonResult LoadData33(string Country, string Category, string NoOfCrew)
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
            equipmentspocoList = equipmentsBL.GetEquipmentsPageWise(pageIndex, ref totalrecords, length, Country, Category, NoOfCrew/*, int.Parse(Session["VesselID"].ToString())*/);
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
            GetAllCountryForDrp();
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

        //public JsonResult LoadData(Reports reports)
        //{
        //    ConsultantBL consultantBL = new ConsultantBL();
        //    ConsultantPOCO consultantPC = new ConsultantPOCO();

        //    int draw, start, length;
        //    int pageIndex = 0;

        //    if (null != Request.Form.GetValues("draw"))
        //    {
        //        draw = int.Parse(Request.Form.GetValues("draw").FirstOrDefault().ToString());
        //        start = int.Parse(Request.Form.GetValues("start").FirstOrDefault().ToString());
        //        length = int.Parse(Request.Form.GetValues("length").FirstOrDefault().ToString());
        //    }
        //    else
        //    {
        //        draw = 1;
        //        start = 0;
        //        length = 50;
        //    }

        //    if (start == 0)
        //    {
        //        pageIndex = 1;
        //    }
        //    else
        //    {
        //        pageIndex = (start / length) + 1;
        //    }
        //    int totalrecords = 0;
        //    string month = reports.SelectedMonthYear.Substring(0, reports.SelectedMonthYear.Length - 4);

        //    consultantPC.Months = (int)((Months)Enum.Parse(typeof(Months), month.Trim()));
        //    consultantPC.MonthName = month;
        //    consultantPC.Year = int.Parse(Utilities.GetLast(reports.SelectedMonthYear, 4));
        //    //consultantPC.CrewID = reports.CrewID;

        //    List<ConsultantPOCO> consultantpocoList = new List<ConsultantPOCO>();
        //    consultantpocoList = consultantBL.GetMedicalAdvisoryPageWise(pageIndex, ref totalrecords, length, int.Parse(Session["LoggedInUserId"].ToString()));

        //    string[] bookedHours = new string[36];
        //    int row = 0;
        //    foreach (ConsultantPOCO item in consultantpocoList)
        //    {
        //        bookedHours[row] = item.Hours;
        //        row++;
        //    }
        //    var data = consultantpocoList;

        //    return Json(new { draw = draw, recordsFiltered = totalrecords, recordsTotal = totalrecords, data = data }, JsonRequestBehavior.AllowGet);
        //}

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

            //crewpocoList = crewDAL.GetAllCrewForDrp(int.Parse(Session["VesselID"].ToString()), int.Parse(System.Web.HttpContext.Current.Session["UserID"].ToString()));
            //Added as a bugfix: Dheeman
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

        
       
        /// <summary>
        /// Added on 8th Jan 2022 @BK
        /// Not Completed
        /// </summary>
        /// <param name="cirm"></param>
        /// <returns></returns>
        [HttpPost]
        public JsonResult SaveCIRMDetails(CIRM cirm)
        {
            CIRMBL CIRMBL = new CIRMBL();
            CIRMPOCO CIRMPC = new CIRMPOCO();

            CIRMPC.CIRMId = cirm.CIRMId;
            CIRMPC.CrewId = cirm.CrewId;
            CIRMPC.NameOfVessel = cirm.NameOfVessel;
            CIRMPC.RadioCallSign = cirm.RadioCallSign;
            CIRMPC.PortofDeparture = cirm.PortofDeparture;
            CIRMPC.PortofDestination = cirm.PortofDestination;
            CIRMPC.LocationOfShip = cirm.LocationOfShip;
            CIRMPC.NameOfVessel = cirm.NameOfVessel;
            CIRMPC.RadioCallSign = cirm.RadioCallSign;
            CIRMPC.PortofDeparture = cirm.PortofDeparture;
            CIRMPC.PortofDestination = cirm.PortofDestination;
            CIRMPC.LocationOfShip = cirm.LocationOfShip;
            CIRMPC.EstimatedTimeOfarrivalhrs = cirm.EstimatedTimeOfarrivalhrs;
            CIRMPC.Speed = cirm.Speed;
            CIRMPC.Weather = cirm.Weather;
            CIRMPC.AgentDetails = cirm.AgentDetails;

            CIRMPC.Nationality = cirm.Nationality;
            CIRMPC.Qualification = cirm.Qualification;
            CIRMPC.Age = cirm.Age;
            CIRMPC.Addiction = cirm.Addiction;
            CIRMPC.Frequency = cirm.Frequency;
            CIRMPC.Ethinicity = cirm.Ethinicity;
            CIRMPC.RankID = cirm.RankID;
            CIRMPC.Sex = cirm.Sex;
            CIRMPC.Category = cirm.Category;
            CIRMPC.SubCategory = cirm.SubCategory;

            CIRMPC.WhereAndHowAccidentOccured = cirm.WhereAndHowAccidentOccured;
            CIRMPC.LocationAndTypeOfInjuryOrBurn = cirm.LocationAndTypeOfInjuryOrBurn;
            CIRMPC.FrequencyOfPain = cirm.FrequencyOfPain;
            CIRMPC.FirstAidGiven = cirm.FirstAidGiven;
            CIRMPC.PercentageOfBurn = cirm.PercentageOfBurn;

            VitalStatisticsPOCO vPoco = new VitalStatisticsPOCO();
            vPoco.ObservationDate = cirm.VitalStatistics.ObservationDate;
            vPoco.ObservationTime = cirm.VitalStatistics.ObservationTime;
            vPoco.Pulse = cirm.VitalStatistics.Pulse;
            vPoco.RespiratoryRate = cirm.VitalStatistics.RespiratoryRate;
            vPoco.OxygenSaturation = cirm.VitalStatistics.OxygenSaturation;
            vPoco.Himoglobin = cirm.VitalStatistics.Himoglobin;
            vPoco.Creatinine = cirm.VitalStatistics.Creatinine;
            vPoco.Bilirubin = cirm.VitalStatistics.Bilirubin;
            vPoco.Temperature = cirm.VitalStatistics.Temperature;
            vPoco.Systolic = cirm.VitalStatistics.Systolic;
            vPoco.Diastolic = cirm.VitalStatistics.Diastolic;
            vPoco.Fasting = cirm.VitalStatistics.Fasting;
            vPoco.Regular = cirm.VitalStatistics.Regular;




            return Json(CIRMBL.SaveCIRM(CIRMPC, int.Parse(Session["VesselID"].ToString())), JsonRequestBehavior.AllowGet);
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

                crewTemp.ReadingDate = crewPC.ReadingDate;
                crewTemp.ReadingTime = crewPC.ReadingTime;
                crewTemp.CrewName = crewPC.CrewName;
                crewTemp.RankName = crewPC.RankName;
                crewTemp.Place = crewPC.Place;
                crewTemp.TemperatureMode = crewPC.TemperatureMode;
                crewTemp.Temperature = crewPC.Temperature;
                crewTemp.Unit = crewPC.Unit;
                crewTemp.Means = crewPC.Means;

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
            CrewTemperaturePOCOList = CrewBL.GetCrewTemperaturePageWiseByCrewID(pageIndex, ref totalrecords, length, CrewID);
            List<CrewTemperature> crewList = new List<CrewTemperature>();
            foreach (CrewTemperaturePOCO crewPC in CrewTemperaturePOCOList)
            {
                CrewTemperature crewTemp = new CrewTemperature();

                crewTemp.ID = crewPC.ID;

                crewTemp.ReadingDate = crewPC.ReadingDate;
                crewTemp.ReadingTime = crewPC.ReadingTime;
                crewTemp.CrewName = crewPC.CrewName;
                crewTemp.RankName = crewPC.RankName;
                crewTemp.Place = crewPC.Place;
                crewTemp.TemperatureMode = crewPC.TemperatureMode;
                crewTemp.Temperature = crewPC.Temperature;
                crewTemp.Unit = crewPC.Unit;
                crewTemp.Means = crewPC.Means;

                crewList.Add(crewTemp);
            }

            var data = crewList;

            return Json(new { draw = draw, recordsFiltered = totalrecords, recordsTotal = totalrecords, data = data }, JsonRequestBehavior.AllowGet);
        }






        public JsonResult GetCrewTemperaturePageWise()
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
            CrewTemperaturePOCOList = CrewBL.GetCrewTemperaturePageWise(pageIndex, ref totalrecords, length);
            List<CrewTemperature> crewList = new List<CrewTemperature>();
            foreach (CrewTemperaturePOCO crewPC in CrewTemperaturePOCOList)
            {
                CrewTemperature crewTemp = new CrewTemperature();

                crewTemp.ID = crewPC.ID;

                crewTemp.ReadingDate = crewPC.ReadingDate;
                crewTemp.ReadingTime = crewPC.ReadingTime;
                crewTemp.CrewName = crewPC.CrewName;
                crewTemp.RankName = crewPC.RankName;
                crewTemp.Place = crewPC.Place;
                crewTemp.TemperatureMode = crewPC.TemperatureMode;
                crewTemp.Temperature = crewPC.Temperature;
                crewTemp.Unit = crewPC.Unit;
                crewTemp.Means = crewPC.Means;

                crewList.Add(crewTemp);
            }

            var data = crewList;

            return Json(new { draw = draw, recordsFiltered = totalrecords, recordsTotal = totalrecords, data = data }, JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetCrewTemperaturePageWise2()
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
            CrewTemperaturePOCOList = CrewBL.GetCrewTemperaturePageWise(pageIndex, ref totalrecords, length);
            List<CrewTemperature> crewList = new List<CrewTemperature>();
            foreach (CrewTemperaturePOCO crewPC in CrewTemperaturePOCOList)
            {
                CrewTemperature crewTemp = new CrewTemperature();

                crewTemp.ID = crewPC.ID;

                crewTemp.ReadingDate = crewPC.ReadingDate;
                crewTemp.ReadingTime = crewPC.ReadingTime;
                crewTemp.CrewName = crewPC.CrewName;
                crewTemp.RankName = crewPC.RankName;
                crewTemp.Place = crewPC.Place;
                crewTemp.TemperatureMode = crewPC.TemperatureMode;
                crewTemp.Temperature = crewPC.Temperature;
                crewTemp.Unit = crewPC.Unit;
                crewTemp.Means = crewPC.Means;

                crewList.Add(crewTemp);
            }

            var data = crewList;

            return Json(new { draw = draw, recordsFiltered = totalrecords, recordsTotal = totalrecords, data = data }, JsonRequestBehavior.AllowGet);
        }




        //////////////////////////////////////////////////////////////////////////////////////////////////////
        #region Upload Section
        public JsonResult UploadCrewHealthImage(string crewId)
        {
            if (Request.Files.Count > 0)
            {
                try
                {
                    List<string> returnMsg = new List<string>();
                    string fileName = String.Empty; //Path.GetFileNameWithoutExtension(postedFile.FileName);
                    fileName = "CrewHealthImages" + "_" + crewId;

                    
                    //  Get all files from Request object  
                    HttpFileCollectionBase files = Request.Files;
                    for (int i = 0; i < files.Count; i++)
                    {
                       
                        HttpPostedFileBase file = files[i];
                        string fname;
                        string extn;

                        // Checking for Internet Explorer  
                        if (Request.Browser.Browser.ToUpper() == "IE" || Request.Browser.Browser.ToUpper() == "INTERNETEXPLORER")
                        {
                            string[] testfiles = file.FileName.Split(new char[] { '\\' });
                            fname = testfiles[testfiles.Length - 1];
                            extn = Path.GetExtension(fname);
                        }
                        else
                        {
                            fname = file.FileName;
                            extn = Path.GetExtension(file.FileName);
                        }
                        string path = Server.MapPath(ConfigurationManager.AppSettings["CrewHealthImagesPath"].ToString());
                        string filePath = ConfigurationManager.AppSettings["CrewHealthImagesPath"].ToString();//Added on 3rd Feb 2022
                        if (!Directory.Exists(path))
                        {
                            Directory.CreateDirectory(path);
                        }
                        if (System.IO.File.Exists(path + fileName))
                        {
                            System.IO.File.Delete(path + fileName);
                        }
                        fileName = fileName + extn;
                        // Get the complete folder path and store the file inside it.  
                        string fnameWithServerPath = Path.Combine(path, fileName);//Alter on 3rd Feb 2022
                        string fnameWithPath = Path.Combine(filePath, fileName);//Added on 3rd Feb 2022
                        file.SaveAs(fnameWithServerPath);
                        returnMsg.Add(fnameWithPath);

                    }
                    
                    returnMsg.Add("File Uploaded Successfully!");
                   

                    return Json(returnMsg,JsonRequestBehavior.AllowGet);
                }
                catch (Exception ex)
                {
                    return Json("Error occurred. Error details: " + ex.Message);
                }
            }
            else
            {
                return Json("No files selected.");
            }
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

                if (FileExtension != ".pdf" && FileExtension != ".jpeg" && FileExtension != ".gif" && FileExtension != ".jpg" && FileExtension != ".png")
                {
                    ViewBag.UploadMessage = "You can only upload files of type pdf/jpeg/gif/png";
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



        public ActionResult UploadPistures()
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
        public ActionResult UploadPistures(HttpPostedFileBase postedFile, FormCollection formCollection)
        {
            GetAllCrewForDrp();
            GetAllCrewForTimeSheet();
            CrewTimesheetViewModel crewtimesheetVM = new CrewTimesheetViewModel();
            Crew c = new Crew();
            crewtimesheetVM.Crew = c; 
            //AdmissionFormBL admissionBl = new AdmissionFormBL();
            if (postedFile != null)
            {
                //upload images
                string fileName = String.Empty; //Path.GetFileNameWithoutExtension(postedFile.FileName);
                fileName = "UploadPistures" + "_" + formCollection["ID"].ToString();

                //To Get File Extension
                string FileExtension = Path.GetExtension(postedFile.FileName);
                fileName = fileName + FileExtension;

                if (FileExtension != ".pdf" && FileExtension != ".jpeg" && FileExtension != ".gif")
                {
                    ViewBag.UploadMessage = "You can only upload files of type pdf/jpef/gif";
                    return View();
                }

                //Get Upload path from Web.Config file AppSettings.
                string path = Server.MapPath(ConfigurationManager.AppSettings["UploadPisturesUploadPath"].ToString());
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

        [HttpPost]
        public JsonResult UploadCIRMPatientMediclImages(string crewId,string fileType)
        {
            if (Request.Files.Count > 0)
            {
                try
                {
                    List<string> returnMsg = new List<string>();
                    string fileName = String.Empty; //Path.GetFileNameWithoutExtension(postedFile.FileName);
                    fileName = "CIRM" + "_" + fileType + "_" + crewId;


                    //  Get all files from Request object  
                    HttpFileCollectionBase files = Request.Files;
                    for (int i = 0; i < files.Count; i++)
                    {

                        HttpPostedFileBase file = files[i];
                        string fname;
                        string extn;

                        // Checking for Internet Explorer  
                        if (Request.Browser.Browser.ToUpper() == "IE" || Request.Browser.Browser.ToUpper() == "INTERNETEXPLORER")
                        {
                            string[] testfiles = file.FileName.Split(new char[] { '\\' });
                            fname = testfiles[testfiles.Length - 1];
                            extn = Path.GetExtension(fname);
                        }
                        else
                        {
                            fname = file.FileName;
                            extn = Path.GetExtension(file.FileName);
                        }
                        string path = Server.MapPath(ConfigurationManager.AppSettings["CIRMPatientMedicalImagesPath"].ToString());
                        string filePath = ConfigurationManager.AppSettings["CIRMPatientMedicalImagesPath"].ToString();
                        if (!Directory.Exists(path))
                        {
                            Directory.CreateDirectory(path);
                        }
                        if (System.IO.File.Exists(path + fileName))
                        {
                            System.IO.File.Delete(path + fileName);
                        }
                        fileName = fileName + extn;
                        // Get the complete folder path and store the file inside it.  
                        string fnameWithServerPath = Path.Combine(path, fileName);
                        string fnameWithPath = Path.Combine(filePath, fileName);
                        file.SaveAs(fnameWithServerPath);
                        returnMsg.Add(fnameWithPath);

                    }

                    returnMsg.Add(fileType +" File Uploaded Successfully!");


                    return Json(returnMsg, JsonRequestBehavior.AllowGet);
                }
                catch (Exception ex)
                {
                    return Json("Error occurred. Error details: " + ex.Message);
                }
            }
            else
            {
                return Json("No files selected.");
            }
        }


        #endregion


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
            //13-01-2021 SSG
            um.CreatedOn = shipPC.CreatedOn;
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

        public JsonResult SendMail(CrewHealthDetails crewHealthDetails)
        {
            CrewBL crewBl = new CrewBL();
            String path = Server.MapPath("~/");
            StringBuilder mailBody = new StringBuilder();

            try
            {
                string s= GenerateEmailBody(crewHealthDetails);
                mailBody.Append(s);
                using (MailMessage mail = new MailMessage())
                {

                    mail.From = new MailAddress(crewBl.GetConfigData("shipemail"));
                    mail.To.Add(crewHealthDetails.DoctorsMail);//----

                    mail.Subject = "Patient's Description";
                    mail.Body =  mailBody.ToString();
                    mail.IsBodyHtml = true;
                    string cerwHealthaimgPath = Server.MapPath(ConfigurationManager.AppSettings["CrewHealthImagesPath"].ToString());
                    if (FileExistInDirectory(cerwHealthaimgPath, "CrewHealthImages_" + crewHealthDetails.ID))
                    {
                        mail.Attachments.Add(new Attachment(cerwHealthaimgPath + "\\" + GetFileName(cerwHealthaimgPath, "CrewHealthImages_" + crewHealthDetails.ID))) ;
                    }
                    string joinMedicalImgPath = Server.MapPath(ConfigurationManager.AppSettings["JoiningMedicalUploadPath"].ToString());
                    if (FileExistInDirectory(joinMedicalImgPath, "JoiningMedical_" + crewHealthDetails.ID))
                    {
                        mail.Attachments.Add(new Attachment(joinMedicalImgPath + "\\" + GetFileName(joinMedicalImgPath, "JoiningMedical_" + crewHealthDetails.ID)));
                    }
                    string medicineAvailableImgPath = Server.MapPath(ConfigurationManager.AppSettings["MedicineAvailableOnBoardUploadPath"].ToString());
                    if (FileExistInDirectory(medicineAvailableImgPath, "MedicineAvailableOnBoard_" + crewHealthDetails.ID))
                    {
                        mail.Attachments.Add(new Attachment(medicineAvailableImgPath + "\\" + GetFileName(medicineAvailableImgPath, "MedicineAvailableOnBoard_" + crewHealthDetails.ID)));
                    }
                    string equipmentAvailableImgPath = Server.MapPath(ConfigurationManager.AppSettings["MedicalEquipmentOnBoardUploadPath"].ToString());
                    if (FileExistInDirectory(equipmentAvailableImgPath, "MedicalEquipmentOnBoard_" + crewHealthDetails.ID))
                    {
                        mail.Attachments.Add(new Attachment(equipmentAvailableImgPath + "\\" + GetFileName(equipmentAvailableImgPath, "MedicalEquipmentOnBoard_" + crewHealthDetails.ID)));
                    }
                    string medicalHistoryImgPath = Server.MapPath(ConfigurationManager.AppSettings["MedicalHistoryUploadUploadPath"].ToString());
                    if (FileExistInDirectory(medicalHistoryImgPath, "MedicalHistoryUpload_" + crewHealthDetails.ID))
                    {
                        mail.Attachments.Add(new Attachment(medicalHistoryImgPath + "\\" + GetFileName(medicalHistoryImgPath, "MedicalHistoryUpload_" + crewHealthDetails.ID)));
                    }
                    string wRHLatestPath = Path.Combine(path ,ConfigurationManager.AppSettings["WorkAndRestHourLatestRecordUploadPath"].ToString());
                    if (FileExistInDirectory(wRHLatestPath, "WorkAndRestHourLatestRecord_" + crewHealthDetails.ID))
                    {
                        mail.Attachments.Add(new Attachment(wRHLatestPath + "\\" + GetFileName(wRHLatestPath, "WorkAndRestHourLatestRecord_" + crewHealthDetails.ID)));
                    }

                    string existingPrescriptionPath = Server.MapPath(ConfigurationManager.AppSettings["PreExistingMedicationPrescriptionUploadPath"].ToString());
                    if (FileExistInDirectory(existingPrescriptionPath, "PreExistingMedicationPrescription_" + crewHealthDetails.ID))
                    {
                        mail.Attachments.Add(new Attachment(existingPrescriptionPath + "\\" + GetFileName(existingPrescriptionPath, "PreExistingMedicationPrescription_" + crewHealthDetails.ID)));
                    }

                    SmtpClient smtp = new SmtpClient(crewBl.GetConfigData("smtp"));
                    smtp.EnableSsl = true;
                    smtp.Port = int.Parse(crewBl.GetConfigData("port"));

                    smtp.Credentials = new System.Net.NetworkCredential(crewBl.GetConfigData("shipemail").Trim(), crewBl.GetConfigData("shipemailpwd").Trim());

                    smtp.Send(mail);
                }
                return Json("Send Mail Succesfully!", JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                
                return Json("Mail send failed - {0}", JsonRequestBehavior.AllowGet);
            }

            
        }
       public string GenerateEmailBody(CrewHealthDetails crewHealthDetails)
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("<div>");//---main div
            sb.Append("<div class='head_title'><h1>CIRM - Patient Details</h1></div>");
            sb.Append("<div class='card bacmt'>");//---Card bacmt
            sb.Append("<div class='clearfix'></div>");
            sb.Append("<div class='row' style='border: 1px solid #eee; padding: 10px;'>");//---row1
            sb.Append("<div class='col-md-3'>");//---Col3 A

            sb.Append("<div class='form-group'>");
            sb.Append("<label for='Crew'>Crew &nbsp;&nbsp; :&nbsp;</label>");
            sb.Append(crewHealthDetails.Name);
            sb.Append("</div>");

            sb.Append("<div class='form-group'>");
            sb.Append("<label for='Nationality'>Nationality &nbsp;&nbsp; :&nbsp;</label>");
            sb.Append(crewHealthDetails.Nationality);
            sb.Append("</div>");
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='Addiction'>Addiction &nbsp;&nbsp; :&nbsp;</label>");
            sb.Append(crewHealthDetails.Adiction);
            sb.Append("</div>");
            sb.Append("</div>");//---Col3 A Close

            sb.Append("<div class='col-md-3'>");//---Col3 B
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='Rank'>Rank &nbsp;&nbsp; :&nbsp;</label>");
            sb.Append(crewHealthDetails.RankName);
            sb.Append("</div>");
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='Ethinicity'>Ethinicity &nbsp;&nbsp; :</label>");
            sb.Append(crewHealthDetails.Ethinicity);
            sb.Append("</div>");
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='Frequency'>Frequency &nbsp;&nbsp; :&nbsp;</label>");
            sb.Append(crewHealthDetails.Frequency);
            sb.Append("</div>");
            sb.Append("</div>");//---Col3 B Close

            sb.Append("<div class='col-md-3'>");//---Col3 C
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='Sex'>Sex &nbsp;&nbsp; :&nbsp;</label>");
            sb.Append(crewHealthDetails.Sex);
            sb.Append("</div>");
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='Age'>Date Of Birth &nbsp;&nbsp; :&nbsp;</label>");
            sb.Append(crewHealthDetails.DOB.ToString());
            sb.Append("</div>");
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='JoiningDate'>Joining Date &nbsp;&nbsp; :&nbsp;</label>");
            sb.Append(crewHealthDetails.JoinDate.ToString());
            sb.Append("</div>");
            sb.Append("</div>");//---Col3 C Close

            sb.Append("</div>");//---row1 Close

            sb.Append("<div class='row' style='border: 1px solid #eee; padding: 10px;'>");//---row2
            sb.Append("<h4>Type of Ailment </h4>");
            sb.Append("<div class='col-md-4'>");//---Col4 A
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='Category'>Category &nbsp;&nbsp; :&nbsp;</label>");
            sb.Append(crewHealthDetails.Category);
            sb.Append("</div>");
            sb.Append("</div>");//---Col4 A Close

            sb.Append("<div class='col-md-4'>");//---Col4 B
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='SubCategory'>Sub Category &nbsp;&nbsp; :&nbsp;</label>");
            sb.Append(crewHealthDetails.SubCategory);
            sb.Append("</div>");
            sb.Append("</div>");//---Col4 B Close

            sb.Append("</div>");//---row2 Close

            sb.Append("<div class='row' style='border: 1px solid #eee; padding: 10px;'>");//---row3
            sb.Append("<h4>Vital statistics </h4>");
            sb.Append("<div class='col-md-6'>");//---Col6 A
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='Pulse'>Pulse (Beats/Minute) &nbsp;&nbsp; :&nbsp;</label>");
            sb.Append(crewHealthDetails.Pulse);
            sb.Append("</div>");
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='OxygenSaturation'>Oxygen Saturation/SpO2 &nbsp;&nbsp; :</label>");
            sb.Append(crewHealthDetails.SPO2);
            sb.Append("</div>");
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='RespiratoryRate'>Respiratory Rate &nbsp;&nbsp; :&nbsp;</label>");
            sb.Append(crewHealthDetails.Respiratory);
            sb.Append("</div>");
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='BP'>Blood Pressure(mmHg) &nbsp;&nbsp; :&nbsp;</label>");
            sb.Append(crewHealthDetails.Systolic + "/" + crewHealthDetails.Diastolic);
            sb.Append("</div>");
            sb.Append("</div>");//---Col6 A Close
            sb.Append("</div>");//---row3 Close

            sb.Append("<div class='row' style='border: 1px solid #eee; padding: 10px;'>");//---row3
            sb.Append("<h4> Medical Condition</h4>");
            sb.Append("<div class='col-md-6'>");//---Col6 A
            sb.Append("<h4> Symptomology</h4>");
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='ObservedDateAndTime'>Observed Date And Time &nbsp;&nbsp; :&nbsp;</label>");
            sb.Append(crewHealthDetails.ObservedDate.ToString() + "/" + crewHealthDetails.ObservedTime.ToString());
            sb.Append("</div>");
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='Vomiting'>Vomiting &nbsp;&nbsp; :&nbsp;</label>");
            sb.Append(crewHealthDetails.IsVomiting);
            if(crewHealthDetails.IsVomiting == "Yes")
            {
                sb.Append("&nbsp;&nbsp;");
                sb.Append("<label for='VomeFrequency'>Frequency &nbsp;&nbsp; :&nbsp;</label>");
                sb.Append(crewHealthDetails.VomitingFrequency);
            }
            sb.Append("</div>");
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='Fits'>Fits &nbsp;&nbsp; :&nbsp;</label>");
            sb.Append(crewHealthDetails.IsFits);
            if (crewHealthDetails.IsFits == "No")
            {
                sb.Append("&nbsp;&nbsp;");
                sb.Append("<label for='FitFrequency'>Frequency &nbsp;&nbsp; :&nbsp;</label>");
                sb.Append(crewHealthDetails.FitsFrequency);
            }
            sb.Append("</div>");
            sb.Append("</div>");//---Col6 A Close
            sb.Append("<div class='col-md-6'>");//---Col6 B
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='Details'>Details &nbsp;&nbsp; :&nbsp;</label>");
            sb.Append(crewHealthDetails.AccidentDesc);
            sb.Append("</div>");
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='MedicinesAdministered'>Medicines Administered &nbsp;&nbsp; :&nbsp;</label>");
            sb.Append(crewHealthDetails.Medicines);
            sb.Append("</div>");
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='AnyOtherRelevantInformation'>Any Other Relevant Information &nbsp;&nbsp; :&nbsp;</label>");
            sb.Append(crewHealthDetails.OtherInfo);
            sb.Append("</div>");
            sb.Append("</div>");//---Col6 B Close
            sb.Append("</div>");//---row3 Close

            sb.Append("<div class='row' style='border: 1px solid #eee; padding: 10px;'>");//---row4
            sb.Append("<h4> In Case of Accident occured</h4>");
            sb.Append("<div class='col-md-6'>");//---Col6 A
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='WhereAndHowAccidentOccured'>Where And How Accident Occured &nbsp;&nbsp; :</label>");
            sb.Append(crewHealthDetails.AccidentLocation);
            sb.Append("</div>");
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='SeverityOfPain'>Severity Of Pain &nbsp;&nbsp; :&nbsp;</label>");
            sb.Append(crewHealthDetails.SeverityPain);
            sb.Append("</div>");
            sb.Append("</div>");//---Col6 A Close
            sb.Append("<div class='col-md-6'>");//---Col6 B
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='LocationAndTypeOfInjuryBurn'>Location And Type Of Injury/Burn &nbsp;&nbsp; : &nbsp;</label>");
            sb.Append(crewHealthDetails.InjuryLocation);
            sb.Append("</div>");
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='FrequencyOfPain'>Frequency Of Pain &nbsp;&nbsp; :&nbsp;</label>");
            sb.Append(crewHealthDetails.FrequencyOfPain);
            sb.Append("</div>");
            sb.Append("</div>");//---Col6 B Close
            sb.Append("<div class='col-md-6'>");//---Col6 C
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='FirstAidGiven'>First Aid Given &nbsp;&nbsp; :&nbsp;</label>");
            sb.Append(crewHealthDetails.FirstAid);
            sb.Append("</div>");
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='PercentageOfBurn'>Percentage Of Burn &nbsp;&nbsp; :&nbsp;</label>");
            sb.Append(crewHealthDetails.PercentageOfInjury);
            sb.Append("</div>");
            sb.Append("</div>");//---Col6 C Close
            sb.Append("</div>");//---row4 Close


            sb.Append("</div>");//---Card bacmt Close
            sb.Append("</div>");//---main div Close


            //sb.Append("<b>CIRM - Patient Details</b>");
            //sb.Append("\n");
            //sb.AppendLine("");
            //sb.Append("Crew :");
            //sb.Append(crewHealthDetails.Name);
            //sb.AppendLine("");


            //sb.Append("Nationality :");
            //sb.Append(crewHealthDetails.Nationality);
            //sb.AppendLine("");
            //sb.Append("Addiction &nbsp;&nbsp; :");
            //sb.Append(crewHealthDetails.Adiction);
            //sb.AppendLine("");

            //sb.Append("Rank:</label>");
            //sb.Append(crewHealthDetails.RankName); 
            //sb.AppendLine("Ethinicity &nbsp;&nbsp; :");
            //sb.Append(crewHealthDetails.Ethinicity);
            //sb.AppendLine("Frequency &nbsp;&nbsp; :");
            //sb.Append(crewHealthDetails.Frequency);
            //sb.AppendLine("Sex  :");
            //sb.Append(crewHealthDetails.Sex);
            //sb.AppendLine("Date Of Birth  :");
            //sb.Append(crewHealthDetails.DOB.ToString());
            //sb.AppendLine("Joining Date  :");
            //sb.Append(crewHealthDetails.JoinDate.ToString());
            //sb.AppendLine("<h4>Type of Ailment </h4>"); 
            //sb.AppendLine("Category &nbsp;&nbsp; :");
            //sb.Append(crewHealthDetails.Category); 
            //sb.AppendLine("Sub Category  :");
            //sb.Append(crewHealthDetails.SubCategory);
            //sb.AppendLine("<h4>Vital statistics </h4>");
            //sb.AppendLine("Pulse (Beats/Minute)  :");
            //sb.Append(crewHealthDetails.Pulse);
            //sb.AppendLine("Oxygen Saturation/SpO2  :");
            //sb.Append(crewHealthDetails.SPO2);
            //sb.AppendLine("Respiratory Rate :");
            //sb.Append(crewHealthDetails.Respiratory);
            //sb.AppendLine("Blood Pressure(mmHg)  :");
            //sb.Append(crewHealthDetails.Systolic + "/" + crewHealthDetails.Diastolic);
            //sb.AppendLine("<h4> Medical Condition</h4>");
            //sb.AppendLine("<h4> Symptomology</h4>");
            //sb.AppendLine("Observed Date And Time  :");
            //sb.Append(crewHealthDetails.ObservedDate.ToString() + "/" + crewHealthDetails.ObservedTime.ToString());
            //sb.AppendLine("Vomiting  :");
            //sb.Append(crewHealthDetails.IsVomiting);
            //sb.AppendLine("Fits  :");
            //sb.Append(crewHealthDetails.IsFits);
            //sb.AppendLine("Details  :");
            //sb.Append(crewHealthDetails.AccidentDesc);
            //sb.AppendLine("Medicines Administered :");
            //sb.Append(crewHealthDetails.Medicines);
            //sb.AppendLine("Any Other Relevant Information :");
            //sb.Append(crewHealthDetails.OtherInfo);
            //sb.AppendLine("<b> In Case of Accident occured</b>");
            //sb.AppendLine("Where And How Accident Occured  :");
            //sb.Append(crewHealthDetails.AccidentLocation);
            //sb.AppendLine("Severity Of Pain  :");
            //sb.Append(crewHealthDetails.SeverityPain);
            //sb.AppendLine("Location And Type Of Injury/Burn  :");
            //sb.Append(crewHealthDetails.InjuryLocation);
            //sb.AppendLine("Frequency Of Pain  :");
            //sb.Append(crewHealthDetails.FrequencyOfPain);
            //sb.AppendLine("First Aid Given  :");
            //sb.Append(crewHealthDetails.FirstAid);
            //sb.AppendLine("Percentage Of Burn  :");
            //sb.Append(crewHealthDetails.PercentageOfInjury);
            //sb.AppendLine("");



            return sb.ToString();
        }

        public bool FileExistInDirectory(string path, string name)
        {
            try
            {
                
                    DirectoryInfo di = new DirectoryInfo(path + "\\");
                    return di.GetFiles(name + ".*").Length > 0;
               
            }
            catch (Exception ex)
            {

                return false;
            }

        }
        public string GetFileName(string path,string name)
        {
           
                DirectoryInfo di = new DirectoryInfo(path + "\\");
                return di.GetFiles(name+".*")[0].Name;
            
        }
        


        public JsonResult SendCIRMMail(CrewHealthDetails crewHealthDetails,string cirmId)
        {
            CrewBL crewBl = new CrewBL();
            String path = Server.MapPath("~/");
            StringBuilder mailBody = new StringBuilder();

            CIRMBL cirmBL = new CIRMBL();
            ShipPOCO shipPC = new ShipPOCO();
            CIRMPOCO cirmPoco = new CIRMPOCO();
            VitalStatisticsPOCO cirmVitalsPoco = new VitalStatisticsPOCO();
            MedicalSymtomologyPOCO cirmSymtomologyPoco = new MedicalSymtomologyPOCO();

            List<VitalStatisticsPOCO> cirmVitalsPocoList = new List<VitalStatisticsPOCO>();
            List<MedicalSymtomologyPOCO> cirmSymtomologyPocoList = new List<MedicalSymtomologyPOCO>();
            CIRM cirm = new CIRM();

            cirmPoco = cirmBL.GetCIRMPatientDetailsByCrew(crewHealthDetails.ID, int.Parse(Session["VesselID"].ToString()));

            if (cirmPoco.CIRMId > 0)
            {
                cirmVitalsPocoList = cirmBL.GetVitalStatisticsByCIRM(cirmPoco.CIRMId);
                cirmSymtomologyPocoList = cirmBL.GetMedicalSymtomologyByCIRM(cirmPoco.CIRMId);
                

            }
            cirmPoco.VitalStatisticsList = cirmVitalsPocoList;
            cirmPoco.SymtomologyList = cirmSymtomologyPocoList;


            try
            {
                string s = GenerateCIRMEmailBody(crewHealthDetails,cirmPoco);
                mailBody.Append(s);
                using (MailMessage mail = new MailMessage())
                {

                    mail.From = new MailAddress(crewBl.GetConfigData("shipemail"));
                    mail.To.Add(crewHealthDetails.DoctorsMail);//----

                    mail.Subject = "Patient's Description";
                    mail.Body = mailBody.ToString();
                    mail.IsBodyHtml = true;
                    string cerwHealthaimgPath = Server.MapPath(ConfigurationManager.AppSettings["CrewHealthImagesPath"].ToString());
                    if (FileExistInDirectory(cerwHealthaimgPath, "CrewHealthImages_" + cirmPoco.CrewId))
                    {
                        mail.Attachments.Add(new Attachment(cerwHealthaimgPath + "\\" + GetFileName(cerwHealthaimgPath, "CrewHealthImages_" + cirmPoco.CrewId)));
                    }
                    string cirmMedicalImgPath = Server.MapPath(ConfigurationManager.AppSettings["CIRMPatientMedicalImagesPath"].ToString());
                    if (Convert.ToBoolean(cirmPoco.JoiningMedical))
                    {
                        if (FileExistInDirectory(cirmMedicalImgPath, "CIRM_JoiningMedical_" + cirmPoco.CrewId))
                        {
                            mail.Attachments.Add(new Attachment(cirmMedicalImgPath + "\\" + GetFileName(cirmMedicalImgPath, "CIRM_JoiningMedical_" + cirmPoco.CrewId)));
                        }
                    }
                    if (Convert.ToBoolean(cirmPoco.MedicineAvailableOnBoard))
                    {
                        if (FileExistInDirectory(cirmMedicalImgPath, "CIRM_MedicineAvailableOnBoard_" + cirmPoco.CrewId))
                        {
                            mail.Attachments.Add(new Attachment(cirmMedicalImgPath + "\\" + GetFileName(cirmMedicalImgPath, "CIRM_MedicineAvailableOnBoard_" + cirmPoco.CrewId)));
                        }
                    }
                    if (Convert.ToBoolean(cirmPoco.MedicalEquipmentOnBoard))
                    {
                        if (FileExistInDirectory(cirmMedicalImgPath, "CIRM_MedicalEquipmentOnBoard_" + cirmPoco.CrewId))
                        {
                            mail.Attachments.Add(new Attachment(cirmMedicalImgPath + "\\" + GetFileName(cirmMedicalImgPath, "CIRM_MedicalEquipmentOnBoard_" + cirmPoco.CrewId)));
                        }
                    }
                    if (Convert.ToBoolean(cirmPoco.MedicalHistoryUpload))
                    {
                        if (FileExistInDirectory(cirmMedicalImgPath, "CIRM_MedicalHistoryUpload_" + cirmPoco.CrewId))
                        {
                            mail.Attachments.Add(new Attachment(cirmMedicalImgPath + "\\" + GetFileName(cirmMedicalImgPath, "CIRM_MedicalHistoryUpload_" + cirmPoco.CrewId)));
                        }
                    }
                    if (Convert.ToBoolean(cirmPoco.WorkAndRestHourLatestRecord))
                    {
                        if (FileExistInDirectory(cirmMedicalImgPath, "CIRM_WorkAndRestHourLatestRecord_" + cirmPoco.CrewId))
                        {
                            mail.Attachments.Add(new Attachment(cirmMedicalImgPath + "\\" + GetFileName(cirmMedicalImgPath, "CIRM_WorkAndRestHourLatestRecord_" + cirmPoco.CrewId)));
                        }
                    }

                    string existingPrescriptionPath = Server.MapPath(ConfigurationManager.AppSettings["PreExistingMedicationPrescriptionUploadPath"].ToString());
                    if (FileExistInDirectory(existingPrescriptionPath, "PreExistingMedicationPrescription_" + cirmPoco.CrewId))
                    {
                        mail.Attachments.Add(new Attachment(existingPrescriptionPath + "\\" + GetFileName(existingPrescriptionPath, "PreExistingMedicationPrescription_" + cirmPoco.CrewId)));
                    }

                    SmtpClient smtp = new SmtpClient(crewBl.GetConfigData("smtp"));
                    smtp.EnableSsl = true;
                    smtp.Port = int.Parse(crewBl.GetConfigData("port"));

                    smtp.Credentials = new System.Net.NetworkCredential(crewBl.GetConfigData("shipemail").Trim(), crewBl.GetConfigData("shipemailpwd").Trim());

                    smtp.Send(mail);
                }
                return Json("Send Mail Succesfully!", JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {

                return Json("Mail send failed - {0}", JsonRequestBehavior.AllowGet);
            }


        }
        public string GenerateCIRMEmailBody(CrewHealthDetails crewHealthDetails,CIRMPOCO cirm)
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("<div>");//---main div
            sb.Append("<div class='head_title'><h1>CIRM - Patient Details</h1></div>");
            sb.Append("<div class='card bacmt'>");//---Card bacmt
            sb.Append("<div class='clearfix'></div>");

            #region Vessel Details Part
            sb.Append("<div class='row' style='border: 1px solid #eee; padding: 10px;'>");//---row0
            sb.Append("< h4 > Vessel Details </ h4 >");
            sb.Append("<div class='col-md-4'>");//---Col4 A
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='Vess'>Vessel Name &nbsp;&nbsp; :&nbsp;</label>");
            sb.Append(cirm.NameOfVessel);
            sb.Append("</div>");
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='POD'>Port Of Departure &nbsp;&nbsp; :&nbsp;</label>");
            sb.Append(cirm.PortofDeparture);
            sb.Append("</div>");
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='Speed'>Speed (in knots) &nbsp;&nbsp; :&nbsp;</label>");
            sb.Append(cirm.Speed);
            sb.Append("</div>");
            sb.Append("</div>");//---Col4 A Close

            sb.Append("<div class='col-md-4'>");//---Col4 B
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='Call'>Radio Call Sign &nbsp;&nbsp; :&nbsp;</label>");
            sb.Append(cirm.RadioCallSign);
            sb.Append("</div>");
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='POA'>Port Of Arrival &nbsp;&nbsp; :&nbsp;</label>");
            sb.Append(cirm.PortofDestination);
            sb.Append("</div>");
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='Weather'>Weather &nbsp;&nbsp; :&nbsp;</label>");
            sb.Append(cirm.Weather);
            sb.Append("</div>");
            sb.Append("</div>");//---Col4 B Close

            sb.Append("<div class='col-md-4'>");//---Col4 B
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='Location'>Location Of Ship &nbsp;&nbsp; :&nbsp;</label>");
            sb.Append(cirm.LocationOfShip);
            sb.Append("</div>");
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='ETA'>Estimated Time Of Arrival (hrs) &nbsp;&nbsp; :&nbsp;</label>");
            sb.Append(cirm.EstimatedTimeOfarrivalhrs);
            sb.Append("</div>");
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='Agent Details'>Agent Details &nbsp;&nbsp; :&nbsp;</label>");
            sb.Append(cirm.AgentDetails);
            sb.Append("</div>");
            sb.Append("</div>");//---Col4 B Close

            sb.Append("</div>");//---row0 Close

            #endregion
            #region Patient Details ---
            sb.Append("<div class='clearfix'></div>");
            sb.Append("<div class='row' style='border: 1px solid #eee; padding: 10px;'>");//---row1
            sb.Append("< h4 > Petient Details </ h4 >");
            sb.Append("<div class='col-md-3'>");//---Col3 A
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='Crew'>Crew &nbsp;&nbsp; :&nbsp;</label>");
            sb.Append(crewHealthDetails.Name);
            sb.Append("</div>");

            sb.Append("<div class='form-group'>");
            sb.Append("<label for='Nationality'>Nationality &nbsp;&nbsp; :&nbsp;</label>");
            sb.Append(crewHealthDetails.Nationality);
            sb.Append("</div>");
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='Addiction'>Addiction &nbsp;&nbsp; :&nbsp;</label>");
            sb.Append(crewHealthDetails.Adiction);
            sb.Append("</div>");
            sb.Append("</div>");//---Col3 A Close

            sb.Append("<div class='col-md-3'>");//---Col3 B
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='Rank'>Rank &nbsp;&nbsp; :&nbsp;</label>");
            sb.Append(crewHealthDetails.RankName);
            sb.Append("</div>");
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='Ethinicity'>Ethinicity &nbsp;&nbsp; :</label>");
            sb.Append(crewHealthDetails.Ethinicity);
            sb.Append("</div>");
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='Frequency'>Frequency &nbsp;&nbsp; :&nbsp;</label>");
            sb.Append(crewHealthDetails.Frequency);
            sb.Append("</div>");
            sb.Append("</div>");//---Col3 B Close

            sb.Append("<div class='col-md-3'>");//---Col3 C
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='Sex'>Sex &nbsp;&nbsp; :&nbsp;</label>");
            sb.Append(crewHealthDetails.Sex);
            sb.Append("</div>");
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='Age'>Date Of Birth &nbsp;&nbsp; :&nbsp;</label>");
            sb.Append(crewHealthDetails.DOB.ToString());
            sb.Append("</div>");
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='JoiningDate'>Joining Date &nbsp;&nbsp; :&nbsp;</label>");
            sb.Append(crewHealthDetails.JoinDate.ToString());
            sb.Append("</div>");
            sb.Append("</div>");//---Col3 C Close

            sb.Append("</div>");//---row1 Close

            #endregion

            #region Type Of Ailment 
            sb.Append("<div class='clearfix'></div>");
            sb.Append("<div class='row' style='border: 1px solid #eee; padding: 10px;'>");//---row2
            sb.Append("<h4>Type of Ailment </h4>");
            sb.Append("<div class='col-md-6'>");//---Col6 A
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='Category'>Category &nbsp;&nbsp; :&nbsp;</label>");
            sb.Append(cirm.Category);
            sb.Append("</div>");
            sb.Append("</div>");//---Col6 A Close

            sb.Append("<div class='col-md-6'>");//---Col6 B
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='SubCategory'>Sub Category &nbsp;&nbsp; :&nbsp;</label>");
            sb.Append(cirm.SubCategory);
            sb.Append("</div>");
            sb.Append("</div>");//---Col6 B Close

            sb.Append("</div>");//---row2 Close

            #endregion

            #region Vital Params
            sb.Append("<div class='row' style='border: 1px solid #eee; padding: 10px;'>");//---row3

            sb.Append("<table id='CIRMVitalParamstable' style='width: 90 % '>");
            sb.Append(" <thead><tr><th>ObservationDate/Time</th><th>Puls</th><th>RespiratoryRate</th><th>Himoglobin</th><th>Creatinine</th>");
            sb.Append("<th>Bilirubin</th><th>Temperature</th><th>Blood Pressure(mmHg)</th><th>Blood Sugar</th></tr></thead>");
            sb.Append("<tbody>");
            foreach( VitalStatisticsPOCO vsp in cirm.VitalStatisticsList)
            {
                sb.Append("<tr>");
                sb.Append("<td>");
                sb.Append(vsp.ObservationDate + "/" + vsp.ObservationTime);
                sb.Append("</td>");
                sb.Append("<td>");
                sb.Append(vsp.Pulse);
                sb.Append("</td>");
                sb.Append("<td>");
                sb.Append(vsp.RespiratoryRate);
                sb.Append("</td>");
                sb.Append("<td>");
                sb.Append(vsp.Himoglobin);
                sb.Append("</td>");
                sb.Append("<td>");
                sb.Append(vsp.Creatinine);
                sb.Append("</td>");
                sb.Append("<td>");
                sb.Append(vsp.Bilirubin);
                sb.Append("</td>");
                sb.Append("<td>");
                sb.Append(vsp.Temperature);
                sb.Append("</td>");
                sb.Append("<td>");
                sb.Append(vsp.Systolic + "/" + vsp.Diastolic);
                sb.Append("</td>");
                sb.Append("<td>");
                sb.Append(vsp.Fasting +"/" + vsp.Regular);
                sb.Append("</td>");
                sb.Append("</tr>");
            }
            sb.Append("</tbody>");
            sb.Append("</table>");
            sb.Append("</div>");//---row3 Close
            #endregion

            #region Medical Symttomology
            sb.Append("<div class='row' style='border: 1px solid #eee; padding: 10px;'>");//---row4

            sb.Append("<table id='myModalCIRMSymtomology' style='width: 90 % '>");
            sb.Append(" <thead><tr><th>ObservationDate/Time</th><th>Vomiting</th><th>Fits</th><th>Giddiness</th><th>Lethargy</th>");
            sb.Append("<th>SymptomatologyDetails</th><th>MedicinesAdministered</th><th>AnyOtherRelevantInformation</th></tr></thead>");
            sb.Append("<tbody>");
            foreach (MedicalSymtomologyPOCO msp in cirm.SymtomologyList)
            {
                sb.Append("<tr>");
                sb.Append("<td>");
                sb.Append(msp.ObservationDate + "/" + msp.ObservationTime);
                sb.Append("</td>");
                sb.Append("<td>");
                sb.Append(msp.Vomiting);
                if (msp.Vomiting == "Yes")
                {
                    sb.Append("&nbsp;&nbsp;(" + msp.FrequencyOfVomiting +")");
                }
                sb.Append("</td>");
                sb.Append("<td>");
                sb.Append(msp.Fits);
                if (msp.Vomiting == "Yes")
                {
                    sb.Append("&nbsp;&nbsp;(" + msp.FrequencyOfFits + ")");
                }
                sb.Append("</td>");
                sb.Append("<td>");
                sb.Append(msp.Giddiness);
                if (msp.Vomiting == "Yes")
                {
                    sb.Append("&nbsp;&nbsp;(" + msp.FrequencyOfGiddiness + ")");
                }
                sb.Append("</td>");
                sb.Append("<td>");
                sb.Append(msp.Lethargy);
                if (msp.Vomiting == "Yes")
                {
                    sb.Append("&nbsp;&nbsp;(" + msp.FrequencyOfLethargy + ")");
                }
                sb.Append("</td>");
                sb.Append("<td>");
                sb.Append(msp.SymptomologyDetails);
                sb.Append("</td>");
                sb.Append("<td>");
                sb.Append(msp.MedicinesAdministered);
                sb.Append("</td>");
                sb.Append("<td>");
                sb.Append(msp.AnyOtherRelevantInformation );
                sb.Append("</td>");
                sb.Append("</tr>");
            }
            sb.Append("</tbody>");
            sb.Append("</table>");
            sb.Append("</div>");//---row4 Close
            #endregion

            #region Past Medical History

            sb.Append("<div class='clearfix'></div>");
            sb.Append("<div class='row' style='border: 1px solid #eee; padding: 10px;'>");//---row5
            sb.Append("<h4>Past Medical History</h4>");
            sb.Append("<div class='col-md-4'>");//---Col4 A
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='Category'>Medical Hostory &nbsp;&nbsp; :&nbsp;</label>");
            sb.Append(cirm.PastMedicalHistory);
            sb.Append("</div>");

            sb.Append("<div class='form-group'>");
            sb.Append("<label for='Remarks'>Remarks &nbsp;&nbsp; :&nbsp;</label>");
            sb.Append(cirm.PastRemarks);
            sb.Append("</div>");
           
            sb.Append("</div>");//---Col4 A Close

            sb.Append("<div class='col-md-4'>");//---Col4 B
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='SubCategory'>Treatment Given &nbsp;&nbsp; :&nbsp;</label>");
            sb.Append(cirm.PastTreatmentGiven);
            sb.Append("</div>");
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='Category'>Medicine Administered &nbsp;&nbsp; :&nbsp;</label>");
            sb.Append(cirm.PastMedicineAdministered);
            sb.Append("</div>");
            sb.Append("</div>");//---Col4 B Close

            sb.Append("<div class='col-md-4'>");//---Col4 C
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='SubCategory'>Tele Medical Advice Received &nbsp;&nbsp; :&nbsp;</label>");
            sb.Append(cirm.PastTeleMedicalAdviceReceived);
            sb.Append("</div>");
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='Category'>Attached File &nbsp;&nbsp; :&nbsp;</label>");
            if (!String.IsNullOrEmpty(cirm.PastMedicalHistoryPath))
            {
                sb.Append("See Attachmenta");
            }
            else
                sb.Append("No Attachment");
            
            sb.Append("</div>");
            sb.Append("</div>");//---Col4 C Close

            sb.Append("</div>");//---row5 Close

            #endregion

            #region Incase of Accident

            sb.Append("<div class='clearfix'></div>");
            sb.Append("<div class='row' style='border: 1px solid #eee; padding: 10px;'>");//---row5
            sb.Append("<h4>Accident</h4>");
            sb.Append("<div class='col-md-4'>");//---Col4 A
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='Category'>Where And How &nbsp;&nbsp; :&nbsp;</label>");
            sb.Append(cirm.WhereAndHowAccidentOccured);
            sb.Append("</div>");

            sb.Append("<div class='form-group'>");
            sb.Append("<label for='Remarks'>Severity Of Pain &nbsp;&nbsp; :&nbsp;</label>");
            //sb.Append(cirm.PastRemarks);
            //----------Code Required---------
            sb.Append("</div>");

            sb.Append("</div>");//---Col4 A Close

            sb.Append("<div class='col-md-4'>");//---Col4 B
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='SubCategory'>Location And Type Of Injury/Burn &nbsp;&nbsp; :&nbsp;</label>");
            sb.Append(cirm.LocationAndTypeOfInjuryOrBurn);
            sb.Append("</div>");
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='Category'>Frequency Of Pain &nbsp;&nbsp; :&nbsp;</label>");
            sb.Append(cirm.FrequencyOfPain);
            sb.Append("</div>");
            sb.Append("</div>");//---Col4 B Close

            sb.Append("<div class='col-md-4'>");//---Col4 C
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='SubCategory'>Percentage Of Burn &nbsp;&nbsp; :&nbsp;</label>");
            sb.Append(cirm.PercentageOfBurn);
            sb.Append("</div>");
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='Category'>First Aid Given &nbsp;&nbsp; :&nbsp;</label>");
            sb.Append(cirm.FirstAidGiven);

            sb.Append("</div>");
            sb.Append("</div>");//---Col4 C Close

            sb.Append("</div>");//---row5 Close

            #endregion

            #region Document Attached
            sb.Append("<div class='row' style='border: 1px solid #eee; padding: 10px;'>");//---row6
            sb.Append("<div class='col-md-4'>");//---Col4 A
            sb.Append("<div class='form-group'>");
            sb.Append("<label for='Pulse'>Document Attached &nbsp;&nbsp; :&nbsp;</label>");
            sb.Append("</div>");
            sb.Append("</div>");//---Col4 B Close
            sb.Append("<div class='col-md-4'>");//---Col4 A
            if (Convert.ToBoolean(cirm.JoiningMedical))
            {
                sb.Append("<div class='form-group'>");
                sb.Append("<label for='Pulse'>Joining Medical &nbsp;&nbsp;&nbsp;</label>");
                sb.Append("</div>");
            }
            if (Convert.ToBoolean(cirm.MedicineAvailableOnBoard))
            {
                sb.Append("<div class='form-group'>");
                sb.Append("<label for='Pulse'> Meical Inventory &nbsp;&nbsp;&nbsp;</label>");
                sb.Append("</div>");
            }
            if (Convert.ToBoolean(cirm.MedicalEquipmentOnBoard))
            {
                sb.Append("<div class='form-group'>");
                sb.Append("<label for='Pulse'>Mecical Equipment list &nbsp;&nbsp;&nbsp;</label>");
                sb.Append("</div>");
            }
            if (Convert.ToBoolean(cirm.MedicalHistoryUpload))
            {
                sb.Append("<div class='form-group'>");
                sb.Append("<label for='Pulse'>Medical History	 &nbsp;&nbsp;&nbsp;</label>");
                sb.Append("</div>");
            }
            if (Convert.ToBoolean(cirm.WorkAndRestHourLatestRecord))
            {
                sb.Append("<div class='form-group'>");
                sb.Append("<label for='Pulse'>Work and Rest hour &nbsp;&nbsp;&nbsp;</label>");
                sb.Append("</div>");
            }

            sb.Append("</div>");//---Col4 B Close
            sb.Append("</div>");//---row6 Close

            #endregion


            sb.Append("</div>");//---Card bacmt Close
            sb.Append("</div>");//---main div Close



            return sb.ToString();
        }

    }
}
