using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TM.Base.Entities;
using TM.Base.Common;

namespace TM.RestHour.DAL
{
    public class ReportsDAL
    {
        public List<ReportsPOCO> GetCrewIDFromWorkSessions(ReportsPOCO reportsPOCO,int VesselID)
        {
            List<ReportsPOCO> prodPOList = new List<ReportsPOCO>();
            List<ReportsPOCO> prodPO = new List<ReportsPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetCrewIDFromWorkSessions", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@CrewID",reportsPOCO.CrewID);
                    cmd.Parameters.AddWithValue("@Month",reportsPOCO.Month);
                    cmd.Parameters.AddWithValue("@Year",reportsPOCO.Year);
                    cmd.Parameters.AddWithValue("@VesselID", VesselID);
                    con.Open();


                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    con.Close();


                }
            }
            return ConvertDataTableToListReports(ds, reportsPOCO.Year, reportsPOCO.Month);
        }

        public List<ReportsPOCO> GetDataForVarianceReport(ReportsPOCO reportsPOCO, int pageIndex, ref int recordCount, int length, int VesselID)
        {
            List<ReportsPOCO> prodPOList = new List<ReportsPOCO>();
            List<ReportsPOCO> prodPO = new List<ReportsPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetDataForVarianceReport", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@CrewID", reportsPOCO.CrewID);
                    cmd.Parameters.AddWithValue("@Month", reportsPOCO.Month);
                    cmd.Parameters.AddWithValue("@Year", reportsPOCO.Year);
                    cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
                    cmd.Parameters.AddWithValue("@PageSize", 32);
                    cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4);
                    cmd.Parameters["@RecordCount"].Direction = ParameterDirection.Output;
                    cmd.Parameters.AddWithValue("@VesselID", VesselID);

                    con.Open();


                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    con.Close();


                }
            }
            return ConvertDataTableToListReportsForVariance(ds, reportsPOCO.Year, reportsPOCO.Month, reportsPOCO.ID);
        }

        private List<ReportsPOCO> ConvertDataTableToListReports(DataSet ds,int year,int month)
        {
            List<ReportsPOCO> reportsList = new List<ReportsPOCO>();
            //check if there is at all any data
            if (ds.Tables.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    ReportsPOCO reports = new ReportsPOCO();

                    if (item["Hours"] != null)
                        reports.Hours = item["Hours"].ToString();
                    if (item["BookDate"] != null)
                    reports.BookDate = item["BookDate"].ToString();
                    reports.Year = year;
                    reports.Month = month;
                    if (item["FirstName"] != null)
                        reports.FirstName = item["FirstName"].ToString();
                    if (item["LastName"] != null)
                        reports.LastName = item["LastName"].ToString();
                    if (item["RankName"] != null)
                        reports.RankName = item["RankName"].ToString();
                    reports.MonthName = ((Months)month).ToString();
                    if (item["WorkDate"] != null)
                        reports.WorkDate = item["WorkDate"].ToString();
                    if (item["ComplianceInfo"] != null)
                        reports.ComplianceInfo = item["ComplianceInfo"].ToString();
                    if (item["Comment"] != null)
                        reports.Comment  = item["Comment"].ToString();
                    if (item["AdjustmentFactor"] != DBNull.Value)
                        reports.AdjustmentFactor = item["AdjustmentFactor"].ToString();
					//DateTime.ParseExact(item["ValidOn"].ToString(), "MM/dd/yyyy", CultureInfo.InvariantCulture);
					if (item["SevenDaysRest"] != DBNull.Value)
						reports.MinSevenDayRest = item["SevenDaysRest"].ToString();

					reports.IsWithinServiceTerm = Convert.ToBoolean(item["IsWithinFiveDays"].ToString());
					//reports.IsWithinServiceTerm = false;

					if (item["RegimeSymbol"] != DBNull.Value)
					{
						reports.RegimeSymbol = item["RegimeSymbol"].ToString();

						switch (reports.RegimeSymbol)
						{
							case "~":
								reports.RegimeSymbol = "&#9818;";
								break;
							case "@":
								reports.RegimeSymbol = "&#9824;";
								break;
							case "#":
								reports.RegimeSymbol = "&#9819;"; //
								break;
							case "$":
								reports.RegimeSymbol = "&#9827;";
								break;
							case "^":
								reports.RegimeSymbol = "&#9820;"; // &#9820;
								break;
							case "&":
								reports.RegimeSymbol = "&#9829;";
								break;
							case "*":
								reports.RegimeSymbol = "&#9822;";
								break;

						}
					}

					//if (item["NCComments"] != DBNull.Value)
					//	reports.NCComments = item["NCComments"].ToString();
					reportsList.Add(reports);
                }
            }


            return reportsList;
        }

		private List<ReportsPOCO> ConvertDataTableToListReportsForVariance(DataSet ds, int year, int month, int ID)
		{
			List<ReportsPOCO> reportsList = new List<ReportsPOCO>();
			//check if there is at all any data
			if (ds.Tables.Count > 0)
			{
				foreach (DataRow item in ds.Tables[0].Rows)
				{
					ReportsPOCO reports = new ReportsPOCO();
                   
                        reports.ID = ID;

                    if (item["Hours"] != null)
						reports.Hours = item["Hours"].ToString();
					if (item["BookDate"] != null)
						reports.BookDate = item["BookDate"].ToString();
					reports.Year = year;
					reports.Month = month;
					if (item["FirstName"] != null)
						reports.FirstName = item["FirstName"].ToString();
					if (item["LastName"] != null)
						reports.LastName = item["LastName"].ToString();
					if (item["RankName"] != null)
						reports.RankName = item["RankName"].ToString();
					reports.MonthName = ((Months)month).ToString();
					if (item["WorkDate"] != null)
						reports.WorkDate = item["WorkDate"].ToString();
					if (item["ComplianceInfo"] != null)
						reports.ComplianceInfo = item["ComplianceInfo"].ToString();
					if (item["Comment"] != null)
						reports.Comment = item["Comment"].ToString();
					if (item["AdjustmentFactor"] != DBNull.Value)
						reports.AdjustmentFactor = item["AdjustmentFactor"].ToString();

                    if (item["MinTotalRestIn7Days"] != DBNull.Value)
                        reports.MinTotalRestIn7Days = int.Parse(item["MinTotalRestIn7Days"].ToString());
                    //DateTime.ParseExact(item["ValidOn"].ToString(), "MM/dd/yyyy", CultureInfo.InvariantCulture);
                    if (item["SevenDaysRest"] != DBNull.Value)
                        reports.MinSevenDayRest = item["SevenDaysRest"].ToString();

                    reportsList.Add(reports);
				}
			}


			return reportsList;
		}

		// public List<ReportsPOCO> GetNonComplianceByCrewId(ReportsPOCO reportsPOCO)
		//{
		//    List<ReportsPOCO> prodPOList = new List<ReportsPOCO>();
		//    List<ReportsPOCO> prodPO = new List<ReportsPOCO>();
		//    DataSet ds = new DataSet();
		//    using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
		//    {
		//        using (SqlCommand cmd = new SqlCommand("stpGetNonComplianceByCrewId", con))
		//        {
		//            cmd.CommandType = CommandType.StoredProcedure;
		//            cmd.Parameters.AddWithValue("@CrewID", reportsPOCO.CrewID);
		//            cmd.Parameters.AddWithValue("@Month", reportsPOCO.Month);
		//            cmd.Parameters.AddWithValue("@Year", reportsPOCO.Year);

		//            con.Open();


		//            SqlDataAdapter da = new SqlDataAdapter(cmd);
		//            da.Fill(ds);
		//            con.Close();


		//        }
		//    }
		//    return ConvertDataTableToListReportsNonComplianceByCrewId(ds, reportsPOCO.Year, reportsPOCO.Month);
		//}

		//private List<ReportsPOCO> ConvertDataTableToListReportsNonComplianceByCrewId(DataSet ds, int year, int month)
		//{
		//    List<ReportsPOCO> reportsList = new List<ReportsPOCO>();
		//    //check if there is at all any data
		//    if (ds.Tables.Count > 0)
		//    {
		//        foreach (DataRow item in ds.Tables[1].Rows)
		//        {
		//            ReportsPOCO reports = new ReportsPOCO();

		//            if (item["ComplianceInfo"] != null)
		//                reports.ComplianceInfo = item["ComplianceInfo"].ToString();
		//            //if (item["TotalNCHours"] != null)
		//            //    reports.TotalNCHours = item["TotalNCHours"];

		//                reportsList.Add(reports);
		//        }
		//    }


		//    return reportsList;
		//}

		public List<ReportsPOCO> GetDayWiseCrewBookingData(ReportsPOCO reportsPOCO, int VesselID)
        {
            List<ReportsPOCO> prodPOList = new List<ReportsPOCO>();
            List<ReportsPOCO> prodPO = new List<ReportsPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetDayWiseCrewBookingData", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
					DateTime dt = reportsPOCO.BookDate.FormatDate(ConfigurationManager.AppSettings["InputDateFormat"].ToString(), ConfigurationManager.AppSettings["InputDateSeperator"].ToString(), ConfigurationManager.AppSettings["OutputDateFormat"].ToString(), ConfigurationManager.AppSettings["OutputDateSeperator"].ToString());
                     cmd.Parameters.AddWithValue("@BookDate", dt);
                    cmd.Parameters.AddWithValue("@VesselID", VesselID);

                    con.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    con.Close();

                }
            }
            return ConvertDataTableToListDayWiseCrewBookingData(ds, reportsPOCO.BookDate);
        }

        private List<ReportsPOCO> ConvertDataTableToListDayWiseCrewBookingData(DataSet ds, string bookDate)
        {
            List<ReportsPOCO> reportsList = new List<ReportsPOCO>();
            //check if there is at all any data
            if (ds.Tables.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    ReportsPOCO reports = new ReportsPOCO();

                    if (item["Hours"] != DBNull.Value)
                        reports.Hours = item["Hours"].ToString();
                    if (item["CrewID"] != DBNull.Value)
                        reports.CrewID = int.Parse(item["CrewID"].ToString());
                    if (item["FirstName"] != DBNull.Value)
                        reports.FirstName = item["FirstName"].ToString();
                    if (item["LastName"] != DBNull.Value)
                        reports.LastName = item["LastName"].ToString();
                    if (item["Nationality"] != DBNull.Value)
                        reports.Nationality = item["Nationality"].ToString();
                    if (item["RankName"] != DBNull.Value)
                        reports.RankName = item["RankName"].ToString();
                    if (item["Comment"] != DBNull.Value)
                        reports.Comment = item["Comment"].ToString();
                    if (item["AdjustmentFactor"] != DBNull.Value)
                        reports.AdjustmentFactor = item["AdjustmentFactor"].ToString();
					if (item["RegimeName"] != DBNull.Value)
						reports.RegimeName = item["RegimeName"].ToString();

                    if (item["ComplianceInfo"] != null)
                        reports.ComplianceInfo = item["ComplianceInfo"].ToString();
                    if (item["WorkDate"] != null)
                        reports.WorkDate = item["WorkDate"].ToString();
                    reports.BookDate = bookDate;

                    reportsList.Add(reports);
                }
            }


            return reportsList;
        }


        

        public List<ReportsPOCO> GetCrewIDFromWorkSessions9(ReportsPOCO reportsPOCO,int VesselID)
        {
            List<ReportsPOCO> prodPOList = new List<ReportsPOCO>();
            List<ReportsPOCO> prodPO = new List<ReportsPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetCrewIDFromWorkSessions", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@CrewID", reportsPOCO.CrewID);
                    cmd.Parameters.AddWithValue("@Month", reportsPOCO.Month);
                    cmd.Parameters.AddWithValue("@Year", reportsPOCO.Year);
                    cmd.Parameters.AddWithValue("@VesselID", VesselID);

                    con.Open();


                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    con.Close();


                }
            }
            return ConvertDataTableToListReports(ds, reportsPOCO.Year, reportsPOCO.Month);
        }

        public List<ReportsPOCO> GetNCDetails(int Month, int Year , int VesselID,int userId)
        {
            List<ReportsPOCO> prodPOList = new List<ReportsPOCO>();
            List<ReportsPOCO> prodPO = new List<ReportsPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetWrokSessionsByDate", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    //cmd.Parameters.AddWithValue("@BookDate", DateTime.ParseExact(reportsPOCO.BookDate, "MM/dd/yyyy", CultureInfo.InvariantCulture));
                    cmd.Parameters.AddWithValue("@Month", Month);
                    cmd.Parameters.AddWithValue("@Year", Year);
                    cmd.Parameters.AddWithValue("@VesselID", VesselID);
                    cmd.Parameters.AddWithValue("@UserID", userId);

                    con.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    con.Close();

                }
            }
            return ConvertDataTableToGetNCDetails(ds,Year,Month);
        }
        private List<ReportsPOCO> ConvertDataTableToGetNCDetails(DataSet ds, int year, int month)
        {
            List<ReportsPOCO> reportsList = new List<ReportsPOCO>();
            //check if there is at all any data
            if (ds.Tables.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    ReportsPOCO reports = new ReportsPOCO();
                    reports.NCDetailsID = int.Parse(item["NCDetailsID"].ToString());
                    reports.ComplianceInfo = item["ComplianceInfo"].ToString();
                    reports.ValidOn = DateTime.Parse(item["ValidOn"].ToString());
                    reports.CrewID = int.Parse(item["CrewID"].ToString());
                    reports.Name = item["CrewName"].ToString();

                    if (item["isNC"].ToString() != String.Empty && Convert.ToBoolean(item["isNC"].ToString()) == true)
                        reports.isNonCompliant = 1;
                    else
                        reports.isNonCompliant = 0;

                    //reports.isNonCompliant = int.Parse(item["isNC"].ToString());
                    if (int.Parse(item["DateNumber"].ToString()) > 10)
                    reports.DateNumber = item["DateNumber"].ToString();
                    else
                        reports.DateNumber = "0" + item["DateNumber"].ToString();
                    if (item["AdjustmentFator"] != DBNull.Value)
                        reports.AdjustmentFactor = item["AdjustmentFator"].ToString();
					if (item["RegimeName"] != DBNull.Value)
						reports.RegimeName = item["RegimeName"].ToString();
					reports.Year = year;
                    reports.Month = month;
                 
                    reportsList.Add(reports);
                }
            }


            return reportsList;
        }


        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        public List<ReportsPOCO> GetCrewIDFromWorkSessionsForUser(ReportsPOCO reportsPOCO)
        {
            List<ReportsPOCO> prodPOList = new List<ReportsPOCO>();
            List<ReportsPOCO> prodPO = new List<ReportsPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetCrewIDFromWorkSessionsxxxxxxxxxxxxxxxxxxxx", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@CrewID", reportsPOCO.CrewID);
                    cmd.Parameters.AddWithValue("@Month", reportsPOCO.Month);
                    cmd.Parameters.AddWithValue("@Year", reportsPOCO.Year);

                    con.Open();


                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    con.Close();


                }
            }
            return ConvertDataTableToListReports(ds, reportsPOCO.Year, reportsPOCO.Month);
        }

        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        public List<ReportsPOCO> GetDataForVarianceReportForUser(ReportsPOCO reportsPOCO, int pageIndex, ref int recordCount, int length)
        {
            List<ReportsPOCO> prodPOList = new List<ReportsPOCO>();
            List<ReportsPOCO> prodPO = new List<ReportsPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetDataForVarianceReportxxxxxxxxxxxxxxxxxx", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@CrewID", reportsPOCO.CrewID);
                    cmd.Parameters.AddWithValue("@Month", reportsPOCO.Month);
                    cmd.Parameters.AddWithValue("@Year", reportsPOCO.Year);
                    cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
                    cmd.Parameters.AddWithValue("@PageSize", length);
                    cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4);
                    cmd.Parameters["@RecordCount"].Direction = ParameterDirection.Output;

                    con.Open();


                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    con.Close();


                }
            }
            return ConvertDataTableToListReportsForUser(ds, reportsPOCO.Year, reportsPOCO.Month);
        }

        private List<ReportsPOCO> ConvertDataTableToListReportsForUser(DataSet ds, int year, int month)
        {
            List<ReportsPOCO> reportsList = new List<ReportsPOCO>();
            //check if there is at all any data
            if (ds.Tables.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    ReportsPOCO reports = new ReportsPOCO();

                    if (item["Hours"] != null)
                        reports.Hours = item["Hours"].ToString();
                    if (item["BookDate"] != null)
                        reports.BookDate = item["BookDate"].ToString();
                    reports.Year = year;
                    reports.Month = month;
                    if (item["FirstName"] != null)
                        reports.FirstName = item["FirstName"].ToString();
                    if (item["LastName"] != null)
                        reports.LastName = item["LastName"].ToString();
                    if (item["RankName"] != null)
                        reports.RankName = item["RankName"].ToString();
                    reports.MonthName = ((Months)month).ToString();
                    if (item["WorkDate"] != null)
                        reports.WorkDate = item["WorkDate"].ToString();
                    if (item["ComplianceInfo"] != null)
                        reports.ComplianceInfo = item["ComplianceInfo"].ToString();
                    if (item["Comment"] != null)
                        reports.Comment = item["Comment"].ToString();
                    if (item["AdjustmentFactor"] != DBNull.Value)
                        reports.AdjustmentFactor = item["AdjustmentFactor"].ToString(); //DateTime.ParseExact(item["ValidOn"].ToString(), "MM/dd/yyyy", CultureInfo.InvariantCulture);

                    reportsList.Add(reports);
                }
            }


            return reportsList;
        }

		public int GetWorkingHours(int DayNumber, int RegimeID)
		{
			List<ReportsPOCO> prodPOList = new List<ReportsPOCO>();
			List<ReportsPOCO> prodPO = new List<ReportsPOCO>();
			DataSet ds = new DataSet();
			using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
			{
				using (SqlCommand cmd = new SqlCommand("stpGetWorkingHours", con))
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.Parameters.AddWithValue("@DayNumber", DayNumber);
					cmd.Parameters.AddWithValue("@RegimeID", RegimeID);
					con.Open();

					SqlDataAdapter da = new SqlDataAdapter(cmd);
					da.Fill(ds);
					con.Close();
				}
			}
			return Convert.ToInt32(ds.Tables[0].Rows[0][0].ToString());
		}

		public bool GetCrewOverTimeStatus(int crewId)
		{
			///
			///
			DataSet ds = new DataSet();
			using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
			{
				using (SqlCommand cmd = new SqlCommand("stpGetCrewOverTime", con))
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.Parameters.AddWithValue("@CrewId", crewId);
					
					con.Open();

					SqlDataAdapter da = new SqlDataAdapter(cmd);
					da.Fill(ds);
					con.Close();
				}
			}

            if (ds.Tables[0].Rows.Count > 0)

                return Convert.ToBoolean(ds.Tables[0].Rows[0][0].ToString());
            else
                return false;
		}
	}
}
