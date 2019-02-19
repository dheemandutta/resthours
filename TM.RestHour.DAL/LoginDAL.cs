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
    public class LoginDAL
    {
        public int ResetPassword(LoginPOCO login)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpResetPassword", con);
            cmd.CommandType = CommandType.StoredProcedure;

            //if (!String.IsNullOrEmpty(crew.MiddleName))
            //{
            //    cmd.Parameters.AddWithValue("@MiddleName", crew.MiddleName.ToString());
            //}
            //else
            //{
            //    cmd.Parameters.AddWithValue("@MiddleName", DBNull.Value);
            //}

            //cmd.Parameters.AddWithValue("@UserName", login.UserName.ToString());
            cmd.Parameters.AddWithValue("@OldPassword", login.OldPassword.ToString());
            cmd.Parameters.AddWithValue("@NewPassword", login.NewPassword.ToString());
            cmd.Parameters.AddWithValue("@UserName", login.UserName);

            
            int recordsAffected = cmd.ExecuteNonQuery();
            con.Close();

            return recordsAffected;
        }


        public int? GetFirstRun()
        {

            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpGetFirstRun", con);
            cmd.CommandType = CommandType.StoredProcedure;
           

            int? recordsAffected = (int?)cmd.ExecuteScalar();
            con.Close();

            return recordsAffected;

        }
    }
}
