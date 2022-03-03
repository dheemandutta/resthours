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
    public class RightsDAL
    {
        public RightsPOCO GetRightsByCrewId(int? CrewId, string PageName, int VesselID, int? UserID)
        {
            List<RightsPOCO> prodPOList = new List<RightsPOCO>();
            List<RightsPOCO> prodPO = new List<RightsPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetRightsByCrewId", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    if (CrewId != null)
                        cmd.Parameters.AddWithValue("@CrewId", CrewId.Value);
                    else
                        cmd.Parameters.AddWithValue("@CrewId", DBNull.Value);

                    if (UserID != null)
                        cmd.Parameters.AddWithValue("@UserId", UserID.Value);
                    else
                        cmd.Parameters.AddWithValue("@UserId", DBNull.Value);

                    if (!String.IsNullOrEmpty(PageName))
                    {
                        cmd.Parameters.AddWithValue("@PageName", PageName);
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@PageName", DBNull.Value);
                    }
                    con.Open();


                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    //prodPOList = Common.CommonDAL.ConvertDataTable<ProductPOCO>(ds.Tables[0]);
                    con.Close();

                }
            }
            return ConvertDataTableToRightsByCrewIdList(ds, VesselID, UserID.Value);
        }

        public List<CrewPOCO> AppendCrew(int VesselID, int UserID)
        {
            List<CrewPOCO> crewPOCOs = new List<CrewPOCO>();
            
            TimeSheetDAL timesheetdal = new TimeSheetDAL();
            crewPOCOs = timesheetdal.GetAllCrewForDrp(VesselID, UserID);

            return crewPOCOs;
        }

        private RightsPOCO ConvertDataTableToRightsByCrewIdList(DataSet ds, int VesselID, int UserID)
        {
            RightsPOCO rightsPOCO = new RightsPOCO();
            List<RightsListPOCO> rightsListPOCO = new List<RightsListPOCO>();
            //check if there is at all any data
            if (ds.Tables.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    RightsListPOCO rightsList = new RightsListPOCO();

                    if (item["Id"] != System.DBNull.Value)
                        rightsList.Id = Convert.ToInt32(item["Id"].ToString());

                    if (item["ResourceName"] != System.DBNull.Value)
                        rightsList.ResourceName = item["ResourceName"].ToString();

                    if (item["ParentId"] != System.DBNull.Value)
                        rightsList.ParentId = Convert.ToInt32(item["ParentId"].ToString());

                    if (item["HasAccess"] != System.DBNull.Value)
                        rightsList.HasAccess = Convert.ToBoolean(item["HasAccess"].ToString());

                    if (item["HasChildren"] != System.DBNull.Value)
                        rightsList.HasChildren = Convert.ToBoolean(item["HasChildren"].ToString());


                    rightsListPOCO.Add(rightsList);
                }
            }
            rightsPOCO.RightsList = rightsListPOCO;
            List<CrewPOCO> crewPOCOs = new List<CrewPOCO>();
            crewPOCOs = AppendCrew(VesselID, UserID);
            rightsPOCO.CrewList = crewPOCOs;

            return rightsPOCO;
        }


        public void SaveAccess(string pageId, string hasAccess, int? crewId, int? userId)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpSaveAccessData", con);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@pageId", pageId);
            cmd.Parameters.AddWithValue("@hasAccess", hasAccess);

            if (crewId != null)
                cmd.Parameters.AddWithValue("@crewId", crewId);
            else
                cmd.Parameters.AddWithValue("@crewId", DBNull.Value);

            if (userId != null)
                cmd.Parameters.AddWithValue("@UserId", userId);
            else
                cmd.Parameters.AddWithValue("@UserId", DBNull.Value);

            int recordsAffected = cmd.ExecuteNonQuery();
            con.Close();

            //return recordsAffected;
        }





        public bool GetRightsByCrewIdAndPageName(int CrewId, string PageName)
        {
            bool hasAccess = false;
            List<RightsPOCO> prodPOList = new List<RightsPOCO>();
            List<RightsPOCO> prodPO = new List<RightsPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetRightsByCrewIdAndPageName", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@CrewId", CrewId);

                    if (!String.IsNullOrEmpty(PageName))
                    {
                        cmd.Parameters.AddWithValue("@PageName", PageName);
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@PageName", DBNull.Value);
                    }
                    con.Open();


                    //SqlDataAdapter da = new SqlDataAdapter(cmd);
                    //da.Fill(ds);
                    hasAccess = (bool)cmd.ExecuteScalar();
                    //prodPOList = Common.CommonDAL.ConvertDataTable<ProductPOCO>(ds.Tables[0]);
                    con.Close();

                }
            }
            return hasAccess;
        }

        private RightsPOCO ConvertDataTableToRightsByCrewIdAndPageNameList(DataSet ds)
        {
            RightsPOCO rightsPOCO = new RightsPOCO();
            List<RightsListPOCO> rightsListPOCO = new List<RightsListPOCO>();
            //check if there is at all any data
            if (ds.Tables.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    RightsListPOCO rightsList = new RightsListPOCO();

                    if (item["HasAccess"] != System.DBNull.Value)
                        rightsList.HasAccess = Convert.ToBoolean(item["HasAccess"].ToString());


                    rightsListPOCO.Add(rightsList);
                }
            }
            rightsPOCO.RightsList = rightsListPOCO;
            List<CrewPOCO> crewPOCOs = new List<CrewPOCO>();
            rightsPOCO.CrewList = crewPOCOs;

            return rightsPOCO;
        }




        public RightsPOCO GetRightsByCrewIdAndPageId(int CrewId, int PageId)
        {
            List<RightsPOCO> prodPOList = new List<RightsPOCO>();
            List<RightsPOCO> prodPO = new List<RightsPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetRightsByCrewIdAndPageId", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@CrewId", CrewId);
                    cmd.Parameters.AddWithValue("@PageId", PageId);

                    //if (!String.IsNullOrEmpty(PageName))
                    //{
                    //    cmd.Parameters.AddWithValue("@PageName", PageName);
                    //}
                    //else
                    //{
                    //    cmd.Parameters.AddWithValue("@PageName", DBNull.Value);
                    //}
                    con.Open();


                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    //prodPOList = Common.CommonDAL.ConvertDataTable<ProductPOCO>(ds.Tables[0]);
                    con.Close();

                }
            }
            return ConvertDataTableToRightsByCrewIdAndPageIdList(ds);
        }

        private RightsPOCO ConvertDataTableToRightsByCrewIdAndPageIdList(DataSet ds)
        {
            RightsPOCO rightsPOCO = new RightsPOCO();
            List<RightsListPOCO> rightsListPOCO = new List<RightsListPOCO>();
            //check if there is at all any data
            if (ds.Tables.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    RightsListPOCO rightsList = new RightsListPOCO();

                    if (item["HasAccess"] != System.DBNull.Value)
                        rightsList.HasAccess = Convert.ToBoolean(item["HasAccess"].ToString());


                    rightsListPOCO.Add(rightsList);
                }
            }
            rightsPOCO.RightsList = rightsListPOCO;
            List<CrewPOCO> crewPOCOs = new List<CrewPOCO>();
            rightsPOCO.CrewList = crewPOCOs;

            return rightsPOCO;
        }




        public List<AccessRightsPOCO> GetAccessRightsByCrewId(int CrewId)
        {
            List<AccessRightsPOCO> prodPOList = new List<AccessRightsPOCO>();
            List<AccessRightsPOCO> prodPO = new List<AccessRightsPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetAccessRightsByCrewId", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@CrewId", CrewId);
                    con.Open();


                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    //prodPOList = Common.CommonDAL.ConvertDataTable<ProductPOCO>(ds.Tables[0]);
                    con.Close();

                }
            }
            return ConvertDataTableToAccessRightsByCrewIdList(ds);
        }

        private List<AccessRightsPOCO> ConvertDataTableToAccessRightsByCrewIdList(DataSet ds)
        {
            List<AccessRightsPOCO> prodPOList = new List<AccessRightsPOCO>();
            //check if there is at all any data
            if (ds.Tables.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    AccessRightsPOCO prodPO = new AccessRightsPOCO();

                    if (item["CrewId"] != System.DBNull.Value)
                        prodPO.CrewId = Convert.ToInt32(item["CrewId"].ToString());

                    if (item["HasAccess"] != System.DBNull.Value)
                        prodPO.HasAccess = Convert.ToBoolean(item["HasAccess"].ToString());

                    if (item["ResourceName"] != System.DBNull.Value)
                        prodPO.ResourceName = item["ResourceName"].ToString();

                    prodPOList.Add(prodPO);
                }
            }
            return prodPOList;
        }


        public int GetUserIdByCrewID(int CrewID)
        {
            List<RightsPOCO> prodPOList = new List<RightsPOCO>();
            List<RightsPOCO> prodPO = new List<RightsPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetUserIdByCrewID", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("CrewID", CrewID);
                    con.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    //prodPOList = Common.CommonDAL.ConvertDataTable<ProductPOCO>(ds.Tables[0]);
                    con.Close();

                }
            }
            return int.Parse(ds.Tables[0].Rows[0]["ID"].ToString());
        }

    }
}
