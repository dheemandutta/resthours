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
    public class WellBeingDAL
    {

        public WellBeingPOCO GetWellBeingHealthPageWise(int pageIndex, ref int recordCount, int length)
        {
            
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetWellBeingHealth", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
                    cmd.Parameters.AddWithValue("@PageSize", length);
                    cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4);
                    cmd.Parameters["@RecordCount"].Direction = ParameterDirection.Output;

                    cmd.CommandTimeout = 100;
                    con.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);

                    da.Fill(ds);


                    recordCount = Convert.ToInt32(cmd.Parameters["@RecordCount"].Value);
                    con.Close();
                }
            }
            return ConvertDataTableToWellBeingHealth(ds);
        }

        private WellBeingPOCO ConvertDataTableToWellBeingHealth(DataSet ds)
        {
            WellBeingPOCO wbPo = new WellBeingPOCO();
            List<WellBeingHealthPOCO> wbHealthPocoList = new List<WellBeingHealthPOCO>();

            //check if there is at all any data
            if (ds.Tables.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    WellBeingHealthPOCO wbHealthPo = new WellBeingHealthPOCO();
                    //if (item["Id"] != DBNull.Value)
                    //    pC.Id = Convert.ToInt32(item["Id"].ToString());

                    if (item["CrewId"] != DBNull.Value)
                        wbHealthPo.CrewId = Convert.ToInt32(item["CrewId"].ToString());

                    if (item["CrewName"] != DBNull.Value)
                        wbHealthPo.CrewName = item["CrewName"].ToString();

                    if (item["JM"] != DBNull.Value)
                        wbHealthPo.IsJoiningMedical = Convert.ToBoolean(item["JM"].ToString());
                    else
                        wbHealthPo.IsJoiningMedical = false;

                    if (item["MM"] != DBNull.Value)
                        wbHealthPo.IsMonthlyMedicalData = Convert.ToBoolean(item["MM"].ToString());
                    else
                        wbHealthPo.IsMonthlyMedicalData = false;

                    if (item["PM"] != DBNull.Value)
                        wbHealthPo.IsPrescriptionMedicine = Convert.ToBoolean(item["PM"].ToString());
                    else
                        wbHealthPo.IsPrescriptionMedicine = false;

                    if (item["MA"] != DBNull.Value)
                        wbHealthPo.IsMedicalAdvise = Convert.ToBoolean(item["MA"].ToString());
                    else
                        wbHealthPo.IsMedicalAdvise = false;

                    if (item["MP"] != DBNull.Value)
                        wbHealthPo.IsMedicinePrescribed = Convert.ToBoolean(item["MP"].ToString());
                    else
                        wbHealthPo.IsMedicinePrescribed = false;



                    wbHealthPocoList.Add(wbHealthPo);
                }

                
            }
            wbPo.WellBeingHealthList = wbHealthPocoList;

            return wbPo;
        }


        public CrewPOCO GetJoiningMedicalFile(int crewId)
        {
            CrewPOCO jm = new CrewPOCO();

            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetJoiningMedicalByCrew", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@CrewId", crewId);
                    cmd.CommandTimeout = 100;
                    con.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);

                    da.Fill(ds);


                    con.Close();
                }
            }
            if (ds.Tables[0].Rows.Count > 0)
            {

                if (ds.Tables[0].Rows[0]["JoiningMedicalFile"] != null)
                    jm.JoiningMedicalFile = ds.Tables[0].Rows[0]["JoiningMedicalFile"].ToString();
                
            }


            return jm;
        }
    }
}
