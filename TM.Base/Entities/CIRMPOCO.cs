using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.Base.Entities
{
    public class CIRMPOCO
    {
        public int CIRMId { get; set; }
        public string MedicalAssitanceType { get; set; }

        #region Vessel Details
        public int VesselId { get; set; }
        public string NameOfVessel { get; set; }
        public string RadioCallSign { get; set; }
        #endregion

        #region Crew Details

        public int CrewId { get; set; }
        public string Nationality { get; set; }
        public string Qualification { get; set; }

        public string Addiction { get; set; }

        public int? RankID { get; set; }

        public string Ethinicity { get; set; }

        public string Frequency { get; set; }

        public string Sex { get; set; }

        public string Age { get; set; }

        public string JoiningDate { get; set; }

        #endregion

        #region Vital Params
        public string RespiratoryRate { get; set; }
        public string Pulse { get; set; }
        public string Temperature { get; set; }
        public string Systolic { get; set; }
        public string Diastolic { get; set; }

        #endregion
        
        public string LocationAndTypeOfPain { get; set; }
        public string RelevantInformationForDesease { get; set; }
        public Boolean WhereAndHowAccidentIsCausedCHK { get; set; }
        public string UploadMedicalHistory { get; set; }
        public string UploadMedicinesAvailable { get; set; }
        public string MedicalProductsAdministered { get; set; }
        public string WhereAndHowAccidentIsausedARA { get; set; }

        public int IsEquipmentUploaded { get; set; }
        public int IsmedicineUploaded { get; set; }
        public int IsJoiningReportUloaded { get; set; }

        public int IsMedicalHistoryUploaded { get; set; }



        public string Category { get; set; }

        public string SubCategory { get; set; }

        public string OxygenSaturation { get; set; }

        #region Symtomology
        public string SymptomatologyDate { get; set; }

        public string SymptomatologyTime { get; set; }
        public string Symptomatology { get; set; }
        public string Vomiting { get; set; }

        public string FrequencyOfVomiting { get; set; }

        public string Fits { get; set; }

        public string FrequencyOfFits { get; set; }

        public string SymptomatologyDetails { get; set; }

        #endregion
        public string MedicinesAdministered { get; set; }

        public string WhereAndHowAccidentOccured { get; set; }

        #region Severity Of Pains
        public Boolean? NoHurt { get; set; }

        public Boolean? HurtLittleBit { get; set; }

        public Boolean? HurtsLittleMore { get; set; }

        public Boolean? HurtsEvenMore { get; set; }

        public Boolean? HurtsWholeLot { get; set; }

        public Boolean? HurtsWoest { get; set; }

        public int SeverityOfPain { get; set; }

        #endregion

        #region Upload Cirm Images
        public Boolean? JoiningMedical { get; set; }
        public string JoiningMedicalPath { get; set; }
        public Boolean? MedicineAvailableOnBoard { get; set; }
        public string MedicineAvailableOnBoardPath { get; set; }
        public Boolean? MedicalEquipmentOnBoard { get; set; }
        public string MedicalEquipmentOnBoardPath { get; set; }
        public Boolean? MedicalHistoryUpload { get; set; }
        public string MedicalHistoryPath { get; set; }
        public Boolean? WorkAndRestHourLatestRecord { get; set; }
        public string WorkAndRestHourLatestRecordPath { get; set; }

        public Boolean? PreExistingMedicationPrescription { get; set; }


        #endregion
        public string LocationAndTypeOfInjuryOrBurn { get; set; }

        public string FrequencyOfPain { get; set; }

        public string PictureUploadPath { get; set; }

        public string FirstAidGiven { get; set; }

        public string PercentageOfBurn { get; set; }

        public VitalStatisticsPOCO VitalParams { get; set; }
        public MedicalSymtomologyPOCO MedicalSymtomology { get; set; }
        public List<VitalStatisticsPOCO> VitalStatisticsList { get; set; }
        public List<MedicalSymtomologyPOCO> SymtomologyList { get; set; }

        #region Past Medical History

        public string PastMedicalHistory { get; set; }

        public string PastTreatmentGiven { get; set; }

        public string PastTeleMedicalAdviceReceived { get; set; }

        public string PastRemarks { get; set; }

        public string PastMedicineAdministered { get; set; }
        public string PastMedicalHistoryPath { get; set; }


        #endregion

        #region Voyage Details
        public int VoyageId { get; set; }
        public string Route { get; set; }
        public string DateOfReportingGMT { get; set; }
        public string TimeOfReportingGMT { get; set; }
        public string LocationOfShip { get; set; }
        public string Cousre { get; set; }
        public string Speed { get; set; }
        public string PortofDeparture { get; set; }
        public string DateOfDeparture { get; set; }
        public string TimeOfDeparture { get; set; }
        public string PortofDestination { get; set; }
        public string ETADateGMT { get; set; }
        public string ETATimeGMT { get; set; }
        public string EstimatedTimeOfarrivalhrs { get; set; }
        public string AgentDetails { get; set; }

        public string NearestPort { get; set; }
        public string NearestPortETADateGMT { get; set; }
        public string NearestPortETATimeGMT { get; set; }
        public string OtherPossiblePort { get; set; }
        public string OtherPortETADateGMT { get; set; }
        public string OtherPortETATimeGMT { get; set; }


        #endregion


        #region Weather Details

        public int WeatherId { get; set; }
        public string WindDirection { get; set; }
        public string BeaufortScale { get; set; }
        public string WindSpeed { get; set; }
        public string SeaState { get; set; }
        public string WaveHeight { get; set; }
        public string Swell { get; set; }
        public string WeatherCondition { get; set; }
        public string WeatherVisibility { get; set; }
        public string Weather { get; set; }

        #endregion


    }
}
