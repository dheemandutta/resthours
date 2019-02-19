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
    public class GroupsController : BaseController
    {
		//
		// GET: /Groups/
		[TraceFilterAttribute]
		public ActionResult Index()
        {
            return View();
        }
        public JsonResult AddNewGroups(Groups groups)
        {
            GroupsBL groupsBL = new GroupsBL();
            GroupsPOCO groupsPC = new GroupsPOCO();
            groupsPC.ID = groups.ID;
            groupsPC.GroupName = groups.GroupName;

            int rowaffected = groupsBL.SaveGroups(groupsPC, int.Parse(Session["VesselID"].ToString()));
            if (rowaffected > 0)
            {
                return Json(new { result = "Redirect", url = Url.Action("Index", "Home") });
            }
            else
            {
                return Json(new { result = "Error" }, JsonRequestBehavior.AllowGet);
            }
        }

        public JsonResult GetParentNodes()
        {
            PermissionsBL permissionsBL = new PermissionsBL();

            List<PermissionsPOCO> permissionsList = new List<PermissionsPOCO>();
            permissionsList = permissionsBL.GetParentNodes(int.Parse(Session["VesselID"].ToString()));
            List<Permissions> permissions = new List<Permissions>();

            permissions = ConvertPermissionsPOCOtoPermissions(permissionsList);
            
            var data = permissions;

            if (permissions.Count > 0)
            {
                return Json(data, JsonRequestBehavior.AllowGet );
            }
            else
            {
                return Json(new { result = "Error" }, JsonRequestBehavior.AllowGet);
            }
        }


        private List<Permissions> ConvertPermissionsPOCOtoPermissions(List<PermissionsPOCO> permissionsList)
        {
           
            List<Permissions> permissions = new List<Permissions>();
            foreach (PermissionsPOCO permissionsPC in permissionsList)
            {
                Permissions permissionsP = new Permissions();
                permissionsP.id = permissionsPC.ID;
                permissionsP.text = permissionsPC.PermissionName;
                permissionsP.@checked = false;
                permissionsP.children = ConvertPermissionsPOCOtoPermissions(permissionsPC.ChildPermissions);

                permissions.Add(permissionsP);
            }


            return permissions; 
        }


        public JsonResult SaveGroups(string groups, string checkedIds)
        {
            GroupsBL groupsBL = new GroupsBL();
            GroupsPOCO groupspoco = new GroupsPOCO();
            //groupsPC.ID = groups.ID;
            //groupsPC.GroupName = groups.GroupName;

            string selectedIds = string.Empty;
            JavaScriptSerializer JsonSerializer = new JavaScriptSerializer();
            IDictionary<string, object> permissiondict = (IDictionary<string, object>)JsonSerializer.DeserializeObject(checkedIds);

            object[] objwf = (object[])permissiondict["WF"];

           
            foreach (object item in objwf)
            {
                Dictionary<string, object> permissiontDictionaryObject = (Dictionary<string, object>)item;

                if (!String.IsNullOrEmpty(permissiontDictionaryObject["d"].ToString()))
                {

                    selectedIds = permissiontDictionaryObject["d"].ToString();
                   
                }
            }

            groupspoco.Permissions.SelectedPermissionIds = selectedIds;
            groupspoco.GroupName = groups;
            int returnedRows = groupsBL.SaveGroups(groupspoco, int.Parse(Session["VesselID"].ToString()));
            return Json(returnedRows , JsonRequestBehavior.AllowGet);
        }
	}
}