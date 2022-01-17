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
    public class CIRMDAL
    {
        public int SaveCIRM(CIRMPOCO cIRM, int VesselID)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpSaveCIRM", con);
            cmd.CommandType = CommandType.StoredProcedure;

            if (cIRM.CIRMId > 0)
            {
                cmd.Parameters.AddWithValue("@CIRMId", cIRM.CIRMId);
            }
            else
            {
                cmd.Parameters.AddWithValue("@CIRMId", DBNull.Value);
            }

            #region Vessel Details 
            cmd.Parameters.AddWithValue("@VesselID", VesselID);
            cmd.Parameters.AddWithValue("@NameOfVessel", cIRM.NameOfVessel.ToString());
            if (!String.IsNullOrEmpty(cIRM.RadioCallSign))
            {
                cmd.Parameters.AddWithValue("@RadioCallSign", cIRM.RadioCallSign.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@RadioCallSign", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(cIRM.PortofDeparture))
            {
                cmd.Parameters.AddWithValue("@PortofDeparture", cIRM.PortofDeparture.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@PortofDeparture", DBNull.Value);
            }
            
            if (!String.IsNullOrEmpty(cIRM.PortofDestination))
            {
                cmd.Parameters.AddWithValue("@PortofDestination", cIRM.PortofDestination.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@PortofDestination", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.LocationOfShip))
            {
                cmd.Parameters.AddWithValue("@LocationOfShip", cIRM.LocationOfShip.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@LocationOfShip", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.EstimatedTimeOfarrivalhrs))
            {
                cmd.Parameters.AddWithValue("@EstimatedTimeOfarrivalhrs", cIRM.EstimatedTimeOfarrivalhrs.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@EstimatedTimeOfarrivalhrs", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.Speed))
            {
                cmd.Parameters.AddWithValue("@Speed", cIRM.Speed.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@Speed", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.Weather))
            {
                cmd.Parameters.AddWithValue("@Weather", cIRM.Weather.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@Weather", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(cIRM.AgentDetails))
            {
                cmd.Parameters.AddWithValue("@AgentDetails", cIRM.AgentDetails.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@AgentDetails", DBNull.Value);
            }

            #endregion

            #region Crew Details
            cmd.Parameters.AddWithValue("@CrewId", cIRM.CrewId);
            cmd.Parameters.AddWithValue("@Nationality", cIRM.Nationality.ToString());
            cmd.Parameters.AddWithValue("@Addiction", cIRM.Addiction.ToString());
            cmd.Parameters.AddWithValue("@RankID", cIRM.RankID);

            if (!String.IsNullOrEmpty(cIRM.Ethinicity))
            {
                cmd.Parameters.AddWithValue("@Ethinicity", cIRM.Ethinicity.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@Ethinicity", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.Frequency))
            {
                cmd.Parameters.AddWithValue("@Frequency", cIRM.Frequency.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@Frequency", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.Sex))
            {
                cmd.Parameters.AddWithValue("@Sex", cIRM.Sex.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@Sex", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.Age))
            {
                cmd.Parameters.AddWithValue("@Age", cIRM.Age.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@Age", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.JoiningDate))
            {
                cmd.Parameters.AddWithValue("@JoiningDate", cIRM.JoiningDate.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@JoiningDate", DBNull.Value);
            }

            #endregion
            
            #region Other Part 1
            if (!String.IsNullOrEmpty(cIRM.Category))
            {
                cmd.Parameters.AddWithValue("@Category", cIRM.Category.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@Category", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.SubCategory))
            {
                cmd.Parameters.AddWithValue("@SubCategory", cIRM.SubCategory.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@SubCategory", DBNull.Value);
            }
            #endregion
            
            #region Vital Parameters
            if (!String.IsNullOrEmpty(cIRM.VitalParams.ObservationDate.ToString()))
            {
                cmd.Parameters.AddWithValue("@ObservationDate", cIRM.VitalParams.ObservationDate);
            }
            else
            {
                cmd.Parameters.AddWithValue("@ObservationDate", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(cIRM.VitalParams.ObservationTime.ToString()))
            {
                cmd.Parameters.AddWithValue("@ObservationTime", cIRM.VitalParams.ObservationTime);
            }
            else
            {
                cmd.Parameters.AddWithValue("@ObservationTime", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(cIRM.VitalParams.Pulse))
            {
                cmd.Parameters.AddWithValue("@Pulse", cIRM.VitalParams.Pulse.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@Pulse", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(cIRM.VitalParams.OxygenSaturation))
            {
                cmd.Parameters.AddWithValue("@OxygenSaturation", cIRM.VitalParams.OxygenSaturation.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@OxygenSaturation", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.VitalParams.RespiratoryRate))
            {
                cmd.Parameters.AddWithValue("@RespiratoryRate", cIRM.VitalParams.RespiratoryRate.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@RespiratoryRate", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.VitalParams.Systolic))
            {
                cmd.Parameters.AddWithValue("@Systolic", cIRM.VitalParams.Systolic.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@Systolic", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.VitalParams.Diastolic))
            {
                cmd.Parameters.AddWithValue("@Diastolic", cIRM.VitalParams.Diastolic.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@Diastolic", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.VitalParams.Temperature))
            {
                cmd.Parameters.AddWithValue("@Temperature", cIRM.VitalParams.Temperature.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@Temperature", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(cIRM.VitalParams.Himoglobin))
            {
                cmd.Parameters.AddWithValue("@Himoglobin", cIRM.VitalParams.Himoglobin.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@Himoglobin", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.VitalParams.Creatinine))
            {
                cmd.Parameters.AddWithValue("@Creatinine", cIRM.VitalParams.Creatinine.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@Creatinine", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.VitalParams.Bilirubin))
            {
                cmd.Parameters.AddWithValue("@Bilirubin", cIRM.VitalParams.Bilirubin.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@Bilirubin", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.VitalParams.Fasting))
            {
                cmd.Parameters.AddWithValue("@Fasting", cIRM.VitalParams.Fasting.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@Fasting", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(cIRM.VitalParams.Regular))
            {
                cmd.Parameters.AddWithValue("@Regular", cIRM.VitalParams.Regular.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@Regular", DBNull.Value);
            }



            #endregion

            #region Symtomology
            if (!String.IsNullOrEmpty(cIRM.MedicalSymtomology.ObservationDate.ToString()))
            {
                cmd.Parameters.AddWithValue("@SymptomatologyDate", cIRM.MedicalSymtomology.ObservationDate.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@SymptomatologyDate", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.MedicalSymtomology.ObservationTime.ToString()))
            {
                cmd.Parameters.AddWithValue("@SymptomatologyTime", cIRM.MedicalSymtomology.ObservationTime.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@SymptomatologyTime", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.MedicalSymtomology.Vomiting))
            {
                cmd.Parameters.AddWithValue("@Vomiting", cIRM.MedicalSymtomology.Vomiting.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@Vomiting", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.MedicalSymtomology.FrequencyOfVomiting))
            {
                cmd.Parameters.AddWithValue("@FrequencyOfVomiting", cIRM.MedicalSymtomology.FrequencyOfVomiting.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@FrequencyOfVomiting", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.MedicalSymtomology.Fits))
            {
                cmd.Parameters.AddWithValue("@Fits", cIRM.MedicalSymtomology.Fits.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@Fits", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.MedicalSymtomology.FrequencyOfFits))
            {
                cmd.Parameters.AddWithValue("@FrequencyOfFits", cIRM.MedicalSymtomology.FrequencyOfFits.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@FrequencyOfFits", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.MedicalSymtomology.Giddiness))
            {
                cmd.Parameters.AddWithValue("@Giddiness", cIRM.MedicalSymtomology.Giddiness.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@Giddiness", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.MedicalSymtomology.FrequencyOfGiddiness))
            {
                cmd.Parameters.AddWithValue("@FrequencyOfGiddiness", cIRM.MedicalSymtomology.FrequencyOfGiddiness.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@FrequencyOfGiddiness", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(cIRM.MedicalSymtomology.Lethargy))
            {
                cmd.Parameters.AddWithValue("@Lethargy", cIRM.MedicalSymtomology.Lethargy.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@Lethargy", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.MedicalSymtomology.FrequencyOfLethargy))
            {
                cmd.Parameters.AddWithValue("@FrequencyOfLethargy", cIRM.MedicalSymtomology.FrequencyOfLethargy.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@FrequencyOfLethargy", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.MedicalSymtomology.SymptomologyDetails))
            {
                cmd.Parameters.AddWithValue("@SymptomatologyDetails", cIRM.MedicalSymtomology.SymptomologyDetails.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@SymptomatologyDetails", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.MedicalSymtomology.MedicinesAdministered))
            {
                cmd.Parameters.AddWithValue("@MedicinesAdministered", cIRM.MedicalSymtomology.MedicinesAdministered.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@MedicinesAdministered", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.MedicalSymtomology.AnyOtherRelevantInformation))
            {
                cmd.Parameters.AddWithValue("@RelevantInformationForDesease", cIRM.MedicalSymtomology.AnyOtherRelevantInformation.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@RelevantInformationForDesease", DBNull.Value);
            }

            #endregion

            #region Past Medical History
            if (!String.IsNullOrEmpty(cIRM.PastMedicalHistory))
            {
                cmd.Parameters.AddWithValue("@PastMedicalHistory", cIRM.PastMedicalHistory.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@PastMedicalHistory", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.PastTreatmentGiven))
            {
                cmd.Parameters.AddWithValue("@PastTreatmentGiven", cIRM.PastTreatmentGiven.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@PastTreatmentGiven", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.PastTeleMedicalAdviceReceived))
            {
                cmd.Parameters.AddWithValue("@PastTeleMedicalAdviceReceived", cIRM.PastTeleMedicalAdviceReceived.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@PastTeleMedicalAdviceReceived", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.PastRemarks))
            {
                cmd.Parameters.AddWithValue("@PastRemarks", cIRM.PastRemarks.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@PastRemarks", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.PastMedicineAdministered))
            {
                cmd.Parameters.AddWithValue("@PastMedicineAdministered", cIRM.PastMedicineAdministered.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@PastMedicineAdministered", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.PastMedicalHistoryPath))
            {
                cmd.Parameters.AddWithValue("@PastMedicalHistoryPath", cIRM.PastMedicalHistoryPath.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@PastMedicalHistoryPath", DBNull.Value);
            }


            #endregion

            #region Other Part 2
            if (!String.IsNullOrEmpty(cIRM.WhereAndHowAccidentOccured))
            {
                cmd.Parameters.AddWithValue("@WhereAndHowAccidentOccured", cIRM.WhereAndHowAccidentOccured.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@WhereAndHowAccidentOccured", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.LocationAndTypeOfInjuryOrBurn))
            {
                cmd.Parameters.AddWithValue("@LocationAndTypeOfInjuryOrBurn", cIRM.LocationAndTypeOfInjuryOrBurn.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@LocationAndTypeOfInjuryOrBurn", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(cIRM.LocationAndTypeOfPain))
            {
                cmd.Parameters.AddWithValue("@LocationAndTypeOfPain", cIRM.LocationAndTypeOfPain.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@LocationAndTypeOfPain", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.FrequencyOfPain))
            {
                cmd.Parameters.AddWithValue("@FrequencyOfPain", cIRM.FrequencyOfPain.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@FrequencyOfPain", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.FirstAidGiven))
            {
                cmd.Parameters.AddWithValue("@FirstAidGiven", cIRM.FirstAidGiven.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@FirstAidGiven", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.PercentageOfBurn))
            {
                cmd.Parameters.AddWithValue("@PercentageOfBurn", cIRM.PercentageOfBurn.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@PercentageOfBurn", DBNull.Value);
            }

            #endregion

            #region Other Part 3 Severity of Pain /Hurt
            //if (cIRM.NoHurt.HasValue)
            //{
            //    cmd.Parameters.AddWithValue("@NoHurt", cIRM.NoHurt);
            //}
            //else
            //{
            //    cmd.Parameters.AddWithValue("@NoHurt", DBNull.Value);
            //}

            //if (cIRM.HurtLittleBit.HasValue)
            //{
            //    cmd.Parameters.AddWithValue("@HurtLittleBit", cIRM.HurtLittleBit);
            //}
            //else
            //{
            //    cmd.Parameters.AddWithValue("@HurtLittleBit", DBNull.Value);
            //}

            //if (cIRM.HurtsLittleMore.HasValue)
            //{
            //    cmd.Parameters.AddWithValue("@HurtsLittleMore", cIRM.HurtsLittleMore);
            //}
            //else
            //{
            //    cmd.Parameters.AddWithValue("@HurtsLittleMore", DBNull.Value);
            //}

            //if (cIRM.HurtsEvenMore.HasValue)
            //{
            //    cmd.Parameters.AddWithValue("@HurtsEvenMore", cIRM.HurtsEvenMore);
            //}
            //else
            //{
            //    cmd.Parameters.AddWithValue("@HurtsEvenMore", DBNull.Value);
            //}

            //if (cIRM.HurtsWholeLot.HasValue)
            //{
            //    cmd.Parameters.AddWithValue("@HurtsWholeLot", cIRM.HurtsWholeLot);
            //}
            //else
            //{
            //    cmd.Parameters.AddWithValue("@HurtsWholeLot", DBNull.Value);
            //}

            //if (cIRM.HurtsWoest.HasValue)
            //{
            //    cmd.Parameters.AddWithValue("@HurtsWoest", cIRM.HurtsWoest);
            //}
            //else
            //{
            //    cmd.Parameters.AddWithValue("@HurtsWoest", DBNull.Value);
            //}

            if (cIRM.SeverityOfPain > 0)
            {
                cmd.Parameters.AddWithValue("@SeverityOfPain", cIRM.HurtsWoest);
            }
            else
            {
                cmd.Parameters.AddWithValue("@SeverityOfPain", DBNull.Value);
            }

            #endregion

            #region Other Part 4 Upload
            if (cIRM.JoiningMedical.HasValue)
            {
                cmd.Parameters.AddWithValue("@JoiningMedical", cIRM.JoiningMedical);
                if (!String.IsNullOrEmpty(cIRM.JoiningMedicalPath))
                {
                    cmd.Parameters.AddWithValue("@JoiningMedicalPath", cIRM.JoiningMedicalPath.ToString());
                }
                else
                {
                    cmd.Parameters.AddWithValue("@JoiningMedicalPath", DBNull.Value);
                }
            }
            else
            {
                cmd.Parameters.AddWithValue("@JoiningMedical", DBNull.Value);
                cmd.Parameters.AddWithValue("@JoiningMedicalPath", DBNull.Value);
            }

            if (cIRM.MedicineAvailableOnBoard.HasValue)
            {
                cmd.Parameters.AddWithValue("@MedicineAvailableOnBoard", cIRM.MedicineAvailableOnBoard);
                if (!String.IsNullOrEmpty(cIRM.MedicineAvailableOnBoardPath))
                {
                    cmd.Parameters.AddWithValue("@MedicineAvailableOnBoardPath", cIRM.MedicineAvailableOnBoardPath.ToString());
                }
                else
                {
                    cmd.Parameters.AddWithValue("@MedicineAvailableOnBoardPath", DBNull.Value);
                }
            }
            else
            {
                cmd.Parameters.AddWithValue("@MedicineAvailableOnBoard", DBNull.Value);
                cmd.Parameters.AddWithValue("@MedicineAvailableOnBoardPath", DBNull.Value);
            }

            if (cIRM.MedicalEquipmentOnBoard.HasValue)
            {
                cmd.Parameters.AddWithValue("@MedicalEquipmentOnBoard", cIRM.MedicalEquipmentOnBoard);
                if (!String.IsNullOrEmpty(cIRM.MedicalEquipmentOnBoardPath))
                {
                    cmd.Parameters.AddWithValue("@MedicalEquipmentOnBoardPath", cIRM.MedicalEquipmentOnBoardPath.ToString());
                }
                else
                {
                    cmd.Parameters.AddWithValue("@MedicalEquipmentOnBoardPath", DBNull.Value);
                }
            }
            else
            {
                cmd.Parameters.AddWithValue("@MedicalEquipmentOnBoard", DBNull.Value);
                cmd.Parameters.AddWithValue("@MedicalEquipmentOnBoardPath", DBNull.Value);
            }

            if (cIRM.MedicalHistoryUpload.HasValue)
            {
                cmd.Parameters.AddWithValue("@MedicalHistoryUpload", cIRM.MedicalHistoryUpload);
                if (!String.IsNullOrEmpty(cIRM.MedicalHistoryPath))
                {
                    cmd.Parameters.AddWithValue("@MedicalHistoryUploadPath", cIRM.MedicalHistoryPath.ToString());
                }
                else
                {
                    cmd.Parameters.AddWithValue("@MedicalHistoryUploadPath", DBNull.Value);
                }
            }
            else
            {
                cmd.Parameters.AddWithValue("@MedicalHistoryUpload", DBNull.Value);
                cmd.Parameters.AddWithValue("@MedicalHistoryUploadPath", DBNull.Value);
            }

            if (cIRM.WorkAndRestHourLatestRecord.HasValue)
            {
                cmd.Parameters.AddWithValue("@WorkAndRestHourLatestRecord", cIRM.WorkAndRestHourLatestRecord);
                if (!String.IsNullOrEmpty(cIRM.WorkAndRestHourLatestRecordPath))
                {
                    cmd.Parameters.AddWithValue("@WorkAndRestHourLatestRecordPath", cIRM.WorkAndRestHourLatestRecordPath.ToString());
                }
                else
                {
                    cmd.Parameters.AddWithValue("@WorkAndRestHourLatestRecordPath", DBNull.Value);
                }
            }
            else
            {
                cmd.Parameters.AddWithValue("@WorkAndRestHourLatestRecord", DBNull.Value);
                cmd.Parameters.AddWithValue("@WorkAndRestHourLatestRecordPath", DBNull.Value);
            }

            if (cIRM.PreExistingMedicationPrescription.HasValue)
            {
                cmd.Parameters.AddWithValue("@PreExistingMedicationPrescription", cIRM.PreExistingMedicationPrescription);
            }
            else
            {
                cmd.Parameters.AddWithValue("@PreExistingMedicationPrescription", DBNull.Value);
            }


            if (!String.IsNullOrEmpty(cIRM.PictureUploadPath))
            {
                cmd.Parameters.AddWithValue("@PictureUploadPath", cIRM.PictureUploadPath.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@PictureUploadPath", DBNull.Value);
            }

            //cmd.Parameters.AddWithValue("@IsEquipmentUploaded", cIRM.IsEquipmentUploaded);

            #endregion
            


            
            int recordsAffected = cmd.ExecuteNonQuery();
            con.Close();

            return recordsAffected;
        }
        public List<CIRMPOCO> GetCIRMByCrewId(int CrewId)
        {
            List<CIRMPOCO> prodPOList = new List<CIRMPOCO>();
            List<CIRMPOCO> prodPO = new List<CIRMPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetCIRMByCrewId", con))
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
            return ConvertDataTableToCIRMByCrewIdList(ds);
        }

        private List<CIRMPOCO> ConvertDataTableToCIRMByCrewIdList(DataSet ds)
        {
            List<CIRMPOCO> crewtimesheetList = new List<CIRMPOCO>();
            //check if there is at all any data
            if (ds.Tables.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    CIRMPOCO crewtimesheet = new CIRMPOCO();

                    //if (item["ID"] != System.DBNull.Value)
                    //    crewtimesheet.ID = Convert.ToInt32(item["ID"].ToString());

                    //if (item["LastName"] != System.DBNull.Value)
                    //    crewtimesheet.LastName = item["LastName"].ToString();

                    if (item["IsEquipmentUploaded"] != System.DBNull.Value)
                        crewtimesheet.IsEquipmentUploaded = Convert.ToInt32(item["IsEquipmentUploaded"].ToString());

                    if (item["IsJoiningReportUloaded"] != System.DBNull.Value)
                        crewtimesheet.IsJoiningReportUloaded = Convert.ToInt32(item["IsJoiningReportUloaded"].ToString());

                    if (item["IsMedicalHistoryUploaded"] != System.DBNull.Value)
                        crewtimesheet.IsMedicalHistoryUploaded = Convert.ToInt32(item["IsMedicalHistoryUploaded"].ToString());

                    if (item["IsmedicineUploaded"] != System.DBNull.Value)
                        crewtimesheet.IsmedicineUploaded = Convert.ToInt32(item["IsmedicineUploaded"].ToString());


                    crewtimesheetList.Add(crewtimesheet);
                }
            }


            return crewtimesheetList;
        }
        public List<ShipPOCO> GetCrewForCIRMPatientDetails()
        {
            List<ShipPOCO> prodPOList = new List<ShipPOCO>();
            List<ShipPOCO> prodPO = new List<ShipPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetCrewForCIRMPatientDetails", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    // cmd.Parameters.AddWithValue("@ID", ID);
                    con.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    //prodPOList = Common.CommonDAL.ConvertDataTable<ProductPOCO>(ds.Tables[0]);
                    con.Close();
                }
            }
            return ConvertDataTableToCrewForCIRMPatientDetailsList(ds);
        }

        private List<ShipPOCO> ConvertDataTableToCrewForCIRMPatientDetailsList(DataSet ds)
        {
            List<ShipPOCO> crewtimesheetList = new List<ShipPOCO>();
            //check if there is at all any data
            if (ds.Tables.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    ShipPOCO crewtimesheet = new ShipPOCO();

                    if (item["ID"] != null)
                        crewtimesheet.ID = Convert.ToInt32(item["ID"].ToString());

                    if (item["CrewName"] != null)
                        crewtimesheet.CrewName = item["CrewName"].ToString();

                    if (item["RankID"] != null)
                        crewtimesheet.RankID = Convert.ToInt32(item["RankID"].ToString());

                    if (item["Gender"] != null)
                        crewtimesheet.Gender = item["Gender"].ToString();

                    if (item["CountryID"] != null)
                        crewtimesheet.CountryID = Convert.ToInt32(item["CountryID"].ToString());

                    if (item["DOB"] != null)
                        crewtimesheet.DOB = item["DOB"].ToString();
                    //13-01-2021 SSG
                    if (item["CreatedOn"] != null)
                        crewtimesheet.CreatedOn = item["CreatedOn"].ToString();

                    crewtimesheetList.Add(crewtimesheet);
                }
            }
            return crewtimesheetList;
        }
        public List<ShipPOCO> GetCrewForCIRMPatientDetailsByCrew(int ID)
        {
            List<ShipPOCO> prodPOList = new List<ShipPOCO>();
            List<ShipPOCO> prodPO = new List<ShipPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetCrewForCIRMPatientDetailsByCrew", con))
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
            return ConvertDataTableToCIRMByCrewId2List(ds);
        }
        private List<ShipPOCO> ConvertDataTableToCIRMByCrewId2List(DataSet ds)
        {
            List<ShipPOCO> crewtimesheetList = new List<ShipPOCO>();
            //check if there is at all any data
            if (ds.Tables.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    ShipPOCO crewtimesheet = new ShipPOCO();

                    if (item["ID"] != null)
                        crewtimesheet.ID = Convert.ToInt32(item["ID"].ToString());

                    //if (item["CrewName"] != null)
                    //    crewtimesheet.CrewName = item["CrewName"].ToString();

                    if (item["RankID"] != null)
                        crewtimesheet.RankID = Convert.ToInt32(item["RankID"].ToString());

                    if (item["Gender"] != null)
                        crewtimesheet.Gender = item["Gender"].ToString();

                    if (item["CountryID"] != null)
                        crewtimesheet.CountryID = Convert.ToInt32(item["CountryID"].ToString());

                    if (item["DOB"] != null)
                        crewtimesheet.DOB = item["DOB"].ToString();
                    //13-01-2021 SSG
                    if (item["CreatedOn"] != null)
                        crewtimesheet.CreatedOn = item["CreatedOn"].ToString();

                    crewtimesheetList.Add(crewtimesheet);
                }
            }


            return crewtimesheetList;
        }

        /// <summary>
        /// Added on 7th Jan 2022 @ BK
        /// </summary>
        /// <param name="cewId"></param>
        /// <param name="VesselId"></param>
        /// <returns></returns>
        public CIRMPOCO GetCIRMPatientDetailsByCrew(int cewId,int vesselId)
        {
            CIRMPOCO cirm = new CIRMPOCO();
            VitalStatisticsPOCO cirmVitals = new VitalStatisticsPOCO();
            MedicalSymtomologyPOCO cirmSymtomology = new MedicalSymtomologyPOCO();

            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpCIRMPatientDetailsByCrew", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@CrewID", cewId);
                    cmd.Parameters.AddWithValue("@VesselID", vesselId);
                    con.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    //prodPOList = Common.CommonDAL.ConvertDataTable<ProductPOCO>(ds.Tables[0]);
                    con.Close();
                }
            }
            if(ds.Tables[0].Rows.Count > 0)
            {

                DataSet dsUploadedImages = new DataSet();
                cirm.CIRMId = Convert.ToInt32(ds.Tables[0].Rows[0]["CIRMId"].ToString());
                dsUploadedImages = GetCIRMUploadedImages(Convert.ToInt32(ds.Tables[0].Rows[0]["CIRMId"].ToString()));

                
                #region Vessel Details---

                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["VesselID"].ToString()))
                    cirm.VesselId = Convert.ToInt32(ds.Tables[0].Rows[0]["VesselID"].ToString());

                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["NameOfVessel"].ToString()))
                    cirm.NameOfVessel = ds.Tables[0].Rows[0]["NameOfVessel"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["RadioCallSign"].ToString()))
                    cirm.RadioCallSign = ds.Tables[0].Rows[0]["RadioCallSign"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["PortofDeparture"].ToString()))
                    cirm.PortofDeparture = ds.Tables[0].Rows[0]["PortofDeparture"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["PortofDestination"].ToString()))
                    cirm.PortofDestination = ds.Tables[0].Rows[0]["PortofDestination"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["Route"].ToString()))
                    cirm.Route = ds.Tables[0].Rows[0]["Route"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["LocationOfShip"].ToString()))
                    cirm.LocationOfShip = ds.Tables[0].Rows[0]["LocationOfShip"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["EstimatedTimeOfarrivalhrs"].ToString()))
                    cirm.EstimatedTimeOfarrivalhrs = ds.Tables[0].Rows[0]["EstimatedTimeOfarrivalhrs"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["Speed"].ToString()))
                    cirm.Speed = ds.Tables[0].Rows[0]["Speed"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["Weather"].ToString()))
                    cirm.Weather = ds.Tables[0].Rows[0]["Weather"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["AgentDetails"].ToString()))
                    cirm.AgentDetails = ds.Tables[0].Rows[0]["AgentDetails"].ToString();

                #endregion

                #region Crew Details --
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["CrewId"].ToString()))
                    cirm.CrewId = Convert.ToInt32(ds.Tables[0].Rows[0]["CrewId"].ToString());
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["Nationality"].ToString()))
                    cirm.Nationality = ds.Tables[0].Rows[0]["Nationality"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["Qualification"].ToString()))
                    cirm.Qualification = ds.Tables[0].Rows[0]["Qualification"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["Addiction"].ToString()))
                    cirm.Addiction = ds.Tables[0].Rows[0]["Addiction"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["Ethinicity"].ToString()))
                    cirm.Ethinicity = ds.Tables[0].Rows[0]["Ethinicity"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["Frequency"].ToString()))
                    cirm.Frequency = ds.Tables[0].Rows[0]["Frequency"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["Sex"].ToString()))
                    cirm.Sex = ds.Tables[0].Rows[0]["Sex"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["Age"].ToString()))
                    cirm.Age = ds.Tables[0].Rows[0]["Age"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["JoiningDate"].ToString()))
                    cirm.JoiningDate = ds.Tables[0].Rows[0]["JoiningDate"].ToString();

                #endregion

                //cirm.RespiratoryRate = ds.Tables[0].Rows[0]["CIRMId"].ToString();
                //cirm.Pulse = ds.Tables[0].Rows[0]["CIRMId"].ToString();
                //cirm.Temperature = ds.Tables[0].Rows[0]["CIRMId"].ToString();
                //cirm.Systolic = ds.Tables[0].Rows[0]["CIRMId"].ToString();
                //cirm.Diastolic = ds.Tables[0].Rows[0]["CIRMId"].ToString();

                //cirm.Symptomatology = ds.Tables[0].Rows[0]["CIRMId"].ToString();

                #region Other Parameters (some are not used)

                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["LocationAndTypeOfPain"].ToString()))
                    cirm.LocationAndTypeOfPain = ds.Tables[0].Rows[0]["LocationAndTypeOfPain"].ToString();
                if ( !String.IsNullOrEmpty(ds.Tables[0].Rows[0]["WhereAndHowAccidentIsCausedCHK"].ToString()))
                    cirm.WhereAndHowAccidentIsCausedCHK = Convert.ToBoolean(ds.Tables[0].Rows[0]["WhereAndHowAccidentIsCausedCHK"].ToString());
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["UploadMedicalHistory"].ToString()))
                    cirm.UploadMedicalHistory = ds.Tables[0].Rows[0]["UploadMedicalHistory"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["UploadMedicinesAvailable"].ToString()))
                    cirm.UploadMedicinesAvailable = ds.Tables[0].Rows[0]["UploadMedicinesAvailable"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["MedicalProductsAdministered"].ToString()))
                    cirm.MedicalProductsAdministered = ds.Tables[0].Rows[0]["MedicalProductsAdministered"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["WhereAndHowAccidentIsausedARA"].ToString()))
                    cirm.WhereAndHowAccidentIsausedARA = ds.Tables[0].Rows[0]["WhereAndHowAccidentIsausedARA"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["IsEquipmentUploaded"].ToString()))
                {
                    //cirm.IsEquipmentUploaded = Convert.ToInt32(ds.Tables[0].Rows[0]["IsEquipmentUploaded"].ToString());
                    cirm.IsEquipmentUploaded = Convert.ToBoolean(ds.Tables[0].Rows[0]["IsEquipmentUploaded"].ToString()) ? 1 : 0;
                }
                    
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["IsJoiningReportUloaded"].ToString()))
                    cirm.IsJoiningReportUloaded = Convert.ToInt32(ds.Tables[0].Rows[0]["IsJoiningReportUloaded"].ToString());
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["IsMedicalHistoryUploaded"].ToString()))
                    cirm.IsMedicalHistoryUploaded = Convert.ToInt32(ds.Tables[0].Rows[0]["IsMedicalHistoryUploaded"].ToString());
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["IsmedicineUploaded"].ToString()))
                    cirm.IsmedicineUploaded = Convert.ToInt32(ds.Tables[0].Rows[0]["IsmedicineUploaded"].ToString());

               
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["Category"].ToString()))
                    cirm.Category = ds.Tables[0].Rows[0]["Category"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["SubCategory"].ToString()))
                    cirm.SubCategory = ds.Tables[0].Rows[0]["SubCategory"].ToString();

                //cirm.OxygenSaturation = ds.Tables[0].Rows[0]["CIRMId"].ToString();

                //cirm.SymptomatologyDate = ds.Tables[0].Rows[0]["CIRMId"].ToString();
                //cirm.SymptomatologyTime = ds.Tables[0].Rows[0]["CIRMId"].ToString();
                //cirm.SymptomatologyDetails = ds.Tables[0].Rows[0]["CIRMId"].ToString();
                //cirm.Vomiting = ds.Tables[0].Rows[0]["CIRMId"].ToString();
                //cirm.FrequencyOfVomiting = ds.Tables[0].Rows[0]["CIRMId"].ToString();
                //cirm.Fits = ds.Tables[0].Rows[0]["CIRMId"].ToString();
                //cirm.FrequencyOfFits = ds.Tables[0].Rows[0]["CIRMId"].ToString();
                //cirm.MedicinesAdministered = ds.Tables[0].Rows[0]["CIRMId"].ToString();

                #endregion

                #region Past Medical History

                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["PastMedicalHistory"].ToString()))
                    cirm.PastMedicalHistory = ds.Tables[0].Rows[0]["PastMedicalHistory"].ToString();

                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["PastTreatmentGiven"].ToString()))
                    cirm.PastTreatmentGiven = ds.Tables[0].Rows[0]["PastTreatmentGiven"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["PastTeleMedicalAdviceReceived"].ToString()))
                    cirm.PastTeleMedicalAdviceReceived = ds.Tables[0].Rows[0]["PastTeleMedicalAdviceReceived"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["PastRemarks"].ToString()))
                    cirm.PastRemarks = ds.Tables[0].Rows[0]["PastRemarks"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["PastMedicineAdministered"].ToString()))
                    cirm.PastMedicineAdministered = ds.Tables[0].Rows[0]["PastMedicineAdministered"].ToString();

                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["PastMedicalHistoryPath"].ToString()))
                    cirm.PastMedicalHistoryPath = ds.Tables[0].Rows[0]["PastMedicalHistoryPath"].ToString();

                #endregion

                #region Incase of Accident
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["WhereAndHowAccidentOccured"].ToString()))
                    cirm.WhereAndHowAccidentOccured = ds.Tables[0].Rows[0]["WhereAndHowAccidentOccured"].ToString();

                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["LocationAndTypeOfInjuryOrBurn"].ToString()))
                    cirm.LocationAndTypeOfInjuryOrBurn = ds.Tables[0].Rows[0]["LocationAndTypeOfInjuryOrBurn"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["FrequencyOfPain"].ToString()))
                    cirm.FrequencyOfPain = ds.Tables[0].Rows[0]["FrequencyOfPain"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["FirstAidGiven"].ToString()))
                    cirm.FirstAidGiven = ds.Tables[0].Rows[0]["FirstAidGiven"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["PercentageOfBurn"].ToString()))
                    cirm.PercentageOfBurn = ds.Tables[0].Rows[0]["PercentageOfBurn"].ToString();

                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["PictureUploadPath"].ToString()))
                    cirm.PictureUploadPath = ds.Tables[0].Rows[0]["PictureUploadPath"].ToString();

                #endregion

                #region Severity of Pain / Hurt

                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["NoHurt"].ToString()))
                    cirm.NoHurt = Convert.ToBoolean(ds.Tables[0].Rows[0]["NoHurt"].ToString());
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["NoHurt"].ToString()))
                    cirm.HurtLittleBit = Convert.ToBoolean(ds.Tables[0].Rows[0]["HurtLittleBit"].ToString());
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["HurtLittleBit"].ToString()))
                    cirm.HurtsLittleMore = Convert.ToBoolean(ds.Tables[0].Rows[0]["HurtsLittleMore"].ToString());
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["HurtsLittleMore"].ToString()))
                    cirm.HurtsEvenMore = Convert.ToBoolean(ds.Tables[0].Rows[0]["HurtsEvenMore"].ToString());
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["HurtsWholeLot"].ToString()))
                    cirm.HurtsWholeLot = Convert.ToBoolean(ds.Tables[0].Rows[0]["HurtsWholeLot"].ToString());
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["HurtsWoest"].ToString()))
                    cirm.HurtsWoest = Convert.ToBoolean(ds.Tables[0].Rows[0]["HurtsWoest"].ToString());
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["SeverityOfPain"].ToString()))
                    cirm.SeverityOfPain = Convert.ToInt32(ds.Tables[0].Rows[0]["SeverityOfPain"].ToString());

                #endregion

                #region Upload section

                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["JoiningMedical"].ToString()))
                {
                    cirm.JoiningMedical = Convert.ToBoolean(ds.Tables[0].Rows[0]["JoiningMedical"].ToString());
                    //cirm.JoiningMedicalPath = dsUploadedImages.Tables[0].Select("FilePath")
                    //                                    .Where(e => e.ItemArray[2].ToString().Equals("JoiningMedical")).FirstOrDefault().ToString();
                    cirm.JoiningMedicalPath = dsUploadedImages.Tables[0].AsEnumerable()
                                                        .Where(r => r.Field<string>("FileType") == "JoiningMedical")
                                                        .Select(r => r.Field<string>("FilePath")).FirstOrDefault().ToString();
                }
                    
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["MedicineAvailableOnBoard"].ToString()))
                {
                    cirm.MedicineAvailableOnBoard = Convert.ToBoolean(ds.Tables[0].Rows[0]["MedicineAvailableOnBoard"].ToString());
                    //cirm.JoiningMedicalPath = dsUploadedImages.Tables[0].Select("FilePath")
                    //                                    .Where(e => e.ItemArray[2].ToString().Equals("MedicineAvailableOnBoard")).FirstOrDefault().ToString();
                    cirm.MedicineAvailableOnBoardPath = dsUploadedImages.Tables[0].AsEnumerable()
                                                        .Where(r => r.Field<string>("FileType") == "MedicineAvailableOnBoard")
                                                        .Select(r => r.Field<string>("FilePath")).FirstOrDefault().ToString();
                }
                   
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["MedicalEquipmentOnBoard"].ToString()))
                {
                    cirm.MedicalEquipmentOnBoard = Convert.ToBoolean(ds.Tables[0].Rows[0]["MedicalEquipmentOnBoard"].ToString());
                    //cirm.MedicalEquipmentOnBoardPath = dsUploadedImages.Tables[0].AsEnumerable().Select(r => r.Field<string>("FilePath"))
                    //                                    .Where(e => e.ItemArray[2].ToString().Equals("MedicalEquipmentOnBoard")).FirstOrDefault().ToString();
                    cirm.MedicalEquipmentOnBoardPath = dsUploadedImages.Tables[0].AsEnumerable()
                                                        .Where( r => r.Field<string>("FileType") == "MedicalEquipmentOnBoard")
                                                        .Select(r => r.Field<string>("FilePath")).FirstOrDefault().ToString();
                }
                    
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["MedicalHistoryUpload"].ToString()))
                {
                    cirm.MedicalHistoryUpload = Convert.ToBoolean(ds.Tables[0].Rows[0]["MedicalHistoryUpload"].ToString());
                    //cirm.MedicalHistoryPath = dsUploadedImages.Tables[0].Select("FilePath")
                    //                                    .Where(e => e.ItemArray[2].ToString().Equals("MedicalHistoryUpload")).FirstOrDefault().ToString();
                    cirm.MedicalHistoryPath = dsUploadedImages.Tables[0].AsEnumerable()
                                                        .Where(r => r.Field<string>("FileType") == "MedicalHistoryUpload")
                                                        .Select(r => r.Field<string>("FilePath")).FirstOrDefault().ToString();
                }
                    
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["WorkAndRestHourLatestRecord"].ToString()))
                {
                    cirm.WorkAndRestHourLatestRecord = Convert.ToBoolean(ds.Tables[0].Rows[0]["WorkAndRestHourLatestRecord"].ToString());
                    //cirm.WorkAndRestHourLatestRecordPath = dsUploadedImages.Tables[0].Select("FilePath")
                    //                                    .Where(e => e.ItemArray[2].ToString().Equals("WorkAndRestHourLatestRecord")).FirstOrDefault().ToString();
                    cirm.WorkAndRestHourLatestRecordPath = dsUploadedImages.Tables[0].AsEnumerable()
                                                        .Where(r => r.Field<string>("FileType") == "WorkAndRestHourLatestRecord")
                                                        .Select(r => r.Field<string>("FilePath")).FirstOrDefault().ToString();
                }
                    
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["PreExistingMedicationPrescription"].ToString()))
                    cirm.PreExistingMedicationPrescription = Convert.ToBoolean(ds.Tables[0].Rows[0]["PreExistingMedicationPrescription"].ToString());

                #endregion

                
            }


            return cirm;
        }
        /// <summary>
        /// Added on 7th Jan 2022 @ BK
        /// </summary>
        /// <param name="Id"></param>
        /// <returns></returns>
        public List<VitalStatisticsPOCO> GetVitalStatisticsByCIRM(int Id)
        {
            List<VitalStatisticsPOCO> cirmVitalsList = new List<VitalStatisticsPOCO>();
            

            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetVitalParametersByCIRM", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@CIRMid", Id);
                    con.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    //prodPOList = Common.CommonDAL.ConvertDataTable<ProductPOCO>(ds.Tables[0]);
                    con.Close();
                }
            }
            if(ds.Tables[0].Rows.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    VitalStatisticsPOCO cirmVitals = new VitalStatisticsPOCO();
                    if (ds.Tables[0].Rows[0]["ID"] != null)
                        cirmVitals.ID = Convert.ToInt32(item["ID"].ToString());
                    if (ds.Tables[0].Rows[0]["CIRMId"] != null)
                        cirmVitals.CIRMId = Convert.ToInt32(item["CIRMId"].ToString());
                    if (ds.Tables[0].Rows[0]["ObservationDate"] != null)
                        cirmVitals.ObservationDate = item["ObservationDate"].ToString();
                    if (ds.Tables[0].Rows[0]["ObservationTime"] != null)
                        cirmVitals.ObservationTime = item["ObservationTime"].ToString();
                    if (ds.Tables[0].Rows[0]["Pulse"] != null)
                        cirmVitals.Pulse = item["Pulse"].ToString();
                    if (ds.Tables[0].Rows[0]["RespiratoryRate"] != null)
                        cirmVitals.RespiratoryRate = item["RespiratoryRate"].ToString();
                    if (ds.Tables[0].Rows[0]["OxygenSaturation"] != null)
                        cirmVitals.OxygenSaturation = item["OxygenSaturation"].ToString();
                    if (ds.Tables[0].Rows[0]["Himoglobin"] != null)
                        cirmVitals.Himoglobin = item["Himoglobin"].ToString();
                    if (ds.Tables[0].Rows[0]["Creatinine"] != null)
                        cirmVitals.Creatinine = item["Creatinine"].ToString();
                    if (ds.Tables[0].Rows[0]["Bilirubin"] != null)
                        cirmVitals.Bilirubin = item["Bilirubin"].ToString();
                    if (ds.Tables[0].Rows[0]["Temperature"] != null)
                        cirmVitals.Temperature = item["Temperature"].ToString();
                    if (ds.Tables[0].Rows[0]["Systolic"] != null)
                        cirmVitals.Systolic = item["Systolic"].ToString();
                    if (ds.Tables[0].Rows[0]["Diastolic"] != null)
                        cirmVitals.Diastolic = item["Diastolic"].ToString();
                    if (ds.Tables[0].Rows[0]["Fasting"] != null)
                        cirmVitals.Fasting = item["Fasting"].ToString();
                    if (ds.Tables[0].Rows[0]["Regular"] != null)
                        cirmVitals.Regular = item["Regular"].ToString();

                        
                    cirmVitalsList.Add(cirmVitals);

                }
            }
            else
            {
                VitalStatisticsPOCO cirmVitals = new VitalStatisticsPOCO();
                cirmVitalsList.Add(cirmVitals);
            }

            return cirmVitalsList;
        }

        /// <summary>
        /// Added on 7th Jan 2022 @ BK
        /// </summary>
        /// <param name="Id"></param>
        /// <returns></returns>
        public List<MedicalSymtomologyPOCO> GetMedicalSymtomologyByCIRM(int Id)
        {
            List<MedicalSymtomologyPOCO> cirmSymtomologyList = new List<MedicalSymtomologyPOCO>();

            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetMedicalSymtomologyByCIRM", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@CIRMid", Id);
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
                    MedicalSymtomologyPOCO cirmSymtomology = new MedicalSymtomologyPOCO();
                    if (ds.Tables[0].Rows[0]["ID"] != null)
                        cirmSymtomology.ID = Convert.ToInt32(item["ID"].ToString());
                    if (ds.Tables[0].Rows[0]["CIRMId"] != null)
                        cirmSymtomology.CIRMId = Convert.ToInt32(item["CIRMId"].ToString());
                    if (ds.Tables[0].Rows[0]["ObservationDate"] != null)
                        cirmSymtomology.ObservationDate = item["ObservationDate"].ToString();
                    if (ds.Tables[0].Rows[0]["ObservationTime"] != null)
                        cirmSymtomology.ObservationTime = item["ObservationTime"].ToString();
                    if (ds.Tables[0].Rows[0]["Vomiting"] != null)
                        cirmSymtomology.Vomiting = item["Vomiting"].ToString();
                    if (ds.Tables[0].Rows[0]["FrequencyOfVomiting"] != null)
                        cirmSymtomology.FrequencyOfVomiting = item["FrequencyOfVomiting"].ToString();
                    if (ds.Tables[0].Rows[0]["Fits"] != null)
                        cirmSymtomology.Fits = item["Fits"].ToString();
                    if (ds.Tables[0].Rows[0]["FrequencyOfFits"] != null)
                        cirmSymtomology.FrequencyOfFits = item["FrequencyOfFits"].ToString();
                    if (ds.Tables[0].Rows[0]["Giddiness"] != null)
                        cirmSymtomology.Giddiness = item["Giddiness"].ToString();
                    if (ds.Tables[0].Rows[0]["FrequencyOfGiddiness"] != null)
                        cirmSymtomology.FrequencyOfGiddiness = item["FrequencyOfGiddiness"].ToString();
                    if (ds.Tables[0].Rows[0]["Lethargy"] != null)
                        cirmSymtomology.Lethargy = item["Lethargy"].ToString();
                    if (ds.Tables[0].Rows[0]["FrequencyOfLethargy"] != null)
                        cirmSymtomology.FrequencyOfLethargy = item["FrequencyOfLethargy"].ToString();
                    if (ds.Tables[0].Rows[0]["SymptomatologyDetails"] != null)
                        cirmSymtomology.SymptomologyDetails = item["SymptomatologyDetails"].ToString();
                    if (ds.Tables[0].Rows[0]["MedicinesAdministered"] != null)
                        cirmSymtomology.MedicinesAdministered = item["MedicinesAdministered"].ToString();
                    if (ds.Tables[0].Rows[0]["AnyOtherRelevantInformation"] != null)
                        cirmSymtomology.AnyOtherRelevantInformation = item["AnyOtherRelevantInformation"].ToString();


                    cirmSymtomologyList.Add(cirmSymtomology);
                }
            }
            else
            {
                MedicalSymtomologyPOCO cirmSymtomology = new MedicalSymtomologyPOCO();
                cirmSymtomologyList.Add(cirmSymtomology);
            }
            return cirmSymtomologyList;
        }

        public DataSet GetCIRMUploadedImages(int cirmId)
        {
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetCIRMUploadedImages", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@CIRMid", cirmId);
                    con.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    //prodPOList = Common.CommonDAL.ConvertDataTable<ProductPOCO>(ds.Tables[0]);
                    con.Close();
                }
            }
            return ds;
        }

        /// <summary>
        /// Added on 11th Jan 2022 @BK
        /// </summary>
        /// <param name="vitaPoco"></param>
        /// <returns></returns>
        public int SaveCIRMVitalParams(VitalStatisticsPOCO vitaPoco)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpSaveCIRMVitalParams", con);
            cmd.CommandType = CommandType.StoredProcedure;
            if (vitaPoco.CIRMId > 0)
            {
                cmd.Parameters.AddWithValue("@CIRMId", vitaPoco.CIRMId);
                #region Vital Parameters
                if (!String.IsNullOrEmpty(vitaPoco.ObservationDate.ToString()))
                {
                    cmd.Parameters.AddWithValue("@ObservationDate", vitaPoco.ObservationDate);
                }
                else
                {
                    cmd.Parameters.AddWithValue("@ObservationDate", DBNull.Value);
                }
                if (!String.IsNullOrEmpty(vitaPoco.ObservationTime.ToString()))
                {
                    cmd.Parameters.AddWithValue("@ObservationTime", vitaPoco.ObservationTime);
                }
                else
                {
                    cmd.Parameters.AddWithValue("@ObservationTime", DBNull.Value);
                }
                if (!String.IsNullOrEmpty(vitaPoco.Pulse))
                {
                    cmd.Parameters.AddWithValue("@Pulse", vitaPoco.Pulse.ToString());
                }
                else
                {
                    cmd.Parameters.AddWithValue("@Pulse", DBNull.Value);
                }
                if (!String.IsNullOrEmpty(vitaPoco.OxygenSaturation))
                {
                    cmd.Parameters.AddWithValue("@OxygenSaturation", vitaPoco.OxygenSaturation.ToString());
                }
                else
                {
                    cmd.Parameters.AddWithValue("@OxygenSaturation", DBNull.Value);
                }

                if (!String.IsNullOrEmpty(vitaPoco.RespiratoryRate))
                {
                    cmd.Parameters.AddWithValue("@RespiratoryRate", vitaPoco.RespiratoryRate.ToString());
                }
                else
                {
                    cmd.Parameters.AddWithValue("@RespiratoryRate", DBNull.Value);
                }

                if (!String.IsNullOrEmpty(vitaPoco.Systolic))
                {
                    cmd.Parameters.AddWithValue("@Systolic", vitaPoco.Systolic.ToString());
                }
                else
                {
                    cmd.Parameters.AddWithValue("@Systolic", DBNull.Value);
                }

                if (!String.IsNullOrEmpty(vitaPoco.Diastolic))
                {
                    cmd.Parameters.AddWithValue("@Diastolic", vitaPoco.Diastolic.ToString());
                }
                else
                {
                    cmd.Parameters.AddWithValue("@Diastolic", DBNull.Value);
                }

                if (!String.IsNullOrEmpty(vitaPoco.Temperature))
                {
                    cmd.Parameters.AddWithValue("@Temperature", vitaPoco.Temperature.ToString());
                }
                else
                {
                    cmd.Parameters.AddWithValue("@Temperature", DBNull.Value);
                }
                if (!String.IsNullOrEmpty(vitaPoco.Himoglobin))
                {
                    cmd.Parameters.AddWithValue("@Himoglobin", vitaPoco.Himoglobin.ToString());
                }
                else
                {
                    cmd.Parameters.AddWithValue("@Himoglobin", DBNull.Value);
                }

                if (!String.IsNullOrEmpty(vitaPoco.Creatinine))
                {
                    cmd.Parameters.AddWithValue("@Creatinine", vitaPoco.Creatinine.ToString());
                }
                else
                {
                    cmd.Parameters.AddWithValue("@Creatinine", DBNull.Value);
                }

                if (!String.IsNullOrEmpty(vitaPoco.Bilirubin))
                {
                    cmd.Parameters.AddWithValue("@Bilirubin", vitaPoco.Bilirubin.ToString());
                }
                else
                {
                    cmd.Parameters.AddWithValue("@Bilirubin", DBNull.Value);
                }

                if (!String.IsNullOrEmpty(vitaPoco.Fasting))
                {
                    cmd.Parameters.AddWithValue("@Fasting", vitaPoco.Fasting.ToString());
                }
                else
                {
                    cmd.Parameters.AddWithValue("@Fasting", DBNull.Value);
                }
                if (!String.IsNullOrEmpty(vitaPoco.Regular))
                {
                    cmd.Parameters.AddWithValue("@Regular", vitaPoco.Regular.ToString());
                }
                else
                {
                    cmd.Parameters.AddWithValue("@Regular", DBNull.Value);
                }



                #endregion

                int recordsAffected = cmd.ExecuteNonQuery();
                con.Close();

                return recordsAffected;
            }
            else
                return 0;
        }
        /// <summary>
        /// Added on 11th Jan 2022 @BK
        /// </summary>
        /// <param name="symPoco"></param>
        /// <returns></returns>
        public int SaveCIRMSymtomology(MedicalSymtomologyPOCO symPoco)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpSaveCIRMSymtomology", con);
            cmd.CommandType = CommandType.StoredProcedure;
            if (symPoco.CIRMId > 0)
            {
                cmd.Parameters.AddWithValue("@CIRMId", symPoco.CIRMId);
                #region Symtomology
                if (!String.IsNullOrEmpty(symPoco.ObservationDate.ToString()))
                {
                    cmd.Parameters.AddWithValue("@SymptomatologyDate", symPoco.ObservationDate.ToString());
                }
                else
                {
                    cmd.Parameters.AddWithValue("@SymptomatologyDate", DBNull.Value);
                }

                if (!String.IsNullOrEmpty(symPoco.ObservationTime.ToString()))
                {
                    cmd.Parameters.AddWithValue("@SymptomatologyTime", symPoco.ObservationTime.ToString());
                }
                else
                {
                    cmd.Parameters.AddWithValue("@SymptomatologyTime", DBNull.Value);
                }

                if (!String.IsNullOrEmpty(symPoco.Vomiting))
                {
                    cmd.Parameters.AddWithValue("@Vomiting", symPoco.Vomiting.ToString());
                }
                else
                {
                    cmd.Parameters.AddWithValue("@Vomiting", DBNull.Value);
                }

                if (!String.IsNullOrEmpty(symPoco.FrequencyOfVomiting))
                {
                    cmd.Parameters.AddWithValue("@FrequencyOfVomiting", symPoco.FrequencyOfVomiting.ToString());
                }
                else
                {
                    cmd.Parameters.AddWithValue("@FrequencyOfVomiting", DBNull.Value);
                }

                if (!String.IsNullOrEmpty(symPoco.Fits))
                {
                    cmd.Parameters.AddWithValue("@Fits", symPoco.Fits.ToString());
                }
                else
                {
                    cmd.Parameters.AddWithValue("@Fits", DBNull.Value);
                }

                if (!String.IsNullOrEmpty(symPoco.FrequencyOfFits))
                {
                    cmd.Parameters.AddWithValue("@FrequencyOfFits", symPoco.FrequencyOfFits.ToString());
                }
                else
                {
                    cmd.Parameters.AddWithValue("@FrequencyOfFits", DBNull.Value);
                }

                if (!String.IsNullOrEmpty(symPoco.Giddiness))
                {
                    cmd.Parameters.AddWithValue("@Giddiness", symPoco.Giddiness.ToString());
                }
                else
                {
                    cmd.Parameters.AddWithValue("@Giddiness", DBNull.Value);
                }

                if (!String.IsNullOrEmpty(symPoco.FrequencyOfGiddiness))
                {
                    cmd.Parameters.AddWithValue("@FrequencyOfGiddiness", symPoco.FrequencyOfGiddiness.ToString());
                }
                else
                {
                    cmd.Parameters.AddWithValue("@FrequencyOfGiddiness", DBNull.Value);
                }
                if (!String.IsNullOrEmpty(symPoco.Lethargy))
                {
                    cmd.Parameters.AddWithValue("@Lethargy", symPoco.Lethargy.ToString());
                }
                else
                {
                    cmd.Parameters.AddWithValue("@Lethargy", DBNull.Value);
                }

                if (!String.IsNullOrEmpty(symPoco.FrequencyOfLethargy))
                {
                    cmd.Parameters.AddWithValue("@FrequencyOfLethargy", symPoco.FrequencyOfLethargy.ToString());
                }
                else
                {
                    cmd.Parameters.AddWithValue("@FrequencyOfLethargy", DBNull.Value);
                }

                if (!String.IsNullOrEmpty(symPoco.SymptomologyDetails))
                {
                    cmd.Parameters.AddWithValue("@SymptomatologyDetails", symPoco.SymptomologyDetails.ToString());
                }
                else
                {
                    cmd.Parameters.AddWithValue("@SymptomatologyDetails", DBNull.Value);
                }

                if (!String.IsNullOrEmpty(symPoco.MedicinesAdministered))
                {
                    cmd.Parameters.AddWithValue("@MedicinesAdministered", symPoco.MedicinesAdministered.ToString());
                }
                else
                {
                    cmd.Parameters.AddWithValue("@MedicinesAdministered", DBNull.Value);
                }

                if (!String.IsNullOrEmpty(symPoco.AnyOtherRelevantInformation))
                {
                    cmd.Parameters.AddWithValue("@RelevantInformationForDesease", symPoco.AnyOtherRelevantInformation.ToString());
                }
                else
                {
                    cmd.Parameters.AddWithValue("@RelevantInformationForDesease", DBNull.Value);
                }

                #endregion

                int recordsAffected = cmd.ExecuteNonQuery();
                con.Close();

                return recordsAffected;
            }
            else
                return 0;
        }

        public List<VitalStatisticsPOCO> GetAllCIRMVitalParamsPageWise(int pageIndex, ref int recordCount, int length, int cirmId)
        {
            List<VitalStatisticsPOCO> vitaPoList = new List<VitalStatisticsPOCO>();

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetAllCIRMVitalParamsPageWise", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
                    cmd.Parameters.AddWithValue("@PageSize", length);
                    cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4);
                    cmd.Parameters["@RecordCount"].Direction = ParameterDirection.Output;
                    cmd.Parameters.AddWithValue("@CIRMid", cirmId);
                    con.Open();

                    DataSet ds = new DataSet();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        vitaPoList.Add(new VitalStatisticsPOCO
                        {
                            ID = Convert.ToInt32(dr["ID"]),
                            CIRMId = Convert.ToInt32(dr["CIRMId"]),
                            ObservationDate = Convert.ToString(dr["ObservationDate"]),
                            ObservationTime = Convert.ToString(dr["ObservationTime"]),
                            Pulse = Convert.ToString(dr["Pulse"]),
                            RespiratoryRate = Convert.ToString(dr["RespiratoryRate"]),
                            OxygenSaturation = Convert.ToString(dr["OxygenSaturation"]),
                            Himoglobin = Convert.ToString(dr["Himoglobin"]),
                            Creatinine = Convert.ToString(dr["Creatinine"]),
                            Bilirubin = Convert.ToString(dr["Bilirubin"]),
                            Temperature = Convert.ToString(dr["Temperature"]),
                            Systolic = Convert.ToString(dr["Systolic"]),
                            Diastolic = Convert.ToString(dr["Diastolic"]),
                            Fasting = Convert.ToString(dr["Fasting"]),
                            Regular = Convert.ToString(dr["Regular"] )

                        });
                    }
                    recordCount = Convert.ToInt32(cmd.Parameters["@RecordCount"].Value);
                    con.Close();
                }
            }
            return vitaPoList;
        }

        public List<MedicalSymtomologyPOCO> GetAllCIRMSymtomologyPageWise(int pageIndex, ref int recordCount, int length, int cirmId)
        {
            List<MedicalSymtomologyPOCO> symPoList = new List<MedicalSymtomologyPOCO>();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetAllCIRMSymtomologyPageWise", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
                    cmd.Parameters.AddWithValue("@PageSize", length);
                    cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4);
                    cmd.Parameters["@RecordCount"].Direction = ParameterDirection.Output;
                    cmd.Parameters.AddWithValue("@CIRMid", cirmId);
                    con.Open();

                    DataSet ds = new DataSet();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        symPoList.Add(new MedicalSymtomologyPOCO
                        {
                            ID = Convert.ToInt32(dr["ID"]),
                            CIRMId = Convert.ToInt32(dr["CIRMId"]),
                            ObservationDate = Convert.ToString(dr["ObservationDate"]),
                            ObservationTime = Convert.ToString(dr["ObservationTime"]),
                            Vomiting = Convert.ToString(dr["Vomiting"]),
                            FrequencyOfVomiting = Convert.ToString(dr["FrequencyOfVomiting"]),
                            Fits = Convert.ToString(dr["Fits"]),
                            FrequencyOfFits = Convert.ToString(dr["FrequencyOfFits"]),
                            Giddiness = Convert.ToString(dr["Giddiness"]),
                            FrequencyOfGiddiness = Convert.ToString(dr["FrequencyOfGiddiness"]),
                            Lethargy = Convert.ToString(dr["Lethargy"]),
                            FrequencyOfLethargy = Convert.ToString(dr["FrequencyOfLethargy"]),
                            SymptomologyDetails = Convert.ToString(dr["SymptomatologyDetails"]),
                            MedicinesAdministered = Convert.ToString(dr["MedicinesAdministered"]),
                            AnyOtherRelevantInformation = Convert.ToString(dr["AnyOtherRelevantInformation"])

                        });
                    }
                    recordCount = Convert.ToInt32(cmd.Parameters["@RecordCount"].Value);
                    con.Close();
                }
            }
            return symPoList;
        }


    }
}
