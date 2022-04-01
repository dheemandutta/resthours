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

namespace TM.RestHour.Controllers
{
    [TraceFilterAttribute]
    public class CreateNewUserAccountController : BaseController
    {
		//
		// GET: /CreateNewUserAccount/
		[TraceFilterAttribute]
		public ActionResult Index()
        {
            GetAllGroupsForDrp2();
            GetAllCrewForDrp();

			


            return View();
        }

        public JsonResult GetCrewByID(string crewid)
        {
            CrewBL crewBL = new CrewBL();
            string name = "";
            if(!String.IsNullOrEmpty(crewid))
            {
                name = crewBL.GetCrewByID(int.Parse(crewid)).Name;
            }

            var data = name;
            return Json(data, JsonRequestBehavior.AllowGet);
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


        // for Groups drp
        public void GetAllGroupsForDrp()
        {
            GroupsBL groupsDAL = new GroupsBL();
            List<GroupsPOCO> groupspocoList = new List<GroupsPOCO>();

            groupspocoList = groupsDAL.GetAllGroupsForDrp(int.Parse(Session["VesselID"].ToString()));

            List<Groups> itmasterList = new List<Groups>();

            foreach (GroupsPOCO up in groupspocoList)
            {
                Groups unt = new Groups();
                unt.ID = up.ID;
                unt.GroupName = up.GroupName;

                itmasterList.Add(unt);
            }

            ViewBag.Groups = itmasterList.Select(x =>
                                            new SelectListItem()
                                            {
                                                Text = x.GroupName,
                                                Value = x.ID.ToString()
                                            });

        }

        // for Groups drp 2
        public void GetAllGroupsForDrp2()
        {
            GroupsBL groupsDAL = new GroupsBL();
            List<GroupsPOCO> groupspocoList = new List<GroupsPOCO>();

            groupspocoList = groupsDAL.GetAllGroupsForDrp2(int.Parse(Session["VesselID"].ToString()));

            List<Groups> itmasterList = new List<Groups>();

            foreach (GroupsPOCO up in groupspocoList)
            {
                Groups unt = new Groups();
                unt.ID = up.ID;
                unt.GroupName = up.GroupName;

                itmasterList.Add(unt);
            }

            ViewBag.Groups = itmasterList.Select(x =>
                                            new SelectListItem()
                                            {
                                                Text = x.GroupName,
                                                Value = x.ID.ToString()
                                            });

        }

        public bool CheckUserNameValididty(string userName)
        {
            UsersBL userBL = new UsersBL();
            return userBL.CheckUserNameValidity(userName);

            //return Json(data, JsonRequestBehavior.AllowGet);

        }

		public JsonResult GetUserByCrewId(string crewId)
		{
			int id = int.Parse(crewId);
			CreateNewUserAccountBL createNewUserAccountBL = new CreateNewUserAccountBL();
			var data = createNewUserAccountBL.GetUserByCrewId(id);

			return Json(data, JsonRequestBehavior.AllowGet);

		}



		public JsonResult Add(string Username, string Password, string SelectedGroupID,int? CrewID,int? ID)
        {


            bool isUserNameNotduplicate = false;
            CreateNewUserAccountBL createNewUserAccountBL = new CreateNewUserAccountBL();
            UsersPOCO usersPC = new UsersPOCO();
            UserGroupsPOCO userGroupsPC = new UserGroupsPOCO();
        
            usersPC.Username = Username;
            usersPC.Password = Password;
            usersPC.Active = true;
            //usersPC.CrewID = CrewID;

            userGroupsPC.Users = usersPC;

            string selectedIds = string.Empty;
            

            userGroupsPC.SelectedGroupID = SelectedGroupID;
            userGroupsPC.CrewID = CrewID;

			if (ID.HasValue)
				userGroupsPC.Users.ID = ID.Value ;
			else
				userGroupsPC.Users.ID = 0;

            if (userGroupsPC.Users.ID == 0)
                isUserNameNotduplicate = CheckUserNameValididty(userGroupsPC.Users.Username);

            if (isUserNameNotduplicate)
            {
                int returnedRows = createNewUserAccountBL.SaveCreateNewUserAccount(userGroupsPC, int.Parse(Session["VesselID"].ToString()));
                return Json(new { result = "Redirect", url = Url.Action("CrewListNew", "CrewList") });
            }
            else if(!isUserNameNotduplicate && userGroupsPC.Users.ID == 0)
            {
                return Json(new { result = "Duplicate", url = Url.Action("CrewListNew", "CrewList") });
            }
            else
            {
                int returnedRows = createNewUserAccountBL.SaveCreateNewUserAccount(userGroupsPC, int.Parse(Session["VesselID"].ToString()));
                return Json(new { result = "Redirect", url = Url.Action("CrewListNew", "CrewList") });
            }
			
			//return Json(returnedRows, JsonRequestBehavior.AllowGet);



			//var data = usersPC;

			//return Json(data, JsonRequestBehavior.AllowGet);
		}


        public JsonResult LoadData()
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

            CreateNewUserAccountBL createNewUserAccountBL = new CreateNewUserAccountBL();
            int totalrecords = 0;

            List<UsersPOCO> userspocoList = new List<UsersPOCO>();
            userspocoList = createNewUserAccountBL.GetUsersPageWise(pageIndex, ref totalrecords, length, int.Parse(Session["VesselID"].ToString()));
            List<Users> usersList = new List<Users>();
            foreach (UsersPOCO usersPC in userspocoList)
            {
                Users users = new Users();
                users.ID = usersPC.ID;
                users.Username = usersPC.Username;
                users.Active = usersPC.Active;
                usersList.Add(users);
            }

            var data = usersList;

            return Json(new { draw = draw, recordsFiltered = totalrecords, recordsTotal = totalrecords, data = data }, JsonRequestBehavior.AllowGet);
        }
	}
}