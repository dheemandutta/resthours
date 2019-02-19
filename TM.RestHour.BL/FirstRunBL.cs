using TM.RestHour.DAL;
using TM.Base.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.RestHour.BL
{
    public class FirstRunBL
    {
        public List<ShipPOCO> ValidateFirstRun(ref string msg)
        {
            FirstRunDAL firstRunDAL = new FirstRunDAL();
            return firstRunDAL.ValidateFirstRun(ref msg);
        }
    }
}
