using TM.RestHour.DAL;
using TM.Base.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.RestHour.BL
{
    public class MentalHealthBL
    {
        public List<MentalHealthPOCO> GetMentalHealthPageWise(int pageIndex, ref int recordCount, int length, int VesselID)
        {
            MentalHealthDAL mentalHealthDAL = new MentalHealthDAL();
            return mentalHealthDAL.GetMentalHealthPageWise(pageIndex, ref recordCount, length, VesselID);
        }
    }
}
