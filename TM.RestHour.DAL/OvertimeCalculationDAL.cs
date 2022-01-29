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
    public class OvertimeCalculationDAL
    {
        public OvertimeCalculationPOCO GetOvertimeCalculation(int Id, int VesselID)
        {
            List<OvertimeCalculationPOCO> prodPOList = new List<OvertimeCalculationPOCO>();
            List<OvertimeCalculationPOCO> prodPO = new List<OvertimeCalculationPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetOvertimeCalculation", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Id", Id);
                    cmd.Parameters.AddWithValue("@VesselID", VesselID);
                    con.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    con.Close();
                }
            }
            return ConvertDataTableToOvertimeCalculationList(ds);
        }
        private OvertimeCalculationPOCO ConvertDataTableToOvertimeCalculationList(DataSet ds)
        {
            OvertimeCalculationPOCO overtimeCalculationPOCOPC = new OvertimeCalculationPOCO();
            //check if there is at all any data
            if (ds.Tables.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    if (item["Id"] != DBNull.Value)
                        overtimeCalculationPOCOPC.Id = Convert.ToInt32(item["Id"].ToString());

                    if (item["DailyWorkHours"] != DBNull.Value)
                        overtimeCalculationPOCOPC.DailyWorkHours = Convert.ToInt32(item["DailyWorkHours"].ToString());

                    if (item["HourlyRate"] != DBNull.Value)
                        overtimeCalculationPOCOPC.HourlyRate = Convert.ToInt32(item["HourlyRate"].ToString());

                    if (item["HoursPerWeekOrMonth"] != DBNull.Value)
                        overtimeCalculationPOCOPC.HoursPerWeekOrMonth = Convert.ToBoolean(item["HoursPerWeekOrMonth"].ToString());

                    if (item["FixedOvertime"] != DBNull.Value)
                        overtimeCalculationPOCOPC.FixedOvertime = Convert.ToInt32(item["FixedOvertime"].ToString());

                    if (item["SunDay"] != DBNull.Value)
                        overtimeCalculationPOCOPC.WorkingHoursPOCO.SunDay = Convert.ToInt32(item["SunDay"].ToString());

                    if (item["MonDay"] != DBNull.Value)
                        overtimeCalculationPOCOPC.WorkingHoursPOCO.MonDay = Convert.ToInt32(item["MonDay"].ToString());

                    if (item["TueDay"] != DBNull.Value)
                        overtimeCalculationPOCOPC.WorkingHoursPOCO.TueDay = Convert.ToInt32(item["TueDay"].ToString());

                    if (item["WedDay"] != DBNull.Value)
                        overtimeCalculationPOCOPC.WorkingHoursPOCO.WedDay = Convert.ToInt32(item["WedDay"].ToString());

                    if (item["ThuDay"] != DBNull.Value)
                        overtimeCalculationPOCOPC.WorkingHoursPOCO.ThuDay = Convert.ToInt32(item["ThuDay"].ToString());

                    if (item["FriDay"] != DBNull.Value)
                        overtimeCalculationPOCOPC.WorkingHoursPOCO.FriDay = Convert.ToInt32(item["FriDay"].ToString());

                    if (item["SatDay"] != DBNull.Value)
                        overtimeCalculationPOCOPC.WorkingHoursPOCO.SatDay = Convert.ToInt32(item["SatDay"].ToString());

                    //if (item["DepartmentMasterName"] != DBNull.Value)
                    //    overtimeCalculationPOCOPC.DepartmentMasterName = item["DepartmentMasterName"].ToString();


                    //if (item["DepartmentAdmin"] != DBNull.Value)
                    //{
                    //    overtimeCalculationPOCOPC.SelectedCrewID = item["DepartmentAdmin"].ToString();
                    //    overtimeCalculationPOCOPC.SelectedCrewID = overtimeCalculationPOCOPC.SelectedCrewID.TrimStart(',');
                    //    overtimeCalculationPOCOPC.SelectedCrewID = overtimeCalculationPOCOPC.SelectedCrewID.TrimEnd(',');
                    //}

                    //List<int> days = new List<int>();
                    //departmentList.Add(departmentPC);
                }
            }
            return overtimeCalculationPOCOPC;
        }


        public int SaveOvertimeCalculation(OvertimeCalculationPOCO overtimeCalculationPOCO, int VesselID)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpSaveOvertimeCalculation", con);
            cmd.CommandType = CommandType.StoredProcedure;
            //cmd.Parameters.AddWithValue("@DepartmentMasterName", department.DepartmentMasterName.ToString());

            cmd.Parameters.AddWithValue("@DailyWorkHours", overtimeCalculationPOCO.DailyWorkHours);
            cmd.Parameters.AddWithValue("@HourlyRate", overtimeCalculationPOCO.HourlyRate);
            cmd.Parameters.AddWithValue("@HoursPerWeekOrMonth", overtimeCalculationPOCO.HoursPerWeekOrMonth);
            cmd.Parameters.AddWithValue("@FixedOvertime", overtimeCalculationPOCO.FixedOvertime);
            cmd.Parameters.AddWithValue("@SunDay", overtimeCalculationPOCO.WorkingHoursPOCO.SunDay);
            cmd.Parameters.AddWithValue("@MonDay", overtimeCalculationPOCO.WorkingHoursPOCO.MonDay);
            cmd.Parameters.AddWithValue("@TueDay", overtimeCalculationPOCO.WorkingHoursPOCO.TueDay);
            cmd.Parameters.AddWithValue("@WedDay", overtimeCalculationPOCO.WorkingHoursPOCO.WedDay);
            cmd.Parameters.AddWithValue("@ThuDay", overtimeCalculationPOCO.WorkingHoursPOCO.ThuDay);
            cmd.Parameters.AddWithValue("@FriDay", overtimeCalculationPOCO.WorkingHoursPOCO.FriDay);
            cmd.Parameters.AddWithValue("@SatDay", overtimeCalculationPOCO.WorkingHoursPOCO.SatDay);

            cmd.Parameters.AddWithValue("@RegimeID", overtimeCalculationPOCO.WorkingHoursPOCO.RegimeID);

            cmd.Parameters.AddWithValue("@VesselID", VesselID);

            //if (!String.IsNullOrEmpty(overtimeCalculationPOCO.DepartmentMasterCode))
            //{
            //    cmd.Parameters.AddWithValue("@DepartmentMasterCode", overtimeCalculationPOCO.DepartmentMasterCode);
            //}
            //else
            //{
            //    cmd.Parameters.AddWithValue("@DepartmentMasterCode", DBNull.Value);
            //}

            if (overtimeCalculationPOCO.Id > 0)
            {
                cmd.Parameters.AddWithValue("@ID", overtimeCalculationPOCO.Id);
            }
            else
            {
                cmd.Parameters.AddWithValue("@ID", DBNull.Value);
            }
            int recordsAffected = cmd.ExecuteNonQuery();
            con.Close();
            return recordsAffected;
        }







        public OvertimeCalculationPOCO GetWorkingHoursForOvertime(/*int Id, int VesselID*/)
        {
            List<OvertimeCalculationPOCO> prodPOList = new List<OvertimeCalculationPOCO>();
            List<OvertimeCalculationPOCO> prodPO = new List<OvertimeCalculationPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetWorkingHoursForOvertime", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    //cmd.Parameters.AddWithValue("@Id", Id);
                    //cmd.Parameters.AddWithValue("@VesselID", VesselID);
                    con.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    con.Close();
                }
            }
            return ConvertDataTableToWorkingHoursForOvertimeList(ds);
        }
        private OvertimeCalculationPOCO ConvertDataTableToWorkingHoursForOvertimeList(DataSet ds)
        {
            OvertimeCalculationPOCO overtimeCalculationPOCOPC = new OvertimeCalculationPOCO();
            //check if there is at all any data
            if (ds.Tables.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    if (item["DayNumber"] != DBNull.Value)
                        overtimeCalculationPOCOPC.WorkingHoursPOCO.DayNumber = Convert.ToInt32(item["DayNumber"].ToString());

                    if (item["RegimeID"] != DBNull.Value)
                        overtimeCalculationPOCOPC.WorkingHoursPOCO.RegimeID = Convert.ToInt32(item["RegimeID"].ToString());

                    if (item["WorkHours"] != DBNull.Value)
                        overtimeCalculationPOCOPC.WorkingHoursPOCO.WorkHours = Convert.ToInt32(item["WorkHours"].ToString());


                    //if (item["DepartmentMasterName"] != DBNull.Value)
                    //    overtimeCalculationPOCOPC.DepartmentMasterName = item["DepartmentMasterName"].ToString();


                    //if (item["DepartmentAdmin"] != DBNull.Value)
                    //{
                    //    overtimeCalculationPOCOPC.SelectedCrewID = item["DepartmentAdmin"].ToString();
                    //    overtimeCalculationPOCOPC.SelectedCrewID = overtimeCalculationPOCOPC.SelectedCrewID.TrimStart(',');
                    //    overtimeCalculationPOCOPC.SelectedCrewID = overtimeCalculationPOCOPC.SelectedCrewID.TrimEnd(',');
                    //}

                    //List<int> days = new List<int>();
                    //departmentList.Add(departmentPC);
                }
            }
            return overtimeCalculationPOCOPC;
        }


        public int SaveWorkingHours(OvertimeCalculationPOCO overtimeCalculationPOCO /*, int VesselID*/)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpSaveWorkingHours", con);
            cmd.CommandType = CommandType.StoredProcedure;
            //cmd.Parameters.AddWithValue("@DepartmentMasterName", department.DepartmentMasterName.ToString());

            cmd.Parameters.AddWithValue("@RegimeID", overtimeCalculationPOCO.WorkingHoursPOCO.RegimeID);
            cmd.Parameters.AddWithValue("@WorkHours", overtimeCalculationPOCO.WorkingHoursPOCO.WorkHours);

            //cmd.Parameters.AddWithValue("@VesselID", VesselID);

            //if (!String.IsNullOrEmpty(overtimeCalculationPOCO.DepartmentMasterCode))
            //{
            //    cmd.Parameters.AddWithValue("@DepartmentMasterCode", overtimeCalculationPOCO.DepartmentMasterCode);
            //}
            //else
            //{
            //    cmd.Parameters.AddWithValue("@DepartmentMasterCode", DBNull.Value);
            //}

            if (overtimeCalculationPOCO.WorkingHoursPOCO.DayNumber > 0)
            {
                cmd.Parameters.AddWithValue("@DayNumber", overtimeCalculationPOCO.WorkingHoursPOCO.DayNumber);
            }
            else
            {
                cmd.Parameters.AddWithValue("@DayNumber", DBNull.Value);
            }
            int recordsAffected = cmd.ExecuteNonQuery();
            con.Close();
            return recordsAffected;
        }




        private WorkingHoursPOCO ConvertDataTableToWorkingHoursForOvertimeListForPOCO(DataSet ds)
        {
            WorkingHoursPOCO workingHoursPOCO = new WorkingHoursPOCO();
            //check if there is at all any data
            if (ds.Tables.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    if (item["SunDay"] != DBNull.Value)
                        workingHoursPOCO.SunDay = Convert.ToInt32(item["SunDay"].ToString());

                    if (item["MonDay"] != DBNull.Value)
                        workingHoursPOCO.MonDay = Convert.ToInt32(item["MonDay"].ToString());

                    if (item["TueDay"] != DBNull.Value)
                        workingHoursPOCO.TueDay = Convert.ToInt32(item["TueDay"].ToString());

                    if (item["WedDay"] != DBNull.Value)
                        workingHoursPOCO.WedDay = Convert.ToInt32(item["WedDay"].ToString());

                    if (item["ThuDay"] != DBNull.Value)
                        workingHoursPOCO.ThuDay = Convert.ToInt32(item["ThuDay"].ToString());

                    if (item["FriDay"] != DBNull.Value)
                        workingHoursPOCO.FriDay = Convert.ToInt32(item["FriDay"].ToString());

                    if (item["SatDay"] != DBNull.Value)
                        workingHoursPOCO.SatDay = Convert.ToInt32(item["SatDay"].ToString());



                    if (item["DayNumber"] != DBNull.Value)
                        workingHoursPOCO.DayNumber = Convert.ToInt32(item["DayNumber"].ToString());

                    if (item["RegimeID"] != DBNull.Value)
                        workingHoursPOCO.RegimeID = Convert.ToInt32(item["RegimeID"].ToString());

                    if (item["WorkHours"] != DBNull.Value)
                        workingHoursPOCO.WorkHours = Convert.ToInt32(item["WorkHours"].ToString());


                    //if (item["DepartmentMasterName"] != DBNull.Value)
                    //    overtimeCalculationPOCOPC.DepartmentMasterName = item["DepartmentMasterName"].ToString();


                    //if (item["DepartmentAdmin"] != DBNull.Value)
                    //{
                    //    overtimeCalculationPOCOPC.SelectedCrewID = item["DepartmentAdmin"].ToString();
                    //    overtimeCalculationPOCOPC.SelectedCrewID = overtimeCalculationPOCOPC.SelectedCrewID.TrimStart(',');
                    //    overtimeCalculationPOCOPC.SelectedCrewID = overtimeCalculationPOCOPC.SelectedCrewID.TrimEnd(',');
                    //}

                    //List<int> days = new List<int>();
                    //departmentList.Add(departmentPC);
                }
            }
            return workingHoursPOCO;
        }
    }
}
