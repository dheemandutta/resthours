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
using TM.Base.Common;

namespace TM.RestHour.DAL
{
    public class CrewImportDAL
    {
        public void ImportCrew(object dataTable,int vesselId)
        {
            DataTable dTable = (DataTable)dataTable;
            DataSet ds = new DataSet("CrewImport");
            ds = dTable.DataSet;
            //string strXMl = ds.GetXml();

           

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))

            {

                con.Open();
                SqlCommand command = new SqlCommand("stpImportCrew", con);
				command.CommandType = CommandType.StoredProcedure;

                for (int r = 0; r < dTable.Rows.Count; r++)
                {

                    if (dTable.Rows[r][1].ToString() != String.Empty || !dTable.Rows[r][0].ToString().Contains("signature"))
                    {

                        command.Parameters.Clear();
                        string watchkeeper = String.Empty;//dTable.Rows[r][0].ToString();
                        string notes = String.Empty;//dTable.Rows[r][1].ToString();
                        string overtime = String.Empty;//dTable.Rows[r][2].ToString();
                        string employeeNum = dTable.Rows[r][0].ToString();
                        string rank = dTable.Rows[r][3].ToString();
                        string firstname = dTable.Rows[r][2].ToString();
                        string middlename = String.Empty;//dTable.Rows[r][6].ToString();
                        string lastname = dTable.Rows[r][1].ToString();
                        string dob = dTable.Rows[r][5].ToString();
                        string pob = dTable.Rows[r][4].ToString();
                        string passportbook = string.Empty;
                        string seaman = string.Empty;
                        if (dTable.Rows[r][11].ToString().ToUpper().Trim() == "PASSPORT")
                            passportbook = dTable.Rows[r][12].ToString();
                        else
                            seaman = dTable.Rows[r][12].ToString();
                        string countryname = dTable.Rows[r][14].ToString();
                        string gender = dTable.Rows[r][8].ToString();
                        bool bwatchkeeper = false;
                        bool bovertime = false;
                        DateTime dateofbirth = new DateTime();

                        if (rank != String.Empty && firstname != String.Empty && lastname != string.Empty & dob != string.Empty && rank != string.Empty && countryname != string.Empty)
                        {
                            if (watchkeeper != string.Empty)
                            {
                                try
                                {
                                    bwatchkeeper = Convert.ToBoolean(watchkeeper);
                                }
                                catch
                                {
                                    bwatchkeeper = false;
                                }
                            }

                            if (overtime != string.Empty)
                            {
                                try
                                {
                                    bovertime = Convert.ToBoolean(overtime);
                                }
                                catch
                                {
                                    bovertime = false;
                                }
                            }

                            if (dob != string.Empty)
                            {
                                try
                                {
                                    dob = dob.Replace('.', '-');
                                    dateofbirth = dob.FormatDate(ConfigurationManager.AppSettings["InputDateFormat"].ToString(), ConfigurationManager.AppSettings["InputDateSeperator"].ToString(), ConfigurationManager.AppSettings["OutputDateFormat"].ToString(), ConfigurationManager.AppSettings["OutputDateSeperator"].ToString());
                                }
                                catch
                                {
                                    dateofbirth = new DateTime(2000, 01, 01);
                                }
                            }

                            if (gender.Trim().ToUpper() == "MALE") gender = "Male";
                            else if (gender.Trim().ToUpper() == "FEMALE") gender = "Female";


                            command.Parameters.AddWithValue("@WatchKeeper", bwatchkeeper);
                            if (!String.IsNullOrEmpty(notes))
                                command.Parameters.AddWithValue("@notes", notes);
                            else
                                command.Parameters.AddWithValue("@notes", DBNull.Value);
                            command.Parameters.AddWithValue("@Overtime", bovertime);
                            if (!String.IsNullOrEmpty(employeeNum))
                                command.Parameters.AddWithValue("@EmployeeNum", employeeNum);
                            else
                                command.Parameters.AddWithValue("@EmployeeNum", DBNull.Value);
                            command.Parameters.AddWithValue("@Rank", rank);
                            command.Parameters.AddWithValue("@FirstName", firstname);
                            if (!String.IsNullOrEmpty(middlename))
                                command.Parameters.AddWithValue("@MiddleName", middlename);
                            else
                                command.Parameters.AddWithValue("@MiddleName", DBNull.Value);
                            command.Parameters.AddWithValue("@LastName", lastname);
                            command.Parameters.AddWithValue("@DOB", dateofbirth);
                            if (!string.IsNullOrEmpty(pob))
                                command.Parameters.AddWithValue("@POB", pob);
                            else
                                command.Parameters.AddWithValue("@POB", DBNull.Value);

                            if (!String.IsNullOrEmpty(passportbook))
                                command.Parameters.AddWithValue("@PassportBook", passportbook);
                            else
                                command.Parameters.AddWithValue("@PassportBook", DBNull.Value);

                            if (!String.IsNullOrEmpty(seaman))
                                command.Parameters.AddWithValue("@Seaman", seaman);
                            else
                                command.Parameters.AddWithValue("@Seaman", DBNull.Value);
                            command.Parameters.AddWithValue("@Country", countryname);

                            command.Parameters.AddWithValue("@VesselId", vesselId);

                            if (!String.IsNullOrEmpty(gender))
                                command.Parameters.AddWithValue("@Gender", gender);
                            else
                                command.Parameters.AddWithValue("@Gender", DBNull.Value);

                            int i = command.ExecuteNonQuery();
                        }

                    }
                }


                //command.Parameters.Add(new SqlParameter("@XMLDoc", SqlDbType.VarChar));
                //command.Parameters[0].Value = strXMl; //passing the string form of XML generated above
                

            }


        }
    }
}
