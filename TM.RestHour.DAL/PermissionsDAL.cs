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
    public class PermissionsDAL
    {
        public List<PermissionsPOCO> GetParentNodes( int VesselID)
        {
            List<PermissionsPOCO> prodPOList = new List<PermissionsPOCO>();
            List<PermissionsPOCO> prodPO = new List<PermissionsPOCO>();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetParentNodes", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    //cmd.Parameters.AddWithValue("@ID", ID);
                    cmd.Parameters.AddWithValue("@VesselID", VesselID);
                    con.Open();

                    DataSet ds = new DataSet();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    //prodPOList = Common.CommonDAL.ConvertDataTable<ProductPOCO>(ds.Tables[0]);
                    con.Close();

                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        prodPOList.Add(new PermissionsPOCO
                        {
                            ID = Convert.ToInt32(dr["ID"]),
                            PermissionName = Convert.ToString(dr["PermissionName"]),
                           // PermissionsPOCOList = Convert.ToString(dr["PermissionName"]),
                            ChildPermissions = GetChildNodes(Convert.ToInt32(dr["ID"]), VesselID)

                        });
                    }
                }
            }

            return prodPOList;
        }

        private  List<PermissionsPOCO> GetChildNodes(int ID, int VesselID)
        {
            List<PermissionsPOCO> prodPOList = new List<PermissionsPOCO>();
            List<PermissionsPOCO> prodPO = new List<PermissionsPOCO>();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetChildNodes", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@ID", ID);
                    cmd.Parameters.AddWithValue("@VesselID", VesselID);
                    con.Open();

                    DataSet ds = new DataSet();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    //prodPOList = Common.CommonDAL.ConvertDataTable<ProductPOCO>(ds.Tables[0]);
                    con.Close();

                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        prodPOList.Add(new PermissionsPOCO
                        {
                            ID = Convert.ToInt32(dr["ID"]),
                            PermissionName = Convert.ToString(dr["PermissionName"]),
                            // PermissionsPOCOList = Convert.ToString(dr["PermissionName"]),
                            ChildPermissions = GetChildNodes(Convert.ToInt32(dr["ID"]), VesselID)
                        });
                    }
                }
            }

            return prodPOList;
        }
    }
}
