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
//using HiQPdf;

namespace TM.RestHour.Controllers
{
    [TraceFilterAttribute]
    public class ReportsController : BaseController
    {
		//
		// GET: /Reports/
		[TraceFilterAttribute]
		public ActionResult Index()
        {
            //GetAllCrewForDrp();
            GetAllCrewForTimeSheet();


            CrewTimesheetViewModel crewtimesheetVM = new CrewTimesheetViewModel();
            Crew c = new Crew();
            crewtimesheetVM.Crew = c;

            if (Convert.ToBoolean(Session["User"]) == true)
            {
                crewtimesheetVM.Crew.ID = int.Parse(System.Web.HttpContext.Current.Session["LoggedInUserId"].ToString());

            }
            else
                crewtimesheetVM.Crew.ID = 0;

            return View(crewtimesheetVM);
        }

		[TraceFilterAttribute]
		public ActionResult DailyCrewReport()
        {
            return View();
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

        [TraceFilterAttribute]
		public ActionResult WorkAndRestHours()
        {
            //GetAllCrewForDrp();
            GetAllCrewForTimeSheet();

            CrewTimesheetViewModel crewtimesheetVM = new CrewTimesheetViewModel();
            Crew c = new Crew();
            crewtimesheetVM.Crew = c;

            if (Convert.ToBoolean(Session["User"]) == true)
            {
                crewtimesheetVM.Crew.ID = int.Parse(System.Web.HttpContext.Current.Session["LoggedInUserId"].ToString());

            }
            else
                crewtimesheetVM.Crew.ID = 0;

            return View(crewtimesheetVM);
        }

		[TraceFilterAttribute]
		public ActionResult CrewList()
        {
            return View();
        }
        
       
        //public ActionResult MonthlyWorkHoursPDF(string html)
        //{


        //    //// set a session variable to be used in the the converted view
        //    ////Session["MySessionVariable"] = formCollection["textBoxSessionValue"];

        //    //// get the About view HTML code
        //    //string htmlToConvert = RenderViewAsString("MonthlyWorkHoursPDF", new ViewDataDictionary()); //

        //    //// the base URL to resolve relative images and css
        //    //String thisViewUrl = this.ControllerContext.HttpContext.Request.Url.AbsoluteUri;
        //    //String baseUrl = thisViewUrl.Substring(0, thisViewUrl.Length - "Reports/MonthlyWorkHoursPDF".Length);

        //    //// instantiate the HiQPdf HTML to PDF converter
        //    //HtmlToPdf htmlToPdfConverter = new HtmlToPdf();

        //    //// render the HTML code as PDF in memory
        //    //byte[] pdfBuffer = htmlToPdfConverter.ConvertHtmlToMemory(htmlToConvert, baseUrl);

        //    //// send the PDF document to browser
        //    //FileResult fileResult = new FileContentResult(pdfBuffer, "application/pdf");
        //    //fileResult.FileDownloadName = "MonthlyWorkHours.pdf";

        //    //Response.Write(fileResult);

        //    //HtmlToPdf htmlToPdfConverter = new HtmlToPdf();
        //    //htmlToPdfConverter.ConvertedHtmlElementSelector = "#printdiv";
        //    //string url = "/Reports/Index";//Request.RawUrl;
        //    //byte[] pdfBuffer = htmlToPdfConverter.ConvertUrlToMemory(url);
        //    // inform the browser about the binary data format
        //    //System.Web.HttpContext.Current.Response.AddHeader("Content-Type", "application/pdf");

        //    //// let the browser know how to open the PDF document
        //    //System.Web.HttpContext.Current.Response.AddHeader("Content-Disposition",String.Format("attachment; filename=ConvertHtmlPart.pdf;size ={ 0}",pdfBuffer.Length.ToString()));

        //    //// write the PDF buffer to HTTP response
        //    //System.Web.HttpContext.Current.Response.BinaryWrite(pdfBuffer);

        //    //// call End() method of HTTP response 
        //    //// to stop ASP.NET page processing
        //    //System.Web.HttpContext.Current.Response.End();

        //    byte[] pdfBuffer = null;
        //    HtmlToPdf htmlToPdfConverter = new HtmlToPdf();
        //    string htmlCode = html;
        //    string baseUrl = "";//System.Web.HttpContext.Current.Request.Url.AbsoluteUri; ;

        //    // set PDF page size and orientation
        //    htmlToPdfConverter.Document.PageSize = PdfPageSize.A3; ; //GetSelectedPageSize();
        //    htmlToPdfConverter.Document.PageOrientation = PdfPageOrientation.Landscape;//GetSelectedPageOrientation();

        //    // convert HTML code to a PDF memory buffer
        //    pdfBuffer = htmlToPdfConverter.ConvertHtmlToMemory(htmlCode, baseUrl);

        //    FileResult fileResult = new FileContentResult(pdfBuffer, "application/pdf");
        //    fileResult.FileDownloadName = "MonthlyWorkHours.pdf";

        //    return fileResult;

        //   // return View();
        //}

        // for Crew drp
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
        [TraceFilterAttribute]
       
        public JsonResult GetMonthlyData(Reports reports)
        {
            ReportsBL reportsBL = new ReportsBL();
            ReportsPOCO reportsPC = new ReportsPOCO();

            string month = reports.SelectedMonthYear.Substring(0, reports.SelectedMonthYear.Length - 4);

            reportsPC.Month = (int)((Months)Enum.Parse(typeof(Months), month.Trim()));
            reportsPC.MonthName = month;
            reportsPC.Year = int.Parse(Utilities.GetLast(reports.SelectedMonthYear, 4));
            reportsPC.CrewID = reports.CrewID;

            List<ReportsPOCO> reportsList = new List<ReportsPOCO>();
            reportsList = reportsBL.GetCrewIDFromWorkSessions(reportsPC, int.Parse(Session["VesselID"].ToString()));

            string[] bookedHours = new string[31];
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
        [TraceFilterAttribute]
        
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
        [TraceFilterAttribute]
        
        public JsonResult GetDayWiseCrewData(string bookDate)
        {
            //Reports reports = new Reports();
            ReportsBL reportsBL = new ReportsBL();
            ReportsPOCO reportsPC = new ReportsPOCO();

            //string month = reports.SelectedMonthYear.Substring(0, reports.SelectedMonthYear.Length - 4);

            reportsPC.BookDate = bookDate;
            //crewPC.BookDate = DateTime.ParseExact(selectedDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            
            // reportsPC.CrewID = reports.CrewID;

            List<ReportsPOCO> reportsList = new List<ReportsPOCO>();
            reportsList = reportsBL.GetDayWiseCrewBookingData(reportsPC, int.Parse(Session["VesselID"].ToString()));

            //string[] bookedHours = new string[31];
            //int row = 0;
            //foreach (ReportsPOCO item in reportsList)
            //{
            //    bookedHours[row] = item.Hours;


            //    row++;
            //}


            var data = reportsList;



            // return Json(data, JsonRequestBehavior.AllowGet);
            return Json(new { BookedHours = data }, JsonRequestBehavior.AllowGet);
        }

        [TraceFilterAttribute]
        public JsonResult GetVarianceFromWorkSessions(Reports reports)
        {
            ReportsBL reportsBL = new ReportsBL();
            ReportsPOCO reportsPC = new ReportsPOCO();

            int draw, start, length;
            int pageIndex = 0;

            if (null != Request.Form.GetValues("draw"))
            {
                draw = int.Parse(Request.Form.GetValues("draw").FirstOrDefault().ToString());
                start = int.Parse(Request.Form.GetValues("start").FirstOrDefault().ToString());
				length = 31;  //int.Parse(Request.Form.GetValues("length").FirstOrDefault().ToString());
            }
            else
            {
                draw = 1;
                start = 0;
                length = 31;
            }
            if (start == 0)
            {
                pageIndex = 1;
            }
            else
            {
                pageIndex = (start / length) + 1;
            }
            int totalrecords = 0;
            string month = reports.SelectedMonthYear.Substring(0, reports.SelectedMonthYear.Length - 4);

            reportsPC.Month = (int)((Months)Enum.Parse(typeof(Months), month.Trim()));
            reportsPC.MonthName = month;
            reportsPC.Year = int.Parse(Utilities.GetLast(reports.SelectedMonthYear, 4));
            reportsPC.CrewID = reports.CrewID;

            List<ReportsPOCO> reportsList = new List<ReportsPOCO>();
            reportsList = reportsBL.GetVarianceFromWorkSessions(reportsPC, pageIndex, ref totalrecords, length, int.Parse(Session["VesselID"].ToString()));
            //32 to 36
            string[] bookedHours = new string[36];
            int row = 0;
            foreach (ReportsPOCO item in reportsList)
            {
                bookedHours[row] = item.Hours;
                row++;
            }
            var data = reportsList;



            return Json(new { draw = draw, recordsFiltered = totalrecords, recordsTotal = totalrecords, data = data }, JsonRequestBehavior.AllowGet);
            // return Json(data, JsonRequestBehavior.AllowGet);
            //return Json(new { BookedHours = data }, JsonRequestBehavior.AllowGet);
        }
        
        [TraceFilterAttribute]
        public JsonResult GetVarianceFromWorkSessionsForPdf(Reports reports)
        {
            ReportsBL reportsBL = new ReportsBL();
            ReportsPOCO reportsPC = new ReportsPOCO();

            //int draw, start, length;
            int pageIndex = 0;

            //if (null != Request.Form.GetValues("draw"))
            //{
            //    draw = int.Parse(Request.Form.GetValues("draw").FirstOrDefault().ToString());
            //    start = int.Parse(Request.Form.GetValues("start").FirstOrDefault().ToString());
            //    length = int.Parse(Request.Form.GetValues("length").FirstOrDefault().ToString());
            //}
            //else
            //{
            //    draw = 1;
            //    start = 0;
            //    length = 31;
            //}
            //if (start == 0)
            //{
            //    pageIndex = 1;
            //}
            //else
            //{
            //    pageIndex = (start / length) + 1;
            //}
            int totalrecords = 0;
            string month = reports.SelectedMonthYear.Substring(0, reports.SelectedMonthYear.Length - 4);

            reportsPC.Month = (int)((Months)Enum.Parse(typeof(Months), month.Trim()));
            reportsPC.MonthName = month;
            reportsPC.Year = int.Parse(Utilities.GetLast(reports.SelectedMonthYear, 4));
            reportsPC.CrewID = reports.CrewID;

            List<ReportsPOCO> reportsList = new List<ReportsPOCO>();
            reportsList = reportsBL.GetVarianceFromWorkSessionsForPdf(reportsPC, 1, ref totalrecords, 31, int.Parse(Session["VesselID"].ToString()));

            string[] bookedHours = new string[31];
            int row = 0;
            foreach (ReportsPOCO item in reportsList)
            {
                bookedHours[row] = item.Hours;
                row++;
            }
            var data = reportsList;


           
             return Json(data, JsonRequestBehavior.AllowGet);
            //return Json(new { BookedHours = data }, JsonRequestBehavior.AllowGet);
        }
        
        [TraceFilterAttribute]
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
                length = 15;
            }

            if (start == 0)
            {
                pageIndex = 1;
            }
            else
            {
                pageIndex = (start / length) + 1;
            }

            CrewListReportBL crewListReportBL = new CrewListReportBL();
            int totalrecords = 0;

            List<CrewPOCO> crewpocoList = new List<CrewPOCO>();
            crewpocoList = crewListReportBL.GetCrewReportListPageWise(pageIndex, ref totalrecords, length, int.Parse(Session["VesselID"].ToString()));
            List<Crew> crewList = new List<Crew>();
            foreach (CrewPOCO crewPC in crewpocoList)
            {
                Crew crew = new Crew();
                crew.RowNumber = crewPC.RowNumber;
                crew.ID = crewPC.ID;
                crew.Name = crewPC.Name;
                crew.RankName = crewPC.RankName;

                //crew.FlagOfShip = crewPC.FlagOfShip;      //////////////////////////////// deep
                crew.DOB1 = crewPC.DOB1;
                crew.Nationality = crewPC.Nationality;
                crew.EmployeeNumber = crewPC.EmployeeNumber;
                crew.PassportSeamanPassportBook = crewPC.PassportSeamanPassportBook;
                crew.Seaman = crewPC.Seaman;
                crewList.Add(crew);
            }

            var data = crewList;

            return Json(new { draw = draw, recordsFiltered = totalrecords, recordsTotal = totalrecords, data = data }, JsonRequestBehavior.AllowGet);
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
				length = 1000;//int.Parse(Request.Form.GetValues("length").FirstOrDefault().ToString());
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

            CrewListReportBL crewListReportBL = new CrewListReportBL();
            int totalrecords = 0;

            List<CrewPOCO> crewpocoList = new List<CrewPOCO>();
            crewpocoList = crewListReportBL.GetCrewReportListPageWise2(pageIndex, ref totalrecords, length, int.Parse(Session["VesselID"].ToString()));
            List<Crew> crewList = new List<Crew>();
            foreach (CrewPOCO crewPC in crewpocoList)
            {
                Crew crew = new Crew();
                crew.RowNumber = crewPC.RowNumber;
                crew.ID = crewPC.ID;
                crew.Name = crewPC.Name;
                crew.RankName = crewPC.RankName;

                //crew.FlagOfShip = crewPC.FlagOfShip;      //////////////////////////////// deep
                crew.DOB1 = crewPC.DOB1;
                crew.Nationality = crewPC.Nationality;
                crew.EmployeeNumber = crewPC.EmployeeNumber;
                crew.PassportSeamanPassportBook = crewPC.PassportSeamanPassportBook;
                crew.Seaman = crewPC.Seaman;
                crewList.Add(crew);
            }

            var data = crewList;

            return Json(new { draw = draw, recordsFiltered = totalrecords, recordsTotal = totalrecords, data = data }, JsonRequestBehavior.AllowGet);
        }

