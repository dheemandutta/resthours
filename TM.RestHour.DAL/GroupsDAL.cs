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
    public class GroupsDAL
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="groups"></param>
        /// <returns></returns>
        public int SaveGroups(GroupsPOCO groups,int VesselID)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpSaveGroups", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@GroupName", groups.GroupName);
            cmd.Parameters.AddWithValue("@PermissionIds", groups.Permissions.SelectedPermissionIds);   //////////// 
            cmd.Parameters.AddWithValue("@VesselID", VesselID);

            if (groups.ID > 0)
            {
                cmd.Parameters.AddWithValue("@ID", groups.ID);
            }
            else
            {
                cmd.Parameters.AddWithValue("@ID", DBNull.Value);
            }


            int recordsAffected = cmd.ExecuteNonQuery();
            con.Close();

            return recordsAffected;
        }

        public int SaveRankPermission(RanksPOCO rank, int VesselID)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpSaveRankGroups", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@RankId", rank.ID);
            cmd.Parameters.AddWithValue("@Groups", rank.SelectedGroups) ;
            cmd.Parameters.AddWithValue("@VesselID", VesselID);

            int recordsAffected = cmd.ExecuteNonQuery();
            con.Close();

            return recordsAffected;
        }

        //for Groups drp
        public List<GroupsPOCO> GetAllGroupsForDrp(int VesselID)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("usp_GetAllGroupsForDrp", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@VesselID", VesselID);
            DataSet ds = new DataSet();
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(ds);
            DataTable myTable = ds.Tables[0];
            List<GroupsPOCO> ranksList = myTable.AsEnumerable().Select(m => new GroupsPOCO()
            {
                ID = m.Field<int>("ID"),
                GroupName = m.Field<string>("GroupName"),

            }).ToList();

            return ranksList;
            con.Close();
        }

        //for Groups drp 2
        public List<GroupsPOCO> GetAllGroupsForDrp2(int VesselID)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("usp_GetAllGroupsForDrp2", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@VesselID", VesselID);
            DataSet ds = new DataSet();
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(ds);
            DataTable myTable = ds.Tables[0];
            List<GroupsPOCO> ranksList = myTable.AsEnumerable().Select(m => new GroupsPOCO()
            {
                ID = m.Field<int>("ID"),
                GroupName = m.Field<string>("GroupName"),

            }).ToList();

            return ranksList;
            con.Close();
        }
    }
}
