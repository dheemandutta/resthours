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
        public List<RightsPOCO> GetRightsByCrewId(int CrewId)
        {
            List<RightsPOCO> prodPOList = new List<RightsPOCO>();
            List<RightsPOCO> prodPO = new List<RightsPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetRightsByCrewId", con))
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
            return ConvertDataTableToRightsByCrewIdList(ds);
        }

        private List<RightsPOCO> ConvertDataTableToRightsByCrewIdList(DataSet ds)
        {
            List<RightsPOCO> crewtimesheetList = new List<RightsPOCO>();
            //check if there is at all any data
            if (ds.Tables.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    RightsPOCO crewtimesheet = new RightsPOCO();

                    if (item["Id"] != System.DBNull.Value)
                        crewtimesheet.Id = Convert.ToInt32(item["Id"].ToString());

                    if (item["ResourceName"] != System.DBNull.Value)
                        crewtimesheet.ResourceName = item["ResourceName"].ToString();

                    if (item["ParentId"] != System.DBNull.Value)
                        crewtimesheet.ParentId = Convert.ToInt32(item["ParentId"].ToString());

                    if (item["HasAccess"] != System.DBNull.Value)
                        crewtimesheet.HasAccess = Convert.ToBoolean(item["HasAccess"].ToString());


                    crewtimesheetList.Add(crewtimesheet);
                }
            }


            return crewtimesheetList;
        }

    }
}
