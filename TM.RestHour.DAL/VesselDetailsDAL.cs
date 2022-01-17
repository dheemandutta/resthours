using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TM.Base.Entities;

namespace TM.RestHour.DAL
{

    public class VesselDetailsDAL
    {
        public int SaveVesselDetails(VesselDetailsPOCO vesselDetails /*, int VesselID*/)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpSaveVesselDetails", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@VesselName", vesselDetails.VesselName.ToString());
            if (!String.IsNullOrEmpty(vesselDetails.CallSign))
            {
                cmd.Parameters.AddWithValue("@CallSign", vesselDetails.CallSign);
            }
            else
            {
                cmd.Parameters.AddWithValue("@CallSign", DBNull.Value);
            }

            
              if (!String.IsNullOrEmpty(vesselDetails.DateOfReportingGMT))
            {
                cmd.Parameters.AddWithValue("@DateOfReportingGMT", vesselDetails.DateOfReportingGMT);
            }
            else
            {
                cmd.Parameters.AddWithValue("@DateOfReportingGMT", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(vesselDetails.TimeOfReportingGMT))
            {
                cmd.Parameters.AddWithValue("@TimeOfReportingGMT", vesselDetails.TimeOfReportingGMT);
            }
            else
            {
                cmd.Parameters.AddWithValue("@TimeOfReportingGMT", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(vesselDetails.PresentLocation))
            {
                cmd.Parameters.AddWithValue("@PresentLocation", vesselDetails.PresentLocation);
            }
            else
            {
                cmd.Parameters.AddWithValue("@PresentLocation", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(vesselDetails.Course))
            {
                cmd.Parameters.AddWithValue("@Course", vesselDetails.Course);
            }
            else
            {
                cmd.Parameters.AddWithValue("@Course", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(vesselDetails.Speed))
            {
                cmd.Parameters.AddWithValue("@Speed", vesselDetails.Speed);
            }
            else
            {
                cmd.Parameters.AddWithValue("@Speed", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(vesselDetails.PortOfDeparture))
            {
                cmd.Parameters.AddWithValue("@PortOfDeparture", vesselDetails.PortOfDeparture);
            }
            else
            {
                cmd.Parameters.AddWithValue("@PortOfDeparture", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(vesselDetails.PortOfArrival))
            {
                cmd.Parameters.AddWithValue("@PortOfArrival", vesselDetails.PortOfArrival);
            }
            else
            {
                cmd.Parameters.AddWithValue("@PortOfArrival", DBNull.Value);
            }

            
              if (!String.IsNullOrEmpty(vesselDetails.ETADateGMT))
            {
                cmd.Parameters.AddWithValue("@ETADateGMT", vesselDetails.ETADateGMT);
            }
            else
            {
                cmd.Parameters.AddWithValue("@ETADateGMT", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(vesselDetails.ETATimeGMT))
            {
                cmd.Parameters.AddWithValue("@ETATimeGMT", vesselDetails.ETATimeGMT);
            }
            else
            {
                cmd.Parameters.AddWithValue("@ETATimeGMT", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(vesselDetails.AgentDetails))
            {
                cmd.Parameters.AddWithValue("@AgentDetails", vesselDetails.AgentDetails);
            }
            else
            {
                cmd.Parameters.AddWithValue("@AgentDetails", DBNull.Value);
            }

            
            if (!String.IsNullOrEmpty(vesselDetails.NearestPortETADateGMT))
            {
                cmd.Parameters.AddWithValue("@NearestPortETADateGMT", vesselDetails.NearestPortETADateGMT);
            }
            else
            {
                cmd.Parameters.AddWithValue("@NearestPortETADateGMT", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(vesselDetails.NearestPortETATimeGMT))
            {
                cmd.Parameters.AddWithValue("@NearestPortETATimeGMT", vesselDetails.NearestPortETATimeGMT);
            }
            else
            {
                cmd.Parameters.AddWithValue("@NearestPortETATimeGMT", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(vesselDetails.WindSpeed))
            {
                cmd.Parameters.AddWithValue("@WindSpeed", vesselDetails.WindSpeed);
            }
            else
            {
                cmd.Parameters.AddWithValue("@WindSpeed", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(vesselDetails.Sea))
            {
                cmd.Parameters.AddWithValue("@Sea", vesselDetails.Sea);
            }
            else
            {
                cmd.Parameters.AddWithValue("@Sea", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(vesselDetails.Visibility))
            {
                cmd.Parameters.AddWithValue("@Visibility", vesselDetails.Visibility);
            }
            else
            {
                cmd.Parameters.AddWithValue("@Visibility", DBNull.Value);
            }
            if (!String.IsNullOrEmpty(vesselDetails.Swell))
            {
                cmd.Parameters.AddWithValue("@Swell", vesselDetails.Swell);
            }
            else
            {
                cmd.Parameters.AddWithValue("@Swell", DBNull.Value);
            }





            ///////////////////////////////////////////////////////////////
            if (!String.IsNullOrEmpty(vesselDetails.PortOfRegistry))
            {
                cmd.Parameters.AddWithValue("@PortOfRegistry", vesselDetails.PortOfRegistry);
            }
            else
            {
                cmd.Parameters.AddWithValue("@PortOfRegistry", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(vesselDetails.HelicopterDeck))
            {
                cmd.Parameters.AddWithValue("@HelicopterDeck", vesselDetails.HelicopterDeck);
            }
            else
            {
                cmd.Parameters.AddWithValue("@HelicopterDeck", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(vesselDetails.HelicopterWinchingArea))
            {
                cmd.Parameters.AddWithValue("@HelicopterWinchingArea", vesselDetails.HelicopterWinchingArea);
            }
            else
            {
                cmd.Parameters.AddWithValue("@HelicopterWinchingArea", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(vesselDetails.Length))
            {
                cmd.Parameters.AddWithValue("@Length", vesselDetails.Length);
            }
            else
            {
                cmd.Parameters.AddWithValue("@Length", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(vesselDetails.Breadth))
            {
                cmd.Parameters.AddWithValue("@Breadth", vesselDetails.Breadth);
            }
            else
            {
                cmd.Parameters.AddWithValue("@Breadth", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(vesselDetails.PAndIClub))
            {
                cmd.Parameters.AddWithValue("@PAndIClub", vesselDetails.PAndIClub);
            }
            else
            {
                cmd.Parameters.AddWithValue("@PAndIClub", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(vesselDetails.PAndIClubOther))
            {
                cmd.Parameters.AddWithValue("@PAndIClubOther", vesselDetails.PAndIClubOther);
            }
            else
            {
                cmd.Parameters.AddWithValue("@PAndIClubOther", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(vesselDetails.ContactDetails))
            {
                cmd.Parameters.AddWithValue("@ContactDetails", vesselDetails.ContactDetails);
            }
            else
            {
                cmd.Parameters.AddWithValue("@ContactDetails", DBNull.Value);
            }
            ////////////////////////////////////////////

            //cmd.Parameters.AddWithValue("@VesselID", VesselID);

            if (vesselDetails.ID > 0)
            {
                cmd.Parameters.AddWithValue("@ID", vesselDetails.ID);
            }
            else
            {
                cmd.Parameters.AddWithValue("@ID", DBNull.Value);
            }
            int recordsAffected = cmd.ExecuteNonQuery();
            con.Close();

            return recordsAffected;
        }



    }
}
