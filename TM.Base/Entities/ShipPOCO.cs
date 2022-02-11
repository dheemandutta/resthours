using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.Base.Entities
{
    public class ShipPOCO
    {
        public int ID { get; set; }
        public string ShipName { get; set; }
        public string IMONumber { get; set; }
        public string FlagOfShip { get; set; }
        public string Regime { get; set; }

        public string SuperAdminUserName { get; set; }
        public string SuperAdminPassword { get; set; }

        public string Vessel { get; set; }
        public string Flag { get; set; }
        public int IMO { get; set; }
        public string AdminUser { get; set; }
        public string AdminPassword { get; set; }

        public string SmtpServer { get; set; }
        public string Port { get; set; }
        public string MailFrom { get; set; }
        public string MailTo { get; set; }
        public string MailPassword { get; set; }
        public string AttachmentSize { get; set; }

        public string DeactivationDate { get; set; }

        public string ShipEmail { get; set; }
        public string ShipEmailPassword { get; set; }
        public string AdminCenterEmail { get; set; }
        public string POP3 { get; set; }
        public string POP3Port { get; set; }





        public string Description { get; set; }
        public int VesselSubTypeID { get; set; }
        public string VesselSubSubTypeDecsription { get; set; }
        public int VesselTypeID { get; set; }
        public string SubTypeDescription { get; set; }
        public int? VesselSubSubTypeID { get; set; }








        public long TimeStamp { get; set; }

        //public DateTime? LastSyncDate { get; set; }
        public string LastSyncDate { get; set; }

        public int? CompanyID { get; set; }

        public string ShipEmail2 { get; set; }

        public string Voices1 { get; set; }

        public string Voices2 { get; set; }

        public string Fax1 { get; set; }

        public string Fax2 { get; set; }

        public string VOIP1 { get; set; }

        public string VOIP2 { get; set; }

        public string Mobile1 { get; set; }

        public string Mobile2 { get; set; }

        public string CommunicationsResources { get; set; }

        //public int? HelicopterDeck { get; set; }

        //public int? HelicopterWinchingArea { get; set; }





        public string CrewName { get; set; }
        public int RankID { get; set; }
        public string Gender { get; set; }
        public int CountryID { get; set; }
        public string DOB { get; set; }
        //13-01-2021 SSG
        public string CreatedOn { get; set; }


        public string IMAPPOP { get; set; }

        #region properties added on 9th Feb 2022 @ BK
        public string CallSign { get; set; }
        public string PortOfRegistry { get; set; }
        public string Length { get; set; }
        public string Breadth { get; set; }
        #endregion

        public string PAndIClub { get; set; }
        public string PAndIClubOther { get; set; }
        public string ContactDetails { get; set; }
        public string HelicopterDeck { get; set; }
        public string HelicopterWinchingArea { get; set; }
    }
}
