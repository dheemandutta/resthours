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
    public class MedicalAdviseDAL
    {
        public MedicalAdvisePOCO GetMedicalAdvise(int CrewId, DateTime TestDate)
        {
            List<MedicalAdvisePOCO> prodPOList = new List<MedicalAdvisePOCO>();
            List<MedicalAdvisePOCO> prodPO = new List<MedicalAdvisePOCO>();

            MedicalAdvisePOCO mAdvisePo = new MedicalAdvisePOCO();
            List<ExaminationForMedicalAdvisePOCO> exmtnMedAdviseList = new List<ExaminationForMedicalAdvisePOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetMedicalAdvise", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@CrewId", CrewId);
                    cmd.Parameters.AddWithValue("@TestDate", DateTime.Now); //just assign test date value
                    con.Open();


                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    //prodPOList = Common.CommonDAL.ConvertDataTable<ProductPOCO>(ds.Tables[0]);
                    con.Close();

                }
            }
            //return ConvertDataTableToMedicalAdviseList(ds).OrderByDescending(dt => dt.TestDate).FirstOrDefault();

            mAdvisePo = ConvertDataTableToMedicalAdviseList(ds).OrderByDescending(dt => dt.Id).FirstOrDefault();
            exmtnMedAdviseList = GetExaminationForMedicalAdviseByAdviseId(mAdvisePo.Id);
            mAdvisePo.ExaminationForMedicalAdviseList = exmtnMedAdviseList;
            return mAdvisePo;
        }
        public MedicalAdvisePOCO GetMedicalAdviseById(int adviseId)
        {
            List<MedicalAdvisePOCO> prodPOList = new List<MedicalAdvisePOCO>();
            List<MedicalAdvisePOCO> prodPO = new List<MedicalAdvisePOCO>();
            MedicalAdvisePOCO mAdvisePo = new MedicalAdvisePOCO();
            List<ExaminationForMedicalAdvisePOCO> exmtnMedAdviseList = new List<ExaminationForMedicalAdvisePOCO>();

            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetAllMedicalAdviseById", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@AdviseId", adviseId);
                    con.Open();


                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    //prodPOList = Common.CommonDAL.ConvertDataTable<ProductPOCO>(ds.Tables[0]);
                    con.Close();

                }
            }
            mAdvisePo= ConvertDataTableToMedicalAdviseList(ds).FirstOrDefault();
            exmtnMedAdviseList = GetExaminationForMedicalAdviseByAdviseId(mAdvisePo.Id);
            mAdvisePo.ExaminationForMedicalAdviseList = exmtnMedAdviseList;
            return mAdvisePo;
        }
        public List<MedicalAdvisePOCO> GetAllMedicalAdviseByCrew (int CrewId)
        {
            List<MedicalAdvisePOCO> prodPOList = new List<MedicalAdvisePOCO>();
            List<MedicalAdvisePOCO> prodPO = new List<MedicalAdvisePOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetAllMedicalAdviseByCrew", con))
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
            return ConvertDataTableToMedicalAdviseList(ds);
        }

        private List<MedicalAdvisePOCO> ConvertDataTableToMedicalAdviseList(DataSet ds)
        {
            List<MedicalAdvisePOCO> medicalAdvisePOCOList = new List<MedicalAdvisePOCO>();
            
            List<ExaminationForMedicalAdvisePOCO> examinationForMedicalAdvisePOCOs = new List<ExaminationForMedicalAdvisePOCO>();

            //check if there is at all any data
            if (ds.Tables.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    MedicalAdvisePOCO medicalAdvisePOCO = new MedicalAdvisePOCO();
                    ExaminationForMedicalAdvisePOCO examinationForMedicalAdvisePOCO = new ExaminationForMedicalAdvisePOCO();
                    

                    if (item["Id"] != System.DBNull.Value)
                        medicalAdvisePOCO.Id = Convert.ToInt32(item["Id"].ToString());

                    if (item["Diagnosis"] != System.DBNull.Value)
                        medicalAdvisePOCO.Diagnosis = item["Diagnosis"].ToString();

                    if (item["TreatmentPrescribed"] != System.DBNull.Value)
                        medicalAdvisePOCO.TreatmentPrescribed = item["TreatmentPrescribed"].ToString();

                    if (item["IsIllnessDueToAnAccident"] != System.DBNull.Value)
                        medicalAdvisePOCO.IsIllnessDueToAnAccident = Convert.ToBoolean(item["IsIllnessDueToAnAccident"]);

                    if (item["MedicinePrescribed"] != System.DBNull.Value)
                        medicalAdvisePOCO.MedicinePrescribed = item["MedicinePrescribed"].ToString();

                    if (item["RequireHospitalisation"] != System.DBNull.Value)
                        medicalAdvisePOCO.RequireHospitalisation = item["RequireHospitalisation"].ToString();

                    if (item["RequireSurgery"] != System.DBNull.Value)
                        medicalAdvisePOCO.RequireSurgery = item["RequireSurgery"].ToString();

                    if (item["IsFitForDuty"] != System.DBNull.Value)
                        medicalAdvisePOCO.IsFitForDuty = Convert.ToBoolean(item["IsFitForDuty"]);

                    if (item["FitForDutyComments"] != System.DBNull.Value)
                        medicalAdvisePOCO.FitForDutyComments = item["FitForDutyComments"].ToString();

                    if (item["IsMayJoinOnBoardButLightDuty"] != System.DBNull.Value)
                        medicalAdvisePOCO.IsMayJoinOnBoardButLightDuty = Convert.ToBoolean(item["IsMayJoinOnBoardButLightDuty"]);

                    if (item["MayJoinOnBoardDays"] != System.DBNull.Value)
                        medicalAdvisePOCO.MayJoinOnBoardDays = item["MayJoinOnBoardDays"].ToString();

                    if (item["MayJoinOnBoardComments"] != System.DBNull.Value)
                        medicalAdvisePOCO.MayJoinOnBoardComments = item["MayJoinOnBoardComments"].ToString();

                    if (item["IsUnfitForDuty"] != System.DBNull.Value)
                        medicalAdvisePOCO.IsUnfitForDuty = Convert.ToBoolean(item["IsUnfitForDuty"]);

                    if (item["UnfitForDutyComments"] != System.DBNull.Value)
                        medicalAdvisePOCO.UnfitForDutyComments = item["UnfitForDutyComments"].ToString();

                    if (item["FutureFitnessAndRestrictions"] != System.DBNull.Value)
                        medicalAdvisePOCO.FutureFitnessAndRestrictions = item["FutureFitnessAndRestrictions"].ToString();

                    if (item["DischargeSummary"] != System.DBNull.Value)
                        medicalAdvisePOCO.DischargeSummary = item["DischargeSummary"].ToString();

                    if (item["FollowUpAction"] != System.DBNull.Value)
                        medicalAdvisePOCO.FollowUpAction = item["FollowUpAction"].ToString();

                    if (item["DoctorName"] != System.DBNull.Value)
                        medicalAdvisePOCO.DoctorName = item["DoctorName"].ToString();

                    if (item["DoctorContactNo"] != System.DBNull.Value)
                        medicalAdvisePOCO.DoctorContactNo = item["DoctorContactNo"].ToString();

                    if (item["DoctorEmail"] != System.DBNull.Value)
                        medicalAdvisePOCO.DoctorEmail = item["DoctorEmail"].ToString();

                    if (item["DoctorSpeciality"] != System.DBNull.Value)
                        medicalAdvisePOCO.DoctorSpeciality = item["DoctorSpeciality"].ToString();

                    if (item["DoctorMedicalRegNo"] != System.DBNull.Value)
                        medicalAdvisePOCO.DoctorMedicalRegNo = item["DoctorMedicalRegNo"].ToString();

                    if (item["DoctorCountry"] != System.DBNull.Value)
                        medicalAdvisePOCO.DoctorCountry = item["DoctorCountry"].ToString();

                    if (item["NameOfHospital"] != System.DBNull.Value)
                        medicalAdvisePOCO.NameOfHospital = item["NameOfHospital"].ToString();

                    if (item["Path"] != System.DBNull.Value)
                        medicalAdvisePOCO.Path = item["Path"].ToString();

                    if (item["TestDate"] != System.DBNull.Value)
                        medicalAdvisePOCO.TestDate = Convert.ToDateTime(item["TestDate"]);

                    if (item["CrewId"] != System.DBNull.Value)
                        medicalAdvisePOCO.CrewId = Convert.ToInt32(item["CrewId"]);

                    if (item["CrewName"] != System.DBNull.Value)
                        medicalAdvisePOCO.CrewName = item["CrewName"].ToString();

                    if (item["RankName"] != System.DBNull.Value)
                        medicalAdvisePOCO.RankName = item["RankName"].ToString();

                    if (item["Gender"] != System.DBNull.Value)
                        medicalAdvisePOCO.Gender = item["Gender"].ToString();

                    if (item["Nationality"] != System.DBNull.Value)
                        medicalAdvisePOCO.Nationality = item["Nationality"].ToString();

                    if (item["DOB"] != System.DBNull.Value)
                        medicalAdvisePOCO.DOB = Convert.ToDateTime(item["DOB"]);

                    if (item["PassportOrSeaman"] != System.DBNull.Value)
                        medicalAdvisePOCO.PassportOrSeaman = item["PassportOrSeaman"].ToString();

                    if (item["VesselName"] != System.DBNull.Value)
                        medicalAdvisePOCO.VesselName = item["VesselName"].ToString();

                    if (item["VesselSubType"] != System.DBNull.Value)
                        medicalAdvisePOCO.VesselSubType = item["VesselSubType"].ToString();

                    if (item["FlagOfShip"] != System.DBNull.Value)
                        medicalAdvisePOCO.FlagOfShip = item["FlagOfShip"].ToString();

                    if (item["IMONumber"] != System.DBNull.Value)
                        medicalAdvisePOCO.IMONumber = item["IMONumber"].ToString();

                    if (item["CompanyOwner"] != System.DBNull.Value)
                        medicalAdvisePOCO.CompanyOwner = item["CompanyOwner"].ToString();


                    // child poco of ExaminationForMedicalAdvisePOCO

                    //if (item["Examination"] != System.DBNull.Value)
                    //    examinationForMedicalAdvisePOCO.Examination = item["Examination"].ToString();

                    //if (item["ExaminationPath"] != System.DBNull.Value)
                    //    examinationForMedicalAdvisePOCO.ExaminationPath = item["ExaminationPath"].ToString();

                    //if (item["ExaminationDate"] != System.DBNull.Value)
                    //    examinationForMedicalAdvisePOCO.ExaminationDate = Convert.ToDateTime(item["ExaminationDate"]);

                    examinationForMedicalAdvisePOCOs.Add(examinationForMedicalAdvisePOCO);

                    medicalAdvisePOCOList.Add(medicalAdvisePOCO);
                }
                //medicalAdvisePOCO.ExaminationForMedicalAdviseList = examinationForMedicalAdvisePOCOs;
            }

            return medicalAdvisePOCOList;
        }
        //private MedicalAdvisePOCO ConvertDataTableToMedicalAdviseList(DataSet ds)
        //{
        //    List<MedicalAdvisePOCO> medicalAdvisePOCOList = new List<MedicalAdvisePOCO>();
        //    MedicalAdvisePOCO medicalAdvisePOCO = new MedicalAdvisePOCO();
        //    List<ExaminationForMedicalAdvisePOCO> examinationForMedicalAdvisePOCOs = new List<ExaminationForMedicalAdvisePOCO>();

        //    //check if there is at all any data
        //    if (ds.Tables.Count > 0)
        //    {
        //        foreach (DataRow item in ds.Tables[0].Rows)
        //        {

        //            ExaminationForMedicalAdvisePOCO examinationForMedicalAdvisePOCO = new ExaminationForMedicalAdvisePOCO();


        //            if (item["Id"] != System.DBNull.Value)
        //                medicalAdvisePOCO.Id = Convert.ToInt32(item["Id"].ToString());

        //            if (item["Diagnosis"] != System.DBNull.Value)
        //                medicalAdvisePOCO.Diagnosis = item["Diagnosis"].ToString();

        //            if (item["TreatmentPrescribed"] != System.DBNull.Value)
        //                medicalAdvisePOCO.TreatmentPrescribed = item["TreatmentPrescribed"].ToString();

        //            if (item["IsIllnessDueToAnAccident"] != System.DBNull.Value)
        //                medicalAdvisePOCO.IsIllnessDueToAnAccident = Convert.ToBoolean(item["IsIllnessDueToAnAccident"]);

        //            if (item["MedicinePrescribed"] != System.DBNull.Value)
        //                medicalAdvisePOCO.MedicinePrescribed = item["MedicinePrescribed"].ToString();

        //            if (item["RequireHospitalisation"] != System.DBNull.Value)
        //                medicalAdvisePOCO.RequireHospitalisation = item["RequireHospitalisation"].ToString();

        //            if (item["RequireSurgery"] != System.DBNull.Value)
        //                medicalAdvisePOCO.RequireSurgery = item["RequireSurgery"].ToString();

        //            if (item["IsFitForDuty"] != System.DBNull.Value)
        //                medicalAdvisePOCO.IsFitForDuty = Convert.ToBoolean(item["IsFitForDuty"]);

        //            if (item["FitForDutyComments"] != System.DBNull.Value)
        //                medicalAdvisePOCO.FitForDutyComments = item["FitForDutyComments"].ToString();

        //            if (item["IsMayJoinOnBoardButLightDuty"] != System.DBNull.Value)
        //                medicalAdvisePOCO.IsMayJoinOnBoardButLightDuty = Convert.ToBoolean(item["IsMayJoinOnBoardButLightDuty"]);

        //            if (item["MayJoinOnBoardDays"] != System.DBNull.Value)
        //                medicalAdvisePOCO.MayJoinOnBoardDays = item["MayJoinOnBoardDays"].ToString();

        //            if (item["MayJoinOnBoardComments"] != System.DBNull.Value)
        //                medicalAdvisePOCO.MayJoinOnBoardComments = item["MayJoinOnBoardComments"].ToString();

        //            if (item["IsUnfitForDuty"] != System.DBNull.Value)
        //                medicalAdvisePOCO.IsUnfitForDuty = Convert.ToBoolean(item["IsUnfitForDuty"]);

        //            if (item["UnfitForDutyComments"] != System.DBNull.Value)
        //                medicalAdvisePOCO.UnfitForDutyComments = item["UnfitForDutyComments"].ToString();

        //            if (item["FutureFitnessAndRestrictions"] != System.DBNull.Value)
        //                medicalAdvisePOCO.FutureFitnessAndRestrictions = item["FutureFitnessAndRestrictions"].ToString();

        //            if (item["DischargeSummary"] != System.DBNull.Value)
        //                medicalAdvisePOCO.DischargeSummary = item["DischargeSummary"].ToString();

        //            if (item["FollowUpAction"] != System.DBNull.Value)
        //                medicalAdvisePOCO.FollowUpAction = item["FollowUpAction"].ToString();

        //            if (item["DoctorName"] != System.DBNull.Value)
        //                medicalAdvisePOCO.DoctorName = item["DoctorName"].ToString();

        //            if (item["DoctorContactNo"] != System.DBNull.Value)
        //                medicalAdvisePOCO.DoctorContactNo = item["DoctorContactNo"].ToString();

        //            if (item["DoctorEmail"] != System.DBNull.Value)
        //                medicalAdvisePOCO.DoctorEmail = item["DoctorEmail"].ToString();

        //            if (item["DoctorSpeciality"] != System.DBNull.Value)
        //                medicalAdvisePOCO.DoctorSpeciality = item["DoctorSpeciality"].ToString();

        //            if (item["DoctorMedicalRegNo"] != System.DBNull.Value)
        //                medicalAdvisePOCO.DoctorMedicalRegNo = item["DoctorMedicalRegNo"].ToString();

        //            if (item["DoctorCountry"] != System.DBNull.Value)
        //                medicalAdvisePOCO.DoctorCountry = item["DoctorCountry"].ToString();

        //            if (item["NameOfHospital"] != System.DBNull.Value)
        //                medicalAdvisePOCO.NameOfHospital = item["NameOfHospital"].ToString();

        //            if (item["Path"] != System.DBNull.Value)
        //                medicalAdvisePOCO.Path = item["Path"].ToString();

        //            if (item["TestDate"] != System.DBNull.Value)
        //                medicalAdvisePOCO.TestDate = Convert.ToDateTime(item["TestDate"]);

        //            if (item["CrewId"] != System.DBNull.Value)
        //                medicalAdvisePOCO.CrewId = Convert.ToInt32(item["CrewId"]);

        //            if (item["CrewName"] != System.DBNull.Value)
        //                medicalAdvisePOCO.CrewName = item["CrewName"].ToString();

        //            if (item["RankName"] != System.DBNull.Value)
        //                medicalAdvisePOCO.RankName = item["RankName"].ToString();

        //            if (item["Gender"] != System.DBNull.Value)
        //                medicalAdvisePOCO.Gender = item["Gender"].ToString();

        //            if (item["Nationality"] != System.DBNull.Value)
        //                medicalAdvisePOCO.Nationality = item["Nationality"].ToString();

        //            if (item["DOB"] != System.DBNull.Value)
        //                medicalAdvisePOCO.DOB = Convert.ToDateTime(item["DOB"]);

        //            if (item["PassportOrSeaman"] != System.DBNull.Value)
        //                medicalAdvisePOCO.PassportOrSeaman = item["PassportOrSeaman"].ToString();

        //            if (item["VesselName"] != System.DBNull.Value)
        //                medicalAdvisePOCO.VesselName = item["VesselName"].ToString();

        //            if (item["VesselSubType"] != System.DBNull.Value)
        //                medicalAdvisePOCO.VesselSubType = item["VesselSubType"].ToString();

        //            if (item["FlagOfShip"] != System.DBNull.Value)
        //                medicalAdvisePOCO.FlagOfShip = item["FlagOfShip"].ToString();

        //            if (item["IMONumber"] != System.DBNull.Value)
        //                medicalAdvisePOCO.IMONumber = item["IMONumber"].ToString();

        //            if (item["CompanyOwner"] != System.DBNull.Value)
        //                medicalAdvisePOCO.CompanyOwner = item["CompanyOwner"].ToString();


        //            // child poco of ExaminationForMedicalAdvisePOCO

        //            //if (item["Examination"] != System.DBNull.Value)
        //            //    examinationForMedicalAdvisePOCO.Examination = item["Examination"].ToString();

        //            //if (item["ExaminationPath"] != System.DBNull.Value)
        //            //    examinationForMedicalAdvisePOCO.ExaminationPath = item["ExaminationPath"].ToString();

        //            //if (item["ExaminationDate"] != System.DBNull.Value)
        //            //    examinationForMedicalAdvisePOCO.ExaminationDate = Convert.ToDateTime(item["ExaminationDate"]);

        //            examinationForMedicalAdvisePOCOs.Add(examinationForMedicalAdvisePOCO);
        //        }
        //        medicalAdvisePOCO.ExaminationForMedicalAdviseList = examinationForMedicalAdvisePOCOs;
        //    }

        //    return medicalAdvisePOCO;
        //}

        public int SaveMedicalAdvise(MedicalAdvisePOCO mAdvisePoco)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpSaveMedicalAdvise", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@Id", mAdvisePoco.Id);
            cmd.Parameters.AddWithValue("@CrewId", mAdvisePoco.CrewId);


            if (!String.IsNullOrEmpty(mAdvisePoco.Diagnosis))
            {
                cmd.Parameters.AddWithValue("@Diagnosis", mAdvisePoco.Diagnosis);
            }
            else
            {
                cmd.Parameters.AddWithValue("@Diagnosis", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(mAdvisePoco.TreatmentPrescribed))
            {
                cmd.Parameters.AddWithValue("@TreatmentPrescribed", mAdvisePoco.TreatmentPrescribed.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@TreatmentPrescribed", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(mAdvisePoco.IsIllnessDueToAnAccident.ToString()))
            {
                cmd.Parameters.AddWithValue("@IsIllnessDueToAnAccident", mAdvisePoco.IsIllnessDueToAnAccident.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@IsIllnessDueToAnAccident", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(mAdvisePoco.MedicinePrescribed))
            {
                cmd.Parameters.AddWithValue("@MedicinePrescribed", mAdvisePoco.MedicinePrescribed.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@MedicinePrescribed", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(mAdvisePoco.RequireHospitalisation))
            {
                cmd.Parameters.AddWithValue("@RequireHospitalisation", mAdvisePoco.RequireHospitalisation.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@RequireHospitalisation", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(mAdvisePoco.RequireSurgery))
            {
                cmd.Parameters.AddWithValue("@RequireSurgery", mAdvisePoco.RequireSurgery.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@RequireSurgery", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(mAdvisePoco.IsFitForDuty.ToString()))
            {
                cmd.Parameters.AddWithValue("@IsFitForDuty", mAdvisePoco.IsFitForDuty.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@IsFitForDuty", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(mAdvisePoco.FitForDutyComments))
            {
                cmd.Parameters.AddWithValue("@FitForDutyComments", mAdvisePoco.FitForDutyComments.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@FitForDutyComments", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(mAdvisePoco.IsMayJoinOnBoardButLightDuty.ToString()))
            {
                cmd.Parameters.AddWithValue("@IsMayJoinOnBoardButLightDuty", mAdvisePoco.IsMayJoinOnBoardButLightDuty.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@IsMayJoinOnBoardButLightDuty", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(mAdvisePoco.MayJoinOnBoardDays))
            {
                cmd.Parameters.AddWithValue("@MayJoinOnBoardDays", mAdvisePoco.MayJoinOnBoardDays.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@MayJoinOnBoardDays", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(mAdvisePoco.MayJoinOnBoardComments))
            {
                cmd.Parameters.AddWithValue("@MayJoinOnBoardComments", mAdvisePoco.MayJoinOnBoardComments.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@MayJoinOnBoardComments", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(mAdvisePoco.IsUnfitForDuty.ToString()))
            {
                cmd.Parameters.AddWithValue("@IsUnfitForDuty", mAdvisePoco.IsUnfitForDuty.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@IsUnfitForDuty", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(mAdvisePoco.UnfitForDutyComments))
            {
                cmd.Parameters.AddWithValue("@UnfitForDutyComments", mAdvisePoco.UnfitForDutyComments.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@UnfitForDutyComments", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(mAdvisePoco.FutureFitnessAndRestrictions))
            {
                cmd.Parameters.AddWithValue("@FutureFitnessAndRestrictions", mAdvisePoco.FutureFitnessAndRestrictions.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@FutureFitnessAndRestrictions", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(mAdvisePoco.DischargeSummary))
            {
                cmd.Parameters.AddWithValue("@DischargeSummary", mAdvisePoco.DischargeSummary.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@DischargeSummary", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(mAdvisePoco.FollowUpAction))
            {
                cmd.Parameters.AddWithValue("@FollowUpAction", mAdvisePoco.FollowUpAction.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@FollowUpAction", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(mAdvisePoco.DoctorName))
            {
                cmd.Parameters.AddWithValue("@DoctorName", mAdvisePoco.DoctorName.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@DoctorName", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(mAdvisePoco.DoctorContactNo))
            {
                cmd.Parameters.AddWithValue("@DoctorContactNo", mAdvisePoco.DoctorContactNo.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@DoctorContactNo", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(mAdvisePoco.DoctorEmail))
            {
                cmd.Parameters.AddWithValue("@DoctorEmail", mAdvisePoco.DoctorEmail.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@DoctorEmail", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(mAdvisePoco.DoctorSpeciality))
            {
                cmd.Parameters.AddWithValue("@DoctorSpeciality", mAdvisePoco.DoctorSpeciality.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@DoctorSpeciality", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(mAdvisePoco.DoctorMedicalRegNo))
            {
                cmd.Parameters.AddWithValue("@DoctorMedicalRegNo", mAdvisePoco.DoctorMedicalRegNo.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@DoctorMedicalRegNo", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(mAdvisePoco.DoctorCountry))
            {
                cmd.Parameters.AddWithValue("@DoctorCountry", mAdvisePoco.DoctorCountry.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@DoctorCountry", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(mAdvisePoco.NameOfHospital))
            {
                cmd.Parameters.AddWithValue("@NameOfHospital", mAdvisePoco.NameOfHospital.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@NameOfHospital", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(mAdvisePoco.Path))
            {
                cmd.Parameters.AddWithValue("@Path", mAdvisePoco.Path.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@Path", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(mAdvisePoco.TestDate.ToString()))
            {
                cmd.Parameters.AddWithValue("@TestDate", mAdvisePoco.TestDate.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@TestDate", DBNull.Value);
            }

            #region Examination Details Params

            DataTable exmtnTable = CreateExaminationForMedicalAdviseTable();
            foreach (ExaminationForMedicalAdvisePOCO exmtnMedAdvisePo in mAdvisePoco.ExaminationForMedicalAdviseList)
            {
                exmtnTable.Rows.Add(exmtnMedAdvisePo.Id, exmtnMedAdvisePo.MedicalAdviseId, exmtnMedAdvisePo.Examination, exmtnMedAdvisePo.ExaminationPath, exmtnMedAdvisePo.ExaminationDate);
            }

            cmd.Parameters.AddWithValue("@ExaminationForMedicalAdvise", exmtnTable);

            #endregion


            int recordsAffected = cmd.ExecuteNonQuery();
            con.Close();

            return recordsAffected;
        }

        public static DataTable CreateExaminationForMedicalAdviseTable()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("Id", typeof(Int32));
            dt.Columns.Add("MedicalAdviseId", typeof(Int32));
            dt.Columns.Add("Examination", typeof(string));
            dt.Columns.Add("ExaminationPath", typeof(string));
            dt.Columns.Add("ExaminationDate", typeof(DateTime));
            return dt;
        }

        public List<ExaminationForMedicalAdvisePOCO> GetExaminationForMedicalAdviseByAdviseId(int Id)
        {
            List<ExaminationForMedicalAdvisePOCO> exmtnMedAdvisePoList = new List<ExaminationForMedicalAdvisePOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetExaminationForMedicalAdviseByAdviseId", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@MedicalAdviseId", Id);
                    con.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    //prodPOList = Common.CommonDAL.ConvertDataTable<ProductPOCO>(ds.Tables[0]);
                    con.Close();
                }
            }
            if (ds.Tables[0].Rows.Count > 0)
            {

                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    ExaminationForMedicalAdvisePOCO exmtnMedAdvisePo = new ExaminationForMedicalAdvisePOCO();
                    if (ds.Tables[0].Rows[0]["Id"] != null)
                        exmtnMedAdvisePo.Id = Convert.ToInt32(item["Id"].ToString());
                    if (ds.Tables[0].Rows[0]["MedicalAdviseId"] != null)
                        exmtnMedAdvisePo.MedicalAdviseId = Convert.ToInt32(item["MedicalAdviseId"].ToString());
                    if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["Examination"].ToString()))
                        exmtnMedAdvisePo.Examination = item["Examination"].ToString();
                    if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["ExaminationPath"].ToString()))
                        exmtnMedAdvisePo.ExaminationPath = item["ExaminationPath"].ToString();
                    if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["ExaminationDate"].ToString() ))
                        exmtnMedAdvisePo.ExaminationDate = Convert.ToDateTime( item["ExaminationDate"].ToString());

                    exmtnMedAdvisePoList.Add(exmtnMedAdvisePo);
                }

            }
            else
            {
                ExaminationForMedicalAdvisePOCO exmtnMedAdvisePo = new ExaminationForMedicalAdvisePOCO();
                exmtnMedAdvisePoList.Add(exmtnMedAdvisePo);
            }
            return exmtnMedAdvisePoList;
        }
    }
}
