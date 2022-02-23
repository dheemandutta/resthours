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
using TM.Base.Common;

using System.Configuration;

using System.IO;

namespace TM.RestHour.Controllers
{
    public class WellBeingController : Controller
    {
        // GET: WellBeing
        public ActionResult WellBeingHealth()
        {
            return View();
        }

        public ActionResult WellBeingMentalHealth()
        {
            return View();
        }

        [TraceFilterAttribute]
        public ActionResult WellBeingWorkAndRestHours()
        {
            return View();
        }

        [TraceFilterAttribute]
        public ActionResult MonthlyWorkHours(string crewId, string monthYear)
        {
            //GetAllCrewForTimeSheet();

            if(Request.QueryString["crew"] != null && String.IsNullOrEmpty(crewId))
                crewId = Request.QueryString["crew"].ToString();

            if (Request.QueryString["monthYear"] != null && String.IsNullOrEmpty(monthYear))
                monthYear = Request.QueryString["monthYear"];

            CrewTimesheetViewModel crewtimesheetVM = new CrewTimesheetViewModel();
            Crew c = new Crew();
            c.ID = int.Parse(crewId);

            crewtimesheetVM.Crew = c;
            crewtimesheetVM.SelectedMonthYear = monthYear;


            return View(crewtimesheetVM);
           
        }

        public JsonResult GetNCDetails(string monthyear)
        {
            ReportsBL reportsBL = new ReportsBL();
            ReportsPOCO reportsPC = new ReportsPOCO();
            Reports reports = new Reports();

            string month = monthyear.Substring(0, monthyear.Length - 4);

            int mon = (int)((Months)Enum.Parse(typeof(Months), month.Trim()));
            //reportsPC.MonthName = month;
            int year = int.Parse(Utilities.GetLast(monthyear, 4));


            //string month = reports.SelectedMonthYear.Substring(0, reports.SelectedMonthYear.Length - 4);

            //reportsPC.Month = (int)((Months)Enum.Parse(typeof(Months), month.Trim()));
            //reportsPC.MonthName = month;
            //reportsPC.Year = int.Parse(Utilities.GetLast(reports.SelectedMonthYear, 4));
            //reportsPC.CrewID = reports.CrewID;
            reportsPC.NCDetailsID = reports.NCDetailsID;

            List<ReportsPOCO> reportsList = new List<ReportsPOCO>();
            reportsList = reportsBL.GetNCDetails(mon, year, int.Parse(Session["VesselID"].ToString()), int.Parse(Session["UserID"].ToString()));
            //string[] bookedHours = new string[31];
            //int row = 0;
            //foreach (ReportsPOCO item in reportsList)
            //{
            //    bookedHours[row] = item.Hours;
            //    row++;
            //}
            var data = reportsList;



            return Json(data, JsonRequestBehavior.AllowGet);
            //return Json(new { BookedHours = data }, JsonRequestBehavior.AllowGet);
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




        public JsonResult GetMonthlyDataForWeb(Reports reports)
        {
            ReportsBL reportsBL = new ReportsBL();
            ReportsPOCO reportsPC = new ReportsPOCO();

            string month = reports.SelectedMonthYear.Substring(0, reports.SelectedMonthYear.Length - 4);

            reportsPC.Month = (int)((Months)Enum.Parse(typeof(Months), month.Trim()));
            reportsPC.MonthName = month;
            reportsPC.Year = int.Parse(Utilities.GetLast(reports.SelectedMonthYear, 4));
            reportsPC.CrewID = reports.CrewID;

            List<ReportsPOCO> reportsList = new List<ReportsPOCO>();
            reportsList = reportsBL.GetCrewIDFromWorkSessionsForWeb(reportsPC, int.Parse(Session["VesselID"].ToString()));
            //32 to 36
            string[] bookedHours = new string[62];
            int row = 0;
            foreach (ReportsPOCO item in reportsList)
            {
                bookedHours[row] = item.Hours;


                row++;
            }


            var data = reportsList;



            // return Json(data, JsonRequestBehavior.AllowGet);
            return Json(new { BookedHours = data }, JsonRequestBehavior.AllowGet);
        }


        public JsonResult LoadWellBeingHealthData()
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

            WellBeingBL wellBeingBL = new WellBeingBL();
            int totalrecords = 0;

            WellBeingPOCO wellBeingPOCO = new WellBeingPOCO();
            wellBeingPOCO = wellBeingBL.GetWellBeingHealthPageWise(pageIndex, ref totalrecords, length);

            var data = wellBeingPOCO;
            return Json(new { draw = draw, recordsFiltered = totalrecords, totalRecords = totalrecords, data = data }, JsonRequestBehavior.AllowGet);
        }


