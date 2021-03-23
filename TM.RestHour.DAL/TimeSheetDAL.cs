using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;
using TM.Base.Entities;

namespace TM.RestHour.DAL
{
    public class TimeSheetDAL
    {
        //for Crew drp
        public List<CrewPOCO> GetAllCrewForDrp(int VesselID, int UserID)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("usp_GetAllCrewForDrp", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@VesselID", VesselID);
            if (UserID == 0) UserID = 1;
            cmd.Parameters.AddWithValue("@UserID", UserID);
            DataSet ds = new DataSet();
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(ds);
            DataTable myTable = ds.Tables[0];
            List<CrewPOCO> ranksList = myTable.AsEnumerable().Select(m => new CrewPOCO()
            {
                ID = m.Field<int>("ID"),
                Name = m.Field<string>("Name"),

            }).ToList();

            return ranksList;
            con.Close();
        }

        public List<CrewPOCO> GetAllCrewForTimeSheet(int VesselID, int UserID)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("usp_GetAllCrewForTimeSheet", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@VesselID", VesselID);
            if (UserID == 0) UserID = 1;
            cmd.Parameters.AddWithValue("@UserID", UserID);
            DataSet ds = new DataSet();
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(ds);
            DataTable myTable = ds.Tables[0];
            List<CrewPOCO> ranksList = myTable.AsEnumerable().Select(m => new CrewPOCO()
            {
                ID = m.Field<int>("ID"),
                Name = m.Field<string>("Name"),

            }).ToList();

            return ranksList;
            con.Close();
        }

        public CrewTimesheetPOCO GetCrewTimeSheetByDate(int crewId,DateTime bookDate, int VesselID)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpGetWrokSessionsByCrewandDate", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@CrewId",crewId);
            cmd.Parameters.AddWithValue("@BookDate",bookDate);
            cmd.Parameters.AddWithValue("@VesselID", VesselID);
            DataSet ds = new DataSet();
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(ds);
            DataTable myTable = ds.Tables[0];
            CrewTimesheetPOCO timesheet = new CrewTimesheetPOCO();

			for (int i = 0; i < myTable.Rows.Count; i++)
			{
				timesheet.ActualHours = myTable.Rows[i]["ActualHours"].ToString();
				timesheet.Comment = myTable.Rows[i]["Comment"].ToString();
				timesheet.ID = int.Parse(myTable.Rows[i]["ID"].ToString());
				timesheet.NCDetailsID = int.Parse(myTable.Rows[i]["NCDetailsID"].ToString());
				timesheet.WorkSessionId = int.Parse(myTable.Rows[i]["ID"].ToString());
				timesheet.Comment = myTable.Rows[i]["Comment"].ToString();
				timesheet.RegimeID = int.Parse(myTable.Rows[i]["RegimeID"].ToString());
			}

            //timesheet = myTable.AsEnumerable().Select(c => new CrewTimesheetPOCO()
            //{
            //    ActualHours = c.Field<string>("ActualHours"),
            //    Comment = c.Field<string>("Comment"),
            //    ID = c.Field<int>("ID"),
            //    NCDetailsID = c.Field<int>("NCDetailsID")
            //}).FirstOrDefault();

