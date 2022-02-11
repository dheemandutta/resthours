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
        public MentalHealthPOCO GetMentalHealthPageWise(int pageIndex, ref int postJoiningRecordCount, int length, ref int preSignOffRecordCount)
        {
            MentalHealthDAL mentalHealthDAL = new MentalHealthDAL();
            return mentalHealthDAL.GetMentalHealthPageWise(pageIndex, ref postJoiningRecordCount, length, ref preSignOffRecordCount);
        }
    }
}
