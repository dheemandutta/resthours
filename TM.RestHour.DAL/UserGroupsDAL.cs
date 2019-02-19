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
    public class UserGroupsDAL
    {
        public UserGroupsPOCO GetUserGroupsByUserID(int UserID)
        {
            List<UserGroupsPOCO> prodPOList = new List<UserGroupsPOCO>();
            List<UserGroupsPOCO> prodPO = new List<UserGroupsPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetUserGroupsByUserID", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@UserID", UserID);
                    //cmd.Parameters.AddWithValue("@VesselID", VesselID);
                    con.Open();


                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    //prodPOList = Common.CommonDAL.ConvertDataTable<ProductPOCO>(ds.Tables[0]);
                    con.Close();

                }
            }
            return ConvertDataTableToUserGroupsList(ds)[0];
        }

        private List<UserGroupsPOCO> ConvertDataTableToUserGroupsList(DataSet ds)
        {
            List<UserGroupsPOCO> userGroupsList = new List<UserGroupsPOCO>();
            //check if there is at all any data
            if (ds.Tables.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    UserGroupsPOCO userGroups = new UserGroupsPOCO();

                    if (item["GroupID"] != System.DBNull.Value)
                        userGroups.GroupID = Convert.ToInt32(item["GroupID"].ToString());

                    if (item["GroupName"] != System.DBNull.Value)
                        userGroups.GroupName = item["GroupName"].ToString();

                    userGroupsList.Add(userGroups);
                }
            }


            return userGroupsList;
        }
    }
}
