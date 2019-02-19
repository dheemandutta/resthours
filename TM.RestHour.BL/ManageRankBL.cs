using TM.RestHour.DAL;
using TM.Base.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.RestHour.BL
{
    public class ManageRankBL
    {
        public ManageRankPOCO GetCrewByRankID(int RankID, int VesselID)
        {
            ManageRankDAL shipDAL = new ManageRankDAL();
            return shipDAL.GetCrewByRankID(RankID, VesselID).FirstOrDefault();
        }
    }
}
