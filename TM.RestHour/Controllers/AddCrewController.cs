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

using System.Configuration;
using TM.Base.Common;

namespace TM.RestHour.Controllers
{
    [TraceFilterAttribute]
    public class AddCrewController : Controller
    {
        //
        // GET: /AddCrew/
        [TraceFilterAttribute]
        public ActionResult ServiceTerm()
        {
            GetAllCrewForDrp();
            CrewTimesheetViewModel crewtimesheetVM = new CrewTimesheetViewModel();
            Crew crew = new Crew();
            crew.ID = int.Parse(Session["LoggedInUserId"].ToString());
            crewtimesheetVM.Crew = crew;
            return View(crewtimesheetVM);
        }


        [TraceFilterAttribute]
		public ActionResult Index()
        {
            if(Request.QueryString["crew"] != null)
            {
                int crewId = int.Parse(Request.QueryString["crew"].ToString());
                //GetAllCrewByCrewID(Convert.ToString(crewId).ToString());
            }

            return View();
        }

        //[HttpPost]
        //public ActionResult Index()
        //{
        //    if (Request.QueryString["crew"] != null)
        //    {
        //        int crewId = int.Parse(Request.QueryString["crew"].ToString());
        //        //GetAllCrewByCrewID(Convert.ToString(crewId).ToString());
        //    }
        //    return Json(new { result = "Redirect", url = Url.Action("Index", "CreateNewUserAccount", Request.QueryString.ToRouteValues(new { grp = groupId, username = crewUserId, crewId = crew.ID })) });
        //}

        //public ActionResult Index()
        //{

        //    return View();
        //}
        [TraceFilterAttribute]
		public ActionResult CrewDetails()
        {
            GetAllRanksForDrp();
            GetAllDepartmentForDrp();
            return PartialView();
        }


        public ActionResult test()
        {
            GetAllRanksForDrp();
            return View();
        }
		[TraceFilterAttribute]
		public ActionResult Edit()
        {
            return View();
        }


		[TraceFilterAttribute]
		public ActionResult BasicTimesheet()
        {
            //GetAllRanksForDrp();
            return PartialView("BasicTimeSheet");
        }
		[TraceFilterAttribute]
		public PartialViewResult AddEditCrew()
        {
            GetAllRanksForDrp();
            GetAllDepartmentForDrp();
            GetAllCountryForDrp();
            return PartialView("AddEditCrew");
        }
		[TraceFilterAttribute]
		public ActionResult AdvancedTimesheet()
        {
            //GetAllRanksForDrp();
            return PartialView("AdvancedTimesheet");
        }
		[TraceFilterAttribute]
		public ActionResult DailyTimesheet()
        {
            GetAllRanksForDrp();
            return View();
        }
		[TraceFilterAttribute]
		public ActionResult Overtime()
        {
            return PartialView("Overtime");
        }
		[TraceFilterAttribute]
		public ActionResult IMOSchedule()
        {
            return PartialView("IMOSchedule");
        }
		[TraceFilterAttribute]
		public ActionResult MonTimeSheet()
        {
            return PartialView("MonTimeSheet");
        }
		[TraceFilterAttribute]
		public ActionResult TuesTimeSheet()
        {
            return PartialView("TuesTimeSheet");
        }
		[TraceFilterAttribute]
		public ActionResult WednesTimeSheet()
        {
            return PartialView("WednesTimeSheet");
        }
		[TraceFilterAttribute]
		public ActionResult ThursTimeSheet()
        {
            return PartialView("ThursTimeSheet");
        }
		[TraceFilterAttribute]
		public ActionResult FriTimeSheet()
        {
            return PartialView("FriTimeSheet");
        }
		[TraceFilterAttribute]
		public ActionResult SaturTimeSheet()
        {
            return PartialView("SaturTimeSheet");
        }
		[TraceFilterAttribute]
		public ActionResult SunTimeSheet()
        {
            return PartialView("SunTimeSheet");
        }

