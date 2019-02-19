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


namespace TM.RestHour.Controllers
{
    [TraceFilterAttribute]
    public class RankPermissionController : BaseController
    {
		//
		// GET: /RankPermission/
		[TraceFilterAttribute]
		public ActionResult Index()
        {
            GetAllRanksForDrp();
            GetAllGroupsForDrp();
            return View();
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

        public JsonResult SaveRankPermission(string ranks, string selectedGroups)
        {
            GroupsBL groupsBL = new GroupsBL();
            RanksPOCO ranksPC = new RanksPOCO();
            //groupsPC.ID = groups.ID;
            //groupsPC.GroupName = groups.GroupName;

            string selectedIds = string.Empty;
            JavaScriptSerializer JsonSerializer = new JavaScriptSerializer();
            IDictionary<string, object> permissiondict = (IDictionary<string, object>)JsonSerializer.DeserializeObject(selectedGroups);

            object[] objwf = (object[])permissiondict["WF"];

            foreach (object item in objwf)
            {
                Dictionary<string, object> selectedGroupsDictionaryObject = (Dictionary<string, object>)item;

                if (!String.IsNullOrEmpty(selectedGroupsDictionaryObject["d"].ToString()))
                {

                    selectedIds = selectedGroupsDictionaryObject["d"].ToString();

                }
            }

            ranksPC.SelectedGroups = selectedIds;
            ranksPC.ID = int.Parse(ranks);
            int returnedRows = groupsBL.SaveRankPermission(ranksPC, int.Parse(Session["VesselID"].ToString()));
            return Json(returnedRows, JsonRequestBehavior.AllowGet);
           
        }
	}
}