using TM.RestHour.DAL;
using TM.Base.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.RestHour.BL
{
    public class RegimesBL
    {
        public List<RegimesPOCO> GetDataForRegimes()
        {
            RegimesDAL regimes = new RegimesDAL();
            return regimes.GetDataForRegimes();
        }

        public int SaveRegime(RegimesPOCO regimes, int VesselID)
        {
            RegimesDAL regimesDAL = new RegimesDAL();
            return regimesDAL.SaveRegime(regimes, VesselID);
        }

        public RegimesPOCO GetIsActiveRegime(/*int ID*/)
        {
            RegimesDAL regimesDAL = new RegimesDAL();
            return regimesDAL.GetIsActiveRegime().FirstOrDefault();
        }
    }
}