        public JsonResult Add(Crew crew)
        {
            CrewBL crewBL = new CrewBL();
            CrewPOCO crewPC = new CrewPOCO();
            ServiceTermsPOCO serviceTermsPOCO = new ServiceTermsPOCO();
			string crewUserId = string.Empty;
            crewPC.ID = crew.ID;
            //crewPC.Name = crew.Name;
            crewPC.FirstName = crew.FirstName;
            crewPC.MiddleName = crew.MiddleName;
            crewPC.LastName = crew.LastName;
            crewPC.Gender = crew.Gender;
            crewPC.RankID = crew.RankID;

            crewPC.DepartmentMasterID = crew.DepartmentMasterID;          

            Random rnd = new Random();
			if(crew.FirstName.Length > 3 && crew.LastName.Length > 3)
			crewUserId = crew.FirstName.Substring(0, 3) + crew.LastName.Substring(0, 3) + rnd.Next(100);
			else if(crew.FirstName.Length <= 3 && crew.LastName.Length > 3)
				crewUserId = crew.FirstName + crew.LastName.Substring(0, 3) + rnd.Next(100);
			else if(crew.FirstName.Length > 3 && crew.LastName.Length <=3)
				crewUserId = crew.FirstName.Substring(0, 3) + crew.LastName + rnd.Next(100);
			else
				crewUserId = crew.FirstName + crew.LastName + rnd.Next(100);


			crewPC.CountryID = crew.CountryID;
            // crewPC.Nationality = crew.Nationality;

            crewPC.DOB1 = crew.DOB1;

            //crewPC.DOB = DateTime.ParseExact(crewPC.DOB1, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            DateTime dt = crewPC.DOB1.FormatDate(ConfigurationManager.AppSettings["InputDateFormat"].ToString(), ConfigurationManager.AppSettings["InputDateSeperator"].ToString(), ConfigurationManager.AppSettings["OutputDateFormat"].ToString(), ConfigurationManager.AppSettings["OutputDateSeperator"].ToString());
            crewPC.DOB = dt;

            crewPC.POB = crew.POB;
           // crewPC.CrewIdentity = crew.CrewIdentity;
            crewPC.PassportSeamanPassportBook = crew.PassportSeamanPassportBook;
            //crewPC.Seaman = crew.Seaman;
            crewPC.PassportSeaman = crew.PassportSeaman;



            serviceTermsPOCO.ActiveFrom1 = crew.CreatedOn1;
            //serviceTermsPOCO.ActiveFrom = DateTime.ParseExact(serviceTermsPOCO.ActiveFrom1, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            DateTime dt1 = serviceTermsPOCO.ActiveFrom1.FormatDate(ConfigurationManager.AppSettings["InputDateFormat"].ToString(), ConfigurationManager.AppSettings["InputDateSeperator"].ToString(), ConfigurationManager.AppSettings["OutputDateFormat"].ToString(), ConfigurationManager.AppSettings["OutputDateSeperator"].ToString());
            serviceTermsPOCO.ActiveFrom = dt1;

            serviceTermsPOCO.ActiveTo1 = crew.LatestUpdate1;

            if (!String.IsNullOrEmpty(serviceTermsPOCO.ActiveTo1))
            {
                //serviceTermsPOCO.ActiveTo = DateTime.ParseExact(serviceTermsPOCO.ActiveTo1, "MM/dd/yyyy", CultureInfo.InvariantCulture);
                DateTime dt2 = serviceTermsPOCO.ActiveTo1.FormatDate(ConfigurationManager.AppSettings["InputDateFormat"].ToString(), ConfigurationManager.AppSettings["InputDateSeperator"].ToString(), ConfigurationManager.AppSettings["OutputDateFormat"].ToString(), ConfigurationManager.AppSettings["OutputDateSeperator"].ToString());
                serviceTermsPOCO.ActiveTo = dt2;
            }
            else
            {
                serviceTermsPOCO.ActiveTo = null;
            }
            //crewPC.PayNum = crew.PayNum;
           // crewPC.EmployeeNumber = crew.EmployeeNumber;
            crewPC.Notes = crew.Notes;
            crewPC.Watchkeeper = crew.Watchkeeper;
            crewPC.OvertimeEnabled = crew.OvertimeEnabled;

            crewPC.AllowPsychologyForms = crew.AllowPsychologyForms;

            crewPC.ServiceTermsPOCO = serviceTermsPOCO;




            crewPC.IssuingStateOfIdentityDocument = crew.IssuingStateOfIdentityDocument;

            crewPC.ExpiryDateOfIdentityDocument1 = crew.ExpiryDateOfIdentityDocument1;
            if (!String.IsNullOrEmpty(crewPC.ExpiryDateOfIdentityDocument1))
            {
                //serviceTermsPOCO.ActiveTo = DateTime.ParseExact(serviceTermsPOCO.ActiveTo1, "MM/dd/yyyy", CultureInfo.InvariantCulture);
                DateTime expiryDateOfIdentityDocument1 = crewPC.ExpiryDateOfIdentityDocument1.FormatDate(ConfigurationManager.AppSettings["InputDateFormat"].ToString(), ConfigurationManager.AppSettings["InputDateSeperator"].ToString(), ConfigurationManager.AppSettings["OutputDateFormat"].ToString(), ConfigurationManager.AppSettings["OutputDateSeperator"].ToString());
                crewPC.ExpiryDateOfIdentityDocument = expiryDateOfIdentityDocument1;
            }
            else
            {
                crewPC.ExpiryDateOfIdentityDocument = null;
            }





            // return Json(crewBL.SaveCrew(crewPC), JsonRequestBehavior.AllowGet);




            int recordsaffected = crewBL.SaveCrew(crewPC, int.Parse(Session["VesselID"].ToString()));

			RanksBL ranks = new RanksBL();
			int groupId = ranks.GetGroupFromRank(crew.RankID, int.Parse(Session["VesselID"].ToString()));


            if (recordsaffected > 0 && crewPC.ID == 0 )
            {
                return Json(new { result = "Redirect", url = Url.Action("Index", "CreateNewUserAccount", Request.QueryString.ToRouteValues(new { grp = groupId, username = crewUserId , crewId = recordsaffected })) });
            }
            else if(recordsaffected == 0)
            {
                return Json(new { result = "Error" }, JsonRequestBehavior.AllowGet);
            }
			else
			{
				return Json(new { result = "Redirect", url = Url.Action("CrewListNew", "CrewList") });
			}
        }

