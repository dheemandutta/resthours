using TM.RestHour.DAL;
using TM.Base.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.RestHour.BL
{
    public class RanksBL
    {
        public int SaveRanks(RanksPOCO ranksPOCO,int VesselID)
        {
            RanksDAL ranksDAL = new RanksDAL();
            return ranksDAL.SaveRanks(ranksPOCO, VesselID);
        }

		public int GetGroupFromRank(int rankId, int VesselID)
		{
			RanksDAL ranksDAL = new RanksDAL();
			return ranksDAL.GetGroupFromRank(rankId, VesselID);
		}

			public List<RanksPOCO> GetRanksPageWise(int pageIndex, ref int recordCount, int length, int VesselID)
        {
            RanksDAL ranksDAL = new RanksDAL();
            return ranksDAL.GetRanksPageWise(pageIndex, ref recordCount, length, VesselID);
        }

        public List<CrewPOCO> GetCrewPageWise(int ID, int pageIndex, ref int recordCount, int length,int VesselID)
        {
            RanksDAL ranksDAL = new RanksDAL();
            return ranksDAL.GetCrewPageWise(ID,pageIndex, ref recordCount, length, VesselID);
        }

        public void Update(List<RanksPOCO> rankspocolist,int VesselID)
        {
            RanksDAL ranksDAL = new RanksDAL();
            ranksDAL.Update(rankspocolist, VesselID);
        }

        public RanksPOCO GetRanksByID(int ID, int VesselID)
        {
            RanksDAL ranksDAL = new RanksDAL();
            return ranksDAL.GetRanksByID(ID, VesselID).FirstOrDefault();
        }

        public int DeleteRankByID(int ID)
        {
            RanksDAL ranksDAL = new RanksDAL();
            return ranksDAL.DeleteRankByID(ID);

        }
    }
}
