using TM.RestHour.DAL;
using TM.Base.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.RestHour.BL
{
   public  class CrewListReportBL
    {
        public List<CrewPOCO> GetCrewReportListPageWise(int pageIndex, ref int recordCount, int length, int VesselID)
        {
            CrewListReportDAL crew = new CrewListReportDAL();
            return crew.GetCrewReportListPageWise(pageIndex, ref recordCount, length, VesselID);
        }

        public List<CrewPOCO> GetCrewReportListPageWise2(int pageIndex, ref int recordCount, int length, int VesselID)
        {
            CrewListReportDAL crew = new CrewListReportDAL();
            return crew.GetCrewReportListPageWise2(pageIndex, ref recordCount, length, VesselID);
        }
    }
}
