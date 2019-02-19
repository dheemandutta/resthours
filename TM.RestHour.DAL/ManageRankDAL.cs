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
    public class ManageRankDAL
    {
        public List<ManageRankPOCO> GetCrewByRankID(int RankID, int VesselID)
        {
            List<ManageRankPOCO> prodPOList = new List<ManageRankPOCO>();
            List<ManageRankPOCO> prodPO = new List<ManageRankPOCO>();
            DataSet ds = new DataSet();

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetCrewByRankID", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@RankID", RankID);
                    cmd.Parameters.AddWithValue("@VesselID", VesselID);
                    con.Open();

                   
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    //prodPOList = Common.CommonDAL.ConvertDataTable<ProductPOCO>(ds.Tables[0]);
                    con.Close();

                    
                }
            }
            return ConvertDataTableToManageRankList(ds);
        }


        private List<ManageRankPOCO> ConvertDataTableToManageRankList(DataSet ds)
        {
            List<ManageRankPOCO> crewtimesheetList = new List<ManageRankPOCO>();
            //check if there is at all any data
            if (ds.Tables.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    ManageRankPOCO crewtimesheet = new ManageRankPOCO();

                    if (item["RankID"] != null)
                        crewtimesheet.RankID = Convert.ToInt32(item["RankID"].ToString());

                    if (item["Name"] != null)
                        crewtimesheet.Name = item["Name"].ToString();

                    crewtimesheetList.Add(crewtimesheet);
                }
            }


            return crewtimesheetList;
        }
    }
}





