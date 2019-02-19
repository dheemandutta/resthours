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
    public class DepartmentDAL
    {
        //for Admin Crew drp
        public List<DepartmentPOCO> GetAllAdminCrewForDrp(int VesselID)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("usp_GetAllAdminCrewForDrp", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@VesselID", VesselID);
            DataSet ds = new DataSet();
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(ds);
            DataTable myTable = ds.Tables[0];
            List<DepartmentPOCO> ranksList = myTable.AsEnumerable().Select(m => new DepartmentPOCO()
            {
                ID = m.Field<int>("ID"),
                Name = m.Field<string>("Name"),

            }).ToList();

            return ranksList;
            con.Close();
        }

        //for User Crew drp
        public List<DepartmentPOCO> GetAllUserCrewForDrp(int VesselID)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("usp_GetAllUserCrewForDrp", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@VesselID", VesselID);
            DataSet ds = new DataSet();
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(ds);
            DataTable myTable = ds.Tables[0];
            List<DepartmentPOCO> ranksList = myTable.AsEnumerable().Select(m => new DepartmentPOCO()
            {
                IDUser = m.Field<int>("ID"),
                NameUser = m.Field<string>("Name"),

            }).ToList();

            return ranksList;
            con.Close();
        }

        public int SaveDepartment(DepartmentPOCO department, int VesselID)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpSaveDepartment", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@DepartmentMasterName", department.DepartmentMasterName.ToString());
            cmd.Parameters.AddWithValue("@CrewID", department.SelectedCrewID);

            if (!String.IsNullOrEmpty(department.DepartmentMasterCode))
            {
                cmd.Parameters.AddWithValue("@DepartmentMasterCode", department.DepartmentMasterCode);
            }
            else
            {
                cmd.Parameters.AddWithValue("@DepartmentMasterCode", DBNull.Value);
            }

            cmd.Parameters.AddWithValue("@VesselID", VesselID);

            if (department.DepartmentMasterID > 0)
            {
                cmd.Parameters.AddWithValue("@DepartmentMasterID", department.DepartmentMasterID);
            }
            else
            {
                cmd.Parameters.AddWithValue("@DepartmentMasterID", DBNull.Value);
            }
            int recordsAffected = cmd.ExecuteNonQuery();
            con.Close();
            return recordsAffected;
        }

        public List<DepartmentPOCO> GetDepartmentPageWise(int pageIndex, ref int recordCount, int length, int VesselID)
        {

            List<DepartmentPOCO> departmentPOList = new List<DepartmentPOCO>();
            List<DepartmentPOCO> departmentPO = new List<DepartmentPOCO>();

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetDepartmentPageWise", con))
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
                        departmentPOList.Add(new DepartmentPOCO
                        {
                            DepartmentMasterID = Convert.ToInt32(dr["DepartmentMasterID"]),
                            DepartmentMasterName = Convert.ToString(dr["DepartmentMasterName"]),
                            //DepartmentMasterCode = Convert.ToString(dr["DepartmentMasterCode"]),
                            CrewName = Convert.ToString(dr["CrewName"]),

                            //CrewID = Convert.ToInt32(dr["CrewID"])
                        });
                    }
                    recordCount = Convert.ToInt32(cmd.Parameters["@RecordCount"].Value);
                    con.Close();
                }
            }
            return departmentPOList;
        }



        public DepartmentPOCO GetDepartmentByID(int DepartmentMasterID, int VesselID)
        {
            List<DepartmentPOCO> prodPOList = new List<DepartmentPOCO>();
            List<DepartmentPOCO> prodPO = new List<DepartmentPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetDepartmentByID", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@DepartmentMasterID", DepartmentMasterID);
                    cmd.Parameters.AddWithValue("@VesselID", VesselID);
                    con.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    con.Close();
                }
            }
            return ConvertDataTableToDepartmentList(ds);
        }
        private DepartmentPOCO ConvertDataTableToDepartmentList(DataSet ds)
        {
			DepartmentPOCO departmentPC = new DepartmentPOCO();
			//check if there is at all any data
			if (ds.Tables.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    

                    if (item["DepartmentMasterID"] != DBNull.Value)
                        departmentPC.DepartmentMasterID = Convert.ToInt32(item["DepartmentMasterID"].ToString());

                    if (item["DepartmentMasterName"] != DBNull.Value)
                        departmentPC.DepartmentMasterName = item["DepartmentMasterName"].ToString();

                    if (item["DepartmentMasterCode"] != DBNull.Value)
                        departmentPC.DepartmentMasterCode = item["DepartmentMasterCode"].ToString();

					if (item["DepartmentAdmin"] != DBNull.Value)
					{
						departmentPC.SelectedCrewID = item["DepartmentAdmin"].ToString();
						departmentPC.SelectedCrewID = departmentPC.SelectedCrewID.TrimStart(',');
						departmentPC.SelectedCrewID = departmentPC.SelectedCrewID.TrimEnd(',');
					}

					//List<int> days = new List<int>();



					//departmentList.Add(departmentPC);
                }
            }
            return departmentPC;
        }



        public int DeleteDepartment(int DepartmentMasterID)
        {

            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpDeleteDepartment", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@DepartmentMasterID", DepartmentMasterID);

            int recordsAffected = cmd.ExecuteNonQuery();
            con.Close();

            return recordsAffected;

        }

        //for Crew DualListbox
        public List<DepartmentPOCO> GetAllCrewForAssign(int VesselID)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpGetAllCrewForAssign", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@VesselID", VesselID);
            DataSet ds = new DataSet();
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(ds);
            DataTable myTable = ds.Tables[0];
            List<DepartmentPOCO> ranksList = myTable.AsEnumerable().Select(m => new DepartmentPOCO()
            {
                ID = m.Field<int>("ID"),
                Name = m.Field<string>("Name"),

            }).ToList();

            return ranksList;
            con.Close();
        }










        //public DepartmentPOCO GetDepartmentByIDForAssignCrew(int DepartmentMasterID, int VesselID)
        //{
        //    List<DepartmentPOCO> prodPOList = new List<DepartmentPOCO>();
        //    List<DepartmentPOCO> prodPO = new List<DepartmentPOCO>();
        //    DataSet ds = new DataSet();
        //    using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
        //    {
        //        using (SqlCommand cmd = new SqlCommand("stpGetDepartmentByIDForAssignCrew", con))
        //        {
        //            cmd.CommandType = CommandType.StoredProcedure;
        //            cmd.Parameters.AddWithValue("@DepartmentMasterID", DepartmentMasterID);
        //            cmd.Parameters.AddWithValue("@VesselID", VesselID);
        //            con.Open();

        //            SqlDataAdapter da = new SqlDataAdapter(cmd);
        //            da.Fill(ds);
        //            con.Close();
        //        }
        //    }
        //    return ConvertDataTableToDepartmentForAssignCrewList(ds);
        //}
        //private DepartmentPOCO ConvertDataTableToDepartmentForAssignCrewList(DataSet ds)
        //{
        //    DepartmentPOCO departmentPC = new DepartmentPOCO();
        //    //check if there is at all any data
        //    if (ds.Tables.Count > 0)
        //    {
        //        foreach (DataRow item in ds.Tables[0].Rows)
        //        {


        //            if (item["DepartmentMasterID"] != DBNull.Value)
        //                departmentPC.DepartmentMasterID = Convert.ToInt32(item["DepartmentMasterID"].ToString());

        //            if (item["CName"] != DBNull.Value)
        //                departmentPC.CName = item["CName"].ToString();



        //            //List<int> days = new List<int>();



        //            //departmentList.Add(departmentPC);
        //        }
        //    }
        //    return departmentPC;
        //}



        //for  GetDepartmentByIDForAssignCrew drp
        public List<DepartmentPOCO> GetDepartmentByIDForAssignCrew(int DepartmentMasterID, int VesselID)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpGetDepartmentByIDForAssignCrew", con);
            cmd.CommandType = CommandType.StoredProcedure;
           
			cmd.Parameters.AddWithValue("@DepartmentMasterID",DepartmentMasterID);
			cmd.Parameters.AddWithValue("@VesselID", VesselID);
			DataSet ds = new DataSet();
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(ds);
            DataTable myTable = ds.Tables[0];
			List<DepartmentPOCO> departments = new List<DepartmentPOCO>();

			for(int i=0;i<ds.Tables[0].Rows.Count;i++)
			{
				DepartmentPOCO dept = new DepartmentPOCO();
				dept.CName = ds.Tables[0].Rows[i]["Name"].ToString();
				dept.ID = int.Parse(ds.Tables[0].Rows[i]["ID"].ToString());
				departments.Add(dept);
			}

            return departments;
            con.Close();
        }










        public int SaveDepartmentMaster(DepartmentPOCO department, int VesselID)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpSaveDepartmentMaster", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@DepartmentMasterName", department.DepartmentMasterName.ToString());

            if (!String.IsNullOrEmpty(department.DepartmentMasterCode))
            {
                cmd.Parameters.AddWithValue("@DepartmentMasterCode", department.DepartmentMasterCode);
            }
            else
            {
                cmd.Parameters.AddWithValue("@DepartmentMasterCode", DBNull.Value);
            }

            cmd.Parameters.AddWithValue("@VesselID", VesselID);

            //if (department.DepartmentMasterID > 0)
            //{
            //    cmd.Parameters.AddWithValue("@DepartmentMasterID", department.DepartmentMasterID);
            //}
            //else
            //{
            //    cmd.Parameters.AddWithValue("@DepartmentMasterID", DBNull.Value);
            //}

            int recordsAffected = cmd.ExecuteNonQuery();
            con.Close();

            return recordsAffected;
        }
    }
}
