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
    public class UsersDAL
    {
        public int GetUserAuthentication(string Username,  string Password)
        {
            List<UsersPOCO> usersPOList = new List<UsersPOCO>();
            int returnedRows=0;
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpUserAuthentication", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Username", Username);
                    cmd.Parameters.AddWithValue("@Password", Password);

                   // cmd.Parameters.AddWithValue("@VesselID", VesselID);
                    con.Open();

                    returnedRows = (int)cmd.ExecuteScalar();

                    //SqlDataAdapter da = new SqlDataAdapter(cmd);
                    //da.Fill(ds);
                    //prodPOList = Common.CommonDAL.ConvertDataTable<ProductPOCO>(ds.Tables[0]);
                    con.Close();


                }
            }
            return returnedRows ;
        }



        private List<UsersPOCO> ConvertDataTableToUsersList(DataSet ds)
        {
            List<UsersPOCO> usersList = new List<UsersPOCO>();
            //check if there is at all any data
            if (ds.Tables.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    UsersPOCO users = new UsersPOCO();

                    //if (item["ID"] != null)
                    //    users.ID = Convert.ToInt32(item["ID"].ToString());

                    if (item["Username"] != null)
                        users.Username = item["Username"].ToString();

                    if (item["Password"] != null)
                        users.Password = item["Password"].ToString();

                    if (item["Active"] != null)
                        users.Active = Convert.ToBoolean(item["Active"].ToString());

                    usersList.Add(users);
                }
            }
            return usersList;
        }




        public List<UsersPOCO> GetUserNameByUserId(int UserId, int VesselID)
        {
            List<UsersPOCO> prodPOList = new List<UsersPOCO>();
            List<UsersPOCO> prodPO = new List<UsersPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetFirstLastNameByUserId", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@UserId", UserId);
                    cmd.Parameters.AddWithValue("@VesselID", VesselID);
                    con.Open();


                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    //prodPOList = Common.CommonDAL.ConvertDataTable<ProductPOCO>(ds.Tables[0]);
                    con.Close();


                }
            }
            return ConvertDataTableToUserNameByUserIdList(ds);
        }


        public bool CheckUserNameValidity(string username)
        {
            int usernamecount = 0;
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpCheckUserIdAvailibility", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@UserId", username);
                    con.Open();

                    usernamecount = (int)cmd.ExecuteScalar();
                    
                    con.Close();


                }
            }

            if (usernamecount == 0) return true;
            else return false;
        }



        private List<UsersPOCO> ConvertDataTableToUserNameByUserIdList(DataSet ds)
        {
            List<UsersPOCO> userNameByUserIdList = new List<UsersPOCO>();
            //check if there is at all any data
            if (ds.Tables.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    UsersPOCO userNameByUserId = new UsersPOCO();

                    //if (item["UserId"] != null)
                    //    userNameByUserId.UserId = Convert.ToInt32(item["UserId"].ToString());

					if (item["CrewId"] != DBNull.Value)
						userNameByUserId.CrewId = Convert.ToInt32(item["CrewId"].ToString());

					if (item["FirstName"] != DBNull.Value)
                        userNameByUserId.FirstName = item["FirstName"].ToString();

                    if (item["LastName"] != DBNull.Value)
                        userNameByUserId.LastName = item["LastName"].ToString();

					if (item["AdminGroup"] != DBNull.Value)
						userNameByUserId.AdminGroup = item["AdminGroup"].ToString();

                    if (item["AllowPsychologyForms"] != DBNull.Value)
                        userNameByUserId.AllowPsychologyForms = Convert.ToBoolean(item["AllowPsychologyForms"].ToString());


                    userNameByUserIdList.Add(userNameByUserId);

                }
            }
            return userNameByUserIdList;
        }












        public List<UsersPOCO> GetShipMaster()
        {
            List<UsersPOCO> prodPOList = new List<UsersPOCO>();
            List<UsersPOCO> prodPO = new List<UsersPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetShipMaster", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    con.Open();


                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    //prodPOList = Common.CommonDAL.ConvertDataTable<ProductPOCO>(ds.Tables[0]);
                    con.Close();


                }
            }
            return ConvertDataTableToGetShipMasterList(ds);
        }



        private List<UsersPOCO> ConvertDataTableToGetShipMasterList(DataSet ds)
        {
            List<UsersPOCO> userNameByUserIdList = new List<UsersPOCO>();
            //check if there is at all any data
            UsersPOCO userNameByUserId = new UsersPOCO();
            if (ds.Tables[0].Rows.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                   


                    //if (item["CrewId"] != null)
                    //    userNameByUserId.CrewId = Convert.ToInt32(item["CrewId"].ToString());

                    if (item["MName"] != DBNull.Value)
                        userNameByUserId.MName = item["MName"].ToString();

                    else
                    {
                        userNameByUserId.MName = string.Empty;
                    }


                    userNameByUserIdList.Add(userNameByUserId);
                }
            }
            else
            
                userNameByUserId.MName = string.Empty;
         

            return userNameByUserIdList;
        }
    }
}