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
    public class DepartmentController : BaseController
    {
        // GET: Department
        [TraceFilterAttribute]
        public ActionResult Index()
        {
            GetAllAdminCrewForDrp();
            GetAllUserCrewForDrp();
            //GetDepartmentByIDForAssignCrew();
           // GetAllCrewForAssign();
            return View();
        }


        [TraceFilterAttribute]
        public ActionResult DepartmentMaster()
        {
            return View();
        }


        // for Admin Crew drp
        [TraceFilterAttribute]
        public void GetAllAdminCrewForDrp()
        {
            DepartmentBL departmentDAL = new DepartmentBL();
            List<DepartmentPOCO> departmentpocoList = new List<DepartmentPOCO>();

            departmentpocoList = departmentDAL.GetAllAdminCrewForDrp(int.Parse(Session["VesselID"].ToString()));

            List<Department> departmentList = new List<Department>();

            foreach (DepartmentPOCO up in departmentpocoList)
            {
                Department dpartment = new Department();
                dpartment.ID = up.ID;
                dpartment.Name = up.Name;

                departmentList.Add(dpartment);
            }

            ViewBag.Crew = departmentList.Select(x =>
                                            new SelectListItem()
                                            {
                                                Text = x.Name,
                                                Value = x.ID.ToString()
                                            });

        }

        // for User Crew drp
        [TraceFilterAttribute]
        public void GetAllUserCrewForDrp()
        {
            DepartmentBL departmentDAL = new DepartmentBL();
            List<DepartmentPOCO> departmentpocoList = new List<DepartmentPOCO>();

            departmentpocoList = departmentDAL.GetAllUserCrewForDrp(int.Parse(Session["VesselID"].ToString()));

            List<Department> departmentList = new List<Department>();

            foreach (DepartmentPOCO up in departmentpocoList)
            {
                Department dpartment = new Department();
                dpartment.IDUser = up.IDUser;
                dpartment.NameUser = up.NameUser;

                departmentList.Add(dpartment);
            }

            ViewBag.CrewUser = departmentList.Select(x =>
                                            new SelectListItem()
                                            {
                                                Text = x.NameUser,
                                                Value = x.IDUser.ToString()
                                            });

        }

        public JsonResult Add(Department department,string selectedCrewID )
        {
            DepartmentBL departmentBL = new DepartmentBL();
            DepartmentPOCO departmentPC = new DepartmentPOCO();


            string selectedIds = string.Empty;
            JavaScriptSerializer JsonSerializer = new JavaScriptSerializer();
            IDictionary<string, object> permissiondict = (IDictionary<string, object>)JsonSerializer.DeserializeObject(selectedCrewID);

            object[] objwf = (object[])permissiondict["WF"];

            foreach (object item in objwf)
            {
                Dictionary<string, object> selectedDictionaryObject = (Dictionary<string, object>)item;

                if (!String.IsNullOrEmpty(selectedDictionaryObject["d"].ToString()))
                {

                    selectedIds = selectedDictionaryObject["d"].ToString();

                }
            }

            departmentPC.SelectedCrewID = selectedIds;


            departmentPC.DepartmentMasterID = department.DepartmentMasterID;
            departmentPC.DepartmentMasterName = department.DepartmentMasterName;
            departmentPC.DepartmentMasterCode = department.DepartmentMasterCode;
            // departmentPC.CrewID = department.CrewID;
            //departmentPC.SelectedCrewID = department.SelectedCrewID;
            return Json(departmentBL.SaveDepartment(departmentPC, int.Parse(Session["VesselID"].ToString())), JsonRequestBehavior.AllowGet);
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

            DepartmentBL departmentBL = new DepartmentBL();
            int totalrecords = 0;

            List<DepartmentPOCO> departmentpocoList = new List<DepartmentPOCO>();
            departmentpocoList = departmentBL.GetDepartmentPageWise(pageIndex, ref totalrecords, length, int.Parse(Session["VesselID"].ToString()));
            List<Department> departmentList = new List<Department>();
            foreach (DepartmentPOCO departmentPC in departmentpocoList)
            {
                Department department = new Department();
                department.DepartmentMasterID = departmentPC.DepartmentMasterID;
                department.DepartmentMasterName = departmentPC.DepartmentMasterName;
               // department.DepartmentMasterCode = departmentPC.DepartmentMasterCode;
                department.CrewName = departmentPC.CrewName;
                //  department.CrewID = departmentPC.CrewID;
                departmentList.Add(department);
            }

            var data = departmentList;

            return Json(new { draw = draw, recordsFiltered = totalrecords, recordsTotal = totalrecords, data = data }, JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetDepartmentByID(int DepartmentMasterID)
        {
            DepartmentBL departmentBL = new DepartmentBL();
            DepartmentPOCO departmentpocoList = new DepartmentPOCO();

            departmentpocoList = departmentBL.GetDepartmentByID(DepartmentMasterID, int.Parse(Session["VesselID"].ToString()));

            Department dept = new Department();

			dept.DepartmentMasterID = departmentpocoList.DepartmentMasterID;
			dept.DepartmentMasterName = departmentpocoList.DepartmentMasterName;
			dept.DepartmentMasterCode = departmentpocoList.DepartmentMasterCode;
			dept.SelectedCrewID = departmentpocoList.SelectedCrewID;

            var data = dept;

            return Json(data, JsonRequestBehavior.AllowGet);
        }

        public JsonResult DeleteDepartment(string DepartmentMasterID)
        {
            DepartmentBL departmentBL = new DepartmentBL();
            return Json(departmentBL.DeleteDepartment(int.Parse(DepartmentMasterID)), JsonRequestBehavior.AllowGet);
            int recordaffected = 0;
            return Json(recordaffected, JsonRequestBehavior.AllowGet);
        }

        ////for Crew DualListbox
        //[TraceFilterAttribute]
        //public void GetAllCrewForAssign()
        //{
        //    DepartmentBL departmentDAL = new DepartmentBL();
        //    List<DepartmentPOCO> departmentpocoList = new List<DepartmentPOCO>();

        //    departmentpocoList = departmentDAL.GetAllCrewForAssign(int.Parse(Session["VesselID"].ToString()));

        //    List<Department> departmentList = new List<Department>();

        //    foreach (DepartmentPOCO up in departmentpocoList)
        //    {
        //        Department dpartment = new Department();
        //        dpartment.ID = up.ID;
        //        dpartment.Name = up.Name;

        //        departmentList.Add(dpartment);
        //    }

        //    ViewBag.Crew = departmentList.Select(x =>
        //                                    new SelectListItem()
        //                                    {
        //                                        Text = x.Name,
        //                                        Value = x.ID.ToString()
        //                                    });

        //}




        //public JsonResult GetDepartmentByIDForAssignCrew(int DepartmentMasterID)
        //{
        //    DepartmentBL departmentBL = new DepartmentBL();
        //    DepartmentPOCO departmentpocoList = new DepartmentPOCO();

        //    departmentpocoList = departmentBL.GetDepartmentByIDForAssignCrew(DepartmentMasterID, int.Parse(Session["VesselID"].ToString()));

        //    Department dept = new Department();

        //    dept.DepartmentMasterID = departmentpocoList.DepartmentMasterID;
        //    dept.CName = departmentpocoList.CName;


        //    var data = dept;

        //    return Json(data, JsonRequestBehavior.AllowGet);
        //}





        // for GetDepartmentByIDForAssignCrew drp
        //[TraceFilterAttribute]
        public JsonResult GetDepartmentByIDForAssignCrew(int DepartmentMasterID)
        {
            DepartmentBL departmentBL = new DepartmentBL();
            List <DepartmentPOCO> departmentpocoList = new List<DepartmentPOCO>();

            departmentpocoList = departmentBL.GetDepartmentByIDForAssignCrew(DepartmentMasterID,int.Parse(Session["VesselID"].ToString()));

            //List<Department> departmentList = new List<Department>();

            //departmentList.DepartmentMasterID = departmentpocoList.DepartmentMasterID;
            //departmentList.CName = departmentpocoList.CName;

            var data = departmentpocoList;

            return Json(data, JsonRequestBehavior.AllowGet);
        }


        public JsonResult SaveDepartmentMaster(Department department)
        {
            DepartmentBL departmentBL = new DepartmentBL();
            DepartmentPOCO departmentPC = new DepartmentPOCO();

            //departmentPC.DepartmentMasterID = department.DepartmentMasterID;
            departmentPC.DepartmentMasterName = department.DepartmentMasterName;
            departmentPC.DepartmentMasterCode = department.DepartmentMasterCode;

            return Json(departmentBL.SaveDepartmentMaster(departmentPC, int.Parse(Session["VesselID"].ToString())), JsonRequestBehavior.AllowGet);
        }
    }
}