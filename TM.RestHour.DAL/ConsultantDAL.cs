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
    public class ConsultantDAL
    {
        //for Speciality drp
        public List<ConsultantPOCO> GetAllSpecialityForDrp(/*int VesselID*/)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("usp_GetAllSpecialityForDrp", con);
            cmd.CommandType = CommandType.StoredProcedure;
            //cmd.Parameters.AddWithValue("@VesselID", VesselID);
            DataSet ds = new DataSet();
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(ds);
            DataTable myTable = ds.Tables[0];
            List<ConsultantPOCO> consultantList = myTable.AsEnumerable().Select(m => new ConsultantPOCO()
            {
                SpecialityID = m.Field<int>("SpecialityID"),
                SpecialityName = m.Field<string>("SpecialityName"),

            }).ToList();
            con.Close();
            return consultantList;

        }

        public int SaveDoctorMaster(ConsultantPOCO consultant /*,int VesselID*/)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpSaveDoctorMaster", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@DoctorName", consultant.DoctorName.ToString());
            cmd.Parameters.AddWithValue("@DoctorEmail", consultant.DoctorEmail.ToString());    
            cmd.Parameters.AddWithValue("@SpecialityID", consultant.SpecialityID);

            if (!String.IsNullOrEmpty(consultant.Comment))
            {
                cmd.Parameters.AddWithValue("@Comment", consultant.Comment.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@Comment", DBNull.Value);
            }


            //if (!String.IsNullOrEmpty(consultant.Weight))
            //{
            //    cmd.Parameters.AddWithValue("@Weight", consultant.Weight.ToString());
            //}
            //else
            //{
            //    cmd.Parameters.AddWithValue("@Weight", DBNull.Value);
            //}

            //if (!String.IsNullOrEmpty(consultant.BMI))
            //{
            //    cmd.Parameters.AddWithValue("@BMI", consultant.BMI.ToString());
            //}
            //else
            //{
            //    cmd.Parameters.AddWithValue("@BMI", DBNull.Value);
            //}

            //if (!String.IsNullOrEmpty(consultant.BP))
            //{
            //    cmd.Parameters.AddWithValue("@BP", consultant.BP.ToString());
            //}
            //else
            //{
            //    cmd.Parameters.AddWithValue("@BP", DBNull.Value);
            //}

            //if (!String.IsNullOrEmpty(consultant.BloodSugarLevel))
            //{
            //    cmd.Parameters.AddWithValue("@BloodSugarLevel", consultant.BloodSugarLevel.ToString());
            //}
            //else
            //{
            //    cmd.Parameters.AddWithValue("@BloodSugarLevel", DBNull.Value);
            //}

            //cmd.Parameters.AddWithValue("@UrineTest", consultant.UrineTest);







            //cmd.Parameters.AddWithValue("@VesselID", VesselID);

            //if (ship.ID > 0)
            //{
            //    cmd.Parameters.AddWithValue("@ID", ship.ID);
            //}
            //else
            //{
            //    cmd.Parameters.AddWithValue("@ID", DBNull.Value);
            //}
            int recordsAffected = cmd.ExecuteNonQuery();
            con.Close();

            return recordsAffected;
        }

        public List<ConsultantPOCO> GetDoctorBySpecialityID(string SpecialityID)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("usp_GetDoctorBySpecialityID", con);
            cmd.Parameters.AddWithValue("@SpecialityID", SpecialityID);
            cmd.CommandType = CommandType.StoredProcedure;
            DataSet ds = new DataSet();
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(ds);
            DataTable myTable = ds.Tables[0];
            List<ConsultantPOCO> ConsultantList = myTable.AsEnumerable().Select(m => new ConsultantPOCO()
            {
                DoctorID = m.Field<int>("DoctorID"),
                DoctorName = m.Field<string>("DoctorName")

            }).ToList();
            con.Close();
            return ConsultantList;
        }

        public int SaveConsultation(ConsultantPOCO consultant /*,int VesselID*/)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpSaveConsultation", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@DoctorID", consultant.DoctorID);
            cmd.Parameters.AddWithValue("@Problem", consultant.Problem.ToString());
            //cmd.Parameters.AddWithValue("@VesselID", VesselID);

            //if (ship.ID > 0)
            //{
            //    cmd.Parameters.AddWithValue("@ID", ship.ID);
            //}
            //else
            //{
            //    cmd.Parameters.AddWithValue("@ID", DBNull.Value);
            //}
            int recordsAffected = cmd.ExecuteNonQuery();
            con.Close();

            return recordsAffected;
        }



        public List<ConsultantPOCO> GetCrewByID(int ID)
        {
            List<ConsultantPOCO> prodPOList = new List<ConsultantPOCO>();
            List<ConsultantPOCO> prodPO = new List<ConsultantPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetCrewByID", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@ID", ID);
                    con.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    //prodPOList = Common.CommonDAL.ConvertDataTable<ProductPOCO>(ds.Tables[0]);
                    con.Close();

                }
            }
            return ConvertDataTableToCrewByIDList(ds);
        }

        private List<ConsultantPOCO> ConvertDataTableToCrewByIDList(DataSet ds)
        {
            List<ConsultantPOCO> consultantList = new List<ConsultantPOCO>();
            //check if there is at all any data
            if (ds.Tables.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    ConsultantPOCO consultant = new ConsultantPOCO();

                    if (item["ID"] != System.DBNull.Value)
                        consultant.ID = Convert.ToInt32(item["ID"].ToString());

                    if (item["DOB1"] != System.DBNull.Value)
                        consultant.DOB1 = item["DOB1"].ToString();

                    //if (item["RankID"] != System.DBNull.Value)
                    //    consultant.RankID = Convert.ToInt16(item["RankID"]);

                    consultantList.Add(consultant);
                }
            }
            
            return consultantList;
        }




        public int SaveMedicalAdvisory(ConsultantPOCO consultant, int CrewID /*,int VesselID*/)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpSaveMedicalAdvisory", con);
            cmd.CommandType = CommandType.StoredProcedure;


  
            cmd.Parameters.AddWithValue("@CrewNameID", consultant.CrewNameID);
            cmd.Parameters.AddWithValue("@CrewName", consultant.CrewName);




            if (!String.IsNullOrEmpty(consultant.Weight))
            {
                cmd.Parameters.AddWithValue("@Weight", consultant.Weight.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@Weight", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(consultant.BMI))
            {
                cmd.Parameters.AddWithValue("@BMI", consultant.BMI.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@BMI", DBNull.Value);
            }

            //if (!String.IsNullOrEmpty(consultant.BP))
            //{
            //    cmd.Parameters.AddWithValue("@BP", consultant.BP.ToString());
            //}
            //else
            //{
            //    cmd.Parameters.AddWithValue("@BP", DBNull.Value);
            //}

            if (!String.IsNullOrEmpty(consultant.BloodSugarLevel))
            {
                cmd.Parameters.AddWithValue("@BloodSugarLevel", consultant.BloodSugarLevel.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@BloodSugarLevel", DBNull.Value);
            }

            cmd.Parameters.AddWithValue("@UrineTest", consultant.UrineTest);







            if (!String.IsNullOrEmpty(consultant.Height))
            {
                cmd.Parameters.AddWithValue("@Height", consultant.Height.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@Height", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(consultant.Age))
            {
                cmd.Parameters.AddWithValue("@Age", consultant.Age.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@Age", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(consultant.BloodSugarUnit))
            {
                cmd.Parameters.AddWithValue("@BloodSugarUnit", consultant.BloodSugarUnit.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@BloodSugarUnit", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(consultant.BloodSugarTestType))
            {
                cmd.Parameters.AddWithValue("@BloodSugarTestType", consultant.BloodSugarTestType.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@BloodSugarTestType", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(consultant.Systolic))
            {
                cmd.Parameters.AddWithValue("@Systolic", consultant.Systolic.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@Systolic", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(consultant.Diastolic))
            {
                cmd.Parameters.AddWithValue("@Diastolic", consultant.Diastolic.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@Diastolic", DBNull.Value);
            }






            ////////////////////////////////////////////////////////////////////////////////////////////////////////
            cmd.Parameters.AddWithValue("@UnannouncedAlcohol", consultant.UnannouncedAlcohol);

            cmd.Parameters.AddWithValue("@AnnualDH", consultant.AnnualDH);

            if (!String.IsNullOrEmpty(consultant.Month))
            {
                cmd.Parameters.AddWithValue("@Month", consultant.Month.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@Month", DBNull.Value);
            }

           

            if (!String.IsNullOrEmpty(consultant.PulseRatebpm))
            {
                cmd.Parameters.AddWithValue("@PulseRatebpm", consultant.PulseRatebpm.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@PulseRatebpm", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(consultant.AnyDietaryRestrictions))
            {
                cmd.Parameters.AddWithValue("@AnyDietaryRestrictions", consultant.AnyDietaryRestrictions.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@AnyDietaryRestrictions", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(consultant.MedicalProductsAdministered))
            {
                cmd.Parameters.AddWithValue("@MedicalProductsAdministered", consultant.MedicalProductsAdministered.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@MedicalProductsAdministered", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(consultant.UploadExistingPrescriptions))
            {
                cmd.Parameters.AddWithValue("@UploadExistingPrescriptions", consultant.UploadExistingPrescriptions.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@UploadExistingPrescriptions", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(consultant.UploadUrineReport))
            {
                cmd.Parameters.AddWithValue("@UploadUrineReport", consultant.UploadUrineReport.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@UploadUrineReport", DBNull.Value);
            }




            cmd.Parameters.AddWithValue("@LoggedInUserId", CrewID);





            //cmd.Parameters.AddWithValue("@VesselID", VesselID);

            //if (ship.ID > 0)
            //{
            //    cmd.Parameters.AddWithValue("@ID", ship.ID);
            //}
            //else
            //{
            //    cmd.Parameters.AddWithValue("@ID", DBNull.Value);
            //}
            int recordsAffected = cmd.ExecuteNonQuery();
            con.Close();

            return recordsAffected;
        }

        public List<ConsultantPOCO> GetMedicalAdvisoryPageWise(int pageIndex, ref int recordCount, int length, int CrewID/*, int VesselID*/)
        {
            List<ConsultantPOCO> consultantPOList = new List<ConsultantPOCO>();
            List<ConsultantPOCO> consultantPO = new List<ConsultantPOCO>();

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetMedicalAdvisoryPageWise", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
                    cmd.Parameters.AddWithValue("@PageSize", length);
                    cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4);
                    cmd.Parameters["@RecordCount"].Direction = ParameterDirection.Output;
                    cmd.Parameters.AddWithValue("@LoggedInUserId", CrewID);  
                    //cmd.Parameters.AddWithValue("@VesselID", VesselID);
                    con.Open();

                    DataSet ds = new DataSet();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    //prodPOList = Common.CommonDAL.ConvertDataTable<ProductPOCO>(ds.Tables[0]);

                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        consultantPOList.Add(new ConsultantPOCO
                        {
                            MedicalAdvisoryID = Convert.ToInt32(dr["MedicalAdvisoryID"]),
                            CrewName = Convert.ToString(dr["CrewName"]),
                            Weight = Convert.ToString(dr["Weight"]),
                            BMI = Convert.ToString(dr["BMI"]),
                            //BP = Convert.ToString(dr["BP"]),
                            BloodSugarLevel = Convert.ToString(dr["BloodSugarLevel"]),
                            Systolic = Convert.ToString(dr["Systolic"]),
                            Diastolic = Convert.ToString(dr["Diastolic"]),
                            UrineTest = Convert.ToBoolean(dr["UrineTest"]),
                            UnannouncedAlcohol = Convert.ToBoolean(dr["UnannouncedAlcohol"]),
                            AnnualDH = Convert.ToBoolean(dr["AnnualDH"]),
                            Month = Convert.ToString(dr["Month"])

                            //CrewID = Convert.ToInt32(dr["CrewID"])
                        });
                    }
                    recordCount = Convert.ToInt32(cmd.Parameters["@RecordCount"].Value);
                    con.Close();
                }
            }
            return consultantPOList;
        }


        ///////////////////////////////////////////////////////////////////////////////////////////////////////////

        public List<ConsultantPOCO> GetMedicalAdvisoryPageWise2(int pageIndex, ref int recordCount, int length)
        {
            List<ConsultantPOCO> consultantPOList = new List<ConsultantPOCO>();
            List<ConsultantPOCO> consultantPO = new List<ConsultantPOCO>();

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetMedicalAdvisoryListPageWise", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
                    cmd.Parameters.AddWithValue("@PageSize", length);
                    cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4);
                    cmd.Parameters["@RecordCount"].Direction = ParameterDirection.Output;
                    //cmd.Parameters.AddWithValue("@LoggedInUserId", CrewID);
                    con.Open();

                    DataSet ds = new DataSet();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    //prodPOList = Common.CommonDAL.ConvertDataTable<ProductPOCO>(ds.Tables[0]);

                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        consultantPOList.Add(new ConsultantPOCO
                        {
                           // MedicalAdvisoryID = Convert.ToInt32(dr["MedicalAdvisoryID"]),
                            CrewName = Convert.ToString(dr["CrewName"]),
                            Weight = Convert.ToString(dr["Weight"]),
                            BMI = Convert.ToString(dr["BMI"]),
                            //BP = Convert.ToString(dr["BP"]),
                            BloodSugarLevel = Convert.ToString(dr["BloodSugarLevel"]),
                            Systolic = Convert.ToString(dr["Systolic"]),
                            Diastolic = Convert.ToString(dr["Diastolic"]),
                            UrineTest = Convert.ToBoolean(dr["UrineTest"]),
                            UnannouncedAlcohol = Convert.ToBoolean(dr["UnannouncedAlcohol"]),
                            AnnualDH = Convert.ToBoolean(dr["AnnualDH"]),
                            Month = Convert.ToString(dr["Month"])

                            //CrewID = Convert.ToInt32(dr["CrewID"])
                        });
                    }
                    recordCount = Convert.ToInt32(cmd.Parameters["@RecordCount"].Value);
                    con.Close();
                }
            }
            return consultantPOList;
        }



        public List<ConsultantPOCO> stpGetMedicalAdvisoryListPageWise2(int pageIndex, ref int recordCount, int length)
        {
            List<ConsultantPOCO> consultantPOList = new List<ConsultantPOCO>();
            List<ConsultantPOCO> consultantPO = new List<ConsultantPOCO>();

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetMedicalAdvisoryListPageWise2", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
                    cmd.Parameters.AddWithValue("@PageSize", length);
                    cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4);
                    cmd.Parameters["@RecordCount"].Direction = ParameterDirection.Output;
                    //cmd.Parameters.AddWithValue("@LoggedInUserId", CrewID);
                    con.Open();

                    DataSet ds = new DataSet();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    //prodPOList = Common.CommonDAL.ConvertDataTable<ProductPOCO>(ds.Tables[0]);

                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        consultantPOList.Add(new ConsultantPOCO
                        {
                            MedicalAdvisoryID = Convert.ToInt32(dr["MedicalAdvisoryID"]),
                            //CrewName = Convert.ToString(dr["CrewName"]),
                            Weight = Convert.ToString(dr["Weight"]),
                            BMI = Convert.ToString(dr["BMI"]),
                            BloodSugarLevel = Convert.ToString(dr["BloodSugarLevel"]),
                            Systolic = Convert.ToString(dr["Systolic"]),
                            Diastolic = Convert.ToString(dr["Diastolic"]),
                            UrineTest = Convert.ToBoolean(dr["UrineTest"]),
                            UnannouncedAlcohol = Convert.ToBoolean(dr["UnannouncedAlcohol"]),
                            AnnualDH = Convert.ToBoolean(dr["AnnualDH"]),
                            Month = Convert.ToString(dr["Month"])
                        });
                    }
                    recordCount = Convert.ToInt32(cmd.Parameters["@RecordCount"].Value);
                    con.Close();
                }
            }
            return consultantPOList;
        }
    }
}
