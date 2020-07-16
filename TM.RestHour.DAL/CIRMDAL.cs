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

            if (!String.IsNullOrEmpty(cIRM.Pulse))
            {
                cmd.Parameters.AddWithValue("@Pulse", cIRM.Pulse.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@Pulse", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.OxygenSaturation))
            {
                cmd.Parameters.AddWithValue("@OxygenSaturation", cIRM.OxygenSaturation.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@OxygenSaturation", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.RespiratoryRate))
            {
                cmd.Parameters.AddWithValue("@RespiratoryRate", cIRM.RespiratoryRate.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@RespiratoryRate", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.Systolic))
            {
                cmd.Parameters.AddWithValue("@Systolic", cIRM.Systolic.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@Systolic", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.Diastolic))
            {
                cmd.Parameters.AddWithValue("@Diastolic", cIRM.Diastolic.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@Diastolic", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.SymptomatologyDate))
            {
                cmd.Parameters.AddWithValue("@SymptomatologyDate", cIRM.SymptomatologyDate.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@SymptomatologyDate", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.SymptomatologyTime))
            {
                cmd.Parameters.AddWithValue("@SymptomatologyTime", cIRM.SymptomatologyTime.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@SymptomatologyTime", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.Vomiting))
            {
                cmd.Parameters.AddWithValue("@Vomiting", cIRM.Vomiting.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@Vomiting", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.FrequencyOfVomiting))
            {
                cmd.Parameters.AddWithValue("@FrequencyOfVomiting", cIRM.FrequencyOfVomiting.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@FrequencyOfVomiting", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.Fits))
            {
                cmd.Parameters.AddWithValue("@Fits", cIRM.Fits.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@Fits", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.FrequencyOfFits))
            {
                cmd.Parameters.AddWithValue("@FrequencyOfFits", cIRM.FrequencyOfFits.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@FrequencyOfFits", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.SymptomatologyDetails))
            {
                cmd.Parameters.AddWithValue("@SymptomatologyDetails", cIRM.SymptomatologyDetails.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@SymptomatologyDetails", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.MedicinesAdministered))
            {
                cmd.Parameters.AddWithValue("@MedicinesAdministered", cIRM.MedicinesAdministered.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@MedicinesAdministered", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.RelevantInformationForDesease))
            {
                cmd.Parameters.AddWithValue("@RelevantInformationForDesease", cIRM.RelevantInformationForDesease.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@RelevantInformationForDesease", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.WhereAndHowAccidentOccured))
            {
                cmd.Parameters.AddWithValue("@WhereAndHowAccidentOccured", cIRM.WhereAndHowAccidentOccured.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@WhereAndHowAccidentOccured", DBNull.Value);
            }

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

            if (cIRM.JoiningMedical.HasValue)
            {
                cmd.Parameters.AddWithValue("@JoiningMedical", cIRM.JoiningMedical);
            }
            else
            {
                cmd.Parameters.AddWithValue("@JoiningMedical", DBNull.Value);
            }

            if (cIRM.MedicineAvailableOnBoard.HasValue)
            {
                cmd.Parameters.AddWithValue("@MedicineAvailableOnBoard", cIRM.MedicineAvailableOnBoard);
            }
            else
            {
                cmd.Parameters.AddWithValue("@MedicineAvailableOnBoard", DBNull.Value);
            }

            if (cIRM.MedicalEquipmentOnBoard.HasValue)
            {
                cmd.Parameters.AddWithValue("@MedicalEquipmentOnBoard", cIRM.MedicalEquipmentOnBoard);
            }
            else
            {
                cmd.Parameters.AddWithValue("@MedicalEquipmentOnBoard", DBNull.Value);
            }

            if (cIRM.MedicalHistoryUpload.HasValue)
            {
                cmd.Parameters.AddWithValue("@MedicalHistoryUpload", cIRM.MedicalHistoryUpload);
            }
            else
            {
                cmd.Parameters.AddWithValue("@MedicalHistoryUpload", DBNull.Value);
            }

            if (cIRM.WorkAndRestHourLatestRecord.HasValue)
            {
                cmd.Parameters.AddWithValue("@WorkAndRestHourLatestRecord", cIRM.WorkAndRestHourLatestRecord);
            }
            else
            {
                cmd.Parameters.AddWithValue("@WorkAndRestHourLatestRecord", DBNull.Value);
            }

            if (cIRM.PreExistingMedicationPrescription.HasValue)
            {
                cmd.Parameters.AddWithValue("@PreExistingMedicationPrescription", cIRM.PreExistingMedicationPrescription);
            }
            else
            {
                cmd.Parameters.AddWithValue("@PreExistingMedicationPrescription", DBNull.Value);
            }




            if (!String.IsNullOrEmpty(cIRM.LocationAndTypeOfInjuryOrBurn))
            {
                cmd.Parameters.AddWithValue("@LocationAndTypeOfInjuryOrBurn", cIRM.LocationAndTypeOfInjuryOrBurn.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@LocationAndTypeOfInjuryOrBurn", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.FrequencyOfPain))
            {
                cmd.Parameters.AddWithValue("@FrequencyOfPain", cIRM.FrequencyOfPain.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@FrequencyOfPain", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.PictureUploadPath))
            {
                cmd.Parameters.AddWithValue("@PictureUploadPath", cIRM.PictureUploadPath.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@PictureUploadPath", DBNull.Value);
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

            //cmd.Parameters.AddWithValue("@IsEquipmentUploaded", cIRM.IsEquipmentUploaded);

            cmd.Parameters.AddWithValue("@VesselID", VesselID);


            if (cIRM.CIRMId > 0)
            {
                cmd.Parameters.AddWithValue("@CIRMId", cIRM.CIRMId);
            }
            else
            {
                cmd.Parameters.AddWithValue("@CIRMId", DBNull.Value);
            }
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

                    crewtimesheetList.Add(crewtimesheet);
                }
            }
            return crewtimesheetList;
        }

    }
}
