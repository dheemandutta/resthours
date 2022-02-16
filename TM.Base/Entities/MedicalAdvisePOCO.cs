using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.Base.Entities
{
    public class MedicalAdvisePOCO
    {
		public int Id { get; set; }
		public string Diagnosis { get; set; }
		public string TreatmentPrescribed { get; set; }
		public Boolean IsIllnessDueToAnAccident { get; set; }
		public string MedicinePrescribed { get; set; }
		public string RequireHospitalisation { get; set; }
		public string RequireSurgery { get; set; }
		public Boolean IsFitForDuty { get; set; }
		public string FitForDutyComments { get; set; }
		public Boolean IsMayJoinOnBoardButLightDuty { get; set; }
		public string MayJoinOnBoardDays { get; set; }
		public string MayJoinOnBoardComments { get; set; }
		public Boolean IsUnfitForDuty { get; set; }
		public string UnfitForDutyComments { get; set; }
		public string FutureFitnessAndRestrictions { get; set; }
		public string DischargeSummary { get; set; }
		public string FollowUpAction { get; set; }
		public string DoctorName { get; set; }
		public string DoctorContactNo { get; set; }
		public string DoctorEmail { get; set; }
		public string DoctorSpeciality { get; set; }
		public string DoctorMedicalRegNo { get; set; }
		public string DoctorCountry { get; set; }
		public string NameOfHospital { get; set; }
		public string Path { get; set; }
		public DateTime TestDate { get; set; }
		public int CrewId { get; set; }


		public string CrewName { get; set; }
		public string RankName { get; set; }
		public string Gender { get; set; }
		public string Nationality { get; set; }
		public DateTime DOB { get; set; }
		public string PassportOrSeaman { get; set; }
		public string VesselName { get; set; }
		public string VesselSubType { get; set; }
		public string FlagOfShip { get; set; }
		public string IMONumber { get; set; }
		public string CompanyOwner { get; set; }

		/// <summary>
		/// /////////////////////////
		/// 
		/// </summary>
		/// 

		private List<ExaminationForMedicalAdvisePOCO> examinationForMedicalAdvisePOCOs;

		public MedicalAdvisePOCO()
		{
			examinationForMedicalAdvisePOCOs = new List<ExaminationForMedicalAdvisePOCO>();
			this.ExaminationForMedicalAdviseList = examinationForMedicalAdvisePOCOs;
		}

		public List<ExaminationForMedicalAdvisePOCO> ExaminationForMedicalAdviseList { get; set; }
	}


}
