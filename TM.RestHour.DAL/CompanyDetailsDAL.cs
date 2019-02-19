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
    public class CompanyDetailsDAL
    {
        public int SaveCompanyDetails(CompanyDetailsPOCO companyDetails)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpSaveCompanyDetails", con);
            cmd.CommandType = CommandType.StoredProcedure;

            //cmd.Parameters.AddWithValue("@AdminID", companyDetails.AdminID);

            cmd.Parameters.AddWithValue("@Name", companyDetails.Name.ToString());

            if (!String.IsNullOrEmpty(companyDetails.Address))
            {
                cmd.Parameters.AddWithValue("@Address", companyDetails.Address);
            }
            else
            {
                cmd.Parameters.AddWithValue("@Address", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(companyDetails.Website))
            {
                cmd.Parameters.AddWithValue("@Website", companyDetails.Website);
            }
            else
            {
                cmd.Parameters.AddWithValue("@Website", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(companyDetails.AdminContact))
            {
                cmd.Parameters.AddWithValue("@AdminContact", companyDetails.AdminContact);
            }
            else
            {
                cmd.Parameters.AddWithValue("@AdminContact", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(companyDetails.AdminContactEmail))
            {
                cmd.Parameters.AddWithValue("@AdminContactEmail", companyDetails.AdminContactEmail);
            }
            else
            {
                cmd.Parameters.AddWithValue("@AdminContactEmail", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(companyDetails.ContactNumber))
            {
                cmd.Parameters.AddWithValue("@ContactNumber", companyDetails.ContactNumber);
            }
            else
            {
                cmd.Parameters.AddWithValue("@ContactNumber", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(companyDetails.Domain))
            {
                cmd.Parameters.AddWithValue("@Domain", companyDetails.Domain);
            }
            else
            {
                cmd.Parameters.AddWithValue("@Domain", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(companyDetails.SecureKey))
            {
                cmd.Parameters.AddWithValue("@SecureKey", companyDetails.SecureKey);
            }
            else
            {
                cmd.Parameters.AddWithValue("@SecureKey", DBNull.Value);
            }
            cmd.Parameters.AddWithValue("@CId", companyDetails.ID);
            // cmd.Parameters.AddWithValue("@VesselID", VesselID);

            //if (companyDetails.ID > 0)
            //{
            //    cmd.Parameters.AddWithValue("@ID", companyDetails.ID);
            //}
            //else
           // {
                cmd.Parameters.AddWithValue("@ID", DBNull.Value);
           // }

            SqlParameter param = new SqlParameter("@CompanyId", SqlDbType.Int);
            param.Direction = ParameterDirection.Output;
            cmd.Parameters.Add(param);


            int recordsAffected = cmd.ExecuteNonQuery();

            int newCompanyId = int.Parse(param.Value.ToString());

            con.Close();


            return newCompanyId;
        }

        public CompanyDetailsPOCO GetCompanyDetailsByID(int ID)
        {
            List<CompanyDetailsPOCO> prodPOList = new List<CompanyDetailsPOCO>();
            List<CompanyDetailsPOCO> prodPO = new List<CompanyDetailsPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetCompanyDetailsByID", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@ID", ID);
                    //cmd.Parameters.AddWithValue("@VesselID", VesselID);
                    con.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    con.Close();
                }
            }
            return ConvertDataTableToCompanyDetailsList(ds);
        }
        private CompanyDetailsPOCO ConvertDataTableToCompanyDetailsList(DataSet ds)
        {
            CompanyDetailsPOCO companyDetailsPC = new CompanyDetailsPOCO();
            //check if there is at all any data
            if (ds.Tables.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    if (item["ID"] != DBNull.Value)
                        companyDetailsPC.ID = Convert.ToInt32(item["ID"].ToString());

                    //if (item["AdminID"] != DBNull.Value)
                    //    fleetPC.AdminID = Convert.ToInt32(item["AdminID"].ToString());

                    if (item["Name"] != DBNull.Value)
                        companyDetailsPC.Name = item["Name"].ToString();
                    if (item["Address"] != DBNull.Value)
                        companyDetailsPC.Address = item["Address"].ToString();
                    if (item["Website"] != DBNull.Value)
                        companyDetailsPC.Website = item["Website"].ToString();
                    if (item["AdminContact"] != DBNull.Value)
                        companyDetailsPC.AdminContact = item["AdminContact"].ToString();
                    if (item["AdminContactEmail"] != DBNull.Value)
                        companyDetailsPC.AdminContactEmail = item["AdminContactEmail"].ToString();
                    if (item["ContactNumber"] != DBNull.Value)
                        companyDetailsPC.ContactNumber = item["ContactNumber"].ToString();
                    if (item["Domain"] != DBNull.Value)
                        companyDetailsPC.Domain = item["Domain"].ToString();
                    if (item["SecureKey"] != DBNull.Value)
                        companyDetailsPC.SecureKey = item["SecureKey"].ToString();

                    //List<int> days = new List<int>();

                    //departmentList.Add(departmentPC);
                }
            }
            return companyDetailsPC;
        }





        public CompanyDetailsPOCO GetCompanyDetailsNew()
        {
            List<CompanyDetailsPOCO> prodPOList = new List<CompanyDetailsPOCO>();
            List<CompanyDetailsPOCO> prodPO = new List<CompanyDetailsPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetCompanyDetailsNew", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                   // cmd.Parameters.AddWithValue("@ID", ID);
                    //cmd.Parameters.AddWithValue("@VesselID", VesselID);
                    con.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    con.Close();
                }
            }
            return ConvertDataTableToCompanyDetailsNewList(ds);
        }
        private CompanyDetailsPOCO ConvertDataTableToCompanyDetailsNewList(DataSet ds)
        {
            CompanyDetailsPOCO companyDetailsPC = new CompanyDetailsPOCO();
            //check if there is at all any data
            if (ds.Tables.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    //if (item["ID"] != DBNull.Value)
                    //    companyDetailsPC.ID = Convert.ToInt32(item["ID"].ToString());

                    //if (item["AdminID"] != DBNull.Value)
                    //    fleetPC.AdminID = Convert.ToInt32(item["AdminID"].ToString());

                    if (item["Name"] != DBNull.Value)
                        companyDetailsPC.Name = item["Name"].ToString();
                    if (item["Address"] != DBNull.Value)
                        companyDetailsPC.Address = item["Address"].ToString();
                    if (item["Website"] != DBNull.Value)
                        companyDetailsPC.Website = item["Website"].ToString();
                    if (item["AdminContact"] != DBNull.Value)
                        companyDetailsPC.AdminContact = item["AdminContact"].ToString();
                    if (item["AdminContactEmail"] != DBNull.Value)
                        companyDetailsPC.AdminContactEmail = item["AdminContactEmail"].ToString();
                    if (item["ContactNumber"] != DBNull.Value)
                        companyDetailsPC.ContactNumber = item["ContactNumber"].ToString();
                    if (item["Domain"] != DBNull.Value)
                        companyDetailsPC.Domain = item["Domain"].ToString();
                    //if (item["SecureKey"] != DBNull.Value)
                    //    companyDetailsPC.SecureKey = item["SecureKey"].ToString();

                    //List<int> days = new List<int>();

                    //departmentList.Add(departmentPC);
                }
            }
            return companyDetailsPC;
        }
    }
}
