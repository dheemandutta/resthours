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
   public class CrewListReportDAL
    {

        public List<CrewPOCO> GetCrewReportListPageWise(int pageIndex, ref int recordCount, int length, int VesselID)
        {

            List<CrewPOCO> crewPOList = new List<CrewPOCO>();
            List<CrewPOCO> crewPO = new List<CrewPOCO>();

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetCrewReportListPageWise", con))
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
                        crewPOList.Add(new CrewPOCO
                        {
                            RowNumber = Convert.ToInt32(dr["RowNumber"]),
                            ID = Convert.ToInt32(dr["ID"]),
                            Name = Convert.ToString(dr["Name"]),
                            RankName = Convert.ToString(dr["RankName"]),
                            DOB1 = Convert.ToString(dr["DOB1"]),
                            EmployeeNumber = Convert.ToString(dr["EmployeeNumber"]),
                            PassportSeamanPassportBook = Convert.ToString(dr["PassportSeamanPassportBook"]),
                            Nationality = Convert.ToString(dr["Nationality"]),

                            //Passport = Convert.ToString(dr["PassportSeamanPassportBook"]),
                            Seaman = Convert.ToString(dr["Seaman"])
                        });
                    }
                    recordCount = Convert.ToInt32(cmd.Parameters["@RecordCount"].Value);
                    con.Close();
                }
            }
            return crewPOList;
        }

        public List<CrewPOCO> GetCrewReportListPageWise2(int pageIndex, ref int recordCount, int length, int VesselID)
        {

            List<CrewPOCO> crewPOList = new List<CrewPOCO>();
            List<CrewPOCO> crewPO = new List<CrewPOCO>();

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetCrewReportList", con))
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
                        crewPOList.Add(new CrewPOCO
                        {
                            RowNumber = Convert.ToInt32(dr["RowNumber"]),
                            ID = Convert.ToInt32(dr["ID"]),
                            Name = Convert.ToString(dr["Name"]),
                            RankName = Convert.ToString(dr["RankName"]),
                            DOB1 = Convert.ToString(dr["DOB1"]),
                            EmployeeNumber = Convert.ToString(dr["EmployeeNumber"]),
                            PassportSeamanPassportBook = Convert.ToString(dr["PassportSeamanPassportBook"]),
                            Nationality = Convert.ToString(dr["Nationality"]),

                            //Passport = Convert.ToString(dr["PassportSeamanPassportBook"]),
                            Seaman = Convert.ToString(dr["Seaman"])
                        });
                    }
                    recordCount = Convert.ToInt32(cmd.Parameters["@RecordCount"].Value);
                    con.Close();
                }
            }
            return crewPOList;
        }
    }
}
