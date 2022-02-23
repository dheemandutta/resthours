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
    public class MedicalAssistanceController : Controller
    {
        // GET: MedicalAssistance
        public ActionResult TeleMedicine()
        {
            GetAllRanksForDrp();
            GetAllCountryForDrp();
            GetAllCrewForDrp();
            //GetAllCrewForTimeSheet();

            CrewTimesheetViewModel crewtimesheetVM = new CrewTimesheetViewModel();
            return View(crewtimesheetVM);
        }
        public ActionResult DoctorVisit()
        {
            GetAllRanksForDrp();
            GetAllCountryForDrp();
            GetAllCrewForDrp();
            //GetAllCrewForTimeSheet();

            CrewTimesheetViewModel crewtimesheetVM = new CrewTimesheetViewModel();
            return View(crewtimesheetVM);
        }
        public ActionResult CIRM()
        {
            GetAllRanksForDrp();
            GetAllCountryForDrp();
            GetAllCrewForDrp();
            //GetAllCrewForTimeSheet();

            CrewTimesheetViewModel crewtimesheetVM = new CrewTimesheetViewModel();
            return View(crewtimesheetVM);
        }



        public ActionResult MediVac()
        {
            GetAllRanksForDrp();
            GetAllCountryForDrp();
            GetAllCrewForDrp();
            //GetAllCrewForTimeSheet();

            CrewTimesheetViewModel crewtimesheetVM = new CrewTimesheetViewModel();
            return View(crewtimesheetVM);
        }
        public ActionResult MediVac_VesselDeatils()
        {
            return PartialView();
        }
        public ActionResult MediVac_VoyageDeatils()
        {
            return PartialView();
        }
        public ActionResult MediVac_WeatherDeatils()
        {
            return PartialView();
        }
        public ActionResult MediVac_PatientDeatils()
        {
            return PartialView();
        }



        public ActionResult MedicalAdvice()
        {
            return View();
        }
        public ActionResult DoctorVisited()
        {
            List<MedicalAdvise> allMedicalAdvise = new List<MedicalAdvise>();
            

            MedicalAdviseBL madviseBl = new MedicalAdviseBL();
            List<MedicalAdvisePOCO> madvisePocoList = new List<MedicalAdvisePOCO>();

            madvisePocoList = madviseBl.GetAllMedicalAdviseByCrew(Convert.ToInt32(Session["UserID"].ToString()));
            if(madvisePocoList.Count() > 0)
            {
                foreach(MedicalAdvisePOCO madvisePoco in madvisePocoList)
                {
                    MedicalAdvise mAdvise = new MedicalAdvise();
                    mAdvise.Id = madvisePoco.Id;
                    mAdvise.Diagnosis = madvisePoco.Diagnosis;
                    mAdvise.TreatmentPrescribed = madvisePoco.TreatmentPrescribed;
                    mAdvise.IsIllnessDueToAnAccident = madvisePoco.IsIllnessDueToAnAccident;
                    mAdvise.MedicinePrescribed = madvisePoco.MedicinePrescribed;
                    mAdvise.RequireHospitalisation = madvisePoco.RequireHospitalisation;
                    mAdvise.RequireSurgery = madvisePoco.RequireSurgery;
                    mAdvise.IsFitForDuty = madvisePoco.IsFitForDuty;
                    mAdvise.FitForDutyComments = madvisePoco.FitForDutyComments;
                    mAdvise.IsMayJoinOnBoardButLightDuty = madvisePoco.IsMayJoinOnBoardButLightDuty;
                    mAdvise.MayJoinOnBoardDays = madvisePoco.MayJoinOnBoardDays;
                    mAdvise.MayJoinOnBoardComments = madvisePoco.MayJoinOnBoardComments;
                    mAdvise.IsUnfitForDuty = madvisePoco.IsUnfitForDuty;
                    mAdvise.UnfitForDutyComments = madvisePoco.UnfitForDutyComments;
                    mAdvise.FutureFitnessAndRestrictions = madvisePoco.FutureFitnessAndRestrictions;
                    mAdvise.DischargeSummary = madvisePoco.DischargeSummary;
                    mAdvise.FollowUpAction = madvisePoco.FollowUpAction;
                    mAdvise.DoctorName = madvisePoco.DoctorName;
                    mAdvise.DoctorContactNo = madvisePoco.DoctorContactNo;
                    mAdvise.DoctorEmail = madvisePoco.DoctorEmail;
                    mAdvise.DoctorSpeciality = madvisePoco.DoctorSpeciality;
                    mAdvise.DoctorMedicalRegNo = madvisePoco.DoctorMedicalRegNo;
                    mAdvise.DoctorCountry = madvisePoco.DoctorCountry;
                    mAdvise.NameOfHospital = madvisePoco.NameOfHospital;
                    mAdvise.Path = madvisePoco.Path;
                    mAdvise.TestDate = madvisePoco.TestDate;
                    mAdvise.CrewId = madvisePoco.CrewId;

                    allMedicalAdvise.Add(mAdvise);
                }
            }


            return View(allMedicalAdvise);
        }




        #region Dropdown
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



        #endregion

        #region Save Methods

        public JsonResult SaveCIRM(CIRMPOCO cIRM)
        {
            CIRMBL CIRMBL = new CIRMBL();

            return Json(CIRMBL.SaveCIRM(cIRM, int.Parse(Session["VesselID"].ToString())), JsonRequestBehavior.AllowGet);
        }
        public JsonResult SaveCIRMNew(CIRMPOCO cIRM)
        {
            CIRMBL CIRMBL = new CIRMBL();

            return Json(CIRMBL.SaveCIRMNew(cIRM, int.Parse(Session["VesselID"].ToString())), JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// Added on 11th Jan 2022 @BK
        /// </summary>
        /// <param name="cIRM"></param>
        /// <returns></returns>
        [HttpPost]

        public JsonResult SaveCIRMVitalParams(VitalStatisticsPOCO vitaPoco)
        {
            CIRMBL CIRMBL = new CIRMBL();
            return Json(CIRMBL.SaveCIRMVitalParams(vitaPoco), JsonRequestBehavior.AllowGet);

            //return Json("", JsonRequestBehavior.AllowGet);
        }
        /// <summary>
        /// Added on 11th Jan 2022 @BK
        /// </summary>
        /// <param name="cIRM"></param>
        /// <returns></returns>
        public JsonResult SaveCIRMSymtomology(MedicalSymtomologyPOCO symPoco)
        {
            CIRMBL CIRMBL = new CIRMBL();
            return Json(CIRMBL.SaveCIRMSymtomology(symPoco), JsonRequestBehavior.AllowGet);
            //return Json("", JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult SaveCIRMDoctorsEmails(string cirmId,string crewId,string doctorsEmail)
        {
            CIRMBL CIRMBL = new CIRMBL();
            return Json(CIRMBL.SaveCIRMDoctorsEmails(cirmId, crewId, doctorsEmail), JsonRequestBehavior.AllowGet);

            //return Json("", JsonRequestBehavior.AllowGet);
        }

        #endregion


        #region Get and Load Methods
        [HttpGet]
        public JsonResult GetCrewForCIRMPatientDetailsByCrew(int ID)
        {
            CIRMBL shipBL = new CIRMBL();
            ShipPOCO shipPC = new ShipPOCO();

            shipPC = shipBL.GetCrewForCIRMPatientDetailsByCrew(ID);

            Vessel um = new Vessel();

            um.ID = shipPC.ID;

            //um.CrewName = shipPC.CrewName;
            um.RankID = shipPC.RankID;
            um.Gender = shipPC.Gender;
            um.CountryID = shipPC.CountryID;
            um.DOB = shipPC.DOB;
            //13-01-2021 SSG
            um.CreatedOn = shipPC.CreatedOn;

            var cm = um;

            return Json(cm, JsonRequestBehavior.AllowGet);
        }


        /// <summary>
        /// Added on 7th Jan 2022 @BK
        /// </summary>
        /// <param name="ID"></param>
        /// <returns></returns>
        [HttpGet]
        public JsonResult GetCIRMPatientDetailsByCrew(int ID)
        {
            CIRMBL cirmBL = new CIRMBL();
            ShipPOCO shipPC = new ShipPOCO();
            CIRMPOCO cirmPoco = new CIRMPOCO();
            VitalStatisticsPOCO cirmVitalsPoco = new VitalStatisticsPOCO();
            MedicalSymtomologyPOCO cirmSymtomologyPoco = new MedicalSymtomologyPOCO();
            CIRM cirm = new CIRM();
            VitalStatistics cirmVitals = new VitalStatistics();
            MedicalSymtomology cirmSymtomology = new MedicalSymtomology();
            //shipPC = cirmBL.GetCIRMPatientDetailsByCrew(ID, int.Parse(Session["VesselID"].ToString()));

            cirmPoco = cirmBL.GetCIRMPatientDetailsByCrew(ID, int.Parse(Session["VesselID"].ToString()));

            if (cirmPoco.CIRMId > 0)
            {
                cirmVitalsPoco = cirmBL.GetVitalStatisticsByCIRM(cirmPoco.CIRMId).OrderByDescending(c => c.ID).FirstOrDefault();
                cirmSymtomologyPoco = cirmBL.GetMedicalSymtomologyByCIRM(cirmPoco.CIRMId).OrderByDescending(c => c.ID).FirstOrDefault();

            }

            #region -- CIRM--
            cirm.CIRMId = cirmPoco.CIRMId;


            #region Vessel Details
            cirm.VesselId = cirmPoco.VesselId;

            cirm.NameOfVessel = cirmPoco.NameOfVessel;
            cirm.RadioCallSign = cirmPoco.RadioCallSign;

            #endregion

            #region Voyage Details
            cirm.DateOfReportingGMT = cirmPoco.DateOfReportingGMT;
            cirm.TimeOfReportingGMT = cirmPoco.TimeOfReportingGMT;
            cirm.LocationOfShip = cirmPoco.LocationOfShip;
            cirm.Cousre = cirmPoco.Cousre;
            cirm.Speed = cirmPoco.Speed;
            cirm.PortofDeparture = cirmPoco.PortofDeparture;
            cirm.DateOfDeparture = cirmPoco.DateOfDeparture;
            cirm.TimeOfReportingGMT = cirmPoco.TimeOfReportingGMT;
            cirm.PortofDestination = cirmPoco.PortofDestination;
            cirm.ETADateGMT = cirmPoco.ETADateGMT;
            cirm.ETATimeGMT = cirmPoco.ETATimeGMT;
            cirm.EstimatedTimeOfarrivalhrs = cirmPoco.EstimatedTimeOfarrivalhrs;
            cirm.AgentDetails = cirmPoco.AgentDetails;
            cirm.NearestPort = cirmPoco.NearestPort;
            cirm.NearestPortETADateGMT = cirmPoco.NearestPortETADateGMT;
            cirm.NearestPortETATimeGMT = cirmPoco.NearestPortETATimeGMT;
            cirm.OtherPossiblePort = cirmPoco.OtherPossiblePort;
            cirm.OtherPortETADateGMT = cirmPoco.OtherPortETADateGMT;
            cirm.OtherPortETATimeGMT = cirmPoco.OtherPortETATimeGMT;
            #endregion

            #region Weather Details

            cirm.WindDirection = cirmPoco.WindDirection;
            cirm.BeaufortScale = cirmPoco.BeaufortScale;
            cirm.WindSpeed = cirmPoco.WindSpeed;
            cirm.SeaState = cirmPoco.SeaState;
            cirm.WaveHeight = cirmPoco.WaveHeight;
            cirm.Swell = cirmPoco.Swell;
            cirm.WeatherCondition = cirmPoco.WeatherCondition;
            cirm.WeatherVisibility = cirmPoco.WeatherVisibility;
            cirm.Weather = cirmPoco.Weather;
            #endregion

            #region Crew Details 
            cirm.CrewId = cirmPoco.CrewId;
            cirm.Nationality = cirmPoco.Nationality;
            cirm.Qualification = cirmPoco.Qualification;
            cirm.Addiction = cirmPoco.Addiction;
            cirm.Ethinicity = cirmPoco.Ethinicity;
            cirm.Frequency = cirmPoco.Frequency;
            cirm.Sex = cirmPoco.Sex;
            cirm.Age = cirmPoco.Age;
            cirm.JoiningDate = cirmPoco.JoiningDate;

            #endregion

            #region Others 
            cirm.LocationAndTypeOfPain = cirmPoco.LocationAndTypeOfPain;
            cirm.WhereAndHowAccidentIsCausedCHK = cirmPoco.WhereAndHowAccidentIsCausedCHK;
            cirm.UploadMedicalHistory = cirmPoco.UploadMedicalHistory;
            cirm.UploadMedicinesAvailable = cirmPoco.UploadMedicinesAvailable;
            cirm.MedicalProductsAdministered = cirmPoco.MedicalProductsAdministered;
            cirm.WhereAndHowAccidentIsausedARA = cirmPoco.WhereAndHowAccidentIsausedARA;

            cirm.IsEquipmentUploaded = cirmPoco.IsEquipmentUploaded;
            cirm.IsJoiningReportUloaded = cirmPoco.IsJoiningReportUloaded;
            cirm.IsMedicalHistoryUploaded = cirmPoco.IsMedicalHistoryUploaded;
            cirm.IsmedicineUploaded = cirmPoco.IsmedicineUploaded;

            cirm.Category = cirmPoco.Category;
            cirm.SubCategory = cirmPoco.SubCategory;



            #endregion

            #region Past Medical History
            cirm.PastMedicalHistory = cirmPoco.PastMedicalHistory;
            cirm.PastTreatmentGiven = cirmPoco.PastTreatmentGiven;
            cirm.PastRemarks = cirmPoco.PastRemarks;
            cirm.PastMedicineAdministered = cirmPoco.PastMedicineAdministered;
            cirm.PastTeleMedicalAdviceReceived = cirmPoco.PastTeleMedicalAdviceReceived;
            cirm.PastMedicalHistoryPath = cirmPoco.PastMedicalHistoryPath;

            #endregion

            #region Incase of Accident
            cirm.WhereAndHowAccidentOccured = cirmPoco.WhereAndHowAccidentOccured;
            cirm.LocationAndTypeOfInjuryOrBurn = cirmPoco.LocationAndTypeOfInjuryOrBurn;
            cirm.FrequencyOfPain = cirmPoco.FrequencyOfPain;
            cirm.FirstAidGiven = cirmPoco.FirstAidGiven;
            cirm.PercentageOfBurn = cirmPoco.PercentageOfBurn;

            cirm.PictureUploadPath = cirmPoco.PictureUploadPath;

            #endregion

            #region Severity of Pains
            cirm.NoHurt = cirmPoco.NoHurt;
            cirm.HurtLittleBit = cirmPoco.HurtLittleBit;
            cirm.HurtsLittleMore = cirmPoco.HurtsLittleMore;
            cirm.HurtsEvenMore = cirmPoco.HurtsEvenMore;
            cirm.HurtsWholeLot = cirmPoco.HurtsWholeLot;
            cirm.HurtsWoest = cirmPoco.HurtsWoest;
            cirm.SeverityOfPain = cirmPoco.SeverityOfPain;
            #endregion

            #region Upload images
            cirm.JoiningMedical = cirmPoco.JoiningMedical;
            cirm.JoiningMedicalPath = cirmPoco.JoiningMedicalPath;
            cirm.MedicineAvailableOnBoard = cirmPoco.MedicineAvailableOnBoard;
            cirm.MedicineAvailableOnBoardPath = cirmPoco.MedicineAvailableOnBoardPath;
            cirm.MedicalEquipmentOnBoard = cirmPoco.MedicalEquipmentOnBoard;
            cirm.MedicalEquipmentOnBoardPath = cirmPoco.MedicalEquipmentOnBoardPath;
            cirm.MedicalHistoryUpload = cirmPoco.MedicalHistoryUpload;
            cirm.MedicalHistoryPath = cirmPoco.MedicalHistoryPath;
            cirm.WorkAndRestHourLatestRecord = cirmPoco.WorkAndRestHourLatestRecord;
            cirm.WorkAndRestHourLatestRecordPath = cirmPoco.WorkAndRestHourLatestRecordPath;
            cirm.PreExistingMedicationPrescription = cirmPoco.PreExistingMedicationPrescription;
            #endregion

            #endregion

            #region -- Vital Params--
            cirmVitals.ID = cirmVitalsPoco.ID;
            cirmVitals.CIRMId = cirmVitalsPoco.CIRMId;
            cirmVitals.ObservationDate = cirmVitalsPoco.ObservationDate;
            cirmVitals.ObservationTime = cirmVitalsPoco.ObservationTime;
            cirmVitals.Pulse = cirmVitalsPoco.Pulse;
            cirmVitals.RespiratoryRate = cirmVitalsPoco.RespiratoryRate;
            cirmVitals.OxygenSaturation = cirmVitalsPoco.OxygenSaturation;
            cirmVitals.Himoglobin = cirmVitalsPoco.Himoglobin;
            cirmVitals.Creatinine = cirmVitalsPoco.Creatinine;
            cirmVitals.Bilirubin = cirmVitalsPoco.Bilirubin;
            cirmVitals.Temperature = cirmVitalsPoco.Temperature;
            cirmVitals.Systolic = cirmVitalsPoco.Systolic;
            cirmVitals.Diastolic = cirmVitalsPoco.Diastolic;
            cirmVitals.Fasting = cirmVitalsPoco.Fasting;
            cirmVitals.Regular = cirmVitalsPoco.Regular;
            #endregion


            #region -- Medical Symtomology --

            cirmSymtomology.ID = cirmSymtomologyPoco.ID;
            cirmSymtomology.CIRMId = cirmSymtomologyPoco.CIRMId;
            cirmSymtomology.ObservationDate = cirmSymtomologyPoco.ObservationDate;
            cirmSymtomology.ObservationTime = cirmSymtomologyPoco.ObservationTime;
            cirmSymtomology.Vomiting = cirmSymtomologyPoco.Vomiting;
            cirmSymtomology.FrequencyOfVomiting = cirmSymtomologyPoco.FrequencyOfVomiting;
            cirmSymtomology.Fits = cirmSymtomologyPoco.Fits;
            cirmSymtomology.FrequencyOfFits = cirmSymtomologyPoco.FrequencyOfFits;
            cirmSymtomology.Giddiness = cirmSymtomologyPoco.Giddiness;
            cirmSymtomology.FrequencyOfGiddiness = cirmSymtomologyPoco.FrequencyOfGiddiness;
            cirmSymtomology.Lethargy = cirmSymtomologyPoco.Lethargy;
            cirmSymtomology.FrequencyOfLethargy = cirmSymtomologyPoco.FrequencyOfLethargy;
            cirmSymtomology.SymptomologyDetails = cirmSymtomologyPoco.SymptomologyDetails;
            cirmSymtomology.MedicinesAdministered = cirmSymtomologyPoco.MedicinesAdministered;
            cirmSymtomology.AnyOtherRelevantInformation = cirmSymtomologyPoco.AnyOtherRelevantInformation;

            #endregion

            cirm.VitalStatistics = cirmVitals;
            cirm.Symtomology = cirmSymtomology;


            return Json(cirm, JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// Added on 29th Jan 2022 @BK
        /// </summary>
        /// <param name="ID"></param>
        /// <returns></returns>
        [HttpGet]
        public JsonResult GetCIRMPatientDetailsByCrewNew(int ID)
        {
            CIRMBL cirmBL                               = new CIRMBL();
            CIRMPOCO cirmPoco                           = new CIRMPOCO();
            VitalStatisticsPOCO cirmVitalsPoco          = new VitalStatisticsPOCO();
            MedicalSymtomologyPOCO cirmSymtomologyPoco  = new MedicalSymtomologyPOCO();
            CIRM cirm                                   = new CIRM();
            VitalStatistics cirmVitals                  = new VitalStatistics();
            MedicalSymtomology cirmSymtomology          = new MedicalSymtomology();
            cirmPoco                                    = cirmBL.GetCIRMPatientDetailsByCrewNew(ID, int.Parse(Session["VesselID"].ToString()));

            if (cirmPoco.CIRMId > 0)
            {
                cirmVitalsPoco = cirmBL.GetVitalStatisticsByCIRM(cirmPoco.CIRMId).OrderByDescending(c => c.ID).FirstOrDefault();
                //cirmSymtomologyPoco = cirmBL.GetMedicalSymtomologyByCIRM(cirmPoco.CIRMId).OrderByDescending(c => c.ID).FirstOrDefault();

            }

            cirm.CIRMId = cirmPoco.CIRMId;
            #region  CIRM

            #region Vessel Details
            cirm.VesselId = cirmPoco.VesselId;

            cirm.NameOfVessel = cirmPoco.NameOfVessel;
            cirm.RadioCallSign = cirmPoco.RadioCallSign;

            #endregion

            #region Voyage Details
            cirm.DateOfReportingGMT = cirmPoco.DateOfReportingGMT;
            cirm.TimeOfReportingGMT = cirmPoco.TimeOfReportingGMT;
            cirm.LocationOfShip = cirmPoco.LocationOfShip;
            cirm.Cousre = cirmPoco.Cousre;
            cirm.Speed = cirmPoco.Speed;
            cirm.PortofDeparture = cirmPoco.PortofDeparture;
            cirm.DateOfDeparture = cirmPoco.DateOfDeparture;
            cirm.TimeOfReportingGMT = cirmPoco.TimeOfReportingGMT;
            cirm.PortofDestination = cirmPoco.PortofDestination;
            cirm.ETADateGMT = cirmPoco.ETADateGMT;
            cirm.ETATimeGMT = cirmPoco.ETATimeGMT;
            cirm.EstimatedTimeOfarrivalhrs = cirmPoco.EstimatedTimeOfarrivalhrs;
            cirm.AgentDetails = cirmPoco.AgentDetails;
            cirm.NearestPort = cirmPoco.NearestPort;
            cirm.NearestPortETADateGMT = cirmPoco.NearestPortETADateGMT;
            cirm.NearestPortETATimeGMT = cirmPoco.NearestPortETATimeGMT;
            cirm.OtherPossiblePort = cirmPoco.OtherPossiblePort;
            cirm.OtherPortETADateGMT = cirmPoco.OtherPortETADateGMT;
            cirm.OtherPortETATimeGMT = cirmPoco.OtherPortETATimeGMT;
            #endregion

            #region Weather Details

            cirm.WindDirection = cirmPoco.WindDirection;
            cirm.BeaufortScale = cirmPoco.BeaufortScale;
            cirm.WindSpeed = cirmPoco.WindSpeed;
            cirm.SeaState = cirmPoco.SeaState;
            cirm.WaveHeight = cirmPoco.WaveHeight;
            cirm.Swell = cirmPoco.Swell;
            cirm.WeatherCondition = cirmPoco.WeatherCondition;
            cirm.WeatherVisibility = cirmPoco.WeatherVisibility;
            cirm.Weather = cirmPoco.Weather;
            #endregion

            #region Crew Details 
            cirm.CrewId = cirmPoco.CrewId;
            cirm.Nationality = cirmPoco.Nationality;
            cirm.Qualification = cirmPoco.Qualification;
            cirm.Addiction = cirmPoco.Addiction;
            cirm.Ethinicity = cirmPoco.Ethinicity;
            cirm.Frequency = cirmPoco.Frequency;
            cirm.Sex = cirmPoco.Sex;
            cirm.Age = cirmPoco.Age;
            cirm.JoiningDate = cirmPoco.JoiningDate;
            cirm.DateOfOffWork = cirmPoco.DateOfOffWork;
            cirm.TimeOfOffWork = cirmPoco.TimeOfOffWork;
            cirm.DateOfResumeWork = cirmPoco.DateOfResumeWork;
            cirm.TimeOfResumeWork = cirmPoco.TimeOfResumeWork;

            #endregion

            #region Injury or Illness

            cirm.DateOfInjuryOrIllness = cirmPoco.DateOfInjuryOrIllness;
            cirm.TimeOfInjuryOrIllness = cirmPoco.TimeOfInjuryOrIllness;
            cirm.DateOfFirstExamination = cirmPoco.DateOfFirstExamination;
            cirm.TimeOfFirstExamination = cirmPoco.TimeOfFirstExamination;
            cirm.IsInjuryorIllnessWorkRelated = cirmPoco.IsInjuryorIllnessWorkRelated;
            cirm.IsUnconsciousByInjuryOrIllness = cirmPoco.IsUnconsciousByInjuryOrIllness;
            cirm.HowLongWasUnconscious = cirmPoco.HowLongWasUnconscious;
            cirm.LevelOfConsciousness = cirmPoco.LevelOfConsciousness;
            cirm.IsAccidentOrIlness = cirmPoco.IsAccidentOrIlness;

            #region Incase of Accident
            if (cirm.IsAccidentOrIlness == 1)
            {

                cirm.WhereAndHowAccidentOccured = cirmPoco.WhereAndHowAccidentOccured;
                cirm.LocationAndTypeOfInjuryOrBurn = cirmPoco.LocationAndTypeOfInjuryOrBurn;
                cirm.FirstAidGiven = cirmPoco.FirstAidGiven;
                cirm.TypeOfBunrn = cirmPoco.TypeOfBurn;
                cirm.DegreeOfBurn = cirmPoco.DegreeOfBurn;
                cirm.PercentageOfBurn = cirmPoco.PercentageOfBurn;


            }
            //cirm.PictureUploadPath = cirmPoco.PictureUploadPath;

            #endregion
            #region Illness
            if (cirm.IsAccidentOrIlness == 2)
            {
                #region -- Medical Symtomology --
                cirmSymtomologyPoco = cirmBL.GetMedicalSymtomologyByCIRM(cirmPoco.CIRMId).OrderByDescending(c => c.ID).FirstOrDefault();
                cirmSymtomology.ID = cirmSymtomologyPoco.ID;
                cirmSymtomology.CIRMId = cirmSymtomologyPoco.CIRMId;
                cirmSymtomology.ObservationDate = cirmSymtomologyPoco.ObservationDate;
                cirmSymtomology.ObservationTime = cirmSymtomologyPoco.ObservationTime;
                cirmSymtomology.Vomiting = cirmSymtomologyPoco.Vomiting;
                cirmSymtomology.FrequencyOfVomiting = cirmSymtomologyPoco.FrequencyOfVomiting;
                cirmSymtomology.Fits = cirmSymtomologyPoco.Fits;
                cirmSymtomology.FrequencyOfFits = cirmSymtomologyPoco.FrequencyOfFits;
                cirmSymtomology.Giddiness = cirmSymtomologyPoco.Giddiness;
                cirmSymtomology.FrequencyOfGiddiness = cirmSymtomologyPoco.FrequencyOfGiddiness;
                cirmSymtomology.Lethargy = cirmSymtomologyPoco.Lethargy;
                cirmSymtomology.FrequencyOfLethargy = cirmSymtomologyPoco.FrequencyOfLethargy;
                cirmSymtomology.SymptomologyDetails = cirmSymtomologyPoco.SymptomologyDetails;
                cirmSymtomology.MedicinesAdministered = cirmSymtomologyPoco.MedicinesAdministered;
                cirmSymtomology.AnyOtherRelevantInformation = cirmSymtomologyPoco.AnyOtherRelevantInformation;
                cirmSymtomology.Ailment = cirmSymtomologyPoco.Ailment;

                #endregion
                cirm.Symtomology = cirmSymtomology;

            }

            #endregion
            #region Severity of Pains
            //cirm.NoHurt = cirmPoco.NoHurt;
            //cirm.HurtLittleBit = cirmPoco.HurtLittleBit;
            //cirm.HurtsLittleMore = cirmPoco.HurtsLittleMore;
            //cirm.HurtsEvenMore = cirmPoco.HurtsEvenMore;
            //cirm.HurtsWholeLot = cirmPoco.HurtsWholeLot;
            //cirm.HurtsWoest = cirmPoco.HurtsWoest;
            cirm.SeverityOfPain = cirmPoco.SeverityOfPain;
            cirm.FrequencyOfPain = cirmPoco.FrequencyOfPain;
            #endregion

            #endregion

            #region History and Medication Taken
            cirm.PastMedicalHistory = cirmPoco.PastMedicalHistory;
            List<CIRMMedicationTaken> cirmMedicationList = new List<CIRMMedicationTaken>();
            
            foreach(CIRMMedicationTakenPOCO mtPoco in cirmPoco.MedicationTakenList)
            {
                CIRMMedicationTaken cirmMedication = new CIRMMedicationTaken();
                cirmMedication.MedicationId = mtPoco.MedicationId;
                cirmMedication.CIRMId = mtPoco.CIRMId;
                cirmMedication.PrescriptionName = mtPoco.PrescriptionName;
                cirmMedication.MedicalConditionBeingTreated = mtPoco.MedicalConditionBeingTreated;
                cirmMedication.HowOftenMedicationTaken = mtPoco.HowOftenMedicationTaken;

                cirmMedicationList.Add(cirmMedication);
            }
            cirm.MedicationTakenList = cirmMedicationList;
            #endregion

            #region Vital Params--
            cirmVitals.ID = cirmVitalsPoco.ID;
            cirmVitals.CIRMId = cirmVitalsPoco.CIRMId;
            cirmVitals.ObservationDate = cirmVitalsPoco.ObservationDate;
            cirmVitals.ObservationTime = cirmVitalsPoco.ObservationTime;
            cirmVitals.Pulse = cirmVitalsPoco.Pulse;
            cirmVitals.RespiratoryRate = cirmVitalsPoco.RespiratoryRate;
            cirmVitals.OxygenSaturation = cirmVitalsPoco.OxygenSaturation;
            cirmVitals.Himoglobin = cirmVitalsPoco.Himoglobin;
            cirmVitals.Creatinine = cirmVitalsPoco.Creatinine;
            cirmVitals.Bilirubin = cirmVitalsPoco.Bilirubin;
            cirmVitals.Temperature = cirmVitalsPoco.Temperature;
            cirmVitals.Systolic = cirmVitalsPoco.Systolic;
            cirmVitals.Diastolic = cirmVitalsPoco.Diastolic;
            cirmVitals.Fasting = cirmVitalsPoco.Fasting;
            cirmVitals.Regular = cirmVitalsPoco.Regular;

            cirm.VitalStatistics = cirmVitals;
            #endregion

            #region Findings Affected Areas
            cirm.AffectedParts  = cirmPoco.AffectedParts;
            cirm.BloodType      = cirmPoco.BloodType;
            cirm.BloodQuantity  = cirmPoco.BloodQuantity;
            cirm.FluidType      = cirmPoco.FluidType;
            cirm.FluidQuantity  = cirmPoco.FluidQuantity;
            cirm.SkinDetails    = cirmPoco.SkinDetails;
            cirm.PupilsDetails  = cirmPoco.PupilsDetails;

            #endregion

            #region Telemedical Consultation

            cirm.TeleMedicalConsultation        = cirmPoco.TeleMedicalConsultation;
            cirm.TeleMedicalContactDate         = cirmPoco.TeleMedicalContactDate;
            cirm.TeleMedicalContactTime         = cirmPoco.TeleMedicalContactTime;
            cirm.ModeOfCommunication            = cirmPoco.ModeOfCommunication;
            cirm.NameOfTelemedicalConsultant    = cirmPoco.NameOfTelemedicalConsultant;
            cirm.DetailsOfTreatmentAdvised      = cirmPoco.DetailsOfTreatmentAdvised;
            #endregion

            #region Medical Treatment Given Onboard

            cirm.MedicalTreatmentGivenOnboard           = cirmPoco.MedicalTreatmentGivenOnboard;
            cirm.PriorRadioMedicalAdvice                = cirmPoco.PriorRadioMedicalAdvice;
            cirm.AfterRadioMedicalAdvice                = cirmPoco.AfterRadioMedicalAdvice;
            cirm.HowIsPatientRespondingToTreatmentGiven = cirmPoco.HowIsPatientRespondingToTreatmentGiven;
            cirm.DoesPatientNeedRemoveFromVessel        = cirmPoco.DoesPatientNeedRemoveFromVessel;
            cirm.NeedRemovalDesc                        = cirmPoco.NeedRemovalDesc;
            cirm.NeedRemovalToPort                      = cirmPoco.NeedRemovalToPort;
            cirm.AdditionalNotes                        = cirmPoco.AdditionalNotes;
            #endregion

            #region Upload images
            cirm.JoiningMedical                     = cirmPoco.JoiningMedical;
            cirm.JoiningMedicalPath                 = cirmPoco.JoiningMedicalPath;
            cirm.MedicineAvailableOnBoard           = cirmPoco.MedicineAvailableOnBoard;
            cirm.MedicineAvailableOnBoardPath       = cirmPoco.MedicineAvailableOnBoardPath;
            cirm.MedicalEquipmentOnBoard            = cirmPoco.MedicalEquipmentOnBoard;
            cirm.MedicalEquipmentOnBoardPath        = cirmPoco.MedicalEquipmentOnBoardPath;
            cirm.MedicalHistoryUpload               = cirmPoco.MedicalHistoryUpload;
            cirm.MedicalHistoryPath                 = cirmPoco.MedicalHistoryPath;
            cirm.WorkAndRestHourLatestRecord        = cirmPoco.WorkAndRestHourLatestRecord;
            cirm.WorkAndRestHourLatestRecordPath    = cirmPoco.WorkAndRestHourLatestRecordPath;
            cirm.PreExistingMedicationPrescription = cirmPoco.PreExistingMedicationPrescription;
            #endregion

            #endregion CIRM


            return Json(cirm, JsonRequestBehavior.AllowGet);
            //return Json(cirmPoco, JsonRequestBehavior.AllowGet);
        }


        /// <summary>
        /// Added on 12th Jan 2022
        /// Call Ajax method in CIRMjs refered in PatientDetails under CrewHealth
        /// </summary>
        /// <param name="cirmId"></param>
        /// <returns></returns>
        public JsonResult LoadCIRMVitalParamsData(string cirmId)
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
                length = 500;
            }

            if (start == 0)
            {
                pageIndex = 1;
            }
            else
            {
                pageIndex = (start / length) + 1;
            }

            CIRMBL bL = new CIRMBL();
            int totalrecords = 0;

            List<VitalStatisticsPOCO> pocoList = new List<VitalStatisticsPOCO>();
            pocoList = bL.GetAllCIRMVitalParamsPageWise(pageIndex, ref totalrecords, length, Convert.ToInt32(cirmId));

            var data = pocoList;
            return Json(new { draw = draw, recordsFiltered = totalrecords, recordsTotal = totalrecords, data = data }, JsonRequestBehavior.AllowGet);
        }
        /// <summary>
        /// Added on 12th Jan 2022
        /// Call Ajax method in CIRMjs refered in PatientDetails under CrewHealth
        /// </summary>
        /// <param name="cirmId"></param>
        /// <returns></returns>
        public JsonResult LoadCIRMSymtomologyData(string cirmId)
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
                length = 500;
            }

            if (start == 0)
            {
                pageIndex = 1;
            }
            else
            {
                pageIndex = (start / length) + 1;
            }

            CIRMBL bL = new CIRMBL();
            int totalrecords = 0;

            List<MedicalSymtomologyPOCO> pocoList = new List<MedicalSymtomologyPOCO>();
            pocoList = bL.GetAllCIRMSymtomologyPageWise(pageIndex, ref totalrecords, length, Convert.ToInt32(cirmId));

            var data = pocoList;
            return Json(new { draw = draw, recordsFiltered = totalrecords, recordsTotal = totalrecords, data = data }, JsonRequestBehavior.AllowGet);
        }

        #endregion

        [HttpPost]
        public JsonResult UploadMedicalAdviseFile(string category, string visitDate)
        {
            if (Request.Files.Count > 0)
            {
                try
                {
                    List<string> returnMsg = new List<string>();
                    string fileName = String.Empty; //Path.GetFileNameWithoutExtension(postedFile.FileName);
                    fileName = category +"_" + Convert.ToInt32(Session["UserID"].ToString()) +"_" + visitDate;//Useless

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
                        string path = Server.MapPath(ConfigurationManager.AppSettings["MedicalAdviseFilePath"].ToString());
                        string filePath = ConfigurationManager.AppSettings["MedicalAdviseFilePath"].ToString();
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

                    returnMsg.Add(category + " File Uploaded Successfully!");


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

        [HttpPost]
        public JsonResult AddMedicalAdvise(MedicalAdvise medicalAdvise)
        {
            MedicalAdviseBL mAdviseBl = new MedicalAdviseBL();
            MedicalAdvisePOCO mAdvisePo = new MedicalAdvisePOCO();
            string crewUserId = string.Empty;

            mAdvisePo.TestDate = medicalAdvise.TestDate;
            mAdvisePo.Path = medicalAdvise.Path;
            mAdvisePo.CrewId = Convert.ToInt32(Session["UserID"].ToString());

            mAdvisePo.Diagnosis                     = medicalAdvise.Diagnosis;
            mAdvisePo.TreatmentPrescribed           = medicalAdvise.TreatmentPrescribed;
            mAdvisePo.IsIllnessDueToAnAccident      = medicalAdvise.IsIllnessDueToAnAccident;
            mAdvisePo.MedicinePrescribed            = medicalAdvise.MedicinePrescribed;
            mAdvisePo.RequireHospitalisation        = medicalAdvise.RequireHospitalisation;
            mAdvisePo.RequireSurgery                = medicalAdvise.RequireSurgery;
            mAdvisePo.IsFitForDuty                  = medicalAdvise.IsFitForDuty;
            mAdvisePo.FitForDutyComments            = medicalAdvise.FitForDutyComments;
            mAdvisePo.IsMayJoinOnBoardButLightDuty  = medicalAdvise.IsMayJoinOnBoardButLightDuty;
            mAdvisePo.MayJoinOnBoardDays            = medicalAdvise.MayJoinOnBoardDays;
            mAdvisePo.MayJoinOnBoardComments        = medicalAdvise.MayJoinOnBoardComments;
            mAdvisePo.IsUnfitForDuty                = medicalAdvise.IsUnfitForDuty;
            mAdvisePo.UnfitForDutyComments          = medicalAdvise.UnfitForDutyComments;
            mAdvisePo.FutureFitnessAndRestrictions  = medicalAdvise.FutureFitnessAndRestrictions;
            mAdvisePo.DischargeSummary              = medicalAdvise.DischargeSummary;
            mAdvisePo.FollowUpAction                = medicalAdvise.FollowUpAction;
            mAdvisePo.DoctorName                    = medicalAdvise.DoctorName;
            mAdvisePo.DoctorContactNo               = medicalAdvise.DoctorContactNo;
            mAdvisePo.DoctorEmail                   = medicalAdvise.DoctorEmail;
            mAdvisePo.DoctorSpeciality              = medicalAdvise.DoctorSpeciality;
            mAdvisePo.DoctorMedicalRegNo            = medicalAdvise.DoctorMedicalRegNo;
            mAdvisePo.DoctorCountry                 = medicalAdvise.DoctorCountry;
            mAdvisePo.NameOfHospital                = medicalAdvise.NameOfHospital;

            if(medicalAdvise.ExaminationForMedicalAdviseList.Count() > 0)
            {
                foreach(ExaminationForMedicalAdvise exmtnMedAdvise in medicalAdvise.ExaminationForMedicalAdviseList)
                {
                    ExaminationForMedicalAdvisePOCO exmtnMedAdvisePo = new ExaminationForMedicalAdvisePOCO();

                    exmtnMedAdvisePo.Id = exmtnMedAdvise.Id;
                    exmtnMedAdvisePo.Examination = exmtnMedAdvise.Examination;
                    exmtnMedAdvisePo.ExaminationDate = exmtnMedAdvise.ExaminationDate;
                    exmtnMedAdvisePo.ExaminationPath = exmtnMedAdvise.ExaminationPath;

                    mAdvisePo.ExaminationForMedicalAdviseList.Add(exmtnMedAdvisePo);
                }
               
            }


            return Json(mAdviseBl.SaveMedicalAdvise(mAdvisePo), JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult GetMedicalAdviseDetails(string adviseId)
        {
            MedicalAdvise mAdvise = new MedicalAdvise();
            MedicalAdvisePOCO madvisePoco = new MedicalAdvisePOCO();
            MedicalAdviseBL mAdviseBl = new MedicalAdviseBL();

            List<ExaminationForMedicalAdvise> exmtnMedAdviseList = new List<ExaminationForMedicalAdvise>();

            madvisePoco = mAdviseBl.GetMedicalAdviseById(Convert.ToInt32(adviseId));

            mAdvise.Id                              = madvisePoco.Id;
            mAdvise.Diagnosis                       = madvisePoco.Diagnosis;
            mAdvise.TreatmentPrescribed             = madvisePoco.TreatmentPrescribed;
            mAdvise.IsIllnessDueToAnAccident        = madvisePoco.IsIllnessDueToAnAccident;
            mAdvise.MedicinePrescribed              = madvisePoco.MedicinePrescribed;
            mAdvise.RequireHospitalisation          = madvisePoco.RequireHospitalisation;
            mAdvise.RequireSurgery                  = madvisePoco.RequireSurgery;
            mAdvise.IsFitForDuty                    = madvisePoco.IsFitForDuty;
            mAdvise.FitForDutyComments              = madvisePoco.FitForDutyComments;
            mAdvise.IsMayJoinOnBoardButLightDuty    = madvisePoco.IsMayJoinOnBoardButLightDuty;
            mAdvise.MayJoinOnBoardDays              = madvisePoco.MayJoinOnBoardDays;
            mAdvise.MayJoinOnBoardComments          = madvisePoco.MayJoinOnBoardComments;
            mAdvise.IsUnfitForDuty                  = madvisePoco.IsUnfitForDuty;
            mAdvise.UnfitForDutyComments            = madvisePoco.UnfitForDutyComments;
            mAdvise.FutureFitnessAndRestrictions    = madvisePoco.FutureFitnessAndRestrictions;
            mAdvise.DischargeSummary                = madvisePoco.DischargeSummary;
            mAdvise.FollowUpAction                  = madvisePoco.FollowUpAction;
            mAdvise.DoctorName                      = madvisePoco.DoctorName;
            mAdvise.DoctorContactNo                 = madvisePoco.DoctorContactNo;
            mAdvise.DoctorEmail                     = madvisePoco.DoctorEmail;
            mAdvise.DoctorSpeciality                = madvisePoco.DoctorSpeciality;
            mAdvise.DoctorMedicalRegNo              = madvisePoco.DoctorMedicalRegNo;
            mAdvise.DoctorCountry                   = madvisePoco.DoctorCountry;
            mAdvise.NameOfHospital                  = madvisePoco.NameOfHospital;
            mAdvise.Path                            = madvisePoco.Path;
            mAdvise.TestDate                        = madvisePoco.TestDate;

            mAdvise.CrewId                          = madvisePoco.CrewId;
            mAdvise.CrewName                        = madvisePoco.CrewName;
            mAdvise.RankName                        = madvisePoco.RankName;
            mAdvise.Gender                          = madvisePoco.Gender;
            mAdvise.Nationality                     = madvisePoco.Nationality;
            mAdvise.DOB                             = madvisePoco.DOB;
            mAdvise.PassportOrSeaman                = madvisePoco.PassportOrSeaman;
            mAdvise.VesselName                      = madvisePoco.VesselName;
            mAdvise.VesselSubType                   = madvisePoco.VesselSubType;
            mAdvise.FlagOfShip                      = madvisePoco.FlagOfShip;
            mAdvise.IMONumber                       = madvisePoco.IMONumber;
            mAdvise.CompanyOwner                    = madvisePoco.CompanyOwner;

            if(madvisePoco.ExaminationForMedicalAdviseList.Count() > 0)
            {
                foreach(ExaminationForMedicalAdvisePOCO emaPo in madvisePoco.ExaminationForMedicalAdviseList)
                {
                    ExaminationForMedicalAdvise ema = new ExaminationForMedicalAdvise();

                    ema.Id = emaPo.Id;
                    ema.MedicalAdviseId = emaPo.MedicalAdviseId;
                    ema.Examination = emaPo.Examination;
                    ema.ExaminationPath = emaPo.ExaminationPath;
                    ema.ExaminationDate = emaPo.ExaminationDate;

                    exmtnMedAdviseList.Add(ema);
                }
            }
            mAdvise.ExaminationForMedicalAdviseList = exmtnMedAdviseList;


            return Json(mAdvise, JsonRequestBehavior.AllowGet);
            //return Json(cirmPoco, JsonRequestBehavior.AllowGet);
        }

        public FileResult Download(string filePath)
        {
            string path = Server.MapPath(filePath);
            //var folderPath = Path.Combine(path, catName);
            //filePath = Path.Combine(path, filePath);
            filePath = path;
            var memory = new MemoryStream();
            using (var stream = new FileStream(filePath, FileMode.Open))
            {
                stream.CopyToAsync(memory);
            }
            memory.Position = 0;
            var ext = Path.GetExtension(filePath).ToLowerInvariant();
            return File(memory, GetMimeTypes()[ext], Path.GetFileName(filePath));
        }
        private Dictionary<string, string> GetMimeTypes()
        {
            return new Dictionary<string, string>
            {
                {".txt", "text/plain"},
                {".pdf", "application/pdf"},
                {".doc", "application/vnd.ms-word"},
                {".docx", "application/vnd.ms-word"},
                {".png", "image/png"},
                {".jpg", "image/jpeg"},
                //{".xlsx", "application/vnd.openxmlformats officedocument.spreadsheetml.sheet"},
                {".jpeg", "image/jpeg"},
                {".gif", "image/gif"},
                {".csv", "text/csv"}
            };
        }

    }
}