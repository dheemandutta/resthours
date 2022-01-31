using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.Base.Entities
{
    public class OvertimeCalculationPOCO
    {
        public int Id { get; set; }
        public int? DailyWorkHours { get; set; }
        public int? HourlyRate { get; set; }
        public Boolean? HoursPerWeekOrMonth { get; set; }
        public int? FixedOvertime { get; set; }
        public int VesselId { get; set; }



        public WorkingHoursPOCO WorkingHoursPOCO { get; set; }

        public Boolean IsWeekly { get; set; }

        //List<WorkingHoursPOCO> workingHoursPOCO;
        //public OvertimeCalculationPOCO()
        //{
        //    workingHoursPOCO = new List<WorkingHoursPOCO>();
        //    this.WorkingHoursPOCO = workingHoursPOCO;

        //}
    }
}