            con.Close();
            return timesheet;
        }

		public List<string> GetPreviousBlankTimesheetDates(int crewId, DateTime bookDate, int VesselID)
		{
			SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
			con.Open();
			SqlCommand cmd = new SqlCommand("stpGetPreviousBlankDates", con);
			cmd.CommandType = CommandType.StoredProcedure;
			cmd.Parameters.AddWithValue("@CrewId", crewId);
			cmd.Parameters.AddWithValue("@BookDate", bookDate);
			cmd.Parameters.AddWithValue("@VesselId", VesselID);
			DataSet ds = new DataSet();
			SqlDataAdapter da = new SqlDataAdapter(cmd);
			da.Fill(ds);
			DataTable myTable = ds.Tables[0];
			//DateTime blankDate = new DateTime();
			List<string> _blankDates = new List<string>();


			for (int i = 0; i < myTable.Rows.Count; i++)
			{
				_blankDates.Add(myTable.Rows[i]["BlankDate"].ToString().Replace('-','/'));
			}

			

			con.Close();
			return _blankDates;
		}

		public List<CrewTimesheetPOCO> GetNextSixDaysTimesheet(int crewId, DateTime bookDate, int VesselID)
		{
			SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
			con.Open();
			SqlCommand cmd = new SqlCommand("stpGetNextSixDaysTimeSheet", con);
			cmd.CommandType = CommandType.StoredProcedure;
			cmd.Parameters.AddWithValue("@BookDate", bookDate);
			cmd.Parameters.AddWithValue("@CrewId", crewId);
			cmd.Parameters.AddWithValue("@VesselID", VesselID);
			DataSet ds = new DataSet();
			SqlDataAdapter da = new SqlDataAdapter(cmd);
			da.Fill(ds);
			DataTable myTable = ds.Tables[0];
			
			List<CrewTimesheetPOCO> timesheetList = new List<CrewTimesheetPOCO>();
			for (int i = 0; i < myTable.Rows.Count; i++)
			{

				CrewTimesheetPOCO timesheet = new CrewTimesheetPOCO();
				timesheet.ActualHours = myTable.Rows[i]["ActualHours"].ToString();
				//timesheet.Comment = myTable.Rows[i]["Comment"].ToString();
				timesheet.ID = int.Parse(myTable.Rows[i]["ID"].ToString());
				//timesheet.NCDetailsID = int.Parse(myTable.Rows[i]["NCDetailsID"].ToString());
				timesheet.WorkSessionId = int.Parse(myTable.Rows[i]["ID"].ToString());
				timesheet.AdjustmentFactor = myTable.Rows[i]["AdjustmentFator"].ToString();
				timesheet.RegimeID = int.Parse(myTable.Rows[i]["RegimeID"].ToString());
				timesheet.ValidOn = myTable.Rows[i]["ValidOn"].ToString();

				timesheetList.Add(timesheet);
			}

			

			con.Close();
			return timesheetList;
		}

		public CrewTimesheetPOCO GetSecondCrewTimeSheetByDate(int crewId, DateTime bookDate, int VesselID)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpGetSecondWrokSessionsByCrewandDate", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@CrewId", crewId);
            cmd.Parameters.AddWithValue("@BookDate", bookDate);
            cmd.Parameters.AddWithValue("@VesselID", VesselID);
            DataSet ds = new DataSet();
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(ds);
            DataTable myTable = ds.Tables[0];
            CrewTimesheetPOCO timesheet = new CrewTimesheetPOCO();

            for (int i = 0; i < myTable.Rows.Count; i++)
            {
                timesheet.ActualHours = myTable.Rows[i]["ActualHours"].ToString();
                timesheet.Comment = myTable.Rows[i]["Comment"].ToString();
                timesheet.ID = int.Parse(myTable.Rows[i]["ID"].ToString());
                timesheet.NCDetailsID = int.Parse(myTable.Rows[i]["NCDetailsID"].ToString());
                timesheet.WorkSessionId = int.Parse(myTable.Rows[i]["ID"].ToString());
                timesheet.Comment = myTable.Rows[i]["Comment"].ToString();
                timesheet.RegimeID = int.Parse(myTable.Rows[i]["RegimeID"].ToString());
            }

            con.Close();
            return timesheet;
        }


		public int GetWorkDayCountBeforeSevenDays(int crewId, DateTime bookDate, int VesselID)
		{
			SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
			con.Open();
			SqlCommand cmd = new SqlCommand("stpCheckIfWorkedBeforeSevenDays", con);
			cmd.CommandType = CommandType.StoredProcedure;
			cmd.Parameters.AddWithValue("@CrewId", crewId);
			cmd.Parameters.AddWithValue("@BookDate", bookDate);
			cmd.Parameters.AddWithValue("@VesselID", VesselID);

			int numberofDaysWorked = (int)cmd.ExecuteScalar();

			con.Close();
			return numberofDaysWorked;
		}

        public int GetWorkDayCountBeforeOneDays(int crewId, DateTime bookDate, int VesselID)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpCheckIfWorkedBeforeOneDays", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@CrewId", crewId);
            cmd.Parameters.AddWithValue("@BookDate", bookDate);
            cmd.Parameters.AddWithValue("@VesselID", VesselID);

            int numberofDaysWorked = (int)cmd.ExecuteScalar();

            con.Close();
            return numberofDaysWorked;
        }

        public CrewTimesheetPOCO GetLastTimeSheet(int crewId,int VesselID,string copyDate)
        {
			DateTime copydt = new DateTime();
			copydt = DateTime.ParseExact(copyDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
			
			SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpLastBookedSession", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@CrewId", crewId);
            cmd.Parameters.AddWithValue("@VesselID", VesselID);
			cmd.Parameters.AddWithValue("@CopyDate", copydt.AddDays(-1));
            DataSet ds = new DataSet();
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(ds);
            DataTable myTable = ds.Tables[0];
            CrewTimesheetPOCO timesheet = new CrewTimesheetPOCO();

            timesheet = myTable.AsEnumerable().Select(c => new CrewTimesheetPOCO()
            {
                ActualHours = c.Field<string>("ActualHours")
            }).FirstOrDefault();

            con.Close();
            return timesheet;
        }







		public CrewTimesheetPOCO GetNoNCForMonth(int Month, int Year, int CrewId, int VesselID)
		{
			List<CrewTimesheetPOCO> prodPOList = new List<CrewTimesheetPOCO>();
			CrewTimesheetPOCO prodPO = new CrewTimesheetPOCO();
			DataSet ds = new DataSet();
			using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
			{
				using (SqlCommand cmd = new SqlCommand("stpGetNoNCForMonth", con))
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.Parameters.AddWithValue("@Month", Month);
					cmd.Parameters.AddWithValue("@Year", Year);
					cmd.Parameters.AddWithValue("@CrewId", CrewId);
					cmd.Parameters.AddWithValue("@VesselID", VesselID);
					con.Open();


					SqlDataAdapter da = new SqlDataAdapter(cmd);
					da.Fill(ds);
					//prodPOList = Common.CommonDAL.ConvertDataTable<ProductPOCO>(ds.Tables[0]);
					con.Close();


				}
			}

			List<int> days = new List<int>();
			for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
			{
				days.Add(int.Parse(ds.Tables[0].Rows[i]["NcDay"].ToString()));
			}

			prodPO.NcDay = days;
			return prodPO;
		}



		public CrewTimesheetPOCO GetNCForMonth(int Month, int Year, int CrewId, int VesselID)
        {
            List<CrewTimesheetPOCO> prodPOList = new List<CrewTimesheetPOCO>();
            CrewTimesheetPOCO prodPO = new CrewTimesheetPOCO();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetNCForMonth", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Month", Month);
                    cmd.Parameters.AddWithValue("@Year", Year);
					cmd.Parameters.AddWithValue("@CrewId", CrewId);
                    cmd.Parameters.AddWithValue("@VesselID", VesselID);
                    con.Open();


                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    //prodPOList = Common.CommonDAL.ConvertDataTable<ProductPOCO>(ds.Tables[0]);
                    con.Close();


                }
            }

			List<int> days = new List<int>();
			for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
			{
				days.Add(int.Parse(ds.Tables[0].Rows[i]["NcDay"].ToString()));
			}

			prodPO.NcDay = days;
			return prodPO;
		}



        private List<CrewTimesheetPOCO> ConvertDataTableToEntryForMonthList(DataSet ds)
        {
            List<CrewTimesheetPOCO> crewtimesheetList = new List<CrewTimesheetPOCO>();
            //check if there is at all any data
            if (ds.Tables.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    CrewTimesheetPOCO crewtimesheet = new CrewTimesheetPOCO();

                    if (item["Month"] != null)
                        crewtimesheet.Month = Convert.ToInt32(item["Month"].ToString());

                    if (item["Year"] != null)
                        crewtimesheet.Year = Convert.ToInt32(item["Year"].ToString());

					//if (item["NcDay"] != null)
					//	crewtimesheet.NcDay = int.Parse(item["NcDay"].ToString());



					crewtimesheetList.Add(crewtimesheet);
                }
            }
            return crewtimesheetList;
        }




        /////////////////////// For GetDaysLeft
        public int?  GetDaysLeft(int ID)
        {
            int? val = null;
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetDaysLeft", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@ID", ID);
                    con.Open();
                    val = (int?)cmd.ExecuteScalar();
                    con.Close();
                               
                }
            }

            return val;
        }
    }
}
