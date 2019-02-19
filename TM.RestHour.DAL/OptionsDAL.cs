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
    public class OptionsDAL
    {
        public int SaveTimeAdjustment(OptionsPOCO option,int VesselID)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpSaveTimeAdjustment", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@AdjustmentValue", option.AdjustmentValue.ToString());
            cmd.Parameters.AddWithValue("@AdjustmentDate", option.AdjustmentDate);
            cmd.Parameters.AddWithValue("@VesselID", VesselID);
            //if (crew.ServiceTermsPOCO.ActiveTo.HasValue)
            //{
            //    cmd.Parameters.AddWithValue("@ActiveTo", crew.ServiceTermsPOCO.ActiveTo);
            //}
            //else
            //{
            //    cmd.Parameters.AddWithValue("@ActiveTo", DBNull.Value);
            //}      


            //if (!String.IsNullOrEmpty(crew.Notes))
            //{
            //    cmd.Parameters.AddWithValue("@Notes", crew.Notes.ToString());
            //}
            //else
            //{
            //    cmd.Parameters.AddWithValue("@Notes", DBNull.Value);
            //}

            int recordsAffected = cmd.ExecuteNonQuery();
            con.Close();

            return recordsAffected;
        }

        


        public OptionsPOCO GetTimeAdjustment(DateTime bookDate, int VesselID)
        {


            List<OptionsPOCO> prodPOList = new List<OptionsPOCO>();
            List<OptionsPOCO> prodPO = new List<OptionsPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetTimeAdjustment", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@BookDate", bookDate);
                    cmd.Parameters.AddWithValue("@VesselID", VesselID);

                    con.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    con.Close();

                }
            }
            return ConvertDataTableToListTimeAdjustment(ds)[0];
        }

        private List<OptionsPOCO> ConvertDataTableToListTimeAdjustment(DataSet ds /*, int year, int month*/)
        {
            List<OptionsPOCO> timeAdjustmentList = new List<OptionsPOCO>();
            //check if there is at all any data
            if (ds.Tables.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    OptionsPOCO timeAdjustment = new OptionsPOCO();

                    if (item["AdjustmentValue"] != null)
                        timeAdjustment.AdjustmentValue = item["AdjustmentValue"].ToString();
                 
                    //if (item["AdjustmentDate"] != null)
                    //    timeAdjustment.AdjustmentDate = DateTime.Parse(item["AdjustmentDate"].ToString());

                    timeAdjustmentList.Add(timeAdjustment);
                }
            }

            return timeAdjustmentList;
        }
    }
}
