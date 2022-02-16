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
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetMedicalAdvise", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@CrewId", CrewId);
                    cmd.Parameters.AddWithValue("@TestDate", TestDate);
                    con.Open();


                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    //prodPOList = Common.CommonDAL.ConvertDataTable<ProductPOCO>(ds.Tables[0]);
                    con.Close();

                }
            }
            return ConvertDataTableToMedicalAdviseList(ds);
        }

        private MedicalAdvisePOCO ConvertDataTableToMedicalAdviseList(DataSet ds)
        {
            List<MedicalAdvisePOCO> medicalAdvisePOCOList = new List<MedicalAdvisePOCO>();
            MedicalAdvisePOCO medicalAdvisePOCO = new MedicalAdvisePOCO();
            List<ExaminationForMedicalAdvisePOCO> examinationForMedicalAdvisePOCOs = new List<ExaminationForMedicalAdvisePOCO>();

            //check if there is at all any data
            if (ds.Tables.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {

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

                    if (item["Examination"] != System.DBNull.Value)
                        examinationForMedicalAdvisePOCO.Examination = item["Examination"].ToString();

                    if (item["ExaminationPath"] != System.DBNull.Value)
                        examinationForMedicalAdvisePOCO.ExaminationPath = item["ExaminationPath"].ToString();

                    if (item["ExaminationDate"] != System.DBNull.Value)
                        examinationForMedicalAdvisePOCO.ExaminationDate = Convert.ToDateTime(item["ExaminationDate"]);

                    examinationForMedicalAdvisePOCOs.Add(examinationForMedicalAdvisePOCO);
                }
                medicalAdvisePOCO.ExaminationForMedicalAdviseList = examinationForMedicalAdvisePOCOs;
            }

            return medicalAdvisePOCO;
        }

    }
}
