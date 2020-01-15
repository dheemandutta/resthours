using TM.RestHour.DAL;
using TM.Base.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.RestHour.BL
{
    public class ConsultantBL
    {
        //for Speciality drp
        public List<ConsultantPOCO> GetAllSpecialityForDrp(/*int VesselID*/)
        {
            ConsultantDAL consultant = new ConsultantDAL();
            return consultant.GetAllSpecialityForDrp(/*VesselID*/);
        }


        public int SaveDoctorMaster(ConsultantPOCO consultantPOCO /*,int VesselID*/)
        {
            ConsultantDAL consultantDAL = new ConsultantDAL();
            return consultantDAL.SaveDoctorMaster(consultantPOCO/*, VesselID*/);
        }

        public List<ConsultantPOCO> GetDoctorBySpecialityID(string SpecialityID)
        {
            ConsultantDAL consultantDAL = new ConsultantDAL();
            return consultantDAL.GetDoctorBySpecialityID(SpecialityID);
        }

        public int SaveConsultation(ConsultantPOCO consultantPOCO /*,int VesselID*/)
        {
            ConsultantDAL consultantDAL = new ConsultantDAL();
            return consultantDAL.SaveConsultation(consultantPOCO/*, VesselID*/);
        }

        public ConsultantPOCO GetCrewByID(int ID)
        {
            ConsultantDAL consultantDAL = new ConsultantDAL();
            return consultantDAL.GetCrewByID(ID).FirstOrDefault();
        }

        public int SaveMedicalAdvisory(ConsultantPOCO consultantPOCO, int CrewID /*,int VesselID*/)
        {
            ConsultantDAL consultantDAL = new ConsultantDAL();
            return consultantDAL.SaveMedicalAdvisory(consultantPOCO, CrewID/*, VesselID*/);
        }

        public List<ConsultantPOCO> GetMedicalAdvisoryPageWise(int pageIndex, ref int recordCount, int length,int CrewID/*, int VesselID*/)
        {
            ConsultantDAL consultantDAL = new ConsultantDAL();
            return consultantDAL.GetMedicalAdvisoryPageWise(pageIndex, ref recordCount, length, CrewID/*, VesselID*/);
        }

        public List<ConsultantPOCO> GetMedicalAdvisoryPageWise2(int pageIndex, ref int recordCount, int length/*, int CrewID*/)
        {
            ConsultantDAL consultantDAL = new ConsultantDAL();
            return consultantDAL.GetMedicalAdvisoryPageWise2(pageIndex, ref recordCount, length/*, CrewID*/);
        }

        public List<ConsultantPOCO> stpGetMedicalAdvisoryListPageWise2(int pageIndex, ref int recordCount, int length/*, int CrewID*/)
        {
            ConsultantDAL consultantDAL = new ConsultantDAL();
            return consultantDAL.stpGetMedicalAdvisoryListPageWise2(pageIndex, ref recordCount, length/*, CrewID*/);
        }
    }
}