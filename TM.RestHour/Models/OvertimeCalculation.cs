using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TM.RestHour.Models
{
    public class OvertimeCalculation
    {
        public int Id { get; set; }
        public int DailyWorkHours { get; set; }
        public int HourlyRate { get; set; }
        public Boolean HoursPerWeekOrMonth { get; set; }
        public int FixedOvertime { get; set; }
        public int VesselId { get; set; }

        public WorkingHours WorkingHours { get; set; }

        //List<WorkingHours> workingHours;
        //public OvertimeCalculation()
        //{
        //    workingHours = new List<WorkingHours>();
        //    this.WorkingHours = workingHours;

        //}
    }
}