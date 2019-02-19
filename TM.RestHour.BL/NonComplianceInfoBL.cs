using TM.RestHour.DAL;
using TM.Base.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using System.Xml.Linq;

namespace TM.RestHour.BL
{
    public class NonComplianceInfoBL
    {
        public NonComplianceInfoPOCO GetNonComplianceInfo(int NCDetailsID, int VesselID)
        {
            NonComplianceInfoDAL nonComplianceInfoDAL = new NonComplianceInfoDAL();
            NonComplianceInfoPOCO nc = new NonComplianceInfoPOCO();
            nc =nonComplianceInfoDAL.GetNonComplianceInfo(NCDetailsID, VesselID).FirstOrDefault();
            string ncdetails = string.Empty;
            var str = XElement.Parse(nc.ComplianceInfo);
            if (!str.Element("maxnrrestperiodstatus").IsEmpty)
            {
                ncdetails = str.Element("maxnrrestperiodstatus").Value;
                ncdetails += Environment.NewLine;
            }
            if (!str.Element("maxrestperiodstatus").IsEmpty)
            {
                ncdetails += str.Element("maxrestperiodstatus").Value;
                ncdetails += Environment.NewLine;
            }
            if (!str.Element("sevendaysstatus").IsEmpty)
            {


                ncdetails += str.Element("sevendaysstatus").Value;
                ncdetails += Environment.NewLine;
            }
            if (!str.Element("twentyfourhourresthoursstatus").IsEmpty)
            {
                ncdetails += str.Element("twentyfourhourresthoursstatus").Value;
                ncdetails += Environment.NewLine;
            }

            nc.ComplianceInfo = ncdetails;
            return nc;

        }
    }
}
