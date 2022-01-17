using TM.RestHour.DAL;
using TM.Base.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.RestHour.BL
{
    public class CIRMBL
    {
        public int SaveCIRM(CIRMPOCO cIRM ,int VesselID)
        {
            CIRMDAL cIRMDAL = new CIRMDAL();
            return cIRMDAL.SaveCIRM(cIRM , VesselID);
        }

        public CIRMPOCO GetCIRMByCrewId(int CrewId)
        {
            CIRMDAL cIRMDAL = new CIRMDAL();
            return cIRMDAL.GetCIRMByCrewId(CrewId).FirstOrDefault();
        }


        public ShipPOCO GetCrewForCIRMPatientDetails()
        {
            CIRMDAL cIRMDAL = new CIRMDAL();
            ShipPOCO ship = new ShipPOCO();

            return cIRMDAL.GetCrewForCIRMPatientDetails().FirstOrDefault();
            //ship = shipDAL.GetCrewForCIRMPatientDetails().FirstOrDefault();
            //ship.IMONumber = ship.IMONumber.Substring(ship.IMONumber.Length - 7);
            //return ship;
        }

        public ShipPOCO GetCrewForCIRMPatientDetailsByCrew(int ID)
        {
            CIRMDAL cIRMDAL = new CIRMDAL();
            return cIRMDAL.GetCrewForCIRMPatientDetailsByCrew(ID).FirstOrDefault();
        }
        /// <summary>
        /// Added on 7th Jan 2022 @BK
        /// </summary>
        /// <param name="ID"></param>
        /// <param name="vesselId"></param>
        /// <returns></returns>
        public CIRMPOCO GetCIRMPatientDetailsByCrew(int ID,int vesselId)
        {
            CIRMDAL cIRMDAL = new CIRMDAL();
            return cIRMDAL.GetCIRMPatientDetailsByCrew(ID, vesselId);
        }
        /// <summary>
        ///  Added on 7th Jan 2022 @BK
        /// </summary>
        /// <param name="ID"></param>
        /// <returns></returns>
        public List<VitalStatisticsPOCO> GetVitalStatisticsByCIRM(int ID)
        {
            CIRMDAL cIRMDAL = new CIRMDAL();
            return cIRMDAL.GetVitalStatisticsByCIRM(ID);
        }

        /// <summary>
        ///  Added on 7th Jan 2022 @BK
        /// </summary>
        /// <param name="ID"></param>
        /// <returns></returns>
        public List<MedicalSymtomologyPOCO> GetMedicalSymtomologyByCIRM(int ID)
        {
            CIRMDAL cIRMDAL = new CIRMDAL();
            return cIRMDAL.GetMedicalSymtomologyByCIRM(ID);
        }
        /// <summary>
        /// Added on 11th Jan 2022 @BK
        /// </summary>
        /// <param name="vitaPoco"></param>
        /// <returns></returns>
        public int SaveCIRMVitalParams(VitalStatisticsPOCO vitaPoco)
        {
            CIRMDAL cIRMDAL = new CIRMDAL();
            return cIRMDAL.SaveCIRMVitalParams(vitaPoco);
        }
        /// <summary>
        /// Added on 11th Jan 2022 @BK
        /// </summary>
        /// <param name="symPoco"></param>
        /// <returns></returns>
        public int SaveCIRMSymtomology(MedicalSymtomologyPOCO symPoco)
        {
            CIRMDAL cIRMDAL = new CIRMDAL();
            return cIRMDAL.SaveCIRMSymtomology(symPoco);
        }

        public List<VitalStatisticsPOCO> GetAllCIRMVitalParamsPageWise(int pageIndex, ref int recordCount, int length, int shipId)
        {
            CIRMDAL dal = new CIRMDAL();
            return dal.GetAllCIRMVitalParamsPageWise(pageIndex, ref recordCount, length,  shipId);
        }
        public List<MedicalSymtomologyPOCO> GetAllCIRMSymtomologyPageWise(int pageIndex, ref int recordCount, int length, int shipId)
        {
            CIRMDAL dal = new CIRMDAL();
            return dal.GetAllCIRMSymtomologyPageWise(pageIndex, ref recordCount, length,shipId);
        }
    }
}
