using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.Base.Entities
{
    public class VesselDetailsPOCO
    {
        public int ID { get; set; }

        public string VesselName { get; set; }

        public string CallSign { get; set; }

        //public DateTime? DateOfReportingGMT { get; set; }
        public string DateOfReportingGMT { get; set; }

        public string TimeOfReportingGMT { get; set; }

        public string PresentLocation { get; set; }

        public string Course { get; set; }

        public string Speed { get; set; }

        public string PortOfDeparture { get; set; }

        public string PortOfArrival { get; set; }

        //public DateTime? ETADateGMT { get; set; }
        public string ETADateGMT { get; set; }

        public string ETATimeGMT { get; set; }

        public string AgentDetails { get; set; }

        //public DateTime? NearestPortETADateGMT { get; set; }
        public string NearestPortETADateGMT { get; set; }

        public string NearestPortETATimeGMT { get; set; }

        public string WindSpeed { get; set; }

        public string Sea { get; set; }

        public string Visibility { get; set; }

        public string Swell { get; set; }





        public string PortOfRegistry { get; set; }
        public string HelicopterDeck { get; set; }
        public string HelicopterWinchingArea { get; set; }
        public string Length { get; set; }
        public string Breadth { get; set; }
        public string PAndIClub { get; set; }
        public string PAndIClubOther { get; set; }
        public string ContactDetails { get; set; }
    }
}
