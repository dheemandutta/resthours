using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TM.RestHour.Models
{
    public class Regimes
    {
        public int ID { get; set; }
        public string RegimeName { get; set; }
        public string Description { get; set; }
        public string Basis { get; set; }
        public float MinTotalRestIn7Days { get; set; }
        public float MaxTotalWorkIn24Hours { get; set; }
        public float MinContRestIn24Hours { get; set; }
        public float MinTotalRestIn24Hours { get; set; }
        public float MaxTotalWorkIn7Days { get; set; }
        public Boolean CheckFor2Days { get; set; }
        public Boolean OPA90 { get; set; }
        // public times Timestamp { get; set; }
        public Boolean ManilaExceptions { get; set; }
        public Boolean UseHistCalculationOnly { get; set; }
        public Boolean CheckOnlyWorkHours { get; set; }

        public string ShipName { get; set; }
        public string IMONumber { get; set; }
        public string FlagOfShip { get; set; }
        public string Regime { get; set; }

        public int RegimeID { get; set; }
        public DateTime RegimeStartDate { get; set; }
        public string RegimeStartDate1 { get; set; }
        public int VesselID { get; set; }
    }
}