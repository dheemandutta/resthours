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

        #region Save Methods
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
            cmd.Parameters.AddWithValue("@MedicalAssistanceType", cIRM.MedicalAssitanceType.ToString());

            #region Vessel Details 4
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

            if (!String.IsNullOrEmpty(cIRM.Weather))
            {
                cmd.Parameters.AddWithValue("@Weather", cIRM.Weather.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@Weather", DBNull.Value);
            }


            #endregion

            #region Voyage Details

            if (!String.IsNullOrEmpty(cIRM.DateOfReportingGMT.ToString()))
            {
                cmd.Parameters.AddWithValue("@DateOfReportingGMT", cIRM.DateOfReportingGMT);
            }
            else
            {
                cmd.Parameters.AddWithValue("@DateOfReportingGMT", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(cIRM.TimeOfReportingGMT.ToString()))
            {
                cmd.Parameters.AddWithValue("@TimeOfReportingGMT", cIRM.TimeOfReportingGMT);
            }
            else
            {
                cmd.Parameters.AddWithValue("@TimeOfReportingGMT", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.LocationOfShip))
            {
                cmd.Parameters.AddWithValue("@LocationOfShip", cIRM.LocationOfShip.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@LocationOfShip", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.Cousre))
            {
                cmd.Parameters.AddWithValue("@Cousre", cIRM.Cousre.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@Cousre", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(cIRM.Speed))
            {
                cmd.Parameters.AddWithValue("@Speed", cIRM.Speed.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@Speed", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.PortofDeparture))
            {
                cmd.Parameters.AddWithValue("@PortofDeparture", cIRM.PortofDeparture.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@PortofDeparture", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.DateOfDeparture))
            {
                cmd.Parameters.AddWithValue("@DateOfDeparture", cIRM.DateOfDeparture.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@DateOfDeparture", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.TimeOfDeparture))
            {
                cmd.Parameters.AddWithValue("@TimeOfDeparture", cIRM.TimeOfDeparture.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@TimeOfDeparture", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.PortofDestination))
            {
                cmd.Parameters.AddWithValue("@PortofDestination", cIRM.PortofDestination.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@PortofDestination", DBNull.Value);
            }


            if (!String.IsNullOrEmpty(cIRM.ETADateGMT))
            {
                cmd.Parameters.AddWithValue("@ETADateGMT", cIRM.ETADateGMT.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@ETADateGMT", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.ETATimeGMT))
            {
                cmd.Parameters.AddWithValue("@ETATimeGMT", cIRM.ETATimeGMT.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@ETATimeGMT", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.EstimatedTimeOfarrivalhrs))
            {
                cmd.Parameters.AddWithValue("@EstimatedTimeOfarrivalhrs", cIRM.EstimatedTimeOfarrivalhrs.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@EstimatedTimeOfarrivalhrs", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.AgentDetails))
            {
                cmd.Parameters.AddWithValue("@AgentDetails", cIRM.AgentDetails.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@AgentDetails", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.NearestPort))
            {
                cmd.Parameters.AddWithValue("@NearestPort", cIRM.NearestPort.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@NearestPort", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.NearestPortETADateGMT))
            {
                cmd.Parameters.AddWithValue("@NearestPortETADateGMT", cIRM.NearestPortETADateGMT.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@NearestPortETADateGMT", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.NearestPortETATimeGMT))
            {
                cmd.Parameters.AddWithValue("@NearestPortETATimeGMT", cIRM.NearestPortETATimeGMT.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@NearestPortETATimeGMT", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.OtherPossiblePort))
            {
                cmd.Parameters.AddWithValue("@OtherPossiblePort", cIRM.OtherPossiblePort.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@OtherPossiblePort", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(cIRM.OtherPortETADateGMT))
            {
                cmd.Parameters.AddWithValue("@OtherPortETADateGMT", cIRM.OtherPortETADateGMT.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@OtherPortETADateGMT", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.OtherPortETATimeGMT))
            {
                cmd.Parameters.AddWithValue("@OtherPortETATimeGMT", cIRM.OtherPortETATimeGMT.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@OtherPortETATimeGMT", DBNull.Value);
            }

            #endregion


            #region Weather Details

            if (!String.IsNullOrEmpty(cIRM.WindDirection))
            {
                cmd.Parameters.AddWithValue("@WindDirection", cIRM.WindDirection.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@WindDirection", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.BeaufortScale))
            {
                cmd.Parameters.AddWithValue("@BeaufortScale", cIRM.BeaufortScale.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@BeaufortScale", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.WindSpeed))
            {
                cmd.Parameters.AddWithValue("@WindSpeed", cIRM.WindSpeed.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@WindSpeed", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.SeaState))
            {
                cmd.Parameters.AddWithValue("@SeaState", cIRM.SeaState.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@SeaState", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.WaveHeight))
            {
                cmd.Parameters.AddWithValue("@WaveHeight", cIRM.WaveHeight.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@WaveHeight", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.Swell))
            {
                cmd.Parameters.AddWithValue("@Swell", cIRM.Swell.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@Swell", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.WeatherCondition))
            {
                cmd.Parameters.AddWithValue("@WeatherCondition", cIRM.WeatherCondition.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@WeatherCondition", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.WeatherVisibility))
            {
                cmd.Parameters.AddWithValue("@WeatherVisibility", cIRM.WeatherVisibility.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@WeatherVisibility", DBNull.Value);
            }



            #endregion

            #region Crew Details 9
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

            #region Other Part 1 (2)
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

            #region Vital Parameters 13
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

            #region Symtomology 13
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

            #region Past Medical History 6
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

            #region Other Part 2 (6)
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

            #region Other Part 3 Severity of Pain /Hurt 1
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
                cmd.Parameters.AddWithValue("@SeverityOfPain", cIRM.SeverityOfPain);
            }
            else
            {
                cmd.Parameters.AddWithValue("@SeverityOfPain", DBNull.Value);
            }

            #endregion

            #region Other Part 4 Upload 12
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

        public int SaveCIRMNew(CIRMPOCO cIRM, int VesselID)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpSaveCIRMNew", con);
            cmd.CommandType = CommandType.StoredProcedure;

            if (cIRM.CIRMId > 0)
            {
                cmd.Parameters.AddWithValue("@CIRMId", cIRM.CIRMId);
            }
            else
            {
                cmd.Parameters.AddWithValue("@CIRMId", DBNull.Value);
            }
            cmd.Parameters.AddWithValue("@MedicalAssistanceType", cIRM.MedicalAssitanceType.ToString());

            #region Vessel Details 4
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

            if (!String.IsNullOrEmpty(cIRM.Weather))
            {
                cmd.Parameters.AddWithValue("@Weather", cIRM.Weather.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@Weather", DBNull.Value);
            }


            #endregion

            #region Voyage Details 19

            if (!String.IsNullOrEmpty(cIRM.DateOfReportingGMT))
            {
                cmd.Parameters.AddWithValue("@DateOfReportingGMT", cIRM.DateOfReportingGMT);
            }
            else
            {
                cmd.Parameters.AddWithValue("@DateOfReportingGMT", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(cIRM.TimeOfReportingGMT))
            {
                cmd.Parameters.AddWithValue("@TimeOfReportingGMT", cIRM.TimeOfReportingGMT);
            }
            else
            {
                cmd.Parameters.AddWithValue("@TimeOfReportingGMT", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.LocationOfShip))
            {
                cmd.Parameters.AddWithValue("@LocationOfShip", cIRM.LocationOfShip.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@LocationOfShip", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.Cousre))
            {
                cmd.Parameters.AddWithValue("@Cousre", cIRM.Cousre.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@Cousre", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(cIRM.Speed))
            {
                cmd.Parameters.AddWithValue("@Speed", cIRM.Speed.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@Speed", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.PortofDeparture))
            {
                cmd.Parameters.AddWithValue("@PortofDeparture", cIRM.PortofDeparture.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@PortofDeparture", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.DateOfDeparture))
            {
                cmd.Parameters.AddWithValue("@DateOfDeparture", cIRM.DateOfDeparture.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@DateOfDeparture", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.TimeOfDeparture))
            {
                cmd.Parameters.AddWithValue("@TimeOfDeparture", cIRM.TimeOfDeparture.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@TimeOfDeparture", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.PortofDestination))
            {
                cmd.Parameters.AddWithValue("@PortofDestination", cIRM.PortofDestination.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@PortofDestination", DBNull.Value);
            }


            if (!String.IsNullOrEmpty(cIRM.ETADateGMT))
            {
                cmd.Parameters.AddWithValue("@ETADateGMT", cIRM.ETADateGMT.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@ETADateGMT", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.ETATimeGMT))
            {
                cmd.Parameters.AddWithValue("@ETATimeGMT", cIRM.ETATimeGMT.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@ETATimeGMT", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.EstimatedTimeOfarrivalhrs))
            {
                cmd.Parameters.AddWithValue("@EstimatedTimeOfarrivalhrs", cIRM.EstimatedTimeOfarrivalhrs.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@EstimatedTimeOfarrivalhrs", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.AgentDetails))
            {
                cmd.Parameters.AddWithValue("@AgentDetails", cIRM.AgentDetails.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@AgentDetails", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.NearestPort))
            {
                cmd.Parameters.AddWithValue("@NearestPort", cIRM.NearestPort.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@NearestPort", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.NearestPortETADateGMT))
            {
                cmd.Parameters.AddWithValue("@NearestPortETADateGMT", cIRM.NearestPortETADateGMT.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@NearestPortETADateGMT", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.NearestPortETATimeGMT))
            {
                cmd.Parameters.AddWithValue("@NearestPortETATimeGMT", cIRM.NearestPortETATimeGMT.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@NearestPortETATimeGMT", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.OtherPossiblePort))
            {
                cmd.Parameters.AddWithValue("@OtherPossiblePort", cIRM.OtherPossiblePort.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@OtherPossiblePort", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(cIRM.OtherPortETADateGMT))
            {
                cmd.Parameters.AddWithValue("@OtherPortETADateGMT", cIRM.OtherPortETADateGMT.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@OtherPortETADateGMT", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.OtherPortETATimeGMT))
            {
                cmd.Parameters.AddWithValue("@OtherPortETATimeGMT", cIRM.OtherPortETATimeGMT.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@OtherPortETATimeGMT", DBNull.Value);
            }

            #endregion


            #region Weather Details 8+1

            if (!String.IsNullOrEmpty(cIRM.WindDirection))
            {
                cmd.Parameters.AddWithValue("@WindDirection", cIRM.WindDirection.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@WindDirection", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.BeaufortScale))
            {
                cmd.Parameters.AddWithValue("@BeaufortScale", cIRM.BeaufortScale.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@BeaufortScale", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.WindSpeed))
            {
                cmd.Parameters.AddWithValue("@WindSpeed", cIRM.WindSpeed.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@WindSpeed", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.SeaState))
            {
                cmd.Parameters.AddWithValue("@SeaState", cIRM.SeaState.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@SeaState", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.WaveHeight))
            {
                cmd.Parameters.AddWithValue("@WaveHeight", cIRM.WaveHeight.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@WaveHeight", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.Swell))
            {
                cmd.Parameters.AddWithValue("@Swell", cIRM.Swell.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@Swell", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.WeatherCondition))
            {
                cmd.Parameters.AddWithValue("@WeatherCondition", cIRM.WeatherCondition.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@WeatherCondition", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.WeatherVisibility))
            {
                cmd.Parameters.AddWithValue("@WeatherVisibility", cIRM.WeatherVisibility.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@WeatherVisibility", DBNull.Value);
            }



            #endregion

            #region Crew Details 13
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


            if (!String.IsNullOrEmpty(cIRM.DateOfOffWork))
            {
                cmd.Parameters.AddWithValue("@DateOfOffWork", cIRM.DateOfOffWork);
            }
            else
            {
                cmd.Parameters.AddWithValue("@DateOfOffWork", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(cIRM.TimeOfOffWork.ToString()))
            {
                cmd.Parameters.AddWithValue("@TimeOfOffWork", cIRM.TimeOfOffWork);
            }
            else
            {
                cmd.Parameters.AddWithValue("@TimeOfOffWork", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(cIRM.DateOfResumeWork.ToString()))
            {
                cmd.Parameters.AddWithValue("@DateOfResumeWork", cIRM.DateOfResumeWork);
            }
            else
            {
                cmd.Parameters.AddWithValue("@DateOfResumeWork", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(cIRM.TimeOfResumeWork.ToString()))
            {
                cmd.Parameters.AddWithValue("@TimeOfResumeWork", cIRM.TimeOfResumeWork);
            }
            else
            {
                cmd.Parameters.AddWithValue("@TimeOfResumeWork", DBNull.Value);
            }
            #endregion

            #region Accident or Illness 9+8+13

            if (!String.IsNullOrEmpty(cIRM.DateOfInjuryOrIllness))
            {
                cmd.Parameters.AddWithValue("@DateOfInjuryOrIllness", cIRM.DateOfInjuryOrIllness);
            }
            else
            {
                cmd.Parameters.AddWithValue("@DateOfInjuryOrIllness", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(cIRM.TimeOfInjuryOrIllness))
            {
                cmd.Parameters.AddWithValue("@TimeOfInjuryOrIllness", cIRM.TimeOfInjuryOrIllness);
            }
            else
            {
                cmd.Parameters.AddWithValue("@TimeOfInjuryOrIllness", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(cIRM.DateOfFirstExamination))
            {
                cmd.Parameters.AddWithValue("@DateOfFirstExamination", cIRM.DateOfFirstExamination);
            }
            else
            {
                cmd.Parameters.AddWithValue("@DateOfFirstExamination", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(cIRM.TimeOfFirstExamination))
            {
                cmd.Parameters.AddWithValue("@TimeOfFirstExamination", cIRM.TimeOfFirstExamination);
            }
            else
            {
                cmd.Parameters.AddWithValue("@TimeOfFirstExamination", DBNull.Value);
            }


            if (!String.IsNullOrEmpty(cIRM.IsInjuryorIllnessWorkRelated))
            {
                cmd.Parameters.AddWithValue("@IsInjuryorIllnessWorkRelated", cIRM.IsInjuryorIllnessWorkRelated);
            }
            else
            {
                cmd.Parameters.AddWithValue("@IsInjuryorIllnessWorkRelated", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(cIRM.IsUnconsciousByInjuryOrIllness))
            {
                cmd.Parameters.AddWithValue("@IsUnconsciousByInjuryOrIllness", cIRM.IsUnconsciousByInjuryOrIllness);
            }
            else
            {
                cmd.Parameters.AddWithValue("@IsUnconsciousByInjuryOrIllness", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(cIRM.HowLongWasUnconscious))
            {
                cmd.Parameters.AddWithValue("@HowLongWasUnconscious", cIRM.HowLongWasUnconscious);
            }
            else
            {
                cmd.Parameters.AddWithValue("@HowLongWasUnconscious", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(cIRM.LevelOfConsciousness.ToString()))
            {
                cmd.Parameters.AddWithValue("@LevelOfConsciousness", cIRM.LevelOfConsciousness);
            }
            else
            {
                cmd.Parameters.AddWithValue("@LevelOfConsciousness", DBNull.Value);
            }

            cmd.Parameters.AddWithValue("@IsAccidentOrIlness", cIRM.IsAccidentOrIlness);

            #region Accident 7+1

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
            if (!String.IsNullOrEmpty(cIRM.FirstAidGiven))
            {
                cmd.Parameters.AddWithValue("@FirstAidGiven", cIRM.FirstAidGiven.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@FirstAidGiven", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(cIRM.FrequencyOfPain))
            {
                cmd.Parameters.AddWithValue("@FrequencyOfPain", cIRM.FrequencyOfPain.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@FrequencyOfPain", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(cIRM.TypeOfBurn))
            {
                cmd.Parameters.AddWithValue("@TypeOfBurn", cIRM.TypeOfBurn.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@TypeOfBurn", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.DegreeOfBurn))
            {
                cmd.Parameters.AddWithValue("@DegreeOfBurn", cIRM.DegreeOfBurn.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@DegreeOfBurn", DBNull.Value);
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

            #region Illness 14
            #region Symtomology 14
            if (!String.IsNullOrEmpty(cIRM.MedicalSymtomology.ObservationDate))
            {
                cmd.Parameters.AddWithValue("@SymptomatologyDate", cIRM.MedicalSymtomology.ObservationDate.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@SymptomatologyDate", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.MedicalSymtomology.ObservationTime))
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

            if (!String.IsNullOrEmpty(cIRM.MedicalSymtomology.Ailment))
            {
                cmd.Parameters.AddWithValue("@Ailment", cIRM.MedicalSymtomology.Ailment.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@Ailment", DBNull.Value);
            }

            #endregion

            #endregion

            #region Other Part 3 Severity of Pain /Hurt 1


            if (cIRM.SeverityOfPain > 0)
            {
                cmd.Parameters.AddWithValue("@SeverityOfPain", cIRM.SeverityOfPain);
            }
            else
            {
                cmd.Parameters.AddWithValue("@SeverityOfPain", DBNull.Value);
            }

            #endregion
            #endregion


            #region History and Medication Taken (1)

            if (!String.IsNullOrEmpty(cIRM.PastMedicalHistory))
            {
                cmd.Parameters.AddWithValue("@PastMedicalHistory", cIRM.PastMedicalHistory.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@PastMedicalHistory", DBNull.Value);
            }

            //Need to be add more Params--------------
            DataTable medicationTable = CreateCIRMMedicationTakenTable();
            foreach (CIRMMedicationTakenPOCO mtPoco in cIRM.MedicationTakenList)
            {
                medicationTable.Rows.Add(mtPoco.MedicationId, mtPoco.CIRMId, mtPoco.PrescriptionName, mtPoco.MedicalConditionBeingTreated, mtPoco.HowOftenMedicationTaken);
            }

            cmd.Parameters.AddWithValue("@MedicationTaken", medicationTable);

            #endregion

            #region Vital Parameters (13)
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

            #region Affected Findings

            if (!String.IsNullOrEmpty(cIRM.AffectedParts))
            {
                cmd.Parameters.AddWithValue("@AffectedParts", cIRM.AffectedParts);
            }
            else
            {
                cmd.Parameters.AddWithValue("@AffectedParts", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(cIRM.BloodType))
            {
                cmd.Parameters.AddWithValue("@BloodType", cIRM.BloodType);
            }
            else
            {
                cmd.Parameters.AddWithValue("@BloodType", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(cIRM.BloodQuantity))
            {
                cmd.Parameters.AddWithValue("@BloodQuantity", cIRM.BloodQuantity);
            }
            else
            {
                cmd.Parameters.AddWithValue("@BloodQuantity", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(cIRM.FluidType))
            {
                cmd.Parameters.AddWithValue("@FluidType", cIRM.FluidType);
            }
            else
            {
                cmd.Parameters.AddWithValue("@FluidType", DBNull.Value);
            }


            if (!String.IsNullOrEmpty(cIRM.FluidQuantity))
            {
                cmd.Parameters.AddWithValue("@FluidQuantity", cIRM.FluidQuantity);
            }
            else
            {
                cmd.Parameters.AddWithValue("@FluidQuantity", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(cIRM.SkinDetails))
            {
                cmd.Parameters.AddWithValue("@SkinDetails", cIRM.SkinDetails);
            }
            else
            {
                cmd.Parameters.AddWithValue("@SkinDetails", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(cIRM.PupilsDetails))
            {
                cmd.Parameters.AddWithValue("@PupilsDetails", cIRM.PupilsDetails);
            }
            else
            {
                cmd.Parameters.AddWithValue("@PupilsDetails", DBNull.Value);
            }


            #endregion


            #region Tele-medical Consultation
            if (!String.IsNullOrEmpty(cIRM.TeleMedicalConsultation.ToString()))
            {
                cmd.Parameters.AddWithValue("@TeleMedicalConsultation", cIRM.TeleMedicalConsultation);
            }
            else
            {
                cmd.Parameters.AddWithValue("@TeleMedicalConsultation", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(cIRM.TeleMedicalContactDate))
            {
                cmd.Parameters.AddWithValue("@TeleMedicalContactDate", cIRM.TeleMedicalContactDate);
            }
            else
            {
                cmd.Parameters.AddWithValue("@TeleMedicalContactDate", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(cIRM.TeleMedicalContactTime))
            {
                cmd.Parameters.AddWithValue("@TeleMedicalContactTime", cIRM.TeleMedicalContactTime);
            }
            else
            {
                cmd.Parameters.AddWithValue("@TeleMedicalContactTime", DBNull.Value);
            }


            if (!String.IsNullOrEmpty(cIRM.ModeOfCommunication))
            {
                cmd.Parameters.AddWithValue("@ModeOfCommunication", cIRM.ModeOfCommunication);
            }
            else
            {
                cmd.Parameters.AddWithValue("@ModeOfCommunication", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(cIRM.NameOfTelemedicalConsultant))
            {
                cmd.Parameters.AddWithValue("@NameOfTelemedicalConsultant", cIRM.NameOfTelemedicalConsultant);
            }
            else
            {
                cmd.Parameters.AddWithValue("@NameOfTelemedicalConsultant", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(cIRM.DetailsOfTreatmentAdvised))
            {
                cmd.Parameters.AddWithValue("@DetailsOfTreatmentAdvised", cIRM.DetailsOfTreatmentAdvised);
            }
            else
            {
                cmd.Parameters.AddWithValue("@DetailsOfTreatmentAdvised", DBNull.Value);
            }

            #endregion


            #region Medical Treatment Given On board
            if (!String.IsNullOrEmpty(cIRM.MedicalTreatmentGivenOnboard.ToString()))
            {
                cmd.Parameters.AddWithValue("@MedicalTreatmentGivenOnboard", cIRM.MedicalTreatmentGivenOnboard);
            }
            else
            {
                cmd.Parameters.AddWithValue("@MedicalTreatmentGivenOnboard", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(cIRM.PriorRadioMedicalAdvice))
            {
                cmd.Parameters.AddWithValue("@PriorRadioMedicalAdvice", cIRM.PriorRadioMedicalAdvice);
            }
            else
            {
                cmd.Parameters.AddWithValue("@PriorRadioMedicalAdvice", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(cIRM.AfterRadioMedicalAdvice))
            {
                cmd.Parameters.AddWithValue("@AfterRadioMedicalAdvice", cIRM.AfterRadioMedicalAdvice);
            }
            else
            {
                cmd.Parameters.AddWithValue("@AfterRadioMedicalAdvice", DBNull.Value);
            }


            if (!String.IsNullOrEmpty(cIRM.HowIsPatientRespondingToTreatmentGiven))
            {
                cmd.Parameters.AddWithValue("@HowIsPatientRespondingToTreatmentGiven", cIRM.HowIsPatientRespondingToTreatmentGiven);
            }
            else
            {
                cmd.Parameters.AddWithValue("@HowIsPatientRespondingToTreatmentGiven", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(cIRM.DoesPatientNeedRemoveFromVessel.ToString()))
            {
                cmd.Parameters.AddWithValue("@DoesPatientNeedRemoveFromVessel", cIRM.DoesPatientNeedRemoveFromVessel);
            }
            else
            {
                cmd.Parameters.AddWithValue("@DoesPatientNeedRemoveFromVessel", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(cIRM.NeedRemovalDesc))
            {
                cmd.Parameters.AddWithValue("@NeedRemovalDesc", cIRM.NeedRemovalDesc);
            }
            else
            {
                cmd.Parameters.AddWithValue("@NeedRemovalDesc", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.NeedRemovalToPort))
            {
                cmd.Parameters.AddWithValue("@NeedRemovalToPort", cIRM.NeedRemovalToPort);
            }
            else
            {
                cmd.Parameters.AddWithValue("@NeedRemovalToPort", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(cIRM.AdditionalNotes))
            {
                cmd.Parameters.AddWithValue("@AdditionalNotes", cIRM.AdditionalNotes);
            }
            else
            {
                cmd.Parameters.AddWithValue("@AdditionalNotes", DBNull.Value);
            }


            #endregion

            #region Other Part 4 Upload 10
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

            if (!String.IsNullOrEmpty(cIRM.PictureUploadPath))
            {
                cmd.Parameters.AddWithValue("@PictureUploadPath", cIRM.PictureUploadPath.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@PictureUploadPath", DBNull.Value);
            }
            if (cIRM.AccidentOrIllnessImagePathList.Count > 0)
            {
                DataTable imagePaths = new DataTable();
                imagePaths.Columns.Add("FilePath", typeof(string));
                foreach(string s in cIRM.AccidentOrIllnessImagePathList)
                {
                    imagePaths.Rows.Add(s);
                }
                cmd.Parameters.AddWithValue("@AccidentOrIllnessImagePaths", imagePaths);
            }
            else
            {
                cmd.Parameters.AddWithValue("@AccidentOrIllnessImagePaths", DBNull.Value);
            }

            
            #endregion

            int recordsAffected = cmd.ExecuteNonQuery();
            con.Close();

            return recordsAffected;
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

        public int SaveCIRMDoctorsEmails(string cirmId, string crewId, string doctorsEmail)
        {
            try
            {
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
                con.Open();
                SqlCommand cmd = new SqlCommand("stpSaveCIRMDoctorsEmails", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@CIRMId", Convert.ToInt32(cirmId));
                cmd.Parameters.AddWithValue("@CrewId", Convert.ToInt32(crewId));
                cmd.Parameters.AddWithValue("@DoctorsEmail", doctorsEmail);

                int recordsAffected = cmd.ExecuteNonQuery();
                con.Close();
                return recordsAffected;
            }
            catch(Exception ex)
            {
                return 0;
            }
            
        }
        #endregion

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


                #endregion

                #region Voyage Details

                if (!String.IsNullOrEmpty(ds.Tables[3].Rows[0]["DateOfReportingGMT"].ToString()))
                    cirm.DateOfReportingGMT = ds.Tables[3].Rows[0]["DateOfReportingGMT"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[3].Rows[0]["TimeOfReportingGMT"].ToString()))
                    cirm.TimeOfReportingGMT = ds.Tables[3].Rows[0]["TimeOfReportingGMT"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[3].Rows[0]["LocationOfShip"].ToString()))
                    cirm.LocationOfShip = ds.Tables[3].Rows[0]["LocationOfShip"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[3].Rows[0]["Cousre"].ToString()))
                    cirm.Cousre = ds.Tables[3].Rows[0]["Cousre"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[3].Rows[0]["Speed"].ToString()))
                    cirm.Speed = ds.Tables[3].Rows[0]["Speed"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[3].Rows[0]["PortofDeparture"].ToString()))
                    cirm.PortofDeparture = ds.Tables[3].Rows[0]["PortofDeparture"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[3].Rows[0]["DateOfDeparture"].ToString()))
                    cirm.DateOfDeparture = ds.Tables[3].Rows[0]["DateOfDeparture"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[3].Rows[0]["TimeOfDeparture"].ToString()))
                    cirm.TimeOfDeparture = ds.Tables[3].Rows[0]["TimeOfDeparture"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[3].Rows[0]["PortofDestination"].ToString()))
                    cirm.PortofDestination = ds.Tables[3].Rows[0]["PortofDestination"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[3].Rows[0]["ETADateGMT"].ToString()))
                    cirm.ETADateGMT = ds.Tables[3].Rows[0]["ETADateGMT"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[3].Rows[0]["ETATimeGMT"].ToString()))
                    cirm.ETATimeGMT = ds.Tables[3].Rows[0]["ETATimeGMT"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[3].Rows[0]["EstimatedTimeOfarrivalhrs"].ToString()))
                    cirm.EstimatedTimeOfarrivalhrs = ds.Tables[3].Rows[0]["EstimatedTimeOfarrivalhrs"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[3].Rows[0]["AgentDetails"].ToString()))
                    cirm.AgentDetails = ds.Tables[3].Rows[0]["AgentDetails"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[3].Rows[0]["NearestPort"].ToString()))
                    cirm.NearestPort = ds.Tables[3].Rows[0]["NearestPort"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[3].Rows[0]["NearestPortETADateGMT"].ToString()))
                    cirm.NearestPortETADateGMT = ds.Tables[3].Rows[0]["NearestPortETADateGMT"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[3].Rows[0]["NearestPortETATimeGMT"].ToString()))
                    cirm.NearestPortETATimeGMT = ds.Tables[3].Rows[0]["NearestPortETATimeGMT"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[3].Rows[0]["OtherPossiblePort"].ToString()))
                    cirm.OtherPossiblePort = ds.Tables[3].Rows[0]["OtherPossiblePort"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[3].Rows[0]["OtherPortETADateGMT"].ToString()))
                    cirm.OtherPortETADateGMT = ds.Tables[3].Rows[0]["OtherPortETADateGMT"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[3].Rows[0]["OtherPortETATimeGMT"].ToString()))
                    cirm.OtherPortETATimeGMT = ds.Tables[3].Rows[0]["OtherPortETATimeGMT"].ToString();

                #endregion

                #region Weather Details

                if (!String.IsNullOrEmpty(ds.Tables[4].Rows[0]["WindDirection"].ToString()))
                    cirm.WindDirection = ds.Tables[4].Rows[0]["WindDirection"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[4].Rows[0]["BeaufortScale"].ToString()))
                    cirm.BeaufortScale = ds.Tables[4].Rows[0]["BeaufortScale"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[4].Rows[0]["WindSpeed"].ToString()))
                    cirm.WindSpeed = ds.Tables[4].Rows[0]["WindSpeed"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[4].Rows[0]["SeaState"].ToString()))
                    cirm.SeaState = ds.Tables[4].Rows[0]["SeaState"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[4].Rows[0]["WaveHeight"].ToString()))
                    cirm.WaveHeight = ds.Tables[4].Rows[0]["WaveHeight"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[4].Rows[0]["Swell"].ToString()))
                    cirm.Swell = ds.Tables[4].Rows[0]["Swell"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[4].Rows[0]["WeatherCondition"].ToString()))
                    cirm.WeatherCondition = ds.Tables[4].Rows[0]["WeatherCondition"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[4].Rows[0]["WeatherVisibility"].ToString()))
                    cirm.WeatherVisibility = ds.Tables[4].Rows[0]["WeatherVisibility"].ToString();

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

                if (Convert.ToBoolean(ds.Tables[0].Rows[0]["JoiningMedical"].ToString()))
                {
                    cirm.JoiningMedical = Convert.ToBoolean(ds.Tables[0].Rows[0]["JoiningMedical"].ToString());
                    //cirm.JoiningMedicalPath = dsUploadedImages.Tables[0].Select("FilePath")
                    //                                    .Where(e => e.ItemArray[2].ToString().Equals("JoiningMedical")).FirstOrDefault().ToString();
                    cirm.JoiningMedicalPath = dsUploadedImages.Tables[0].AsEnumerable()
                                                        .Where(r => r.Field<string>("FileType") == "JoiningMedical")
                                                        .Select(r => r.Field<string>("FilePath")).FirstOrDefault().ToString();
                }
                    
                if (Convert.ToBoolean(ds.Tables[0].Rows[0]["MedicineAvailableOnBoard"].ToString()))
                {
                    cirm.MedicineAvailableOnBoard = Convert.ToBoolean(ds.Tables[0].Rows[0]["MedicineAvailableOnBoard"].ToString());
                    //cirm.JoiningMedicalPath = dsUploadedImages.Tables[0].Select("FilePath")
                    //                                    .Where(e => e.ItemArray[2].ToString().Equals("MedicineAvailableOnBoard")).FirstOrDefault().ToString();
                    cirm.MedicineAvailableOnBoardPath = dsUploadedImages.Tables[0].AsEnumerable()
                                                        .Where(r => r.Field<string>("FileType") == "MedicineAvailableOnBoard")
                                                        .Select(r => r.Field<string>("FilePath")).FirstOrDefault().ToString();
                }
                   
                if (Convert.ToBoolean(ds.Tables[0].Rows[0]["MedicalEquipmentOnBoard"].ToString()))
                {
                    cirm.MedicalEquipmentOnBoard = Convert.ToBoolean(ds.Tables[0].Rows[0]["MedicalEquipmentOnBoard"].ToString());
                    //cirm.MedicalEquipmentOnBoardPath = dsUploadedImages.Tables[0].AsEnumerable().Select(r => r.Field<string>("FilePath"))
                    //                                    .Where(e => e.ItemArray[2].ToString().Equals("MedicalEquipmentOnBoard")).FirstOrDefault().ToString();
                    cirm.MedicalEquipmentOnBoardPath = dsUploadedImages.Tables[0].AsEnumerable()
                                                        .Where( r => r.Field<string>("FileType") == "MedicalEquipmentOnBoard")
                                                        .Select(r => r.Field<string>("FilePath")).FirstOrDefault().ToString();
                }
                    
                if (Convert.ToBoolean(ds.Tables[0].Rows[0]["MedicalHistoryUpload"].ToString()))
                {
                    cirm.MedicalHistoryUpload = Convert.ToBoolean(ds.Tables[0].Rows[0]["MedicalHistoryUpload"].ToString());
                    //cirm.MedicalHistoryPath = dsUploadedImages.Tables[0].Select("FilePath")
                    //                                    .Where(e => e.ItemArray[2].ToString().Equals("MedicalHistoryUpload")).FirstOrDefault().ToString();
                    cirm.MedicalHistoryPath = dsUploadedImages.Tables[0].AsEnumerable()
                                                        .Where(r => r.Field<string>("FileType") == "MedicalHistoryUpload")
                                                        .Select(r => r.Field<string>("FilePath")).FirstOrDefault().ToString();
                }
                    
                if (Convert.ToBoolean(ds.Tables[0].Rows[0]["WorkAndRestHourLatestRecord"].ToString()))
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
        /// Added on 31st Jan 2022 @ BK
        /// </summary>
        /// <param name="cewId"></param>
        /// <param name="VesselId"></param>
        /// <returns></returns>
        public CIRMPOCO GetCIRMPatientDetailsByCrewNew(int cewId, int vesselId)
        {
            CIRMPOCO cirm = new CIRMPOCO();
            VitalStatisticsPOCO cirmVitals = new VitalStatisticsPOCO();
            MedicalSymtomologyPOCO cirmSymtomology = new MedicalSymtomologyPOCO();
            List<CIRMMedicationTakenPOCO> mtPoco = new List<CIRMMedicationTakenPOCO>();

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
            if (ds.Tables[0].Rows.Count > 0)
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


                #endregion

                #region Voyage Details

                if (!String.IsNullOrEmpty(ds.Tables[3].Rows[0]["DateOfReportingGMT"].ToString()))
                    cirm.DateOfReportingGMT = ds.Tables[3].Rows[0]["DateOfReportingGMT"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[3].Rows[0]["TimeOfReportingGMT"].ToString()))
                    cirm.TimeOfReportingGMT = ds.Tables[3].Rows[0]["TimeOfReportingGMT"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[3].Rows[0]["LocationOfShip"].ToString()))
                    cirm.LocationOfShip = ds.Tables[3].Rows[0]["LocationOfShip"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[3].Rows[0]["Cousre"].ToString()))
                    cirm.Cousre = ds.Tables[3].Rows[0]["Cousre"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[3].Rows[0]["Speed"].ToString()))
                    cirm.Speed = ds.Tables[3].Rows[0]["Speed"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[3].Rows[0]["PortofDeparture"].ToString()))
                    cirm.PortofDeparture = ds.Tables[3].Rows[0]["PortofDeparture"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[3].Rows[0]["DateOfDeparture"].ToString()))
                    cirm.DateOfDeparture = ds.Tables[3].Rows[0]["DateOfDeparture"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[3].Rows[0]["TimeOfDeparture"].ToString()))
                    cirm.TimeOfDeparture = ds.Tables[3].Rows[0]["TimeOfDeparture"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[3].Rows[0]["PortofDestination"].ToString()))
                    cirm.PortofDestination = ds.Tables[3].Rows[0]["PortofDestination"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[3].Rows[0]["ETADateGMT"].ToString()))
                    cirm.ETADateGMT = ds.Tables[3].Rows[0]["ETADateGMT"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[3].Rows[0]["ETATimeGMT"].ToString()))
                    cirm.ETATimeGMT = ds.Tables[3].Rows[0]["ETATimeGMT"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[3].Rows[0]["EstimatedTimeOfarrivalhrs"].ToString()))
                    cirm.EstimatedTimeOfarrivalhrs = ds.Tables[3].Rows[0]["EstimatedTimeOfarrivalhrs"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[3].Rows[0]["AgentDetails"].ToString()))
                    cirm.AgentDetails = ds.Tables[3].Rows[0]["AgentDetails"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[3].Rows[0]["NearestPort"].ToString()))
                    cirm.NearestPort = ds.Tables[3].Rows[0]["NearestPort"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[3].Rows[0]["NearestPortETADateGMT"].ToString()))
                    cirm.NearestPortETADateGMT = ds.Tables[3].Rows[0]["NearestPortETADateGMT"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[3].Rows[0]["NearestPortETATimeGMT"].ToString()))
                    cirm.NearestPortETATimeGMT = ds.Tables[3].Rows[0]["NearestPortETATimeGMT"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[3].Rows[0]["OtherPossiblePort"].ToString()))
                    cirm.OtherPossiblePort = ds.Tables[3].Rows[0]["OtherPossiblePort"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[3].Rows[0]["OtherPortETADateGMT"].ToString()))
                    cirm.OtherPortETADateGMT = ds.Tables[3].Rows[0]["OtherPortETADateGMT"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[3].Rows[0]["OtherPortETATimeGMT"].ToString()))
                    cirm.OtherPortETATimeGMT = ds.Tables[3].Rows[0]["OtherPortETATimeGMT"].ToString();

                #endregion

                #region Weather Details
                if(ds.Tables[4].Rows.Count > 0)
                {
                    if (!String.IsNullOrEmpty(ds.Tables[4].Rows[0]["WindDirection"].ToString()))
                        cirm.WindDirection = ds.Tables[4].Rows[0]["WindDirection"].ToString();
                    if (!String.IsNullOrEmpty(ds.Tables[4].Rows[0]["BeaufortScale"].ToString()))
                        cirm.BeaufortScale = ds.Tables[4].Rows[0]["BeaufortScale"].ToString();
                    if (!String.IsNullOrEmpty(ds.Tables[4].Rows[0]["WindSpeed"].ToString()))
                        cirm.WindSpeed = ds.Tables[4].Rows[0]["WindSpeed"].ToString();
                    if (!String.IsNullOrEmpty(ds.Tables[4].Rows[0]["SeaState"].ToString()))
                        cirm.SeaState = ds.Tables[4].Rows[0]["SeaState"].ToString();
                    if (!String.IsNullOrEmpty(ds.Tables[4].Rows[0]["WaveHeight"].ToString()))
                        cirm.WaveHeight = ds.Tables[4].Rows[0]["WaveHeight"].ToString();
                    if (!String.IsNullOrEmpty(ds.Tables[4].Rows[0]["Swell"].ToString()))
                        cirm.Swell = ds.Tables[4].Rows[0]["Swell"].ToString();
                    if (!String.IsNullOrEmpty(ds.Tables[4].Rows[0]["WeatherCondition"].ToString()))
                        cirm.WeatherCondition = ds.Tables[4].Rows[0]["WeatherCondition"].ToString();
                    if (!String.IsNullOrEmpty(ds.Tables[4].Rows[0]["WeatherVisibility"].ToString()))
                        cirm.WeatherVisibility = ds.Tables[4].Rows[0]["WeatherVisibility"].ToString();
                }
                

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

                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["DateOfOffWork"].ToString()))
                    cirm.DateOfOffWork = ds.Tables[0].Rows[0]["DateOfOffWork"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["TimeOfOffWork"].ToString()))
                    cirm.TimeOfOffWork = ds.Tables[0].Rows[0]["TimeOfOffWork"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["DateOfResumeWork"].ToString()))
                    cirm.DateOfResumeWork = ds.Tables[0].Rows[0]["DateOfResumeWork"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["TimeOfResumeWork"].ToString()))
                    cirm.TimeOfResumeWork = ds.Tables[0].Rows[0]["TimeOfResumeWork"].ToString();

                #endregion


                

                #region Incase of Accident or Illness



                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["DateOfInjuryOrIllness"].ToString()))
                    cirm.DateOfInjuryOrIllness = ds.Tables[0].Rows[0]["DateOfInjuryOrIllness"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["TimeOfInjuryOrIllness"].ToString()))
                    cirm.TimeOfInjuryOrIllness = ds.Tables[0].Rows[0]["TimeOfInjuryOrIllness"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["DateOfFirstExamination"].ToString()))
                    cirm.DateOfFirstExamination = ds.Tables[0].Rows[0]["DateOfFirstExamination"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["TimeOfFirstExamination"].ToString()))
                    cirm.TimeOfFirstExamination = ds.Tables[0].Rows[0]["TimeOfFirstExamination"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["IsInjuryorIllnessWorkRelated"].ToString()))
                    cirm.IsInjuryorIllnessWorkRelated = ds.Tables[0].Rows[0]["IsInjuryorIllnessWorkRelated"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["IsUnconsciousByInjuryOrIllness"].ToString()))
                    cirm.IsUnconsciousByInjuryOrIllness = ds.Tables[0].Rows[0]["IsUnconsciousByInjuryOrIllness"].ToString();

                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["HowLongWasUnconscious"].ToString()))
                    cirm.HowLongWasUnconscious = ds.Tables[0].Rows[0]["HowLongWasUnconscious"].ToString();
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["LevelOfConsciousness"].ToString()))
                    cirm.LevelOfConsciousness = Convert.ToInt32( ds.Tables[0].Rows[0]["LevelOfConsciousness"].ToString());
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["IsAccidentOrIlness"].ToString()))
                    cirm.IsAccidentOrIlness = Convert.ToInt32( ds.Tables[0].Rows[0]["IsAccidentOrIlness"].ToString());



                #region Accident
                if (cirm.IsAccidentOrIlness == 1)
                {
                    DataSet dsAccident = new DataSet();
                    dsAccident = GetCirmAccidentDetailsByCirmId(cirm.CIRMId);
                    if (!String.IsNullOrEmpty(dsAccident.Tables[0].Rows[0]["WhereAndHowAccidentOccured"].ToString()))
                        cirm.WhereAndHowAccidentOccured = dsAccident.Tables[0].Rows[0]["WhereAndHowAccidentOccured"].ToString();
                    if (!String.IsNullOrEmpty(dsAccident.Tables[0].Rows[0]["LocationAndTypeOfInjuryOrBurn"].ToString()))
                        cirm.LocationAndTypeOfInjuryOrBurn = dsAccident.Tables[0].Rows[0]["LocationAndTypeOfInjuryOrBurn"].ToString();
                    if (!String.IsNullOrEmpty(dsAccident.Tables[0].Rows[0]["FirstAidGiven"].ToString()))
                        cirm.FirstAidGiven = dsAccident.Tables[0].Rows[0]["FirstAidGiven"].ToString();
                    if (!String.IsNullOrEmpty(dsAccident.Tables[0].Rows[0]["TypeOfBurn"].ToString()))
                        cirm.TypeOfBurn = dsAccident.Tables[0].Rows[0]["TypeOfBurn"].ToString();
                    if (!String.IsNullOrEmpty(dsAccident.Tables[0].Rows[0]["DegreeOfBurn"].ToString()))
                        cirm.DegreeOfBurn = dsAccident.Tables[0].Rows[0]["DegreeOfBurn"].ToString();
                    if (!String.IsNullOrEmpty(dsAccident.Tables[0].Rows[0]["PercentageOfBurn"].ToString()))
                        cirm.PercentageOfBurn = dsAccident.Tables[0].Rows[0]["PercentageOfBurn"].ToString();
                }


                #endregion

                //if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["PictureUploadPath"].ToString()))
                //    cirm.PictureUploadPath = ds.Tables[0].Rows[0]["PictureUploadPath"].ToString();

                #region Illness



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
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["FrequencyOfPain"].ToString()))
                    cirm.FrequencyOfPain = ds.Tables[0].Rows[0]["FrequencyOfPain"].ToString();

                #endregion
                #endregion

                #region History and Meditation Taken

                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["PastMedicalHistory"].ToString()))
                    cirm.PastMedicalHistory = ds.Tables[0].Rows[0]["PastMedicalHistory"].ToString();

                //List<CIRMMedicationTakenPOCO> mtPoco = new List<CIRMMedicationTakenPOCO>();
                mtPoco = GetMedicationTakenByCIRM(cirm.CIRMId);
                //cirm.MedicationTakenList= GetMedicationTakenByCIRM(cirm.CIRMId);

                #endregion

                #region Findings Affected Areas
                if (ds.Tables[5].Rows.Count > 0)
                {
                    if (!String.IsNullOrEmpty(ds.Tables[5].Rows[0]["AffectedParts"].ToString()))
                        cirm.AffectedParts = ds.Tables[5].Rows[0]["AffectedParts"].ToString();
                    if (!String.IsNullOrEmpty(ds.Tables[5].Rows[0]["BloodType"].ToString()))
                        cirm.BloodType = ds.Tables[5].Rows[0]["BloodType"].ToString();
                    if (!String.IsNullOrEmpty(ds.Tables[5].Rows[0]["BloodQuantity"].ToString()))
                        cirm.BloodQuantity = ds.Tables[5].Rows[0]["BloodQuantity"].ToString();
                    if (!String.IsNullOrEmpty(ds.Tables[5].Rows[0]["FluidType"].ToString()))
                        cirm.FluidType = ds.Tables[5].Rows[0]["FluidType"].ToString();
                    if (!String.IsNullOrEmpty(ds.Tables[5].Rows[0]["FluidQuantity"].ToString()))
                        cirm.FluidQuantity = ds.Tables[5].Rows[0]["FluidQuantity"].ToString();
                    if (!String.IsNullOrEmpty(ds.Tables[5].Rows[0]["SkinDetails"].ToString()))
                        cirm.SkinDetails = ds.Tables[5].Rows[0]["SkinDetails"].ToString();
                    if (!String.IsNullOrEmpty(ds.Tables[5].Rows[0]["PupilsDetails"].ToString()))
                        cirm.PupilsDetails = ds.Tables[5].Rows[0]["PupilsDetails"].ToString();


                }

                #endregion

                #region Telemedical Consultation
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["TeleMedicalConsultation"].ToString()))
                    cirm.TeleMedicalConsultation = Convert.ToBoolean(ds.Tables[0].Rows[0]["TeleMedicalConsultation"].ToString());
                if (ds.Tables[6].Rows.Count > 0)
                {
                    
                    if (!String.IsNullOrEmpty(ds.Tables[6].Rows[0]["TeleMedicalContactDate"].ToString()))
                        cirm.TeleMedicalContactDate = ds.Tables[6].Rows[0]["TeleMedicalContactDate"].ToString();
                    if (!String.IsNullOrEmpty(ds.Tables[6].Rows[0]["TeleMedicalContactTime"].ToString()))
                        cirm.TeleMedicalContactTime = ds.Tables[6].Rows[0]["TeleMedicalContactTime"].ToString();
                    if (!String.IsNullOrEmpty(ds.Tables[6].Rows[0]["ModeOfCommunication"].ToString()))
                        cirm.ModeOfCommunication = ds.Tables[6].Rows[0]["ModeOfCommunication"].ToString();
                    if (!String.IsNullOrEmpty(ds.Tables[6].Rows[0]["NameOfTelemedicalConsultant"].ToString()))
                        cirm.NameOfTelemedicalConsultant = ds.Tables[6].Rows[0]["NameOfTelemedicalConsultant"].ToString();
                    if (!String.IsNullOrEmpty(ds.Tables[6].Rows[0]["DetailsOfTreatmentAdvised"].ToString()))
                        cirm.DetailsOfTreatmentAdvised = ds.Tables[6].Rows[0]["DetailsOfTreatmentAdvised"].ToString();
                }


                #endregion

                #region Medical Treatment Given Onboard
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["MedicalTreatmentGivenOnboard"].ToString()))
                    cirm.MedicalTreatmentGivenOnboard = Convert.ToBoolean(ds.Tables[0].Rows[0]["MedicalTreatmentGivenOnboard"].ToString());
                if (ds.Tables[7].Rows.Count > 0)
                {
                    
                    if (!String.IsNullOrEmpty(ds.Tables[7].Rows[0]["PriorRadioMedicalAdvice"].ToString()))
                        cirm.PriorRadioMedicalAdvice = ds.Tables[7].Rows[0]["PriorRadioMedicalAdvice"].ToString();
                    if (!String.IsNullOrEmpty(ds.Tables[7].Rows[0]["AfterRadioMedicalAdvice"].ToString()))
                        cirm.AfterRadioMedicalAdvice = ds.Tables[7].Rows[0]["AfterRadioMedicalAdvice"].ToString();
                    if (!String.IsNullOrEmpty(ds.Tables[7].Rows[0]["HowIsPatientRespondingToTreatmentGiven"].ToString()))
                        cirm.HowIsPatientRespondingToTreatmentGiven = ds.Tables[7].Rows[0]["HowIsPatientRespondingToTreatmentGiven"].ToString();
                    if (!String.IsNullOrEmpty(ds.Tables[7].Rows[0]["DoesPatientNeedRemoveFromVessel"].ToString()))
                        cirm.DoesPatientNeedRemoveFromVessel = Convert.ToInt32(ds.Tables[7].Rows[0]["DoesPatientNeedRemoveFromVessel"]);
                    if (!String.IsNullOrEmpty(ds.Tables[7].Rows[0]["NeedRemovalDesc"].ToString()))
                        cirm.NeedRemovalDesc = ds.Tables[7].Rows[0]["NeedRemovalDesc"].ToString();
                    if (!String.IsNullOrEmpty(ds.Tables[7].Rows[0]["NeedRemovalToPort"].ToString()))
                        cirm.NeedRemovalToPort = ds.Tables[7].Rows[0]["NeedRemovalToPort"].ToString();
                    if (!String.IsNullOrEmpty(ds.Tables[7].Rows[0]["AdditionalNotes"].ToString()))
                        cirm.AdditionalNotes = ds.Tables[7].Rows[0]["AdditionalNotes"].ToString();

                }


                #endregion

                #region Upload section

                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["JoiningMedical"].ToString()) && Convert.ToBoolean(ds.Tables[0].Rows[0]["JoiningMedical"].ToString()))
                {
                    cirm.JoiningMedical = Convert.ToBoolean(ds.Tables[0].Rows[0]["JoiningMedical"].ToString());
                    //cirm.JoiningMedicalPath = dsUploadedImages.Tables[0].Select("FilePath")
                    //                                    .Where(e => e.ItemArray[2].ToString().Equals("JoiningMedical")).FirstOrDefault().ToString();
                    cirm.JoiningMedicalPath = dsUploadedImages.Tables[0].AsEnumerable()
                                                        .Where(r => r.Field<string>("FileType") == "JoiningMedical")
                                                        .Select(r => r.Field<string>("FilePath")).FirstOrDefault().ToString();
                }

                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["MedicineAvailableOnBoard"].ToString()) && Convert.ToBoolean(ds.Tables[0].Rows[0]["MedicineAvailableOnBoard"].ToString()))
                {
                    cirm.MedicineAvailableOnBoard = Convert.ToBoolean(ds.Tables[0].Rows[0]["MedicineAvailableOnBoard"].ToString());
                    //cirm.JoiningMedicalPath = dsUploadedImages.Tables[0].Select("FilePath")
                    //                                    .Where(e => e.ItemArray[2].ToString().Equals("MedicineAvailableOnBoard")).FirstOrDefault().ToString();
                    cirm.MedicineAvailableOnBoardPath = dsUploadedImages.Tables[0].AsEnumerable()
                                                        .Where(r => r.Field<string>("FileType") == "MedicineAvailableOnBoard")
                                                        .Select(r => r.Field<string>("FilePath")).FirstOrDefault().ToString();
                }

                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["MedicalEquipmentOnBoard"].ToString()) && Convert.ToBoolean(ds.Tables[0].Rows[0]["MedicalEquipmentOnBoard"].ToString()))
                {
                    cirm.MedicalEquipmentOnBoard = Convert.ToBoolean(ds.Tables[0].Rows[0]["MedicalEquipmentOnBoard"].ToString());
                    //cirm.MedicalEquipmentOnBoardPath = dsUploadedImages.Tables[0].AsEnumerable().Select(r => r.Field<string>("FilePath"))
                    //                                    .Where(e => e.ItemArray[2].ToString().Equals("MedicalEquipmentOnBoard")).FirstOrDefault().ToString();
                    cirm.MedicalEquipmentOnBoardPath = dsUploadedImages.Tables[0].AsEnumerable()
                                                        .Where(r => r.Field<string>("FileType") == "MedicalEquipmentOnBoard")
                                                        .Select(r => r.Field<string>("FilePath")).FirstOrDefault().ToString();
                }

                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["MedicalHistoryUpload"].ToString()) && Convert.ToBoolean(ds.Tables[0].Rows[0]["MedicalHistoryUpload"].ToString()))
                {
                    cirm.MedicalHistoryUpload = Convert.ToBoolean(ds.Tables[0].Rows[0]["MedicalHistoryUpload"].ToString());
                    //cirm.MedicalHistoryPath = dsUploadedImages.Tables[0].Select("FilePath")
                    //                                    .Where(e => e.ItemArray[2].ToString().Equals("MedicalHistoryUpload")).FirstOrDefault().ToString();
                    cirm.MedicalHistoryPath = dsUploadedImages.Tables[0].AsEnumerable()
                                                        .Where(r => r.Field<string>("FileType") == "MedicalHistoryUpload")
                                                        .Select(r => r.Field<string>("FilePath")).FirstOrDefault().ToString();
                }

                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["WorkAndRestHourLatestRecord"].ToString()) && Convert.ToBoolean(ds.Tables[0].Rows[0]["WorkAndRestHourLatestRecord"].ToString()))
                {
                    cirm.WorkAndRestHourLatestRecord = Convert.ToBoolean(ds.Tables[0].Rows[0]["WorkAndRestHourLatestRecord"].ToString());
                    //cirm.WorkAndRestHourLatestRecordPath = dsUploadedImages.Tables[0].Select("FilePath")
                    //                                    .Where(e => e.ItemArray[2].ToString().Equals("WorkAndRestHourLatestRecord")).FirstOrDefault().ToString();
                    cirm.WorkAndRestHourLatestRecordPath = dsUploadedImages.Tables[0].AsEnumerable()
                                                        .Where(r => r.Field<string>("FileType") == "WorkAndRestHourLatestRecord")
                                                        .Select(r => r.Field<string>("FilePath")).FirstOrDefault().ToString();
                }

                //if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["PreExistingMedicationPrescription"].ToString()))
                //    cirm.PreExistingMedicationPrescription = Convert.ToBoolean(ds.Tables[0].Rows[0]["PreExistingMedicationPrescription"].ToString());

                #endregion


            }

            cirm.MedicationTakenList = mtPoco;
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
                    if (ds.Tables[0].Rows[0]["Ailment"] != null)
                        cirmSymtomology.Ailment = item["Ailment"].ToString();


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

        public List<CIRMMedicationTakenPOCO> GetMedicationTakenByCIRM(int Id)
        {
            List<CIRMMedicationTakenPOCO> cirmMedicationTakenList = new List<CIRMMedicationTakenPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetMedicationTakenByCIRM", con))
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
                    CIRMMedicationTakenPOCO cirmMedicationTaken = new CIRMMedicationTakenPOCO();
                    if (ds.Tables[0].Rows[0]["MedicationId"] != null)
                        cirmMedicationTaken.MedicationId = Convert.ToInt32(item["MedicationId"].ToString());
                    if (ds.Tables[0].Rows[0]["CIRMId"] != null)
                        cirmMedicationTaken.CIRMId = Convert.ToInt32(item["CIRMId"].ToString());
                    if (ds.Tables[0].Rows[0]["PrescriptionName"] != null)
                        cirmMedicationTaken.PrescriptionName = item["PrescriptionName"].ToString();
                    if (ds.Tables[0].Rows[0]["MedicalConditionBeingTreated"] != null)
                        cirmMedicationTaken.MedicalConditionBeingTreated = item["MedicalConditionBeingTreated"].ToString();
                    if (ds.Tables[0].Rows[0]["HowOftenMedicationTaken"] != null)
                        cirmMedicationTaken.HowOftenMedicationTaken = item["HowOftenMedicationTaken"].ToString();

                    cirmMedicationTakenList.Add(cirmMedicationTaken);
                }

            }
            else
            {
                CIRMMedicationTakenPOCO cirmMedicationTaken = new CIRMMedicationTakenPOCO();
                cirmMedicationTakenList.Add(cirmMedicationTaken);
            }
            return cirmMedicationTakenList;
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



        public DataSet GetCirmAccidentDetailsByCirmId(int cirmId)
        {
            DataSet ds = new DataSet();

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetCIRMAccidentDetailsByCirmId", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;;
                    cmd.Parameters.AddWithValue("@CirmId", cirmId);
                    con.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                   
                    con.Close();
                }
            }


            return ds;
        }

        public static DataTable CreateCIRMMedicationTakenTable()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("MedicationId", typeof(Int32));
            dt.Columns.Add("CIRMId", typeof(Int32));
            dt.Columns.Add("PrescriptionName", typeof(string));
            dt.Columns.Add("MedicalConditionBeingTreated", typeof(string));
            dt.Columns.Add("HowOftenMedicationTaken", typeof(string));
            return dt;
        }
    }
}
