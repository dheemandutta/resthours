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

        public string NameOfVessel { get; set; }
        public string RadioCallSign { get; set; }
        public string PortofDestination { get; set; }
        public string Route { get; set; }
        public string LocationOfShip { get; set; }
        public string PortofDeparture { get; set; }
        public string EstimatedTimeOfarrivalhrs { get; set; }
        public string Speed { get; set; }
        public string Nationality { get; set; }
        public string Qualification { get; set; }
        public string RespiratoryRate { get; set; }
        public string Pulse { get; set; }
        public string Temperature { get; set; }
        public string Systolic { get; set; }
        public string Diastolic { get; set; }
        public string Symptomatology { get; set; }
        public string LocationAndTypeOfPain { get; set; }
        public string RelevantInformationForDesease { get; set; }
        public Boolean WhereAndHowAccidentIsCausedCHK { get; set; }
        public string UploadMedicalHistory { get; set; }
        public string UploadMedicinesAvailable { get; set; }
        public string MedicalProductsAdministered { get; set; }
        public string WhereAndHowAccidentIsausedARA { get; set; }

        public int CrewId { get; set; }
        public int IsEquipmentUploaded { get; set; }
        public int IsmedicineUploaded { get; set; }
        public int IsJoiningReportUloaded { get; set; }

        public int IsMedicalHistoryUploaded { get; set; }
    }
}
