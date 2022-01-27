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
            return View();
        }
        public ActionResult DoctorVisit()
        {
            return View();
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
    }
}