        //

        public JsonResult CreateNewCrewLogin(string ID)
        {
            CrewBL crewBL = new CrewBL();
            CrewPOCO crewPC = new CrewPOCO();
            crewPC = crewBL.GetAllCrewByCrewID(int.Parse(ID), int.Parse(Session["VesselID"].ToString()));
            string crewUserId = string.Empty;

            Random rnd = new Random();
            crewUserId = crewPC.FirstName.Substring(0, 3) + crewPC.LastName.Substring(0, 3) + rnd.Next(100);

            RanksBL ranks = new RanksBL();
            int groupId = ranks.GetGroupFromRank(crewPC.RankID, int.Parse(Session["VesselID"].ToString()));


            //var data = new { result = "Redirect", url = Url.Action("Index", "CreateNewUserAccount", Request.QueryString.ToRouteValues(new { grp = groupId, username = crewUserId, crewId = crewPC.ID })) };
              var data = new { result = "Redirect", url = "/CreateNewUserAccount/Index?" + "grp=" + groupId + "&username=" + crewUserId  + "&crewId=" + crewPC.ID };

            return Json(data, JsonRequestBehavior.AllowGet);


        }


        public JsonResult AddEdit(Crew crew)
        {
			CrewBL crewBL = new CrewBL();
			CrewPOCO crewPC = new CrewPOCO();
			ServiceTermsPOCO serviceTermsPOCO = new ServiceTermsPOCO();
			string crewUserId = string.Empty;
			crewPC.ID = crew.ID;
			//crewPC.Name = crew.Name;
			crewPC.FirstName = crew.FirstName;
			crewPC.MiddleName = crew.MiddleName;
			crewPC.LastName = crew.LastName;
            crewPC.Gender = crew.Gender;
            crewPC.RankID = crew.RankID;

			crewPC.DepartmentMasterID = crew.DepartmentMasterID;

			Random rnd = new Random();
			crewUserId = crew.FirstName.Substring(0, 3) + crew.LastName.Substring(0, 3) + rnd.Next(100);


			crewPC.CountryID = crew.CountryID;
			// crewPC.Nationality = crew.Nationality;

			crewPC.DOB1 = crew.DOB1;

			//crewPC.DOB = DateTime.ParseExact(crewPC.DOB1, "MM/dd/yyyy", CultureInfo.InvariantCulture);
			DateTime dt = crewPC.DOB1.FormatDate(ConfigurationManager.AppSettings["InputDateFormat"].ToString(), ConfigurationManager.AppSettings["InputDateSeperator"].ToString(), ConfigurationManager.AppSettings["OutputDateFormat"].ToString(), ConfigurationManager.AppSettings["OutputDateSeperator"].ToString());
			crewPC.DOB = dt;

			crewPC.POB = crew.POB;
			// crewPC.CrewIdentity = crew.CrewIdentity;
			crewPC.PassportSeamanPassportBook = crew.PassportSeamanPassportBook;
			//crewPC.Seaman = crew.Seaman;
			crewPC.PassportSeaman = crew.PassportSeaman;



			serviceTermsPOCO.ActiveFrom1 = crew.CreatedOn1;
			//serviceTermsPOCO.ActiveFrom = DateTime.ParseExact(serviceTermsPOCO.ActiveFrom1, "MM/dd/yyyy", CultureInfo.InvariantCulture);
			DateTime dt1 = serviceTermsPOCO.ActiveFrom1.FormatDate(ConfigurationManager.AppSettings["InputDateFormat"].ToString(), ConfigurationManager.AppSettings["InputDateSeperator"].ToString(), ConfigurationManager.AppSettings["OutputDateFormat"].ToString(), ConfigurationManager.AppSettings["OutputDateSeperator"].ToString());
			serviceTermsPOCO.ActiveFrom = dt1;

			serviceTermsPOCO.ActiveTo1 = crew.LatestUpdate1;

			if (!String.IsNullOrEmpty(serviceTermsPOCO.ActiveTo1))
			{
				//serviceTermsPOCO.ActiveTo = DateTime.ParseExact(serviceTermsPOCO.ActiveTo1, "MM/dd/yyyy", CultureInfo.InvariantCulture);
				DateTime dt2 = serviceTermsPOCO.ActiveTo1.FormatDate(ConfigurationManager.AppSettings["InputDateFormat"].ToString(), ConfigurationManager.AppSettings["InputDateSeperator"].ToString(), ConfigurationManager.AppSettings["OutputDateFormat"].ToString(), ConfigurationManager.AppSettings["OutputDateSeperator"].ToString());
				serviceTermsPOCO.ActiveTo = dt2;
			}
			else
			{
				serviceTermsPOCO.ActiveTo = null;
			}
			//crewPC.PayNum = crew.PayNum;
			// crewPC.EmployeeNumber = crew.EmployeeNumber;
			crewPC.Notes = crew.Notes;
			crewPC.Watchkeeper = crew.Watchkeeper;
			crewPC.OvertimeEnabled = crew.OvertimeEnabled;

			crewPC.ServiceTermsPOCO = serviceTermsPOCO;

            // return Json(crewBL.SaveCrew(crewPC), JsonRequestBehavior.AllowGet);


            crewPC.IssuingStateOfIdentityDocument = crew.IssuingStateOfIdentityDocument;

            crewPC.ExpiryDateOfIdentityDocument1 = crew.ExpiryDateOfIdentityDocument1;
            if (!String.IsNullOrEmpty(crewPC.ExpiryDateOfIdentityDocument1))
            {
                //serviceTermsPOCO.ActiveTo = DateTime.ParseExact(serviceTermsPOCO.ActiveTo1, "MM/dd/yyyy", CultureInfo.InvariantCulture);
                DateTime expiryDateOfIdentityDocument1 = crewPC.ExpiryDateOfIdentityDocument1.FormatDate(ConfigurationManager.AppSettings["InputDateFormat"].ToString(), ConfigurationManager.AppSettings["InputDateSeperator"].ToString(), ConfigurationManager.AppSettings["OutputDateFormat"].ToString(), ConfigurationManager.AppSettings["OutputDateSeperator"].ToString());
                crewPC.ExpiryDateOfIdentityDocument = expiryDateOfIdentityDocument1;
            }
            else
            {
                crewPC.ExpiryDateOfIdentityDocument = null;
            }

            //int recordsaffected = crewBL.SaveCrew(crewPC, int.Parse(Session["VesselID"].ToString()));

            RanksBL ranks = new RanksBL();
			int groupId = ranks.GetGroupFromRank(crew.RankID, int.Parse(Session["VesselID"].ToString()));


			
				return Json(new { result = "Redirect", url = Url.Action("Index", "CreateNewUserAccount", Request.QueryString.ToRouteValues(new { grp = groupId, username = crewUserId, crewId = crew.ID })) });
			
			
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



        [HttpGet]
        public JsonResult GetAllCrewByCrewID(string ID)
        {
            CrewBL crewBL = new CrewBL();
            CrewPOCO crewPC = new CrewPOCO();

            crewPC = crewBL.GetAllCrewByCrewID(int.Parse(ID), int.Parse(Session["VesselID"].ToString()));

            Crew um = new Crew();
            ServiceTerms st = new ServiceTerms();
            um.ID = crewPC.ID;
            um.Name = crewPC.Name;
            um.RankName = crewPC.RankName;
            um.Notes = crewPC.Notes;
            //um.ServiceTerms = crewPC.ServiceTermsPOCO;
            // New 
            um.DOB = crewPC.DOB;
            um.DOB1 = crewPC.DOB1;
            um.FirstName = crewPC.FirstName;
            um.LastName = crewPC.LastName;
            um.MiddleName = crewPC.MiddleName;
            um.Gender = crewPC.Gender;
            um.ActiveFrom1 = crewPC.ActiveFrom1;
            um.ActiveTo1 = crewPC.ActiveTo1;

            um.CountryName = crewPC.CountryName;
            um.CountryID = crewPC.CountryID;

            // um.Nationality = crewPC.Nationality;
            um.POB = crewPC.POB;
            um.CrewIdentity = crewPC.CrewIdentity;


            um.PassportSeamanPassportBook = crewPC.PassportSeamanPassportBook;
            um.Seaman = crewPC.Seaman;
            um.PassportSeamanIndicator = crewPC.PassportSeamanIndicator;

            if (crewPC.ActiveFrom1.Trim() == "-")
                crewPC.ActiveFrom1 = String.Empty;
            if (crewPC.ActiveTo1.Trim() == "-")
                crewPC.ActiveTo1 = String.Empty;

            um.CreatedOn1 = crewPC.ActiveFrom1;
            um.LatestUpdate1 = crewPC.ActiveTo1;
          //  um.EmployeeNumber = crewPC.EmployeeNumber;
            //um.PayNum = crewPC.PayNum;
            um.OvertimeEnabled = crewPC.OvertimeEnabled;
            um.Watchkeeper = crewPC.Watchkeeper;

            um.AllowPsychologyForms = crewPC.AllowPsychologyForms;

            um.RankID = crewPC.RankID;

            um.DepartmentMasterName = crewPC.DepartmentMasterName;
            um.DepartmentMasterID = crewPC.DepartmentMasterID;


            um.IssuingStateOfIdentityDocument = crewPC.IssuingStateOfIdentityDocument; 
            um.ExpiryDateOfIdentityDocument1 = crewPC.ExpiryDateOfIdentityDocument1;

            var cm = um;

            return Json(cm, JsonRequestBehavior.AllowGet);

            
        }


        // for Department drp
        public void GetAllDepartmentForDrp()
        {
            CrewBL crewBL = new CrewBL();
            List<DepartmentPOCO> departmentpocoList = new List<DepartmentPOCO>();

            departmentpocoList = crewBL.GetAllDepartmentForDrp(int.Parse(Session["VesselID"].ToString()));

            List<Crew> departmentList = new List<Crew>();

            foreach (DepartmentPOCO up in departmentpocoList)
            {
                Crew depart = new Crew();
                depart.DepartmentMasterID = up.DepartmentMasterID;
                depart.DepartmentMasterName = up.DepartmentMasterName;

                departmentList.Add(depart);
            }

            ViewBag.Departments = departmentList.Select(x =>
                                            new SelectListItem()
                                            {
                                                Text = x.DepartmentMasterName,
                                                Value = x.DepartmentMasterID.ToString()
                                            });

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

        // for Crew drp
        [TraceFilterAttribute]
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












        //public JsonResult GetAllowPsychology(int CrewID, int VesselID)
        //{
        //    CrewBL crewBL = new CrewBL();
        //    CrewPOCO crewPC = new CrewPOCO();

        //    crewPC = crewBL.GetAllowPsychology(int.Parse(CrewID), int.Parse(Session["VesselID"].ToString()));

        //    Crew um = new Crew();
        //    um.AllowPsychologyForms = crewPC.AllowPsychologyForms;
           
        //    var cm = um;
        //    return Json(cm, JsonRequestBehavior.AllowGet);
        //}

        public JsonResult GetAllowPsychology(int CrewID, int VesselID)
        {
            CrewBL crewBL = new CrewBL();
            CrewPOCO crewPC = new CrewPOCO();

            crewPC = crewBL.GetAllowPsychology(int.Parse(Session["CrewID"].ToString()), int.Parse(Session["VesselID"].ToString()));

            CrewPOCO dept = new CrewPOCO();

            dept.AllowPsychologyForms = crewPC.AllowPsychologyForms;

            var data = dept;

            return Json(data, JsonRequestBehavior.AllowGet);
        }




    }
}