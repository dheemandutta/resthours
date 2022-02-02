using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using TM.RestHour.BL;
using TM.RestHour.Models;
using TM.Base.Entities;
using System.Globalization;
using System.IO;
using System.Configuration;
using ExcelDataReader;

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

        [HttpPost]
        [TraceFilterAttribute]
        public ActionResult CrewListNew(HttpPostedFileBase postedFile)
        {
            object dtData = new object();
            CrewImportBL crewImportBL = new CrewImportBL();

            if (postedFile != null)
            {
                //string path = Server.MapPath("~/Uploads/");
                string path = Server.MapPath(ConfigurationManager.AppSettings["CrewUploadPath"].ToString());
                if (!Directory.Exists(path))
                {
                    Directory.CreateDirectory(path);
                }

                string fileName = string.Empty;
                fileName = Path.GetFileName(postedFile.FileName);

                if (System.IO.File.Exists(path + fileName))
                {
                    System.IO.File.Delete(path + fileName);
                }

                postedFile.SaveAs(path + Path.GetFileName(postedFile.FileName));
                ViewBag.Message = "File uploaded successfully.";

                string filePath = path + fileName;

                // read file 
                using (var stream = System.IO.File.Open(filePath, FileMode.Open, FileAccess.Read))
                {

                    // Auto-detect format, supports:
                    //  - Binary Excel files (2.0-2003 format; *.xls)
                    //  - OpenXml Excel files (2007 format; *.xlsx)
                    using (var reader = ExcelReaderFactory.CreateReader(stream))
                    {

                        // 2. Use the AsDataSet extension method
                        var dataSet = reader.AsDataSet(new ExcelDataSetConfiguration()
                        {

                            // Gets or sets a callback to determine which row is the header row. 
                            // Only called when UseHeaderRow = true.
                            ConfigureDataTable = _ => new ExcelDataTableConfiguration
                            {
                                UseHeaderRow = false,// Use first row is ColumnName here :D
                                FilterRow = rowHeader => rowHeader.Depth >= 10
                            }
                        });

                        if (dataSet.Tables.Count > 0)
                        {
                            dtData = dataSet.Tables[0];
                            // Do Something
                        }
                        // The result of each spreadsheet is in result.Tables
                    }
                    crewImportBL.ImportCrew(dtData, int.Parse(Session["VesselID"].ToString()));        ////////////////////////////////////////
                }
            }

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
                //if (length < 0)
                //    length = 100;
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
                crew.Nationality = crewPC.Nationality;
                crew.RankName = crewPC.RankName;
                crew.PassportOrSeaman = crewPC.PassportOrSeaman;
                //crew.StartDate = crewPC.StartDate;
                // crew.LatestUpdate = crewPC.LatestUpdate;
                //crew.CreatedOn = crewPC.IMONumber;
                //crew.CreatedOn = crewPC.IMONumber;
                crewList.Add(crew);
            }

            var data = crewList;

            return Json(new { draw = draw, recordsFiltered = totalrecords, recordsTotal = totalrecords, data = data }, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult UpdateCrewServiceEndDate(string ID,string signOffDate)
        {
            CrewBL crewBL = new CrewBL();
            int recordaffected = crewBL.UpdateCrewServiceEndDate(int.Parse(ID),Convert.ToDateTime(signOffDate));
            return Json(recordaffected, JsonRequestBehavior.AllowGet);
        }

    }
}