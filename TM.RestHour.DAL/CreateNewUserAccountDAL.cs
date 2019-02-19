using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TM.Base.Entities;

namespace TM.RestHour.DAL
{
	public class CreateNewUserAccountDAL
	{
		public int SaveCreateNewUserAccount(UserGroupsPOCO userGroupsPOCO, int VesselID)
		{
			SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
			con.Open();
			SqlCommand cmd = new SqlCommand("stpAddUsers", con);
			cmd.CommandType = CommandType.StoredProcedure;
			cmd.Parameters.AddWithValue("@Username", userGroupsPOCO.Users.Username);
			cmd.Parameters.AddWithValue("@Password", userGroupsPOCO.Users.Password);
			cmd.Parameters.AddWithValue("@Active", userGroupsPOCO.Users.Active);
			cmd.Parameters.AddWithValue("@GroupIds", userGroupsPOCO.SelectedGroupID);
			cmd.Parameters.AddWithValue("@VesselID", VesselID);

			//cmd.Parameters.AddWithValue("@Regime", ship.Regime.ToString());

			if (userGroupsPOCO.Users.ID > 0)
			{
				cmd.Parameters.AddWithValue("@ID", userGroupsPOCO.Users.ID);
			}
			else
			{
				cmd.Parameters.AddWithValue("@ID", DBNull.Value);
			}
			if (userGroupsPOCO.CrewID.HasValue)
				cmd.Parameters.AddWithValue("@CrewId", userGroupsPOCO.CrewID);
			else
				cmd.Parameters.AddWithValue("@CrewId", DBNull.Value);
			int recordsAffected = cmd.ExecuteNonQuery();
			con.Close();

			return recordsAffected;
		}

		public List<UsersPOCO> GetUsersPageWise(int pageIndex, ref int recordCount, int length, int VesselID)
		{
			//List<UserGroupsPOCO> userGroupsPOList = new List<UserGroupsPOCO>();
			//List<UserGroupsPOCO> userGroupsPO = new List<UserGroupsPOCO>();

			List<UsersPOCO> usersPOList = new List<UsersPOCO>();

			using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
			{
				using (SqlCommand cmd = new SqlCommand("stpGetUsersDetailsPageWise", con))
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
						usersPOList.Add(new UsersPOCO
						{
							ID = Convert.ToInt32(dr["ID"]),
							Username = Convert.ToString(dr["Username"]),
							Active = Convert.ToBoolean(dr["Active"])
						});
					}
					recordCount = Convert.ToInt32(cmd.Parameters["@RecordCount"].Value);
					con.Close();
				}
			}
			return usersPOList;
		}

		public UsersPOCO GetUserByCrewId(int CrewID)
		{
			UsersPOCO users = new UsersPOCO();
			using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
			{
				using (SqlCommand cmd = new SqlCommand("stpGetUserDetailsByCrewID", con))
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.Parameters.AddWithValue("@CrewID", CrewID);
					con.Open();

					DataSet ds = new DataSet();
					SqlDataAdapter da = new SqlDataAdapter(cmd);
					da.Fill(ds);
					con.Close();

					if(ds.Tables.Count > 0)
					{
						users.Username = ds.Tables[0].Rows[0]["UserName"].ToString();                      ///////////////////////////////
						users.Password = ds.Tables[0].Rows[0]["Password"].ToString();
						users.ID = int.Parse(ds.Tables[0].Rows[0]["ID"].ToString());
					}
					

				}
			}

			return users;
		}
	}
}
