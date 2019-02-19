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
    public class RegimesDAL
    {
        public List<RegimesPOCO> GetDataForRegimes(/*int VesselID*//*RegimesPOCO regimesPOCO, int pageIndex, ref int recordCount, int length*/)
        {
            List<RegimesPOCO> prodPOList = new List<RegimesPOCO>();
            List<RegimesPOCO> prodPO = new List<RegimesPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetAllRegimes", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                   // cmd.Parameters.AddWithValue("@VesselID", VesselID);
                    // cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
                    //  cmd.Parameters.AddWithValue("@PageSize", length);
                    //  cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4);
                    //  cmd.Parameters["@RecordCount"].Direction = ParameterDirection.Output;

                    con.Open();


                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    con.Close();


                }
            }
            return ConvertDataTableToListReports(ds/*, reportsPOCO.Year, reportsPOCO.Month*/);
        }

        private List<RegimesPOCO> ConvertDataTableToListReports(DataSet ds /*, int year, int month*/)
        {
            List<RegimesPOCO> regimesList = new List<RegimesPOCO>();
            //check if there is at all any data
            if (ds.Tables.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    RegimesPOCO reports = new RegimesPOCO();

                    if (item["RegimeName"] != null)
                        reports.RegimeName = item["RegimeName"].ToString();
                    if (item["Description"] != null)
                        reports.Description = item["Description"].ToString();
                    if (item["Basis"] != null)
                        reports.Basis = item["Basis"].ToString();
                    if (item["MinTotalRestIn7Days"] != null)
                        reports.MinTotalRestIn7Days = float.Parse( item["MinTotalRestIn7Days"].ToString());
                    if (item["MaxTotalWorkIn24Hours"] != null)
                        reports.MaxTotalWorkIn24Hours = float.Parse(item["MaxTotalWorkIn24Hours"].ToString());
                    if (item["MinContRestIn24Hours"] != null)
                        reports.MinContRestIn24Hours = float.Parse(item["MinContRestIn24Hours"].ToString());
                    if (item["MinTotalRestIn24Hours"] != null)
                        reports.MinTotalRestIn24Hours = float.Parse(item["MinTotalRestIn24Hours"].ToString());
                    if (item["MaxTotalWorkIn7Days"] != null)
                        reports.MaxTotalWorkIn7Days = float.Parse(item["MaxTotalWorkIn7Days"].ToString());
                    if (item["CheckFor2Days"] != null)
                        reports.CheckFor2Days = Boolean.Parse(item["CheckFor2Days"].ToString());
                    if (item["OPA90"] != null)
                        reports.OPA90 = Boolean.Parse(item["OPA90"].ToString());
                    //if (item["ManilaExceptions"] != null)
                    //    reports.ManilaExceptions = Boolean.Parse(item["ManilaExceptions"].ToString());
                    if (item["UseHistCalculationOnly"] != null)
                        reports.UseHistCalculationOnly = Boolean.Parse(item["UseHistCalculationOnly"].ToString());
                    if (item["CheckOnlyWorkHours"] != null)
                        reports.CheckOnlyWorkHours = Boolean.Parse(item["CheckOnlyWorkHours"].ToString());

                    //if (item["ValidOn"] != null)
                    //crewtimesheet.BookDate =    //DateTime.ParseExact(item["ValidOn"].ToString(), "MM/dd/yyyy", CultureInfo.InvariantCulture);

                    regimesList.Add(reports);
                }
            }


            return regimesList;
        }

        public int SaveRegime(RegimesPOCO regimes, int VesselID)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpSavetblRegime", con);  
            cmd.CommandType = CommandType.StoredProcedure;
            //cmd.Parameters.AddWithValue("@ShipName", regimes.ShipName.ToString());
            //cmd.Parameters.AddWithValue("@IMONumber", regimes.IMONumber.ToString());
           
            cmd.Parameters.AddWithValue("@Regime", int.Parse(regimes.Regime.ToString()));
            cmd.Parameters.AddWithValue("@RegimeStartDate", regimes.RegimeStartDate);
            cmd.Parameters.AddWithValue("@RegimeID", int.Parse(regimes.RegimeID.ToString()));

            cmd.Parameters.AddWithValue("@VesselID",VesselID);

            //if (crew.ServiceTermsPOCO.ActiveTo.HasValue)
            //{
            //    cmd.Parameters.AddWithValue("@ActiveTo", crew.ServiceTermsPOCO.ActiveTo);
            //}
            //else
            //{
            //    cmd.Parameters.AddWithValue("@ActiveTo", DBNull.Value);
            //}



            //if (regimes.ID > 0)
            //{
            //    cmd.Parameters.AddWithValue("@ID", regimes.ID);
            //}
            //else
            //{
            //    cmd.Parameters.AddWithValue("@ID", DBNull.Value);
            //}


            //cmd.Parameters.AddWithValue("@ID", regimes.ID);

            int recordsAffected = cmd.ExecuteNonQuery();
            con.Close();

            return recordsAffected;
        }




        public List<RegimesPOCO> GetIsActiveRegime(/*int ID*/)
        {
            List<RegimesPOCO> prodPOList = new List<RegimesPOCO>();
            List<RegimesPOCO> prodPO = new List<RegimesPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetIsActiveRegime", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    //cmd.Parameters.AddWithValue("@ID", ID);
                    con.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    con.Close();
                }
            }
            return ConvertDataTableToIsActiveRegimeList(ds);
        }

        private List<RegimesPOCO> ConvertDataTableToIsActiveRegimeList(DataSet ds)
        {
            List<RegimesPOCO> regimesList = new List<RegimesPOCO>();
            //check if there is at all any data
            if (ds.Tables.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    RegimesPOCO regimes = new RegimesPOCO();

                    if (item["RegimeID"] != System.DBNull.Value)
                        regimes.RegimeID = Convert.ToInt32(item["RegimeID"].ToString());


                    regimesList.Add(regimes);
                }
            }

            return regimesList;
        }
    }
}
