using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TM.Base.Entities;

namespace TM.RestHour.DAL
{
    public class MentalHealthDAL
    {
        public List<MentalHealthPOCO> GetMentalHealthPageWise(int pageIndex, ref int recordCount, int length, int VesselID)
        {
            //MentalHealthDAL mentalHealthDAL = new MentalHealthDAL();
            //return mentalHealthDAL.GetMentalHealthPageWise(pageIndex, ref recordCount, length, VesselID);

            List<MentalHealthPOCO> mentalHealthPOCOs = new List<MentalHealthPOCO>();
            return mentalHealthPOCOs;
        }
    }
}
