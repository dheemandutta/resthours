using TM.RestHour.DAL;
using TM.Base.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.RestHour.BL
{
    public class OvertimeCalculationBL
    {
        public OvertimeCalculationPOCO GetOvertimeCalculation(/*int Id, int VesselID*/)
        {
            OvertimeCalculationDAL overtimeCalculationDAL = new OvertimeCalculationDAL();
            return overtimeCalculationDAL.GetOvertimeCalculation(/*Id, VesselID*/);
        }

        public int SaveOvertimeCalculation(OvertimeCalculationPOCO overtimeCalculationPOCO, int VesselID)
        {
            OvertimeCalculationDAL overtimeCalculationDAL = new OvertimeCalculationDAL();
            return overtimeCalculationDAL.SaveOvertimeCalculation(overtimeCalculationPOCO, VesselID);
        }






        public OvertimeCalculationPOCO GetWorkingHoursForOvertime(/*int Id, int VesselID*/)
        {
            OvertimeCalculationDAL overtimeCalculationDAL = new OvertimeCalculationDAL();
            return overtimeCalculationDAL.GetWorkingHoursForOvertime(/*Id, VesselID*/);
        }

        public int SaveWorkingHours(OvertimeCalculationPOCO overtimeCalculationPOCO/*, int VesselID*/)
        {
            OvertimeCalculationDAL overtimeCalculationDAL = new OvertimeCalculationDAL();
            return overtimeCalculationDAL.SaveWorkingHours(overtimeCalculationPOCO/*, VesselID*/);
        }


        public bool GetIsWeeklyFromOvertimeCalculation()
        {
            OvertimeCalculationDAL overtimeCalculationDAL = new OvertimeCalculationDAL();
            return overtimeCalculationDAL.GetIsWeeklyFromOvertimeCalculation();
        }

        public decimal GetFixedOvertimeFromOvertimeCalculation()
        {
            OvertimeCalculationDAL overtimeCalculationDAL = new OvertimeCalculationDAL();
            return overtimeCalculationDAL.GetFixedOvertimeFromOvertimeCalculation();
        }
    }
}