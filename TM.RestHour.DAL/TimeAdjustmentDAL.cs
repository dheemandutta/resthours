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

namespace TM.RestHour.DAL
{
    public class TimeAdjustmentDAL
    {
        public List<TimeAdjustmentPOCO> GetLastAdjustmentBookedStatus(int CrewID, DateTime BookDate, int VesselID)
        {
            List<TimeAdjustmentPOCO> prodPOList = new List<TimeAdjustmentPOCO>();
            List<TimeAdjustmentPOCO> prodPO = new List<TimeAdjustmentPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetLastAdjustmentBookedStatus", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@CrewID", CrewID);
                    cmd.Parameters.AddWithValue("@BookDate", BookDate);
                    cmd.Parameters.AddWithValue("@VesselID", VesselID);
                    con.Open();
                    
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    con.Close();

                }
            }
            return ConvertDataTableToList(ds);
        }

        private List<TimeAdjustmentPOCO> ConvertDataTableToList(DataSet ds)
        {
            List<TimeAdjustmentPOCO> crewtimesheetList = new List<TimeAdjustmentPOCO>();
            //check if there is at all any data
            if (ds.Tables.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    TimeAdjustmentPOCO crewtimesheet = new TimeAdjustmentPOCO();

                    if (item["BookCount"] != System.DBNull.Value)
                        crewtimesheet.BookCount = Convert.ToInt32(item["BookCount"].ToString());

                    if (item["LastBookDate"] != DBNull.Value)
                        crewtimesheet.LastBookDate =    item["LastBookDate"].ToString().Substring(0,9);

                        crewtimesheetList.Add(crewtimesheet);
                }
            }
            
            return crewtimesheetList;
        }



        public List<OneDayTimeAdjustmentPOCO> GetPlusOneDayAdjustmentDays(int Month, int Year, int VesselID)
        {
            List<OneDayTimeAdjustmentPOCO> prodPOList = new List<OneDayTimeAdjustmentPOCO>();
            List<OneDayTimeAdjustmentPOCO> prodPO = new List<OneDayTimeAdjustmentPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetPlusOneDayAdjustmentDays", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Month", Month);
                    cmd.Parameters.AddWithValue("@Year", Year);
                    cmd.Parameters.AddWithValue("@VesselID", VesselID);
                    con.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    con.Close();

                }
            }
            return ConvertDataAdjustmentDaysTableToList(ds);
        }

        public List<OneDayTimeAdjustmentPOCO> GetMinusOneDayAdjustmentDays(int Month, int Year,int crewId, int VesselID)
        {
            List<OneDayTimeAdjustmentPOCO> prodPOList = new List<OneDayTimeAdjustmentPOCO>();
            List<OneDayTimeAdjustmentPOCO> prodPO = new List<OneDayTimeAdjustmentPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetMinusOneDayAdjustmentDays", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Month", Month);
                    cmd.Parameters.AddWithValue("@Year", Year);
                    cmd.Parameters.AddWithValue("@CrewId", crewId);
                    cmd.Parameters.AddWithValue("@VesselID", VesselID);
                    con.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    con.Close();

                }
            }
            return ConvertDataAdjustmentDaysTableToList(ds);
        }

        private List<OneDayTimeAdjustmentPOCO> ConvertDataAdjustmentDaysTableToList(DataSet ds)
        {
            List<OneDayTimeAdjustmentPOCO> crewtimesheetList = new List<OneDayTimeAdjustmentPOCO>();
            //check if there is at all any data
            if (ds.Tables.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    OneDayTimeAdjustmentPOCO crewtimesheet = new OneDayTimeAdjustmentPOCO();

                    //if (item["Month"] != System.DBNull.Value)
                    //    crewtimesheet.Month = Convert.ToInt32(item["Month"].ToString());

                    //if (item["Year"] != System.DBNull.Value)
                    //    crewtimesheet.Year = Convert.ToInt32(item["Year"].ToString()); 

                    if (item["AdjustmentDate"] != System.DBNull.Value)
                        crewtimesheet.AdjustmentDate = item["AdjustmentDate"].ToString().Substring(0,2);

                    if (item["MinusAdjustmentDate"] != System.DBNull.Value)
                        crewtimesheet.MinusAdjustmentDate = item["MinusAdjustmentDate"].ToString();

                    crewtimesheetList.Add(crewtimesheet);
                }
            }

            return crewtimesheetList;
        }

        public List<TimeAdjustmentPOCO> GetTimeAdjustmentDetailsPageWise(int pageIndex, ref int recordCount, int length, int VesselID)
        {

            List<TimeAdjustmentPOCO> TimeAdjustmentPOList = new List<TimeAdjustmentPOCO>();
            List<TimeAdjustmentPOCO> TimeAdjustPO = new List<TimeAdjustmentPOCO>();

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetTimeAdjustmentDetailsPageWise", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
                    cmd.Parameters.AddWithValue("@PageSize", length);
                    cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4);
                    cmd.Parameters["@RecordCount"].Direction = ParameterDirection.Output;
                    cmd.Parameters.AddWithValue("@VesselID", VesselID);
                    con.Open();

                    DataSet ds = new DataSet();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    //prodPOList = Common.CommonDAL.ConvertDataTable<ProductPOCO>(ds.Tables[0]);

                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        TimeAdjustmentPOList.Add(new TimeAdjustmentPOCO
                        {

                            AdjustmentValue = Convert.ToString(dr["AdjustmentValue"]),
                            AdjustmentDate1 = Convert.ToString(dr["AdjustmentDate"]),
                        });
                    }
                    recordCount = Convert.ToInt32(cmd.Parameters["@RecordCount"].Value);
                    con.Close();
                }
            }
            return TimeAdjustmentPOList;
        }



        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        public List<OneDayTimeAdjustmentPOCO> GetPlusOneDayAdjustmentDaysForUser(int Month, int Year)
        {
            List<OneDayTimeAdjustmentPOCO> prodPOList = new List<OneDayTimeAdjustmentPOCO>();
            List<OneDayTimeAdjustmentPOCO> prodPO = new List<OneDayTimeAdjustmentPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetPlusOneDayAdjustmentDaysxxxxxxxxxxxxxxxxxxxxxxxxxxxxx", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Month", Month);
                    cmd.Parameters.AddWithValue("@Year", Year);
                    con.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    con.Close();

                }
            }
            return ConvertDataAdjustmentDaysTableToListForUser(ds);
        }

        public List<OneDayTimeAdjustmentPOCO> GetMinusOneDayAdjustmentDaysForUser(int Month, int Year, int crewId)
        {
            List<OneDayTimeAdjustmentPOCO> prodPOList = new List<OneDayTimeAdjustmentPOCO>();
            List<OneDayTimeAdjustmentPOCO> prodPO = new List<OneDayTimeAdjustmentPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetMinusOneDayAdjustmentDaysxxxxxxxxxxxxxxxxxxxxxxx", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Month", Month);
                    cmd.Parameters.AddWithValue("@Year", Year);
                    cmd.Parameters.AddWithValue("@CrewId", crewId);
                    con.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    con.Close();

                }
            }
            return ConvertDataAdjustmentDaysTableToListForUser(ds);
        }

        private List<OneDayTimeAdjustmentPOCO> ConvertDataAdjustmentDaysTableToListForUser(DataSet ds)
        {
            List<OneDayTimeAdjustmentPOCO> crewtimesheetList = new List<OneDayTimeAdjustmentPOCO>();
            //check if there is at all any data
            if (ds.Tables.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    OneDayTimeAdjustmentPOCO crewtimesheet = new OneDayTimeAdjustmentPOCO();

                    //if (item["Month"] != System.DBNull.Value)
                    //    crewtimesheet.Month = Convert.ToInt32(item["Month"].ToString());

                    //if (item["Year"] != System.DBNull.Value)
                    //    crewtimesheet.Year = Convert.ToInt32(item["Year"].ToString()); 

                    if (item["AdjustmentDate"] != System.DBNull.Value)
                        crewtimesheet.AdjustmentDate = item["AdjustmentDate"].ToString().Substring(0, 2);

                    if (item["MinusAdjustmentDate"] != System.DBNull.Value)
                        crewtimesheet.MinusAdjustmentDate = item["MinusAdjustmentDate"].ToString();

                    crewtimesheetList.Add(crewtimesheet);
                }
            }

            return crewtimesheetList;
        }
    }
}
