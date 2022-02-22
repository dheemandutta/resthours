using TM.RestHour.DAL;
using TM.Base.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.RestHour.BL
{
    public class WellBeingBL
    {
        public WellBeingPOCO GetWellBeingHealthPageWise(int pageIndex, ref int recordCount, int length)
        {
            WellBeingDAL wbDAL = new WellBeingDAL();
            return wbDAL.GetWellBeingHealthPageWise(pageIndex, ref recordCount, length);
        }

        public CrewPOCO GetJoiningMedicalFile(int crewId)
        {
            WellBeingDAL wbDAL = new WellBeingDAL();
            return wbDAL.GetJoiningMedicalFile(crewId);
        }
    }
}
