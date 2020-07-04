using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.Base.Entities
{
   public class CrewTimesheetPOCO
    {
       public CrewTimesheetPOCO()
       {
           last7DaysBookedHours = new string[384];
           last7DaysBookedHoursWithNullValue = new string[384];
			last7DaysBookedHoursReversed = new string[336];
			last7DaysBookedHoursReversedWithZeroValues = new string[336];
			BookedHours = new int[48];
            ActualHours = string.Empty;
            NCDetails = new NonCompliancePOCO();
       } 
       
       public CrewPOCO Crew { get; set; }

        public int[] BookedHours { get; set; }

        public DateTime BookDate { get; set; }

		public string ValidOn { get; set; }

		public DayOfWeek DayOfWeek { get; set; }

        public string ActualHours { get; set; }

		public int? WorkSessionId { get; set; }

		public string[] last7DaysBookedHours { get; set; }

		public string[] last7DaysBookedHoursReversed { get; set; }

		public string[] last7DaysBookedHoursReversedWithZeroValues { get; set; }

		public string[] last7DaysBookedHoursWithNullValue { get; set; }

        public int Increament { get; set; }

        public string Comment { get; set; }

        public int ID { get; set; }

        public string AdjustmentFactor { get; set; }

        public NonCompliancePOCO NCDetails { get; set; }

        public int DayUpdate { get; set; }

        public int NCDetailsID { get; set; }

        public int isNonCompliant { get; set; }

        public bool IsTechnicalNC { get; set; }

        public bool IsSevenDaysCompliant { get; set; }

        public bool Is24HoursCompliant { get; set; }

        public bool PaintOrange { get; set; }

        public int Month { get; set; }
        public int Year { get; set; }

		public List<int> NcDay { get; set; }

        public int RegimeID { get; set; }





        public int RankID { get; set; }
        public string RankName { get; set; }
    }
}

