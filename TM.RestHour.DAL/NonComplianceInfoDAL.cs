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
    public class NonComplianceInfoDAL
    {
        public List<NonComplianceInfoPOCO> GetNonComplianceInfo(int NCDetailsID, int VesselID)
        {
            List<NonComplianceInfoPOCO> prodPOList = new List<NonComplianceInfoPOCO>();
            List<NonComplianceInfoPOCO> prodPO = new List<NonComplianceInfoPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetNonComplianceInfo", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@NCDetailsID", NCDetailsID);
                    cmd.Parameters.AddWithValue("@VesselID", VesselID);
                    con.Open();


                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    //prodPOList = Common.CommonDAL.ConvertDataTable<ProductPOCO>(ds.Tables[0]);
                    con.Close();


                }
            }
            return ConvertDataTableToGetNonComplianceInfo(ds);
        }



        private List<NonComplianceInfoPOCO> ConvertDataTableToGetNonComplianceInfo(DataSet ds)
        {
            List<NonComplianceInfoPOCO> nonComplianceInfoList = new List<NonComplianceInfoPOCO>();
            //check if there is at all any data
            if (ds.Tables.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    NonComplianceInfoPOCO nonComplianceInfo = new NonComplianceInfoPOCO();

                    //if (item["NCDetailsID"] != null)
                    //    nonComplianceInfo.NCDetailsID = Convert.ToInt32(item["NCDetailsID"].ToString());

                    if (item["ComplianceInfo"] != null)
                        nonComplianceInfo.ComplianceInfo = item["ComplianceInfo"].ToString();

                    nonComplianceInfoList.Add(nonComplianceInfo);
                }
            }
            return nonComplianceInfoList;
        }
    }
}
