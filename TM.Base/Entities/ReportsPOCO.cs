using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace TM.Base.Entities
{
    public class ReportsPOCO
    {
        public int ID { get; set; }
        public int CrewID { get; set; }
        public DateTime ValidOn { get; set; }
        public string Hours { get; set; }

        public bool HasOneFirst { get; set; }
        public bool HasThirtyFirst { get; set; }
        public string SelectedMonthYear { get; set; }
        public int isNonCompliant { get; set; }
        public int MinTotalRestIn7Days { get; set; }
        public int Month { get; set; }

		public string RegimeName { get; set; }

		public int Year { get; set; }

        public string BookDate { get; set; }

        public string FirstName { get; set; }

        public string LastName { get; set; }

        public string RankName { get; set; }

        public string MonthName { get; set; }

        public double NormalWorkingHours { get; set; }

		public string NCComments { get; set; }

		public string WorkDate { get; set; }

        public string Comment { get; set; }
        public string ComplianceInfo { get; set; }
        public string FomattedComplianceInfo { get; set; }
        public float TotalNCHours { get; set; }
		public bool IsWithinServiceTerm { get; set; }
		public string MaxNRRestPeriodStatus { get; set; }
        public string MaxRestPeriodStatus { get; set; }
        public string SevenDayStatus { get; set; }
        public string TwentFourHourRestHourStatus { get; set; }
        public string MinSevenDayRest { get; set; } //min 7
        public string MinTwentyFourHourrest { get; set; } //rest
        public string MaxRestPeriodInTwentyFourHours { get; set; } //min 24
        public string MaxNrOfrestPeriod { get; set; }
        public string TotalWorkedHours { get; set; }
        public string OvertimeHours { get; set; }
        public string TotalNormalHours { get; set; }
        public string TotalOvertimeHours { get; set; }
        public string TotalHours { get; set; }
        public string TotalRestHours { get; set; }
        public string AdjustmentFactor { get; set; }
        public string Name { get; set; }
        public string Nationality { get; set; }

        public string DateNumber { get; set; }

        public int NCDetailsID { get; set; }

		public string RegimeSymbol { get; set; }
        public string Comments { get; set; }
        public bool IsApproved { get; set; }

    }
}
