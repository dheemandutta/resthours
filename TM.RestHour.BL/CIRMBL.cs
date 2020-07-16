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
    }
}
