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

using System.IO;

namespace TM.RestHour.Controllers
{
    [TraceFilterAttribute]
    public class ReportsNCReportByMonthController : Controller
    {
		// GET: ReportsNCReportByMonth
		[TraceFilterAttribute]
		public ActionResult Index()
        {
            return View();
        }

		[TraceFilterAttribute]
		public ActionResult NCReportByMonth()
        {
            return View();
        }

		[TraceFilterAttribute]
		public ActionResult MonthlyView()
        {
            return View();
        }



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
            reportsList = reportsBL.GetCrewIDFromWorkSessions9(reportsPC, int.Parse(Session["VesselID"].ToString()));

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
            reportsList = reportsBL.GetCrewIDFromWorkSessionsForWeb9(reportsPC, int.Parse(Session["VesselID"].ToString()));

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
            reportsList = reportsBL.GetCrewIDFromWorkSessionsForWeb9(reportsPC, int.Parse(Session["VesselID"].ToString()));

            string[] bookedHours = new string[31];
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

        //public JsonResult GetDayWiseCrewData(string bookDate)
        //{
        //    //Reports reports = new Reports();
        //    ReportsBL reportsBL = new ReportsBL();
        //    ReportsPOCO reportsPC = new ReportsPOCO();

        //    //string month = reports.SelectedMonthYear.Substring(0, reports.SelectedMonthYear.Length - 4);

        //    reportsPC.BookDate = bookDate;
        //    //crewPC.BookDate = DateTime.ParseExact(selectedDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);

        //    // reportsPC.CrewID = reports.CrewID;

        //    List<ReportsPOCO> reportsList = new List<ReportsPOCO>();
        //    reportsList = reportsBL.GetDayWiseCrewBookingData9(reportsPC);

        //    //string[] bookedHours = new string[31];
        //    //int row = 0;
        //    //foreach (ReportsPOCO item in reportsList)
        //    //{
        //    //    bookedHours[row] = item.Hours;


        //    //    row++;
        //    //}


        //    var data = reportsList;



        //    // return Json(data, JsonRequestBehavior.AllowGet);
        //    return Json(new { BookedHours = data }, JsonRequestBehavior.AllowGet);
        //}

        public JsonResult HTML_Report2(string letterText)
        {
            StringBuilder sb = new StringBuilder();
            // PensiionBL pension = new PensiionBL();
            // string refno = pension.SavePensionPrintDetails();

            sb.AppendLine("<table width=\"100%\">");
            sb.AppendLine("    <tr>");
            sb.AppendLine("        <td align=\"left\" width=\"75%\"><b>HOURS OF WORK AND REST</b></td>");
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
            sb.AppendLine("                    <td align=\"right\" width=\"75%\"> Master : Singh, Amitabh </td>");
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
    }
}