using TM.RestHour.DAL;
using TM.Base.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.RestHour.BL
{
    public class OptionsBL
    {
        public int SaveTimeAdjustment(OptionsPOCO options,int VesselID)
        {
            OptionsDAL optionsDAL = new OptionsDAL();
            return optionsDAL.SaveTimeAdjustment(options, VesselID);
        }

        public OptionsPOCO GetTimeAdjustment(DateTime  bookDate, int VesselID)
        {
            OptionsDAL regimes = new OptionsDAL();
            return regimes.GetTimeAdjustment(bookDate, VesselID);
        }
    }
}
