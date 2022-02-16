using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.Base.Entities
{
    public class MedicalAdvisePOCO_old
    {
        public int AdviseId { get; set; }
        public int CIRMId { get; set; }
        public string MedicalAssitanceType { get; set; }
        public int CrewId { get; set; }
        public int VesselId { get; set; }
        public string Diagnosis { get; set; }
        public string TreamentPrescribed { get; set; }
        public string IsIllnessDueAccident { get; set; }
        public string MedicinePrescribed { get; set; }
        public string ExaminationName { get; set; }
        public string ExaminationFilePath { get; set; }
        

        public string RequireHospitalisation { get; set; }
        public string RequireSergery { get; set; }
        public string IsFitForDuty { get; set; }
        public string FitComment { get; set; }
        public string IsJoinOnBoard { get; set; }
        public string JoinOnBoardDays { get; set; }
        public string JoinOnBoardComment { get; set; }
        public string FutureFitnessToWorkAndRestrictions { get; set; }
        public string DischargeSummary { get; set; }
        public string FollowUpAction { get; set; }

        public string NameOfDoctor { get; set; }
        public string ContactNo { get; set; }
        public string DoctorEmail { get; set; }

        public string Spaciality { get; set; }
        public string MedicalRegNo { get; set; }
        public string Country { get; set; }
        public string NameOfHospital { get; set; }
    }
}