        public string RenderViewAsString(string viewName, ViewDataDictionary viewData)
        {
            // create a string writer to receive the HTML code
            StringWriter stringWriter = new StringWriter();

            // get the view to render
            ViewEngineResult viewResult = ViewEngines.Engines.FindView(ControllerContext, viewName, null);
            // create a context to render a view based on a model
            ViewContext viewContext = new ViewContext(
                    ControllerContext,
                    viewResult.View,
                    viewData,
                    new TempDataDictionary(),
                    stringWriter
                    );

            // render the view to a HTML code
            viewResult.View.Render(viewContext, stringWriter);

            // return the HTML code
            return stringWriter.ToString();
        }

        public JsonResult GetPlusOneDayAdjustmentValue(string monthyear)
        {

            TimeAdjustmentBL reportsBL = new TimeAdjustmentBL();
            OneDayTimeAdjustmentPOCO reportsPC = new OneDayTimeAdjustmentPOCO();
            OneDayTimeAdjustment reportsM = new OneDayTimeAdjustment();

            string month = monthyear.Substring(0, monthyear.Length - 4);

            int mon  = (int)((Months)Enum.Parse(typeof(Months), month.Trim()));
            //reportsPC.MonthName = month;
            int year = int.Parse(Utilities.GetLast(monthyear, 4));
            //reportsPC.CrewID = reports.CrewID;

            List<OneDayTimeAdjustmentPOCO> reportsList = new List<OneDayTimeAdjustmentPOCO>();
            reportsList = reportsBL.GetPlusOneDayAdjustmentDays(mon, year, int.Parse(Session["VesselID"].ToString()));

            var data = reportsList;
            
            return Json(new { BookedHours = data }, JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetMinusOneDayAdjustmentValue(string monthyear,string crewID)
        {

            TimeAdjustmentBL reportsBL = new TimeAdjustmentBL();
            OneDayTimeAdjustmentPOCO reportsPC = new OneDayTimeAdjustmentPOCO();
            OneDayTimeAdjustment reportsM = new OneDayTimeAdjustment();

            string month = monthyear.Substring(0, monthyear.Length - 4);

            int mon = (int)((Months)Enum.Parse(typeof(Months), month.Trim()));
            //reportsPC.MonthName = month;
            int year = int.Parse(Utilities.GetLast(monthyear, 4));
            //reportsPC.CrewID = reports.CrewID;

            List<OneDayTimeAdjustmentPOCO> reportsList = new List<OneDayTimeAdjustmentPOCO>();
            reportsList = reportsBL.GetMinusOneDayAdjustmentDays(mon, year,int.Parse(crewID), int.Parse(Session["VesselID"].ToString()));

            var data = reportsList;

            return Json(new { BookedHours = data }, JsonRequestBehavior.AllowGet);
        }

        public List<OneDayTimeAdjustmentPOCO> GetMinusOneDayAdjustmentValueForPDF(string monthyear, string crewID)
        {

            TimeAdjustmentBL reportsBL = new TimeAdjustmentBL();
            OneDayTimeAdjustmentPOCO reportsPC = new OneDayTimeAdjustmentPOCO();
            OneDayTimeAdjustment reportsM = new OneDayTimeAdjustment();

            string month = monthyear.Substring(0, monthyear.Length - 4);

            int mon = (int)((Months)Enum.Parse(typeof(Months), month.Trim()));
            //reportsPC.MonthName = month;
            int year = int.Parse(Utilities.GetLast(monthyear, 4));
            //reportsPC.CrewID = reports.CrewID;

            List<OneDayTimeAdjustmentPOCO> reportsList = new List<OneDayTimeAdjustmentPOCO>();
            reportsList = reportsBL.GetMinusOneDayAdjustmentDays(mon, year, int.Parse(crewID), int.Parse(Session["VesselID"].ToString()));

            //var data = reportsList;

            return reportsList;
        }

        public List<OneDayTimeAdjustmentPOCO> GetPlusOneDayAdjustmentValueForPDF(string monthyear)
        {

            TimeAdjustmentBL reportsBL = new TimeAdjustmentBL();
            OneDayTimeAdjustmentPOCO reportsPC = new OneDayTimeAdjustmentPOCO();
            OneDayTimeAdjustment reportsM = new OneDayTimeAdjustment();

            string month = monthyear.Substring(0, monthyear.Length - 4);

            int mon = (int)((Months)Enum.Parse(typeof(Months), month.Trim()));
            //reportsPC.MonthName = month;
            int year = int.Parse(Utilities.GetLast(monthyear, 4));
            //reportsPC.CrewID = reports.CrewID;

            List<OneDayTimeAdjustmentPOCO> reportsList = new List<OneDayTimeAdjustmentPOCO>();
            reportsList = reportsBL.GetPlusOneDayAdjustmentDays(mon, year , int.Parse(Session["VesselID"].ToString()));

            //var data = reportsList;

            //return Json(new { BookedHours = data }, JsonRequestBehavior.AllowGet);
            return reportsList;
        }

        public List<ReportsPOCO> GetMonthlyDataForWebForPDF(Reports reports)
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

            string[] bookedHours = new string[62];
            int row = 0;
            foreach (ReportsPOCO item in reportsList)
            {
                bookedHours[row] = item.Hours;

                row++;
            }

            var data = reportsList;

            //return Json(new { BookedHours = data }, JsonRequestBehavior.AllowGet);
            return reportsList;
        }

        public JsonResult HTML_Report1(string monthyear, string crewID,string fullname,string rank)
        {
            ReportsPOCO reportsPC = new ReportsPOCO();  //////

            string month = monthyear.Substring(0, monthyear.Length - 4);

            
            //reportsPC.Month = (int)((Months)Enum.Parse(typeof(Months), month.Trim()));  //////
            //reportsPC.MonthName = month;  //////





            int mon = (int)((Months)Enum.Parse(typeof(Months), month.Trim()));
            reportsPC.MonthName = month;
            int year = int.Parse(Utilities.GetLast(monthyear, 4));

            List<OneDayTimeAdjustmentPOCO> reportsList = new List<OneDayTimeAdjustmentPOCO>();
            reportsList = GetMinusOneDayAdjustmentValueForPDF(monthyear, crewID);

            List<OneDayTimeAdjustmentPOCO> reports1List = new List<OneDayTimeAdjustmentPOCO>();
            reports1List = GetPlusOneDayAdjustmentValueForPDF(monthyear);

            Reports r = new Reports();
            r.CrewID = int.Parse(crewID);
            r.SelectedMonthYear = monthyear;
            List<ReportsPOCO> reports = GetMonthlyDataForWebForPDF(r);

            string html = GenerateReport(reportsList, reports1List, reports,fullname,rank, month, year );

            var data = html.ToString();
            return Json(data, JsonRequestBehavior.AllowGet);
        } //end

        private string GetColorHexCode(int index, ReportsPOCO reports)
        {
            string colorCode = string.Empty;
            if (reports.Hours.Substring(index, 1) == "1")
                // colorCode = "&#9724;";
                colorCode = "<h4 style=\"padding-top:0px;padding-bottom:0px;padding-right:0px;padding-left:0px;margin-top:0px;margin-bottom:0px;margin-right:0px;margin-left:0px;\" >&#9673;</h4>";//"&#9673;";
            else if (reports.Hours.Substring(index, 1) == "3")
                // colorCode = "&#9704;";
                colorCode = "<h4 style=\"padding-top:0px;padding-bottom:0px;padding-right:0px;padding-left:0px;margin-top:0px;margin-bottom:0px;margin-right:0px;margin-left:0px;\" >&#9681;</h4>"; //"&#9681;";
            else if (reports.Hours.Substring(index, 1) == "4")
                // colorCode = "&#9703;";
                colorCode = "<h4 style=\"padding-top:0px;padding-bottom:0px;padding-right:0px;padding-left:0px;margin-top:0px;margin-bottom:0px;margin-right:0px;margin-left:0px;\" >&#9680;</h4>";   //"&#9680;";
            return colorCode;
        }

        public String  GenerateReport(List<OneDayTimeAdjustmentPOCO> reportsList, List<OneDayTimeAdjustmentPOCO> reports1List, List<ReportsPOCO> reports,string fullname,string rank, string month, int year)
        {
            StringBuilder sb = new StringBuilder();
            // PensiionBL pension = new PensiionBL();
            //  string refno = pension.SavePensionPrintDetails();

            #region Header
            sb.AppendLine("<body style=\"padding: 30px;\">");
            sb.AppendLine("");
            sb.AppendLine("");
            sb.AppendLine("");
            sb.AppendLine("<table style=\"font-family: arial, sans-serif; border-collapse: collapse; width: 100%;\">");
            sb.AppendLine("  <tr>");
            sb.AppendLine("    <td style=\"text-align: left; padding: 8px;\">HOURS OF WORK AND REST</td>");
            sb.AppendLine("    <td style=\"text-align: right; padding: 8px;\">    </ td>");
            sb.AppendLine("<img src=\"../companylogo/companylogo.png\" style=\"width:112px;\">");
            sb.AppendLine("   <td> &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp;</td>");
           // sb.AppendLine("    <td style=\"text-align: right; padding: 8px;\">Revision Number:</td>");
            sb.AppendLine("  </tr>");
            sb.AppendLine("   ");
            sb.AppendLine("  <tr>");
          //  sb.AppendLine("    <td style=\"text-align: left; padding: 8px;\">Form Number :</td>");
            sb.AppendLine(" <td></td>");
         //   sb.AppendLine("    <td style=\"text-align: right; padding: 8px;\">Page Number :</td>");
            sb.AppendLine("  </tr>");
            sb.AppendLine(" ");
            sb.AppendLine(" ");
            sb.AppendLine("</table>");
            sb.AppendLine("    <hr>");
            sb.AppendLine("    <table style=\"font-family: arial, sans-serif;");
            sb.AppendLine("    border-collapse: collapse;");
            sb.AppendLine("    width: 100%;\">");
            sb.AppendLine("  <tr>");
            sb.AppendLine("    <td style=\"text-align: left; padding: 8px;\">Seafare's Full Name: <span id=\"nm\">"+ fullname   +"</span></td>");    
            sb.AppendLine("<td style=\"text-align: left; padding: 8px;\">Vessel Name:" + Session["ShipName"].ToString() + "</td>");
            sb.AppendLine("    <td style=\"text-align: right; padding: 8px;\">Master :<span id=\"rn1\">"+ Session["Master"].ToString() + "</span></td>");
            sb.AppendLine("  </tr>");
            sb.AppendLine("  <tr>");
            sb.AppendLine("    <td style=\"text-align: left; padding: 8px;\">Seafare's Rank :<span id=\"rn\">"+ rank +"</span></td>");
            sb.AppendLine("<td style=\"text-align: left; padding: 8px;\">IMO Number :" + Session["IMONumber"].ToString() + "</td>");
            sb.AppendLine("    <td style=\"text-align: left; padding: 8px;\"></td>");
            sb.AppendLine("  </tr>");
            sb.AppendLine("         <tr>");
            sb.AppendLine("    <td style=\"text-align: left; padding: 8px;\">Year :<span id=\"yr\">"+ year.ToString() +"</span></td>");
            sb.AppendLine("<td style=\"text-align: left; padding: 8px;\">Month :<span id=\"mn\">"+ month +"</span></td>");
            sb.AppendLine("    <td style=\"text-align: right; padding: 8px;\">Flag :" + Session["Flag"].ToString() + "</td>");
            sb.AppendLine("  </tr>");
            sb.AppendLine(" ");
            sb.AppendLine(" ");

            sb.AppendLine("    </table>");



            /////////////////////////////////////////////////////////////////////////////////////////////
            //sb.AppendLine("    <div style=\"background: #f7f7f7; padding: 5px 9px; margin-bottom: 8px; border-radius: 7px; color: #000; font-size: 12px;    width: 200px; height: 70px; border:1px solid #ccc;\">");
            //sb.AppendLine("                         ");
            //sb.AppendLine("     IMO STCW &#9818;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ILO Rest (Flexible) &#9824;<br />");
            //sb.AppendLine("     ILO Work &#9819;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Customeised &#9827;<br />");
            //sb.AppendLine("     ILO Rest &#9820;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;IMO STCW 2010 &#9829;<br />");
            //sb.AppendLine("     OCIMF &#9822;<br />");
            //sb.AppendLine("                                ");
            //sb.AppendLine("    </div>");

           // sb.AppendLine("_______________________________________________________________________________________________________");

            sb.AppendLine("            <div class=\"row desi\">");
            sb.AppendLine("                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
            sb.AppendLine("                    ILO Work &#9819; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
            sb.AppendLine("                    ILO Rest &#9820; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
            sb.AppendLine("                    OCIMF &#9822; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
            sb.AppendLine("                    Customeised &#9827; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
            sb.AppendLine("                    IMO STCW 2010 &#9829;  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
            sb.AppendLine("                    OPA-90 &#9828;");
            sb.AppendLine("                </div>");
            sb.AppendLine("");

          //  sb.AppendLine("_______________________________________________________________________________________________________");
          //  sb.AppendLine("_________________________________________________________________________________________________________________________________");
            //////////////////////////////////////////////////////////////////////////////////////////////////



            sb.AppendLine("    ");
            // sb.AppendLine("    <button type=\"button\">Hide/show last</button>");
            sb.AppendLine("");
            sb.AppendLine("<table style=\"font-family: arial, sans-serif; border-collapse: collapse; width: 100%; border:1px solid #ccc;\">");
            sb.AppendLine("    <tr>");
            sb.AppendLine("        <th width=\"2%\" style=\"border:1px solid #000;\">Date</th>");
            sb.AppendLine("        <th width=\"1%\" style=\"border:1px solid #000;\">00</th>");
            sb.AppendLine("        <th width=\"1%\" style=\"border:1px solid #000;\">00</th>");
            sb.AppendLine("        <th width=\"1%\" style=\"border:1px solid #000;\">01</th>");
            sb.AppendLine("        <th width=\"1%\" style=\"border:1px solid #000;\">02</th>");
            sb.AppendLine("        <th width=\"1%\" style=\"border:1px solid #000;\">03</th>");
            sb.AppendLine("        <th width=\"1%\" style=\"border:1px solid #000;\">04</th>");
            sb.AppendLine("        <th width=\"1%\" style=\"border:1px solid #000;\">05</th>");
            sb.AppendLine("        <th width=\"1%\" style=\"border:1px solid #000;\">06</th>");
            sb.AppendLine("        <th width=\"1%\" style=\"border:1px solid #000;\">07</th>");
            sb.AppendLine("        <th width=\"1%\" style=\"border:1px solid #000;\">08</th>");
            sb.AppendLine("        <th width=\"1%\" style=\"border:1px solid #000;\">09</th>");
            sb.AppendLine("        <th width=\"1%\" style=\"border:1px solid #000;\">10</th>");
            sb.AppendLine("        <th width=\"1%\" style=\"border:1px solid #000;\">11</th>");
            sb.AppendLine("        <th width=\"1%\" style=\"border:1px solid #000;\">12</th>");
            sb.AppendLine("        <th width=\"1%\" style=\"border:1px solid #000;\">13</th>");
            sb.AppendLine("        <th width=\"1%\" style=\"border:1px solid #000;\">14</th>");
            sb.AppendLine("        <th width=\"1%\" style=\"border:1px solid #000;\">15</th>");
            sb.AppendLine("        <th width=\"1%\" style=\"border:1px solid #000;\">16</th>");
            sb.AppendLine("        <th width=\"1%\" style=\"border:1px solid #000;\">17</th>");
            sb.AppendLine("        <th width=\"1%\" style=\"border:1px solid #000;\">18</th>");
            sb.AppendLine("        <th width=\"1%\" style=\"border:1px solid #000;\">19</th>");
            sb.AppendLine("        <th width=\"1%\" style=\"border:1px solid #000;\">20</th>");
            sb.AppendLine("        <th width=\"1%\" style=\"border:1px solid #000;\">21</th>");
            sb.AppendLine("        <th width=\"1%\" style=\"border:1px solid #000;\">22</th>");
            sb.AppendLine("        <th width=\"1%\" style=\"border:1px solid #000;\">23</th>");
            sb.AppendLine("        <th width=\"2%\" style=\"border:1px solid #000;\">Normal</th>");
            sb.AppendLine("        <th width=\"2%\" style=\"border:1px solid #000;\">Overtime</th>");
            sb.AppendLine("        <th width=\"4%\" style=\"border:1px solid #000;\">Total</th>");
            sb.AppendLine("        <th width=\"4%\" style=\"border:1px solid #000;\">Rest</th>");
            sb.AppendLine("        <th width=\"40%\" style=\"border:1px solid #000;\">Comments</th>");
            sb.AppendLine("        <th width=\"3%\" style=\"border:1px solid #000;\">Minimum Rest in any 24 hours</th>");
            sb.AppendLine("        <th width=\"3%\" style=\"border:1px solid #000;\">Minimum Rest in any 7 days</th>");
            sb.AppendLine("    </tr>"); 
            #endregion

            for (int i = 0; i < (31 + reportsList.Count); i++)
            {
                var match = reportsList.FirstOrDefault(m => m.MinusAdjustmentDate == (i + 1).ToString());
                var disablerow = reports1List.FirstOrDefault(h => h.AdjustmentDate.Substring(0, 2) == (i + 1).ToString());
                var reportdata = reports.FirstOrDefault(j => j.BookDate == (i + 1).ToString());

                if (reportdata == null) // blank row
                {
                    //if (match != null)
                    if (disablerow == null)
                    {
                        sb.AppendLine("    <tr style=\"border:1px solid #000;\">");
                        if (i + 1 < 10)
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + "0" + (i + 1).ToString() + "</td>"); //Date
                        else
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + (i + 1).ToString() + "</td>");

                        sb.AppendLine("        <td style=\"border:1px solid #000;\"></td>"); //00
                        sb.AppendLine("        <td style=\"border:1px solid #000;\"></td>"); //0
                        sb.AppendLine("        <td style=\"border:1px solid #000;\"></td>"); //1

                        sb.AppendLine("        <td style=\"border:1px solid #000;\"></td>"); //2
                        sb.AppendLine("        <td style=\"border:1px solid #000;\"></td>"); //3
                        sb.AppendLine("        <td style=\"border:1px solid #000;\"></td>");//4

                        sb.AppendLine("        <td style=\"border:1px solid #000;\"></td>");//5
                        sb.AppendLine("        <td style=\"border:1px solid #000;\"></td>");//6
                        sb.AppendLine("        <td style=\"border:1px solid #000;\"></td>");//7
                        sb.AppendLine("        <td style=\"border:1px solid #000;\"></td>");//8
                        sb.AppendLine("        <td style=\"border:1px solid #000;\"></td>");//9
                        sb.AppendLine("        <td style=\"border:1px solid #000;\"></td>");//10
                        sb.AppendLine("        <td style=\"border:1px solid #000;\"></td>");//11
                        sb.AppendLine("        <td style=\"border:1px solid #000;\"></td>");//12
                        sb.AppendLine("        <td style=\"border:1px solid #000;\"></td>");//13
                        sb.AppendLine("        <td style=\"border:1px solid #000;\"></td>");//14
                        sb.AppendLine("        <td style=\"border:1px solid #000;\"></td>");//15
                        sb.AppendLine("        <td style=\"border:1px solid #000;\"></td>");//16
                        sb.AppendLine("        <td style=\"border:1px solid #000;\"></td>");//17
                        sb.AppendLine("        <td style=\"border:1px solid #000;\"></td>");//18
                        sb.AppendLine("        <td style=\"border:1px solid #000;\"></td>");//19
                        sb.AppendLine("        <td style=\"border:1px solid #000;\"></td>");//20
                        sb.AppendLine("        <td style=\"border:1px solid #000;\"></td>");//21
                        sb.AppendLine("        <td style=\"border:1px solid #000;\"></td>");//22
                        sb.AppendLine("        <td style=\"border:1px solid #000;\"></td>");//23
                        sb.AppendLine("        <td style=\"border:1px solid #000;\"></td>");//Normal
                        sb.AppendLine("        <td style=\"border:1px solid #000;\"></td>");//Overtime
                        sb.AppendLine("        <td style=\"border:1px solid #000;\"></td>");//Total
                        sb.AppendLine("        <td style=\"border:1px solid #000;\"></td>");//Rest
                        sb.AppendLine("        <td style=\"border:1px solid #000;\"></td>");//Comments
                        sb.AppendLine("        <td style=\"border:1px solid #000;\"></td>");//Min 24
                                                                                            /* pp */
                        sb.AppendLine("        <td style=\"border:1px solid #000;\"></td>"); // Min 7
                                                                                             // sb.AppendLine("        <td style=\"border:1px solid #000;\">B</td>");
                                                                                             //sb.AppendLine("");
                        sb.AppendLine("    </tr>");
                    }
                    else if(disablerow != null)
                    {
                        sb.AppendLine("    <tr style=\"border:1px solid #000;\">");
                        if (i + 1 < 10)
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + "0" + (i + 1).ToString() + "</td>"); //Date // append RegimeSymbol here
                        else
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + (i + 1).ToString() + "</td>"); // append RegimeSymbol here


						sb.AppendLine("        <td style=\"border:1px solid #000; background: #98999b !important;-webkit-print-color-adjust: exact;color-adjust:exact;\"></td>"); //00
                        sb.AppendLine("        <td style=\"border:1px solid #000; background: #98999b !important;-webkit-print-color-adjust: exact;color-adjust:exact;\"></td>"); //0
                        sb.AppendLine("        <td style=\"border:1px solid #000; background: #98999b !important;-webkit-print-color-adjust: exact;color-adjust:exact;\"></td>"); //1

                        sb.AppendLine("        <td style=\"border:1px solid #000; background: #98999b !important;-webkit-print-color-adjust: exact;color-adjust:exact;\"></td>"); //2
                        sb.AppendLine("        <td style=\"border:1px solid #000; background: #98999b !important;-webkit-print-color-adjust: exact;color-adjust:exact;\"></td>"); //3
                        sb.AppendLine("        <td style=\"border:1px solid #000; background: #98999b !important;-webkit-print-color-adjust: exact;color-adjust:exact;\"></td>");//4

                        sb.AppendLine("        <td style=\"border:1px solid #000; background: #98999b !important;-webkit-print-color-adjust: exact;color-adjust:exact;\"></td>");//5
                        sb.AppendLine("        <td style=\"border:1px solid #000; background: #98999b !important;-webkit-print-color-adjust: exact;color-adjust:exact;\"></td>");//6
                        sb.AppendLine("        <td style=\"border:1px solid #000; background: #98999b !important;-webkit-print-color-adjust: exact;color-adjust:exact;\"></td>");//7
                        sb.AppendLine("        <td style=\"border:1px solid #000; background: #98999b !important;-webkit-print-color-adjust: exact;color-adjust:exact;\"></td>");//8
                        sb.AppendLine("        <td style=\"border:1px solid #000; background: #98999b !important;-webkit-print-color-adjust: exact;color-adjust:exact;\"></td>");//9
                        sb.AppendLine("        <td style=\"border:1px solid #000; background: #98999b !important;-webkit-print-color-adjust: exact;color-adjust:exact;\"></td>");//10
                        sb.AppendLine("        <td style=\"border:1px solid #000; background: #98999b !important;-webkit-print-color-adjust: exact;color-adjust:exact;\"></td>");//11
                        sb.AppendLine("        <td style=\"border:1px solid #000; background: #98999b !important;-webkit-print-color-adjust: exact;color-adjust:exact;\"></td>");//12
                        sb.AppendLine("        <td style=\"border:1px solid #000; background: #98999b !important;-webkit-print-color-adjust: exact;color-adjust:exact;\"></td>");//13
                        sb.AppendLine("        <td style=\"border:1px solid #000; background: #98999b !important;-webkit-print-color-adjust: exact;color-adjust:exact;\"></td>");//14
                        sb.AppendLine("        <td style=\"border:1px solid #000; background: #98999b !important;-webkit-print-color-adjust: exact;color-adjust:exact;\"></td>");//15
                        sb.AppendLine("        <td style=\"border:1px solid #000; background: #98999b !important;-webkit-print-color-adjust: exact;color-adjust:exact;\"></td>");//16
                        sb.AppendLine("        <td style=\"border:1px solid #000; background: #98999b !important;-webkit-print-color-adjust: exact;color-adjust:exact;\"></td>");//17
                        sb.AppendLine("        <td style=\"border:1px solid #000; background: #98999b !important;-webkit-print-color-adjust: exact;color-adjust:exact;\"></td>");//18
                        sb.AppendLine("        <td style=\"border:1px solid #000; background: #98999b !important;-webkit-print-color-adjust: exact;color-adjust:exact;\"></td>");//19
                        sb.AppendLine("        <td style=\"border:1px solid #000; background: #98999b !important;-webkit-print-color-adjust: exact;color-adjust:exact;\"></td>");//20
                        sb.AppendLine("        <td style=\"border:1px solid #000; background: #98999b !important;-webkit-print-color-adjust: exact;color-adjust:exact;\"></td>");//21
                        sb.AppendLine("        <td style=\"border:1px solid #000; background: #98999b !important;-webkit-print-color-adjust: exact;color-adjust:exact;\"></td>");//22
                        sb.AppendLine("        <td style=\"border:1px solid #000; background: #98999b !important;-webkit-print-color-adjust: exact;color-adjust:exact;\"></td>");//23
                        sb.AppendLine("        <td style=\"border:1px solid #000; background: #98999b !important;-webkit-print-color-adjust: exact;color-adjust:exact;\"></td>");//Normal
                        sb.AppendLine("        <td style=\"border:1px solid #000; background: #98999b !important;-webkit-print-color-adjust: exact;color-adjust:exact;\"></td>");//Overtime
                        sb.AppendLine("        <td style=\"border:1px solid #000; background: #98999b !important;-webkit-print-color-adjust: exact;color-adjust:exact;\"></td>");//Total
                        sb.AppendLine("        <td style=\"border:1px solid #000; background: #98999b !important;-webkit-print-color-adjust: exact;color-adjust:exact;\"></td>");//Rest
                        sb.AppendLine("        <td style=\"border:1px solid #000; background: #98999b !important;-webkit-print-color-adjust: exact;color-adjust:exact;\"></td>");//Comments
                        sb.AppendLine("        <td style=\"border:1px solid #000; background: #98999b !important;-webkit-print-color-adjust: exact;color-adjust:exact;\"></td>");//Min 24
                                                                                                                                                                                 /* pp */
                        sb.AppendLine("        <td style=\"border:1px solid #000; background: #98999b !important;-webkit-print-color-adjust: exact;color-adjust:exact;\"></td>"); // Min 7
                                                                                                                                                                                  // sb.AppendLine("        <td style=\"border:1px solid #000;\">B</td>");
                                                                                                                                                                                  //sb.AppendLine("");
                        sb.AppendLine("    </tr>");
                    }

                        
                        
                    
                   
                }
                else
                {
                    if(reportdata.AdjustmentFactor == "0" || reportdata.AdjustmentFactor == "+30" || reportdata.AdjustmentFactor == "+1"  || reportdata.AdjustmentFactor == "" || reportdata.AdjustmentFactor == "BOOKING_NOT_ALLOWED")
                    {
                        if (match != null)
                        {
                            i++;



                            sb.AppendLine("    <tr style=\"border:1px solid #000;\">");
                            if (i + 1 < 10)
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + "0" + (i + 1).ToString() + reportdata.RegimeSymbol + "</td>"); // append RegimeSymbol here
							else
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + (i + 1).ToString() + reportdata.RegimeSymbol + "</td>"); // append RegimeSymbol here

							sb.AppendLine("        <td style=\"border:1px solid #000;\"></td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(0, reportdata) + "</td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(1, reportdata) + "</td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(2, reportdata) + "</td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(3, reportdata) + "</td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(4, reportdata) + "</td>");

                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(5, reportdata) + "</td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(6, reportdata) + "</td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(7, reportdata) + "</td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(8, reportdata) + "</td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(9, reportdata) + "</td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(10, reportdata) + "</td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(11, reportdata) + "</td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(12, reportdata) + "</td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(13, reportdata) + "</td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(14, reportdata) + "</td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(15, reportdata) + "</td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(16, reportdata) + "</td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(17, reportdata) + "</td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(18, reportdata) + "</td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(19, reportdata) + "</td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(20, reportdata) + "</td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(21, reportdata) + "</td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(22, reportdata) + "</td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(23, reportdata) + "</td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + reportdata.NormalWorkingHours.ToString() + "</td>"); //reportdata.NormalWorkingHours.ToString()
							sb.AppendLine("        <td style=\"border:1px solid #000;\">" + reportdata.OvertimeHours.ToString() + "</td>"); //reportdata.OvertimeHours.ToString()
							sb.AppendLine("        <td style=\"border:1px solid #000;\">" + reportdata.TotalWorkedHours.ToString() + "</td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + reportdata.MinTwentyFourHourrest.ToString() + "</td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + reportdata.Comment  + "</td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + reportdata.MaxRestPeriodInTwentyFourHours.ToString() + "</td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + reportdata.MinSevenDayRest.ToString() + "</td>");
                            //sb.AppendLine("        <td style=\"border:1px solid #000;\">" + "H" + "</td>");
                            sb.AppendLine("");
                            sb.AppendLine("    </tr>");

                            sb.AppendLine("    <tr style=\"border:1px solid #000;\">");
                            if (i + 1 < 10)
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + "0" + (i + 1).ToString() + reportdata.RegimeSymbol + "</td>"); // append RegimeSymbol here
							else
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + (i + 1).ToString() + reportdata.RegimeSymbol + "</td>"); // append RegimeSymbol here

							sb.AppendLine("        <td style=\"border:1px solid #000;\"></td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(0, reportdata) + "</td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(1, reportdata) + "</td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(2, reportdata) + "</td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(3, reportdata) + "</td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(4, reportdata) + "</td>");

                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(5, reportdata) + "</td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(6, reportdata) + "</td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(7, reportdata) + "</td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(8, reportdata) + "</td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(9, reportdata) + "</td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(10, reportdata) + "</td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(11, reportdata) + "</td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(12, reportdata) + "</td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(13, reportdata) + "</td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(14, reportdata) + "</td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(15, reportdata) + "</td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(16, reportdata) + "</td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(17, reportdata) + "</td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(18, reportdata) + "</td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(19, reportdata) + "</td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(20, reportdata) + "</td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(21, reportdata) + "</td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(22, reportdata) + "</td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(23, reportdata) + "</td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + reportdata.NormalWorkingHours.ToString() + "</td>"); //reportdata.NormalWorkingHours.ToString()
							sb.AppendLine("        <td style=\"border:1px solid #000;\">" + reportdata.OvertimeHours.ToString() + "</td>"); //reportdata.OvertimeHours.ToString()
							sb.AppendLine("        <td style=\"border:1px solid #000;\">" + reportdata.TotalWorkedHours.ToString() + "</td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + reportdata.MinTwentyFourHourrest.ToString() + "</td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + reportdata.Comment + "</td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + reportdata.MaxRestPeriodInTwentyFourHours.ToString() + "</td>");
                            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + reportdata.MinSevenDayRest.ToString() + "</td>");
                           // sb.AppendLine("        <td style=\"border:1px solid #000;\">" + "H" + "</td>");
                            sb.AppendLine("");
                            sb.AppendLine("    </tr>");
                        }
                        else
                        {
                            string r = string.Empty;
                            if (disablerow != null)
                            {
                                r = disablerow.AdjustmentDate.Substring(0, 2);
                            }

                            if (!string.IsNullOrEmpty(r))
                            {
                                sb.AppendLine("    <tr style=\"border:1px solid #000;\">");
                                if (i + 1 < 10)
                                    sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\">" + "0" + (i + 1).ToString() +  reportdata.RegimeSymbol + "</td>"); // append RegimeSymbol here
								else
                                    sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\">" + (i + 1).ToString() + reportdata.RegimeSymbol + reportdata.RegimeSymbol + "</td>"); // append RegimeSymbol here

								sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                                
                                sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");

                                sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                                //sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                                sb.AppendLine("");
                                sb.AppendLine("    </tr>");
                            }
                            else
                            {
                                sb.AppendLine("    <tr style=\"border:1px solid #000;\">");
                                if (i + 1 < 10)
                                    sb.AppendLine("        <td style=\"border:1px solid #000;\">" + "0" + (i + 1).ToString() + reportdata.RegimeSymbol + "</td>"); // append RegimeSymbol here
								else
                                    sb.AppendLine("        <td style=\"border:1px solid #000;\">" + (i + 1).ToString() + reportdata.RegimeSymbol + "</td>"); // append RegimeSymbol here

								sb.AppendLine("        <td style=\"border:1px solid #000;\"></td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(0, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(1, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(2, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(3, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(4, reportdata) + "</td>");

                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(5, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(6, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(7, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(8, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(9, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(10, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(11, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(12, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(13, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(14, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(15, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(16, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(17, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(18, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(19, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(20, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(21, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(22, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(23, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + reportdata.NormalWorkingHours.ToString() + "</td>"); //reportdata.NormalWorkingHours.ToString()
								sb.AppendLine("        <td style=\"border:1px solid #000;\">" + reportdata.OvertimeHours.ToString() + "</td>"); //reportdata.OvertimeHours.ToString()
								sb.AppendLine("        <td style=\"border:1px solid #000;\">" + reportdata.TotalWorkedHours.ToString() + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + reportdata.MinTwentyFourHourrest.ToString() + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + reportdata.Comment + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + reportdata.MaxRestPeriodInTwentyFourHours.ToString() + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + reportdata.MinSevenDayRest.ToString() + "</td>");
                               // sb.AppendLine("        <td style=\"border:1px solid #000;\">" + "H" + "</td>");
                                sb.AppendLine("");
                                sb.AppendLine("    </tr>");
                            }



                        } 
                    }
                    else if(reportdata.AdjustmentFactor == "-1")
                    {
                        string d = string.Empty;
                        if (disablerow != null)
                        {
                            d = disablerow.AdjustmentDate.Substring(0, 2);
                           
                        }

                        if (string.IsNullOrEmpty(d))
                        {
                            //find first occurance of 1/3/4
                            var hrsArray = reportdata.Hours.ToCharArray().Select(c => c.ToString()).ToArray();
                            int firstindex = 0;
                            
                              

                            

                            {
                                sb.AppendLine("    <tr style=\"border:1px solid #000;\">");
                                if (i + 1 < 10)
                                    sb.AppendLine("        <td style=\"border:1px solid #000;\">" + "0" + (i + 1).ToString() + reportdata.RegimeSymbol + "</td>"); // append RegimeSymbol here
								else
                                    sb.AppendLine("        <td style=\"border:1px solid #000;\">" + (i + 1).ToString() + reportdata.RegimeSymbol + "</td>"); // append RegimeSymbol here


								if (reportdata.HasOneFirst)
                                    sb.AppendLine("        <td style=\"border:1px solid #000;\">&#9673;</td>");
                                else
                                    sb.AppendLine("        <td style=\"border:1px solid #000;\"></td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(0, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(1, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(2, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(3, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(4, reportdata) + "</td>");

                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(5, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(6, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(7, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(8, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(9, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(10, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(11, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(12, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(13, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(14, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(15, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(16, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(17, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(18, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(19, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(20, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(21, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(22, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(23, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + reportdata.NormalWorkingHours.ToString() + "</td>"); //reportdata.NormalWorkingHours.ToString()
								sb.AppendLine("        <td style=\"border:1px solid #000;\">" + reportdata.OvertimeHours.ToString() + "</td>"); //reportdata.OvertimeHours.ToString()
								sb.AppendLine("        <td style=\"border:1px solid #000;\">" + reportdata.TotalWorkedHours.ToString() + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + reportdata.MinTwentyFourHourrest.ToString() + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + reportdata.Comment + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + reportdata.MaxRestPeriodInTwentyFourHours.ToString() + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + reportdata.MinSevenDayRest.ToString() + "</td>");
                                // sb.AppendLine("        <td style=\"border:1px solid #000;\">" + "H" + "</td>");
                                sb.AppendLine("");
                                sb.AppendLine("    </tr>");
                            }
                        }
                    }
                    else if (reportdata.AdjustmentFactor == "-30")
                    {
                        string d = string.Empty;
                        if (disablerow != null)
                        {
                            d = disablerow.AdjustmentDate.Substring(0, 2);

                        }

                        if (string.IsNullOrEmpty(d))
                        {
                            //find first occurance of 1/3/4
                            var hrsArray = reportdata.Hours.ToCharArray().Select(c => c.ToString()).ToArray();
                            int firstindex = 0;

                            //get first inde of either 1 or 3 or 4
                            for (int c = 0; c < hrsArray.Length; c++)
                            {
                                if (hrsArray[c].ToString() != "0")
                                {
                                    firstindex = c;
                                    break;
                                }
                            }

                            //Set one 1's b4 first index
                            if (firstindex == 1)
                                hrsArray[0] = "1";
                            else if (firstindex >= 2)
                            {
                                hrsArray[firstindex - 1] = "1";

                            }


                            {
                                sb.AppendLine("    <tr style=\"border:1px solid #000;\">");
                                if (i + 1 < 10)
                                    sb.AppendLine("        <td style=\"border:1px solid #000;\">" + "0" + (i + 1).ToString() + reportdata.RegimeSymbol +  "</td>"); // append RegimeSymbol here
								else
                                    sb.AppendLine("        <td style=\"border:1px solid #000;\">" + (i + 1).ToString() + reportdata.RegimeSymbol + "</td>"); // append RegimeSymbol here

								if (reportdata.HasThirtyFirst)
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">&#9680;</td>");
                                else
                                    sb.AppendLine("        <td style=\"border:1px solid #000;\"></td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(0, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(1, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(2, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(3, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(4, reportdata) + "</td>");

                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(5, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(6, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(7, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(8, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(9, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(10, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(11, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(12, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(13, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(14, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(15, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(16, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(17, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(18, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(19, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(20, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(21, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(22, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(23, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + reportdata.NormalWorkingHours.ToString() + "</td>"); //reportdata.NormalWorkingHours.ToString()
								sb.AppendLine("        <td style=\"border:1px solid #000;\">" + reportdata.OvertimeHours.ToString() + "</td>"); //reportdata.OvertimeHours.ToString()
								sb.AppendLine("        <td style=\"border:1px solid #000;\">" + reportdata.TotalWorkedHours.ToString() + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + reportdata.MinTwentyFourHourrest.ToString() + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + reportdata.Comment + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + reportdata.MaxRestPeriodInTwentyFourHours.ToString() + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + reportdata.MinSevenDayRest.ToString() + "</td>");
                                // sb.AppendLine("        <td style=\"border:1px solid #000;\">" + "H" + "</td>");
                                sb.AppendLine("");
                                sb.AppendLine("    </tr>");
                            }
                        }
                    }
                    else if(reportdata.AdjustmentFactor == "-1D")
                    {

                        {
                            string r = string.Empty;
                            if (disablerow != null)
                            {
                                r = disablerow.AdjustmentDate.Substring(0, 2);
                            }

                            //if (!string.IsNullOrEmpty(r))
                            //{
                            //    sb.AppendLine("    <tr style=\"border:1px solid #000;\">");
                            //    if (i + 1 < 10)
                            //        sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\">" + "0" + (i + 1).ToString() + "</td>");
                            //    else
                            //        sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\">" + (i + 1).ToString() + "</td>");

                            //    sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                            //    sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                            //    sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");

                            //    sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                            //    sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                            //    sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");

                            //    sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                            //    sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                            //    sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                            //    sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                            //    sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                            //    sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                            //    sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                            //    sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                            //    sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                            //    sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                            //    sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                            //    sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                            //    sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                            //    sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                            //    sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                            //    sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                            //    sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                            //    sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                            //    sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                            //    sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                            //    sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                            //    sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                            //    sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                            //    sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                            //    sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                            //    sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                            //    //sb.AppendLine("        <td style=\"border:1px solid #000;background-color:#D3D3D3\"></td>");
                            //    sb.AppendLine("");
                            //    sb.AppendLine("    </tr>");
                            //}
                            //else
                            {
                                sb.AppendLine("    <tr style=\"border:1px solid #000;\">");
                                if (i + 1 < 10)
                                    sb.AppendLine("        <td style=\"border:1px solid #000;\">" + "0" + (i + 1).ToString() + reportdata.RegimeSymbol + "</td>"); // append RegimeSymbol here
								else
                                    sb.AppendLine("        <td style=\"border:1px solid #000;\">" + (i + 1).ToString() + reportdata.RegimeSymbol + "</td>"); // append RegimeSymbol here

								sb.AppendLine("        <td style=\"border:1px solid #000;\"></td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(0, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(1, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(2, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(3, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(4, reportdata) + "</td>");

                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(5, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(6, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(7, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(8, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(9, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(10, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(11, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(12, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(13, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(14, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(15, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(16, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(17, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(18, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(19, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(20, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(21, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(22, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(23, reportdata) + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + reportdata.NormalWorkingHours.ToString() + "</td>"); //reportdata.NormalWorkingHours.ToString()
								sb.AppendLine("        <td style=\"border:1px solid #000;\">" + reportdata.OvertimeHours.ToString() + "</td>"); //reportdata.OvertimeHours.ToString()
								sb.AppendLine("        <td style=\"border:1px solid #000;\">" + reportdata.TotalWorkedHours.ToString() + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + reportdata.MinTwentyFourHourrest.ToString() + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + reportdata.Comment + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + reportdata.MaxRestPeriodInTwentyFourHours.ToString() + "</td>");
                                sb.AppendLine("        <td style=\"border:1px solid #000;\">" + reportdata.MinSevenDayRest.ToString() + "</td>");
                                // sb.AppendLine("        <td style=\"border:1px solid #000;\">" + "H" + "</td>");
                                sb.AppendLine("");
                                sb.AppendLine("    </tr>");

                                //get data for second day 
                                reportdata = reports.FirstOrDefault(j => j.BookDate == ((i + 1).ToString() + "_dup"));

                                if (reportdata != null)
                                {


                                    //create second row for same day

                                    sb.AppendLine("    <tr style=\"border:1px solid #000;\">");
                                    if (i + 1 < 10)
                                        sb.AppendLine("        <td style=\"border:1px solid #000;\">" + "0" + (i + 1).ToString() + reportdata.RegimeSymbol + "</td>"); // append RegimeSymbol here
                                    else
                                        sb.AppendLine("        <td style=\"border:1px solid #000;\">" + (i + 1).ToString() + reportdata.RegimeSymbol + "</td>"); // append RegimeSymbol here

                                    sb.AppendLine("        <td style=\"border:1px solid #000;\"></td>");
                                    sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(0, reportdata) + "</td>");
                                    sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(1, reportdata) + "</td>");
                                    sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(2, reportdata) + "</td>");
                                    sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(3, reportdata) + "</td>");
                                    sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(4, reportdata) + "</td>");

                                    sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(5, reportdata) + "</td>");
                                    sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(6, reportdata) + "</td>");
                                    sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(7, reportdata) + "</td>");
                                    sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(8, reportdata) + "</td>");
                                    sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(9, reportdata) + "</td>");
                                    sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(10, reportdata) + "</td>");
                                    sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(11, reportdata) + "</td>");
                                    sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(12, reportdata) + "</td>");
                                    sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(13, reportdata) + "</td>");
                                    sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(14, reportdata) + "</td>");
                                    sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(15, reportdata) + "</td>");
                                    sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(16, reportdata) + "</td>");
                                    sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(17, reportdata) + "</td>");
                                    sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(18, reportdata) + "</td>");
                                    sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(19, reportdata) + "</td>");
                                    sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(20, reportdata) + "</td>");
                                    sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(21, reportdata) + "</td>");
                                    sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(22, reportdata) + "</td>");
                                    sb.AppendLine("        <td style=\"border:1px solid #000;\">" + GetColorHexCode(23, reportdata) + "</td>");
                                    sb.AppendLine("        <td style=\"border:1px solid #000;\">" + reportdata.NormalWorkingHours.ToString() + "</td>"); //reportdata.NormalWorkingHours.ToString()
                                    sb.AppendLine("        <td style=\"border:1px solid #000;\">" + reportdata.OvertimeHours.ToString() + "</td>"); //reportdata.OvertimeHours.ToString()
                                    sb.AppendLine("        <td style=\"border:1px solid #000;\">" + reportdata.TotalWorkedHours.ToString() + "</td>");
                                    sb.AppendLine("        <td style=\"border:1px solid #000;\">" + reportdata.MinTwentyFourHourrest.ToString() + "</td>");
                                    sb.AppendLine("        <td style=\"border:1px solid #000;\">" + reportdata.Comment + "</td>");
                                    sb.AppendLine("        <td style=\"border:1px solid #000;\">" + reportdata.MaxRestPeriodInTwentyFourHours.ToString() + "</td>");
                                    sb.AppendLine("        <td style=\"border:1px solid #000;\">" + reportdata.MinSevenDayRest.ToString() + "</td>");
                                    // sb.AppendLine("        <td style=\"border:1px solid #000;\">" + "H" + "</td>");

                                    sb.AppendLine("");
                                    sb.AppendLine("    </tr>");
                                }
                            }



                        }
                    }
                    
                }


            }

            #region Footer
            sb.AppendLine("   ");
            sb.AppendLine("   ");
            sb.AppendLine("     <tr style=\"border:1px solid #000;\">");
            sb.AppendLine("        <td><b>Total</b></td>");
            sb.AppendLine("         ");
            sb.AppendLine("        <td></td>");
            sb.AppendLine("        <td></td>");
            sb.AppendLine("        <td></td>");
            sb.AppendLine("        <td></td>");
            sb.AppendLine("        <td></td>");
            sb.AppendLine("        <td></td>");
            sb.AppendLine("        <td></td>");
            sb.AppendLine("        <td></td>");
            sb.AppendLine("        <td></td>");
            sb.AppendLine("        <td></td>");
            sb.AppendLine("        <td></td>");
            sb.AppendLine("        <td></td>");
            sb.AppendLine("        <td></td>");
            sb.AppendLine("        <td></td>");
            sb.AppendLine("        <td></td>");
            sb.AppendLine("        <td></td>");
            sb.AppendLine("        <td></td>");
            sb.AppendLine("        <td></td>");
            sb.AppendLine("        <td></td>");
            sb.AppendLine("        <td></td>");
            sb.AppendLine("        <td></td>");
            sb.AppendLine("        <td></td>");
            sb.AppendLine("        <td></td>");
            sb.AppendLine("        <td></td>");
            sb.AppendLine("        <td></td>");
            sb.AppendLine("        <td style=\"border:1px solid #000;\">" + reports[0].TotalNormalHours.ToString() + "</td>"); //reports[0].TotalNormalHours.ToString()
			sb.AppendLine("        <td style=\"border:1px solid #000;\">" + reports[0].TotalOvertimeHours.ToString() + "</td>"); // reports[0].TotalOvertimeHours.ToString()
			sb.AppendLine("        <td style=\"border:1px solid #000;\">" + reports[0].TotalHours.ToString() + "</td>");
            sb.AppendLine("        <td>" + reports[0].TotalRestHours.ToString() + "</td>");
            sb.AppendLine("        <td></td>");
            sb.AppendLine("        <td></td>");
            //sb.AppendLine("        <td></td>");
            //sb.AppendLine("        <td style=\"border-left:1px solid #000;\"></td>");
            sb.AppendLine("        <td style=\"border:1px solid #000;\"></td>");
            sb.AppendLine("");
            sb.AppendLine("    </tr>");
            sb.AppendLine("    <tr>");
            sb.AppendLine("        <td colspan=\"26\"  style=\"border:1px solid #000;\"><b>Guaranteed Overtime</b></td>");
            sb.AppendLine("        <td style=\"border:1px solid #000;\"><b></b></td>");
            sb.AppendLine("        <td style=\"border:1px solid #000;\"><b></b></td>");
            sb.AppendLine("        <td style=\"border:1px solid #000;\"><b></b></td>");
            sb.AppendLine("        <td colspan=\"4\" style=\"border:1px solid #000;\"><b></b></td>");
           // sb.AppendLine("         <td colspan=\"4\" style=\"border:1px solid #000;\"><b></b></td>");
            sb.AppendLine("");
            sb.AppendLine("    </tr>");
            sb.AppendLine("    <tr>");
            sb.AppendLine("        <td colspan=\"26\"  style=\"border:1px solid #000;\"><b>Extra Overtime Payable</b></td>");
            sb.AppendLine("        <td style=\"border:1px solid #000;\"><b></b></td>");
            sb.AppendLine("        <td style=\"border:1px solid #000;\"><b></b></td>");
            sb.AppendLine("        <td style=\"border:1px solid #000;\"><b></b></td>");
            sb.AppendLine("        <td colspan=\"4\" style=\"border:1px solid #000;\"><b></b></td>");
           //// sb.AppendLine("         <td colspan=\"4\" style=\"border:1px solid #000;\"><b></b></td>");
            sb.AppendLine("");
            sb.AppendLine("    </tr>");
            sb.AppendLine("</table>");
            sb.AppendLine("    <br>");
            sb.AppendLine("    <table style=\"border:1px black solid;\">");
            sb.AppendLine("    <tr>");
            sb.AppendLine("        <td colspan=\"2\"><b>Key :</b></td>");
            sb.AppendLine("    </tr>");
            sb.AppendLine("    <tr>");
            sb.AppendLine("        <td>First 30 mins :</td>");
            sb.AppendLine("        <td> <p>&#9680;</p> </td>");
            sb.AppendLine("    </tr>");
            sb.AppendLine("    <tr>");
            sb.AppendLine("        <td>Last 30 mins :</td>");
            sb.AppendLine("        <td> <p>&#9681;</p> </td>");
            sb.AppendLine("    </tr>");
            sb.AppendLine("    <tr>");
            sb.AppendLine("        <td>Full Hour :</td>");
            sb.AppendLine("        <td> <p>&#9673;</p> </td>");
            sb.AppendLine("    </tr>");
            sb.AppendLine("</table>");
            sb.AppendLine("   <table style=\"width:100%;\">");
            sb.AppendLine("    <tr>");
            sb.AppendLine("        <td>Signature of<br> Seaman:</td>");
            sb.AppendLine("        <td>________________________________________</td>");
            sb.AppendLine("        <td>");
            sb.AppendLine("            Signature of Master/Person<br> Authorised by the Master :");
            sb.AppendLine("        </td>");
            sb.AppendLine("        <td>");
            sb.AppendLine("            ________________________________________");
            sb.AppendLine("        </td>");
            sb.AppendLine("    </tr>");
            sb.AppendLine("");
            sb.AppendLine("");
            sb.AppendLine("    <tr>");
            sb.AppendLine("        <td colspan=\"2\" align=\"center\">");
            sb.AppendLine("");
            sb.AppendLine("            <span id=\"seamanfooter\"></span>");
            sb.AppendLine("        </td>");
            sb.AppendLine("        <td colspan=\"2\" align=\"right\">");
            sb.AppendLine("");
            sb.AppendLine("            <span id=\"rn1\">" + Session["Master"].ToString() + "</span>");
            sb.AppendLine("        </td>");
            sb.AppendLine("    </tr>");
            sb.AppendLine("</table>");
            sb.AppendLine("</body>"); 
            #endregion


            return sb.ToString();
        }

        public JsonResult HTML_Report2(string letterText)
        {
            StringBuilder sb = new StringBuilder();
            // PensiionBL pension = new PensiionBL();
            // string refno = pension.SavePensionPrintDetails();

            sb.AppendLine("<table width=\"100%\">");
            sb.AppendLine("    <tr>");
            sb.AppendLine("        <td align=\"left\" width=\"75%\"><b>HOURS OF WORK AND REST</b></td>");
           // sb.AppendLine("<img src=\"../companylogo/companylogo.png\" style=\"width:112px;\">");
            sb.AppendLine("        <td align=\"right\">Revision Number : 05</td>");
            sb.AppendLine("    </tr>");
            sb.AppendLine("");
            sb.AppendLine("    <tr>");
            sb.AppendLine("        <td align=\"left\" width=\"75%\">Form Number : ILO Rest</td>");
            sb.AppendLine("        <td align=\"right\"> Page Number : 1 of 1</td>");
            sb.AppendLine("    </tr>");
            sb.AppendLine("    <tr style=\"height:2px;\">");
            sb.AppendLine("        <td colspan=\"2\"><hr style=\"padding:0px; margin:0px;\" /></td>");
            sb.AppendLine("    </tr>");
            sb.AppendLine("    <tr>");
            sb.AppendLine("        <td colspan=\"2\">");
            sb.AppendLine("            <table width=\"100%\">");
            sb.AppendLine("                <tr>");
            sb.AppendLine("                    <td align=\"left\" width=\"40%\">Year : <span id=\"yr\"></span></td>");
            sb.AppendLine("                    <td align=\"left\" width=\"20%\"> Vessel Name : OSX 2 </td>");
            sb.AppendLine("                    <td align=\"right\" width=\"75%\"> Master : <span id=\"rn1\">" + Session["Master"].ToString() + "</span> </td>");
            sb.AppendLine("                </tr>");
            sb.AppendLine("                <tr>");
            sb.AppendLine("                    <td align=\"left\" width=\"50%\">Month : <span id=\"mn\"></span> </td>");
            sb.AppendLine("                    <td colspan=\"2\" align=\"left\">IMO Number : 8618217</td>");
            sb.AppendLine("                </tr>");
            sb.AppendLine("                <tr>");
            sb.AppendLine("                    <td align=\"left\">Day : </td>");
            sb.AppendLine("");
            sb.AppendLine("                    <td>Flag : Liberia</td>");
            sb.AppendLine("                </tr>");
            sb.AppendLine("            </table>");
            sb.AppendLine("        </td>");
            sb.AppendLine("    </tr>");
            sb.AppendLine("");
            sb.AppendLine("</table>");
            sb.AppendLine("");
            sb.AppendLine("");
            sb.AppendLine("");
            sb.AppendLine("<table border=\"1\" style=\"  border-style: solid; border-width: 1px; border-collapse: collapse; border-spacing: 0; width: 100%;\" id=\"schedule\">");
            sb.AppendLine("");
            sb.AppendLine("    <tr>");
            sb.AppendLine("        <th class=\"tg-v0f9\" width=\"12%\">Seafarer Name</th>");
            sb.AppendLine("        <th class=\"tg-v0f9\" width=\"10%\">Nationality</th>");
            sb.AppendLine("        <th class=\"tg-v0f9\" width=\"10%\">Rank</th>");
            sb.AppendLine("        <th class=\"tg-amwm\" width=\"1%\">00</th>");
            sb.AppendLine("        <th class=\"tg-amwm\" width=\"1%\">01</th>");
            sb.AppendLine("        <th class=\"tg-amwm\" width=\"1%\">02</th>");
            sb.AppendLine("        <th class=\"tg-amwm\" width=\"1%\">03</th>");
            sb.AppendLine("        <th class=\"tg-amwm\" width=\"1%\">04</th>");
            sb.AppendLine("        <th class=\"tg-amwm\" width=\"1%\">05</th>");
            sb.AppendLine("        <th class=\"tg-amwm\" width=\"1%\">06</th>");
            sb.AppendLine("        <th class=\"tg-amwm\" width=\"1%\">07</th>");
            sb.AppendLine("        <th class=\"tg-amwm\" width=\"1%\">08</th>");
            sb.AppendLine("        <th class=\"tg-amwm\" width=\"1%\">09</th>");
            sb.AppendLine("        <th class=\"tg-amwm\" width=\"1%\">10</th>");
            sb.AppendLine("        <th class=\"tg-amwm\" width=\"1%\">11</th>");
            sb.AppendLine("        <th class=\"tg-amwm\" width=\"1%\">12</th>");
            sb.AppendLine("        <th class=\"tg-amwm\" width=\"1%\">13</th>");
            sb.AppendLine("        <th class=\"tg-amwm\" width=\"1%\">14</th>");
            sb.AppendLine("        <th class=\"tg-amwm\" width=\"1%\">15</th>");
            sb.AppendLine("        <th class=\"tg-amwm\" width=\"1%\">16</th>");
            sb.AppendLine("        <th class=\"tg-amwm\" width=\"1%\">17</th>");
            sb.AppendLine("        <th class=\"tg-amwm\" width=\"1%\">18</th>");
            sb.AppendLine("        <th class=\"tg-amwm\" width=\"1%\">19</th>");
            sb.AppendLine("        <th class=\"tg-amwm\" width=\"1%\">20</th>");
            sb.AppendLine("        <th class=\"tg-amwm\" width=\"1%\">21</th>");
            sb.AppendLine("        <th class=\"tg-amwm\" width=\"1%\">22</th>");
            sb.AppendLine("        <th class=\"tg-amwm\" width=\"1%\">23</th>");
            sb.AppendLine("        <th class=\"tg-amwm\" width=\"6%\">Normal</th>");
            sb.AppendLine("        <th class=\"tg-amwm\" width=\"6%\">Overtime</th>");
            sb.AppendLine("        <th class=\"tg-amwm\" width=\"6%\">Total</th>");
            sb.AppendLine("        <th class=\"tg-amwm\" width=\"6%\">Rest</th>");
            sb.AppendLine("        <th class=\"tg-amwm\" width=\"20%\">Comments</th>");
            sb.AppendLine("    </tr>");
            sb.AppendLine("");
            sb.AppendLine("    <tr id=\"trclone\" filled=\"no\">");
            sb.AppendLine("        <td class=\"tg-yw4l\"></td>");
            sb.AppendLine("        <td class=\"tg-yw4l\"></td>");
            sb.AppendLine("        <td class=\"tg-yw4l\"></td>");
            sb.AppendLine("        <td class=\"tg-yw4l\"></td>");
            sb.AppendLine("        <td class=\"tg-yw4l\"></td>");
            sb.AppendLine("        <td class=\"tg-yw4l\"></td>");
            sb.AppendLine("        <td class=\"tg-yw4l\"></td>");
            sb.AppendLine("        <td class=\"tg-yw4l\"></td>");
            sb.AppendLine("        <td class=\"tg-yw4l\"></td>");
            sb.AppendLine("        <td class=\"tg-yw4l\"></td>");
            sb.AppendLine("        <td class=\"tg-yw4l\"></td>");
            sb.AppendLine("        <td class=\"tg-yw4l\"></td>");
            sb.AppendLine("        <td class=\"tg-yw4l\"></td>");
            sb.AppendLine("        <td class=\"tg-yw4l\"></td>");
            sb.AppendLine("        <td class=\"tg-yw4l\"></td>");
            sb.AppendLine("        <td class=\"tg-yw4l\"></td>");
            sb.AppendLine("        <td class=\"tg-yw4l\"></td>");
            sb.AppendLine("        <td class=\"tg-yw4l\"></td>");
            sb.AppendLine("        <td class=\"tg-yw4l\"></td>");
            sb.AppendLine("        <td class=\"tg-yw4l\"></td>");
            sb.AppendLine("        <td class=\"tg-yw4l\"></td>");
            sb.AppendLine("        <td class=\"tg-yw4l\"></td>");
            sb.AppendLine("        <td class=\"tg-yw4l\"></td>");
            sb.AppendLine("        <td class=\"tg-yw4l\"></td>");
            sb.AppendLine("        <td class=\"tg-yw4l\"></td>");
            sb.AppendLine("        <td class=\"tg-yw4l\"></td>");
            sb.AppendLine("        <td class=\"tg-yw4l\"></td>");
            sb.AppendLine("        <td class=\"tg-yw4l\"></td>");
            sb.AppendLine("        <td class=\"tg-yw4l\"></td>");
            sb.AppendLine("        <td class=\"tg-yw4l\"></td>");
            sb.AppendLine("        <td class=\"tg-yw4l\"></td>");
            sb.AppendLine("");
            sb.AppendLine("");
            sb.AppendLine("    </tr>");
            sb.AppendLine("</table>");
            sb.AppendLine("");
            sb.AppendLine("<p class=\"bottom-three\"></p>");
            sb.AppendLine("");
            sb.AppendLine("<table width=\"100%\">");
            sb.AppendLine("    <tr>");
            sb.AppendLine("");
            sb.AppendLine("        <td align=\"right\"></td>");
            sb.AppendLine("        <td align=\"right\">");
            sb.AppendLine("            Signature of Master:  ________________________________________");
            sb.AppendLine("        </td>");
            sb.AppendLine("    </tr>");
            sb.AppendLine("");
            sb.AppendLine("");
            sb.AppendLine("    <tr>");
            sb.AppendLine("        <td></td>");
            sb.AppendLine("        <td align=\"right\">");
            sb.AppendLine("            Singh, Amitabh");
            sb.AppendLine("        </td>");
            sb.AppendLine("    </tr>");
            sb.AppendLine("</table>");
            sb.AppendLine("");
            sb.AppendLine("<div id=\"dvprint2\"></div>");

            var data = sb.ToString();
            return Json(data, JsonRequestBehavior.AllowGet);
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
            reportsList = reportsBL.GetNCDetails(mon, year, int.Parse(Session["VesselID"].ToString()),int.Parse(Session["UserID"].ToString()));
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

        public JsonResult GetNonComplianceInfo(int ncDetailID)
        {
            NonComplianceInfoBL nonComplianceInfoBL = new NonComplianceInfoBL();
            NonComplianceInfoPOCO nonComplianceInfoPC = new NonComplianceInfoPOCO();
           

            NonComplianceInfoPOCO nonComplianceInfoList = new NonComplianceInfoPOCO();
            nonComplianceInfoList = nonComplianceInfoBL.GetNonComplianceInfo(ncDetailID, int.Parse(Session["VesselID"].ToString()));

            var data = nonComplianceInfoList.ComplianceInfo;

            return Json(data, JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetMonthlyDataForUser(Reports reports)
        {
            ReportsBL reportsBL = new ReportsBL();
            ReportsPOCO reportsPC = new ReportsPOCO();

            string month = reports.SelectedMonthYear.Substring(0, reports.SelectedMonthYear.Length - 4);

            reportsPC.Month = (int)((Months)Enum.Parse(typeof(Months), month.Trim()));
            reportsPC.MonthName = month;
            reportsPC.Year = int.Parse(Utilities.GetLast(reports.SelectedMonthYear, 4));
            reportsPC.CrewID = reports.CrewID;

            List<ReportsPOCO> reportsList = new List<ReportsPOCO>();
            reportsList = reportsBL.GetCrewIDFromWorkSessionsForUser(reportsPC);

            string[] bookedHours = new string[31];
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

        public JsonResult GetMonthlyDataForWebForUser(Reports reports)
        {
            ReportsBL reportsBL = new ReportsBL();
            ReportsPOCO reportsPC = new ReportsPOCO();

            string month = reports.SelectedMonthYear.Substring(0, reports.SelectedMonthYear.Length - 4);

            reportsPC.Month = (int)((Months)Enum.Parse(typeof(Months), month.Trim()));
            reportsPC.MonthName = month;
            reportsPC.Year = int.Parse(Utilities.GetLast(reports.SelectedMonthYear, 4));
            reportsPC.CrewID = reports.CrewID;

            List<ReportsPOCO> reportsList = new List<ReportsPOCO>();
            reportsList = reportsBL.GetCrewIDFromWorkSessionsForWebForUser(reportsPC);

            string[] bookedHours = new string[31];
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

        public JsonResult GetPlusOneDayAdjustmentValueForUser(string monthyear)
        {

            TimeAdjustmentBL reportsBL = new TimeAdjustmentBL();
            OneDayTimeAdjustmentPOCO reportsPC = new OneDayTimeAdjustmentPOCO();
            OneDayTimeAdjustment reportsM = new OneDayTimeAdjustment();

            string month = monthyear.Substring(0, monthyear.Length - 4);

            int mon = (int)((Months)Enum.Parse(typeof(Months), month.Trim()));
            //reportsPC.MonthName = month;
            int year = int.Parse(Utilities.GetLast(monthyear, 4));
            //reportsPC.CrewID = reports.CrewID;

            List<OneDayTimeAdjustmentPOCO> reportsList = new List<OneDayTimeAdjustmentPOCO>();
            reportsList = reportsBL.GetPlusOneDayAdjustmentDaysForUser(mon, year);

            var data = reportsList;

            return Json(new { BookedHours = data }, JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetMinusOneDayAdjustmentValueForUser(string monthyear, string crewID)
        {

            TimeAdjustmentBL reportsBL = new TimeAdjustmentBL();
            OneDayTimeAdjustmentPOCO reportsPC = new OneDayTimeAdjustmentPOCO();
            OneDayTimeAdjustment reportsM = new OneDayTimeAdjustment();

            string month = monthyear.Substring(0, monthyear.Length - 4);

            int mon = (int)((Months)Enum.Parse(typeof(Months), month.Trim()));
            //reportsPC.MonthName = month;
            int year = int.Parse(Utilities.GetLast(monthyear, 4));
            //reportsPC.CrewID = reports.CrewID;

            List<OneDayTimeAdjustmentPOCO> reportsList = new List<OneDayTimeAdjustmentPOCO>();
            reportsList = reportsBL.GetMinusOneDayAdjustmentDaysForUser(mon, year, int.Parse(crewID));

            var data = reportsList;

            return Json(new { BookedHours = data }, JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetVarianceFromWorkSessionsForUser(Reports reports)
        {
            ReportsBL reportsBL = new ReportsBL();
            ReportsPOCO reportsPC = new ReportsPOCO();

            int draw, start, length;
            int pageIndex = 0;

            if (null != Request.Form.GetValues("draw"))
            {
                draw = int.Parse(Request.Form.GetValues("draw").FirstOrDefault().ToString());
                start = int.Parse(Request.Form.GetValues("start").FirstOrDefault().ToString());
                length = 31;  //int.Parse(Request.Form.GetValues("length").FirstOrDefault().ToString());
            }
            else
            {
                draw = 1;
                start = 0;
                length = 31;
            }
            if (start == 0)
            {
                pageIndex = 1;
            }
            else
            {
                pageIndex = (start / length) + 1;
            }
            int totalrecords = 0;
            string month = reports.SelectedMonthYear.Substring(0, reports.SelectedMonthYear.Length - 4);

            reportsPC.Month = (int)((Months)Enum.Parse(typeof(Months), month.Trim()));
            reportsPC.MonthName = month;
            reportsPC.Year = int.Parse(Utilities.GetLast(reports.SelectedMonthYear, 4));
            reportsPC.CrewID = reports.CrewID;

            List<ReportsPOCO> reportsList = new List<ReportsPOCO>();
            reportsList = reportsBL.GetVarianceFromWorkSessionsForUser(reportsPC, pageIndex, ref totalrecords, length);

            string[] bookedHours = new string[31];
            int row = 0;
            foreach (ReportsPOCO item in reportsList)
            {
                bookedHours[row] = item.Hours;
                row++;
            }
            var data = reportsList;


            return Json(new { draw = draw, recordsFiltered = totalrecords, recordsTotal = totalrecords, data = data }, JsonRequestBehavior.AllowGet);
            // return Json(data, JsonRequestBehavior.AllowGet);
            //return Json(new { BookedHours = data }, JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetVarianceFromWorkSessionsForPdfForUser(Reports reports)
        {
            ReportsBL reportsBL = new ReportsBL();
            ReportsPOCO reportsPC = new ReportsPOCO();

            //int draw, start, length;
            int pageIndex = 0;

            //if (null != Request.Form.GetValues("draw"))
            //{
            //    draw = int.Parse(Request.Form.GetValues("draw").FirstOrDefault().ToString());
            //    start = int.Parse(Request.Form.GetValues("start").FirstOrDefault().ToString());
            //    length = int.Parse(Request.Form.GetValues("length").FirstOrDefault().ToString());
            //}
            //else
            //{
            //    draw = 1;
            //    start = 0;
            //    length = 31;
            //}
            //if (start == 0)
            //{
            //    pageIndex = 1;
            //}
            //else
            //{
            //    pageIndex = (start / length) + 1;
            //}
            int totalrecords = 0;
            string month = reports.SelectedMonthYear.Substring(0, reports.SelectedMonthYear.Length - 4);

            reportsPC.Month = (int)((Months)Enum.Parse(typeof(Months), month.Trim()));
            reportsPC.MonthName = month;
            reportsPC.Year = int.Parse(Utilities.GetLast(reports.SelectedMonthYear, 4));
            reportsPC.CrewID = reports.CrewID;

            List<ReportsPOCO> reportsList = new List<ReportsPOCO>();
            reportsList = reportsBL.GetVarianceFromWorkSessionsForPdfForUser(reportsPC, 1, ref totalrecords, 31);

            string[] bookedHours = new string[31];
            int row = 0;
            foreach (ReportsPOCO item in reportsList)
            {
                bookedHours[row] = item.Hours;
                row++;
            }
            var data = reportsList;



            return Json(data, JsonRequestBehavior.AllowGet);
            //return Json(new { BookedHours = data }, JsonRequestBehavior.AllowGet);
        }
    }     
}