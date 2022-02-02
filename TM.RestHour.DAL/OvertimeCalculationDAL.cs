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
        public OvertimeCalculationPOCO GetOvertimeCalculation(/*int Id, int VesselID*/)
        {
            List<OvertimeCalculationPOCO> prodPOList = new List<OvertimeCalculationPOCO>();
            List<OvertimeCalculationPOCO> prodPO = new List<OvertimeCalculationPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetOvertimeCalculation", con))
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
            return GetConvertDataTableToOvertimeCalculationList(ds);
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

                    if (item["IsWeekly"] != DBNull.Value)
                        overtimeCalculationPOCOPC.IsWeekly = Convert.ToBoolean(item["IsWeekly"].ToString());

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

        private OvertimeCalculationPOCO GetConvertDataTableToOvertimeCalculationList(DataSet ds)
        {
            OvertimeCalculationPOCO overtimeCalculationPOCOPC = new OvertimeCalculationPOCO();
            WorkingHoursPOCO workingHoursPOCO = new WorkingHoursPOCO();
            overtimeCalculationPOCOPC.WorkingHoursPOCO = workingHoursPOCO;

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
                        overtimeCalculationPOCOPC.FixedOvertime = Convert.ToDecimal(item["FixedOvertime"].ToString());

                    //if (item["SunDay"] != DBNull.Value)
                    //    overtimeCalculationPOCOPC.WorkingHoursPOCO.SunDay = Convert.ToInt32(item["SunDay"].ToString());

                    //if (item["MonDay"] != DBNull.Value)
                    //    overtimeCalculationPOCOPC.WorkingHoursPOCO.MonDay = Convert.ToInt32(item["MonDay"].ToString());

                    //if (item["TueDay"] != DBNull.Value)
                    //    overtimeCalculationPOCOPC.WorkingHoursPOCO.TueDay = Convert.ToInt32(item["TueDay"].ToString());

                    //if (item["WedDay"] != DBNull.Value)
                    //    overtimeCalculationPOCOPC.WorkingHoursPOCO.WedDay = Convert.ToInt32(item["WedDay"].ToString());

                    //if (item["ThuDay"] != DBNull.Value)
                    //    overtimeCalculationPOCOPC.WorkingHoursPOCO.ThuDay = Convert.ToInt32(item["ThuDay"].ToString());

                    //if (item["FriDay"] != DBNull.Value)
                    //    overtimeCalculationPOCOPC.WorkingHoursPOCO.FriDay = Convert.ToInt32(item["FriDay"].ToString());

                    //if (item["SatDay"] != DBNull.Value)
                    //    overtimeCalculationPOCOPC.WorkingHoursPOCO.SatDay = Convert.ToInt32(item["SatDay"].ToString());

                    if (item["IsWeekly"] != DBNull.Value)
                        overtimeCalculationPOCOPC.IsWeekly = Convert.ToBoolean(item["IsWeekly"].ToString());

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

               
                foreach (DataRow item in ds.Tables[1].Rows)
                {
                    switch (item["DayNumber"].ToString())
                    {
                        case "1":
                            overtimeCalculationPOCOPC.WorkingHoursPOCO.MonDay = Convert.ToInt32(item["WorkHours"].ToString());
                            break;
                        case "2":
                            overtimeCalculationPOCOPC.WorkingHoursPOCO.TueDay = Convert.ToInt32(item["WorkHours"].ToString());
                            break;
                        case "3":
                            overtimeCalculationPOCOPC.WorkingHoursPOCO.WedDay = Convert.ToInt32(item["WorkHours"].ToString());
                            break;
                        case "4":
                            overtimeCalculationPOCOPC.WorkingHoursPOCO.ThuDay = Convert.ToInt32(item["WorkHours"].ToString());
                            break;
                        case "5":
                            overtimeCalculationPOCOPC.WorkingHoursPOCO.FriDay = Convert.ToInt32(item["WorkHours"].ToString());
                            break;
                        case "6":
                            overtimeCalculationPOCOPC.WorkingHoursPOCO.SatDay = Convert.ToInt32(item["WorkHours"].ToString());
                            break;
                        case "7":
                            overtimeCalculationPOCOPC.WorkingHoursPOCO.SunDay = Convert.ToInt32(item["WorkHours"].ToString());
                            break;
                           
                    }
                  
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

            if (overtimeCalculationPOCO.DailyWorkHours.HasValue)
            {
                cmd.Parameters.AddWithValue("@DailyWorkHours", overtimeCalculationPOCO.DailyWorkHours);
            }
            else
            {
                cmd.Parameters.AddWithValue("@DailyWorkHours", DBNull.Value);
            }

            if (overtimeCalculationPOCO.HourlyRate.HasValue)
            {
                cmd.Parameters.AddWithValue("@HourlyRate", overtimeCalculationPOCO.HourlyRate);
            }
            else
            {
                cmd.Parameters.AddWithValue("@HourlyRate", DBNull.Value);
            }

            if (overtimeCalculationPOCO.HoursPerWeekOrMonth.HasValue)
            {
                cmd.Parameters.AddWithValue("@HoursPerWeekOrMonth", overtimeCalculationPOCO.HoursPerWeekOrMonth);
            }
            else
            {
                cmd.Parameters.AddWithValue("@HoursPerWeekOrMonth", DBNull.Value);
            }

            if (overtimeCalculationPOCO.FixedOvertime.HasValue)
            {
                cmd.Parameters.AddWithValue("@FixedOvertime", overtimeCalculationPOCO.FixedOvertime);
            }
            else
            {
                cmd.Parameters.AddWithValue("@FixedOvertime", DBNull.Value);
            }

            if (overtimeCalculationPOCO.WorkingHoursPOCO.SunDay.HasValue)
            {
                cmd.Parameters.AddWithValue("@SunDay", overtimeCalculationPOCO.WorkingHoursPOCO.SunDay);
            }
            else
            {
                cmd.Parameters.AddWithValue("@SunDay", DBNull.Value);
            }

            if (overtimeCalculationPOCO.WorkingHoursPOCO.MonDay.HasValue)
            {
                cmd.Parameters.AddWithValue("@MonDay", overtimeCalculationPOCO.WorkingHoursPOCO.MonDay);
            }
            else
            {
                cmd.Parameters.AddWithValue("@MonDay", DBNull.Value);
            }

            if (overtimeCalculationPOCO.WorkingHoursPOCO.TueDay.HasValue)
            {
                cmd.Parameters.AddWithValue("@TueDay", overtimeCalculationPOCO.WorkingHoursPOCO.TueDay);
            }
            else
            {
                cmd.Parameters.AddWithValue("@TueDay", DBNull.Value);
            }

            if (overtimeCalculationPOCO.WorkingHoursPOCO.WedDay.HasValue)
            {
                cmd.Parameters.AddWithValue("@WedDay", overtimeCalculationPOCO.WorkingHoursPOCO.WedDay);
            }
            else
            {
                cmd.Parameters.AddWithValue("@WedDay", DBNull.Value);
            }

            if (overtimeCalculationPOCO.WorkingHoursPOCO.ThuDay.HasValue)
            {
                cmd.Parameters.AddWithValue("@ThuDay", overtimeCalculationPOCO.WorkingHoursPOCO.ThuDay);
            }
            else
            {
                cmd.Parameters.AddWithValue("@ThuDay", DBNull.Value);
            }

            if (overtimeCalculationPOCO.WorkingHoursPOCO.FriDay.HasValue)
            {
                cmd.Parameters.AddWithValue("@FriDay", overtimeCalculationPOCO.WorkingHoursPOCO.FriDay);
            }
            else
            {
                cmd.Parameters.AddWithValue("@FriDay", DBNull.Value);
            }

            if (overtimeCalculationPOCO.WorkingHoursPOCO.SatDay.HasValue)
            {
                cmd.Parameters.AddWithValue("@SatDay", overtimeCalculationPOCO.WorkingHoursPOCO.SatDay);
            }
            else
            {
                cmd.Parameters.AddWithValue("@SatDay", DBNull.Value);
            }

            cmd.Parameters.AddWithValue("@RegimeID", overtimeCalculationPOCO.WorkingHoursPOCO.RegimeID);

            cmd.Parameters.AddWithValue("@IsWeekly", overtimeCalculationPOCO.IsWeekly);

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





        public bool GetIsWeeklyFromOvertimeCalculation()
        {
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("GetIsWeeklyFromOvertimeCalculation", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    con.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    con.Close();
                }
            }
            return Convert.ToBoolean(ds.Tables[0].Rows[0]["IsWeekly"].ToString());
        }


        public decimal GetFixedOvertimeFromOvertimeCalculation()
        {
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("GetFixedOvertimeFromOvertimeCalculation", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    con.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    con.Close();
                }
            }
            return Convert.ToDecimal(ds.Tables[0].Rows[0]["FixedOvertime"].ToString());
        }

    }
}
