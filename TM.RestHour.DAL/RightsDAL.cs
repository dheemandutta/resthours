using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TM.Base.Entities;

namespace TM.RestHour.DAL
{
    public class RightsDAL
    {
        public RightsPOCO GetRightsByCrewId(int CrewId, string PageName, int VesselID, int UserID)
        {
            List<RightsPOCO> prodPOList = new List<RightsPOCO>();
            List<RightsPOCO> prodPO = new List<RightsPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetRightsByCrewId", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@CrewId", CrewId);
                    cmd.Parameters.AddWithValue("@PageName", PageName);
                    con.Open();


                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    //prodPOList = Common.CommonDAL.ConvertDataTable<ProductPOCO>(ds.Tables[0]);
                    con.Close();

                }
            }
            return ConvertDataTableToRightsByCrewIdList(ds, VesselID, UserID);
        }

        public List<CrewPOCO> AppendCrew(int VesselID, int UserID)
        {
            List<CrewPOCO> crewPOCOs = new List<CrewPOCO>();
            
            TimeSheetDAL timesheetdal = new TimeSheetDAL();
            crewPOCOs = timesheetdal.GetAllCrewForDrp(VesselID, UserID);

            return crewPOCOs;
        }

        private RightsPOCO ConvertDataTableToRightsByCrewIdList(DataSet ds, int VesselID, int UserID)
        {
            RightsPOCO rightsPOCO = new RightsPOCO();
            List<RightsListPOCO> rightsListPOCO = new List<RightsListPOCO>();
            //check if there is at all any data
            if (ds.Tables.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    RightsListPOCO rightsList = new RightsListPOCO();

                    if (item["Id"] != System.DBNull.Value)
                        rightsList.Id = Convert.ToInt32(item["Id"].ToString());

                    if (item["ResourceName"] != System.DBNull.Value)
                        rightsList.ResourceName = item["ResourceName"].ToString();

                    if (item["ParentId"] != System.DBNull.Value)
                        rightsList.ParentId = Convert.ToInt32(item["ParentId"].ToString());

                    if (item["HasAccess"] != System.DBNull.Value)
                        rightsList.HasAccess = Convert.ToBoolean(item["HasAccess"].ToString());


                    rightsListPOCO.Add(rightsList);
                }
            }
            rightsPOCO.RightsList = rightsListPOCO;
            List<CrewPOCO> crewPOCOs = new List<CrewPOCO>();
            crewPOCOs = AppendCrew(VesselID, UserID);
            rightsPOCO.CrewList = crewPOCOs;

            return rightsPOCO;
        }

    }
}
