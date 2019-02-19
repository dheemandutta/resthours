using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.Compliance
{
    //public class Crew
    //{
    //    public Crew(int iD, string name)
    //    {
    //        ID = iD;
    //        Name = name;
    //    }

    //    public int ID { get; set; }
    //    public string Name { get; set; }
    //}

    public class Compliance24Hrs
    {
        public bool IsCompliant { get; set; }
        public bool IsTechnicalNC { get; set; }
        public bool IsValidTotalRestHours { get; set; }
        public double TotalRestHours { get; set; }
        public string TotalRestHoursStatus { get; set; }
        public bool IsValidMaxRestPeriod { get; set; }
        public double MaxRestPeriod { get; set; }
        public string MaxRestPeriodStatus { get; set; }
        public bool IsValidMaxNrOfRestPeriod { get; set; }
        public int MaxNrOfRestPeriod { get; set; }
        public string MaxNrOfRestPeriodStatus { get; set; }
    }

    public class Compliance7Days
    {
        public bool IsCompliant { get; set; }
        public double TotalWorkHours { get; set; }
        public double TotalRestHours { get; set; }
        public string StatusMessage { get; set; }
    }

    public class ComplianceInfo
    {
        public bool IsCompliant { get; set; }
        public bool IsTechnicalNC { get; set; }
        public bool IsSevenDaysCompliant { get; set; }
        public bool Is24HoursCompliant { get; set; }
        public bool PaintOrange { get; set; }
        public Compliance24Hrs TwentyFourHourCompliance;
        public Compliance7Days SevenDaysCompliance;
        public DateTime ComplianceDate { get; set; }
    }

    public class Regime
    {

        public int ID { get; set; }
        public string Name { get; set; }
        public double MinTotalRestIn7Days { get; set; }
        public double MaxTotalWorkIn24Hours { get; set; }
        public double MinContRestIn24Hours { get; set; }
        public double MinTotalRestIn24Hours { get; set; }
        public double MaxTotalWorkIn7Days { get; set; }
        public int OPA90 { get; set; }
        public int ManilaExceptions { get; set; }
        public int CheckOnlyWorkHours { get; set; }
    }

    public class WorkHours
    {
        public WorkHours(int iD, int crewID, DateTime enteredDate, string[] sessions)
        {
            ID = iD;
            CrewID = crewID;
            EnteredDate = enteredDate;
            Sessions = sessions;
        }

        public int ID { get; set; }
        public int CrewID { get; set; }
        public DateTime EnteredDate { get; set; }
        public string[] Sessions { get; set; }
    }

    public class NCDetails
    {
        public NCDetails(int iD, int crewID, string compliance, float nCHours)
        {
            ID = iD;
            CrewID = crewID;
            Compliance = compliance;
            NCHours = nCHours;
        }

        public int ID { get; set; }
        public int CrewID { get; set; }
        public string Compliance { get; set; }
        public float NCHours { get; set; }

    }
}