        [HttpPost]
        public JsonResult GetMedicalAdvise(string crewId)
        {
            MedicalAdvise mAdvise = new MedicalAdvise();
            MedicalAdvisePOCO madvisePoco = new MedicalAdvisePOCO();
            MedicalAdviseBL mAdviseBl = new MedicalAdviseBL();

            List<ExaminationForMedicalAdvise> exmtnMedAdviseList = new List<ExaminationForMedicalAdvise>();

            madvisePoco = mAdviseBl.GetMedicalAdvise(Convert.ToInt32(crewId), mAdvise.TestDate /* as blank date*/);
            //madvisePoco = mAdviseBl.GetAllMedicalAdviseByCrew(Convert.ToInt32(crewId));

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
            mAdvise.CrewName = madvisePoco.CrewName;
            mAdvise.RankName = madvisePoco.RankName;
            mAdvise.Gender = madvisePoco.Gender;
            mAdvise.Nationality = madvisePoco.Nationality;
            mAdvise.DOB = madvisePoco.DOB;
            mAdvise.PassportOrSeaman = madvisePoco.PassportOrSeaman;
            mAdvise.VesselName = madvisePoco.VesselName;
            mAdvise.VesselSubType = madvisePoco.VesselSubType;
            mAdvise.FlagOfShip = madvisePoco.FlagOfShip;
            mAdvise.IMONumber = madvisePoco.IMONumber;
            mAdvise.CompanyOwner = madvisePoco.CompanyOwner;

            if (madvisePoco.ExaminationForMedicalAdviseList.Count() > 0)
            {
                foreach (ExaminationForMedicalAdvisePOCO emaPo in madvisePoco.ExaminationForMedicalAdviseList)
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

        [HttpGet]
        public JsonResult GetJoiningMedicalData(string crewId)
        {
            string path = "/JoiningMedical/";
            Crew file = new Crew();
            CrewPOCO filePo = new CrewPOCO();
            string filePath = "";
            WellBeingBL wbBl = new WellBeingBL();
            filePo = wbBl.GetJoiningMedicalFile(Convert.ToInt32(crewId) );
            filePath = Path.Combine(path, Path.GetFileName( filePo.JoiningMedicalFile));

            //filePath = Path.ChangeExtension(filePo.JoiningMedicalFile, "pdf");
            filePath = Path.ChangeExtension(filePath, "pdf");

            file.JoiningMedicalFileName = Path.GetFileName(filePath);
            //file.JoiningMedicalFileName = filePo.JoiningMedicalFileName;

            //file.JoiningMedicalFile = parentPdfPath + filePath;
            file.JoiningMedicalFile = filePath;
            return Json(file, JsonRequestBehavior.AllowGet);
        }

        [HttpGet]
        public JsonResult GetPrescribedMedicineData(string crewId)
        {
            string path = "/PrescribedMedicineImages/";
            Crew file = new Crew();
            CrewPOCO filePo = new CrewPOCO();
            string filePath = "";
            WellBeingBL wbBl = new WellBeingBL();
            filePo = wbBl.GetPrescribedMedicineFile(Convert.ToInt32(crewId));
            filePath = Path.Combine(path, Path.GetFileName(filePo.JoiningMedicalFile));

            //filePath = Path.ChangeExtension(filePo.JoiningMedicalFile, "pdf");
            filePath = Path.ChangeExtension(filePath, "pdf");

            file.JoiningMedicalFileName = Path.GetFileName(filePath);
            //file.JoiningMedicalFileName = filePo.JoiningMedicalFileName;

            //file.JoiningMedicalFile = parentPdfPath + filePath;
            file.JoiningMedicalFile = filePath;
            return Json(file, JsonRequestBehavior.AllowGet);
        }


        [HttpGet]
        public JsonResult GetMedicalAdviseFileData(string crewId)
        {
            string path = "/MedicalAdviseImages/";
            Crew file = new Crew();
            CrewPOCO filePo = new CrewPOCO();
            string filePath = "";
            WellBeingBL wbBl = new WellBeingBL();
            filePo = wbBl.GetMedicalAdviseFile(Convert.ToInt32(crewId));
            filePath = Path.Combine(path, Path.GetFileName(filePo.JoiningMedicalFile));

            //filePath = Path.ChangeExtension(filePo.JoiningMedicalFile, "pdf");
            filePath = Path.ChangeExtension(filePath, "pdf");

            file.JoiningMedicalFileName = Path.GetFileName(filePath);
            //file.JoiningMedicalFileName = filePo.JoiningMedicalFileName;

            //file.JoiningMedicalFile = parentPdfPath + filePath;
            file.JoiningMedicalFile = filePath;
            return Json(file, JsonRequestBehavior.AllowGet);
        }

    }
}