using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;
using TM.Base.Entities;

namespace TM.RestHour.DAL
{
    public class RanksDAL
    {
        public int SaveRanks(RanksPOCO ranks,int VesselID)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpSaveRanks", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@RankName", ranks.RankName.ToString());

            if (!String.IsNullOrEmpty(ranks.Description))
            {
                cmd.Parameters.AddWithValue("@Description", ranks.Description);
            }
            else
            {
                cmd.Parameters.AddWithValue("@Description", DBNull.Value);
            }

            //if (!String.IsNullOrEmpty(ranks.Scheduled))
            //{
            //    cmd.Parameters.AddWithValue("@Scheduled", ranks.Scheduled);
            //}
            //else
            //{
            //    cmd.Parameters.AddWithValue("@Scheduled", DBNull.Value);
            //}

            cmd.Parameters.AddWithValue("@VesselID", VesselID);
            cmd.Parameters.AddWithValue("@Scheduled", ranks.Scheduled.ToString());
         

            if (ranks.ID > 0)
            {
                cmd.Parameters.AddWithValue("@ID", ranks.ID);
            }
            else
            {
                cmd.Parameters.AddWithValue("@ID", DBNull.Value);
            }
            int recordsAffected = cmd.ExecuteNonQuery();
            con.Close();

            return recordsAffected;
        }

		public int GetGroupFromRank(int rankId, int VesselID)
		{
			SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
			con.Open();
			SqlCommand cmd = new SqlCommand("stpGetRankFromGroup", con);
			cmd.CommandType = CommandType.StoredProcedure;
			cmd.Parameters.AddWithValue("@RankId", rankId);
            cmd.Parameters.AddWithValue("@VesselID", VesselID);
            DataSet ds = new DataSet();
			SqlDataAdapter da = new SqlDataAdapter(cmd);
			da.Fill(ds);
			DataTable myTable = ds.Tables[0];
			con.Close();
			return int.Parse(myTable.Rows[0]["GroupId"].ToString());

			
		}

		public void Update(List<RanksPOCO> rankspocolist, int VesselID)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpUpdateRanks", con);
            cmd.CommandType = CommandType.StoredProcedure;

            if (rankspocolist != null)
            {
                IEnumerable<XElement> el = rankspocolist.Select(i =>
                                 new XElement("row",
                                   new XElement("rankid", i.Order),
                                   new XElement("rankname", i.RankName)
                                 ));
                XElement root = new XElement("root", el);

                cmd.Parameters.AddWithValue("@RankOrder", root.ToString());
                cmd.Parameters.AddWithValue("@VesselID", VesselID);
            }




            int recordsAffected = cmd.ExecuteNonQuery();
            con.Close();

           // return recordsAffected;


        
        }



        public List<RanksPOCO> GetRanksPageWise(int pageIndex, ref int recordCount, int length, int VesselID)
        {

            List<RanksPOCO> ranksPOList = new List<RanksPOCO>();
            List<RanksPOCO> ranksPO = new List<RanksPOCO>();

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetRanksPageWise", con))
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
                        ranksPOList.Add(new RanksPOCO
                        {
                            ID = Convert.ToInt32(dr["ID"]),
                            RankName = Convert.ToString(dr["RankName"]),
                            Description = Convert.ToString(dr["Description"]),
                            Scheduled = Convert.ToBoolean(dr["Scheduled"]),
                            Order = Convert.ToInt32(dr["Order"])
                        });
                    }
                    recordCount = Convert.ToInt32(cmd.Parameters["@RecordCount"].Value);
                    con.Close();
                }
            }
            return ranksPOList;
        }

        public List<CrewPOCO> GetCrewPageWise(int ID, int pageIndex, ref int recordCount, int length, int VesselID)
        {

            List<CrewPOCO> ranksPOList = new List<CrewPOCO>();
            List<CrewPOCO> ranksPO = new List<CrewPOCO>();

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetCrewPageWise", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@ID", ID);
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
                        ranksPOList.Add(new CrewPOCO
                        {
                            ID = Convert.ToInt32(dr["ID"]),
                            Name = Convert.ToString(dr["Name"])
                        });
                    }
                    recordCount = Convert.ToInt32(cmd.Parameters["@RecordCount"].Value);
                    con.Close();
                }
            }
            return ranksPOList;
        }

        public List<RanksPOCO> GetRanksByID(int ID, int VesselID)
        {
            List<RanksPOCO> prodPOList = new List<RanksPOCO>();
            List<RanksPOCO> prodPO = new List<RanksPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetRanksByID", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@ID", ID);
                    cmd.Parameters.AddWithValue("@VesselID", VesselID);
                    con.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    con.Close();


                }
            }
            return ConvertDataTableToRankList(ds);
        }

        private List<RanksPOCO> ConvertDataTableToRankList(DataSet ds)
        {
            List<RanksPOCO> rankList = new List<RanksPOCO>();
            //check if there is at all any data
            if (ds.Tables.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    RanksPOCO rankPC = new RanksPOCO();

                    if (item["ID"] != null)
                        rankPC.ID = Convert.ToInt32(item["ID"].ToString());

                    if (item["RankName"] != null)
                        rankPC.RankName = item["RankName"].ToString();

                    if (item["Description"] != null)
                        rankPC.Description = item["Description"].ToString();

                    if (item["Scheduled"] != null)
                        rankPC.Scheduled = Convert.ToBoolean(item["Scheduled"].ToString());

                    rankList.Add(rankPC);
                }
            }
            return rankList;
        }

        public int DeleteRankByID(int ID)
        {

            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpDetleteRanks", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@ID", ID);

            int recordsAffected = cmd.ExecuteNonQuery();
            DataSet ds = new DataSet();
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(ds);

            con.Close();

            return recordsAffected;

        }
    }
}
