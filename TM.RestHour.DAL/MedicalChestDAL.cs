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
    public class MedicalChestDAL
    {
        public int SaveMedicalChestCerticate(MedicalChestPOCO mdeiChest)
        {

            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpSaveMedicalChetCertificate", con);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@VesselId", mdeiChest.VesselId);
            if (!String.IsNullOrEmpty(mdeiChest.IssuingAuthorityName))
            {
                cmd.Parameters.AddWithValue("@IssuingAuthorityName", mdeiChest.IssuingAuthorityName.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@IssuingAuthorityName", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(mdeiChest.IssueDate))
            {
                cmd.Parameters.AddWithValue("@IssueDate", mdeiChest.IssueDate.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@IssueDate", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(mdeiChest.ExpiryDate))
            {
                cmd.Parameters.AddWithValue("@ExpiryDate", mdeiChest.ExpiryDate.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@ExpiryDate", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(mdeiChest.CertificateImageName))
            {
                cmd.Parameters.AddWithValue("@CertificateImageName", mdeiChest.CertificateImageName.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@CertificateImageName", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(mdeiChest.CertificateImagePath))
            {
                cmd.Parameters.AddWithValue("@CertificateImagePath", mdeiChest.CertificateImagePath.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@CertificateImagePath", DBNull.Value);
            }

            int recordsAffected = cmd.ExecuteNonQuery();
            con.Close();

            return recordsAffected;
        }


        public MedicalChestPOCO GetLatestMedicalChestCertificate(int vesselId)
        {
            MedicalChestPOCO mediChest = new MedicalChestPOCO();
            DataSet ds = new DataSet();

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetLatestMedicalChestCertificate", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@VesselId", vesselId);
                    con.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    con.Close();
                }
            }
            if (ds.Tables[0].Rows.Count > 0)
            {

                mediChest.ChestID = Convert.ToInt32(ds.Tables[0].Rows[0]["ID"].ToString());
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["VesselId"].ToString()))
                    mediChest.VesselId = Convert.ToInt32(ds.Tables[0].Rows[0]["VesselId"].ToString());
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["IssuingAuthorityName"].ToString()))
                    mediChest.IssuingAuthorityName = ds.Tables[0].Rows[0]["IssuingAuthorityName"].ToString();

                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["IssueDate"].ToString()))
                    mediChest.IssueDate = ds.Tables[0].Rows[0]["IssueDate"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["ExpiryDate"].ToString()))
                    mediChest.ExpiryDate = ds.Tables[0].Rows[0]["ExpiryDate"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["ImageName"].ToString()))
                    mediChest.CertificateImageName = ds.Tables[0].Rows[0]["ImageName"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["ImagePath"].ToString()))
                    mediChest.CertificateImagePath = ds.Tables[0].Rows[0]["ImagePath"].ToString();
            }

            return mediChest;
        }
    }
}
