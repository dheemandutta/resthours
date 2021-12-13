using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using TM.RestHour.BL;
using TM.RestHour.Models;
using TM.Base.Entities;
using System.Globalization;

namespace TM.RestHour.Controllers
{
    [TraceFilterAttribute]
    public class CrewListController : BaseController
    {
		//
		// GET: /CrewList/
		[TraceFilterAttribute]
		public ActionResult CrewList()
        {
            return View();
        }

        [TraceFilterAttribute]
        public ActionResult CrewListNew()
        {
            return View();
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

            CrewBL crewBL = new CrewBL();
            int totalrecords = 0;

            List<CrewPOCO> crewpocoList = new List<CrewPOCO>();
            crewpocoList = crewBL.GetCrewPageWise(pageIndex, ref totalrecords, length, int.Parse(Session["VesselID"].ToString()));
            List<Crew> crewList = new List<Crew>();
            foreach (CrewPOCO crewPC in crewpocoList)
            {
                Crew crew = new Crew();
                crew.ID = crewPC.ID;
                crew.Name = crewPC.Name;
                crew.RankName = crewPC.RankName;
                crew.StartDate = crewPC.StartDate;
                crew.EndDate = crewPC.EndDate;
                //crew.LatestUpdate = crewPC.LatestUpdate;
                //crew.CreatedOn = crewPC.IMONumber;
                //crew.CreatedOn = crewPC.IMONumber;
                crewList.Add(crew);
            }

            var data = crewList;

            return Json(new { draw = draw, recordsFiltered = totalrecords, recordsTotal = totalrecords, data = data }, JsonRequestBehavior.AllowGet);
        }


        public JsonResult LoadDataForInactiv()
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

            CrewBL crewBL = new CrewBL();
            int totalrecords = 0;

            List<CrewPOCO> crewpocoList = new List<CrewPOCO>();
            crewpocoList = crewBL.GetCrewForInactivPageWise(pageIndex, ref totalrecords, length, int.Parse(Session["VesselID"].ToString()));
            List<Crew> crewList = new List<Crew>();
            foreach (CrewPOCO crewPC in crewpocoList)
            {
                Crew crew = new Crew();
                crew.ID = crewPC.ID;
                crew.Name = crewPC.Name;
                crew.RankName = crewPC.RankName;
                crew.StartDate = crewPC.StartDate;
                crew.EndDate = crewPC.EndDate;
                // crew.LatestUpdate = crewPC.LatestUpdate;
                //crew.CreatedOn = crewPC.IMONumber;
                //crew.CreatedOn = crewPC.IMONumber;
                crewList.Add(crew);
            }

            var data = crewList;

            return Json(new { draw = draw, recordsFiltered = totalrecords, recordsTotal = totalrecords, data = data }, JsonRequestBehavior.AllowGet);
        }


        //public JsonResult LoadData(string sidx, string sort, int page, int rows)
        //{
        //    int length;
        //    int pageIndex = 0;
        //    pageIndex = page;
        //    length = rows;

        //    CrewBL crewBL = new CrewBL();
        //    int totalrecords = 0;

        //    List<CrewPOCO> crewpocoList = new List<CrewPOCO>();
        //    crewpocoList = crewBL.GetCrewPageWise(pageIndex, ref totalrecords, length, int.Parse(Session["VesselID"].ToString()));
        //    var totalPages = (int)Math.Ceiling((float)totalrecords / (float)rows);


        //    var jsonData = new
        //    {
        //        total = totalPages,
        //        page,
        //        records = totalrecords,
        //        rows = crewpocoList
        //    };
        //    return Json(jsonData, JsonRequestBehavior.AllowGet);
        //}

        public JsonResult UpdateInActive(string ID)
        {
            CrewBL crewBL = new CrewBL();
            return Json(crewBL.UpdateInActive(int.Parse(ID)), JsonRequestBehavior.AllowGet);
            //int recordaffected = 0;
            //return Json(recordaffected, JsonRequestBehavior.AllowGet);
        }








        [TraceFilterAttribute]
        public JsonResult LoadData2()
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

            CrewBL crewBL = new CrewBL();
            int totalrecords = 0;

            List<CrewPOCO> crewpocoList = new List<CrewPOCO>();
            crewpocoList = crewBL.GetCrewPageWise2(pageIndex, ref totalrecords, length, int.Parse(Session["VesselID"].ToString()));
            List<Crew> crewList = new List<Crew>();
            foreach (CrewPOCO crewPC in crewpocoList)
            {
                Crew crew = new Crew();
                crew.ID = crewPC.ID;
                crew.Name = crewPC.Name;
                crew.RankName = crewPC.RankName;
                crew.StartDate = crewPC.StartDate;
                // crew.LatestUpdate = crewPC.LatestUpdate;
                //crew.CreatedOn = crewPC.IMONumber;
                //crew.CreatedOn = crewPC.IMONumber;
                crewList.Add(crew);
            }

            var data = crewList;

            return Json(new { draw = draw, recordsFiltered = totalrecords, recordsTotal = totalrecords, data = data }, JsonRequestBehavior.AllowGet);
        }
    }
}