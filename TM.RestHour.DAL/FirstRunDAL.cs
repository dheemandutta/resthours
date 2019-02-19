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
    public class FirstRunDAL
    {
        public List<ShipPOCO> ValidateFirstRun(ref string msg)
        {

            List<ShipPOCO> shipPOList = new List<ShipPOCO>();
            List<ShipPOCO> shipPO = new List<ShipPOCO>();

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpValidateFirstRun", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@Msg", SqlDbType.Int, 4);
                    cmd.Parameters["@Msg"].Direction = ParameterDirection.Output;
                    con.Open();

                    DataSet ds = new DataSet();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);

                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        shipPOList.Add(new ShipPOCO
                        {
                            //ID = Convert.ToInt32(dr["ID"]),
                            //ShipName = Convert.ToString(dr["ShipName"])
                        });
                    }
                    // msg = Convert.ToInt32(cmd.Parameters["@Msg"].Value);
                       msg = Convert.ToString(cmd.Parameters["@Msg"].Value);
                    con.Close();
                }
            }
            return shipPOList;
        }
    }
}
