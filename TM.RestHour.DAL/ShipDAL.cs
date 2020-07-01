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
    public class ShipDAL
    {

		public int UpdateVessel(ShipPOCO ship/*, int VesselID*/)
		{
			SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
			con.Open();
			SqlCommand cmd = new SqlCommand("stpUpdateVessel", con);
			cmd.CommandType = CommandType.StoredProcedure;
			cmd.Parameters.AddWithValue("@ShipName", ship.ShipName.ToString());
			cmd.Parameters.AddWithValue("@IMONumber", ship.IMONumber.ToString());    ////////////////////////////////////////////////////////////////////
			cmd.Parameters.AddWithValue("@FlagOfShip", ship.FlagOfShip.ToString());

            cmd.Parameters.AddWithValue("@VesselTypeID", ship.VesselTypeID.ToString());
            cmd.Parameters.AddWithValue("@VesselSubTypeID", ship.VesselSubTypeID.ToString());    
            cmd.Parameters.AddWithValue("@VesselSubSubTypeID", ship.VesselSubSubTypeID.ToString());

            if (!String.IsNullOrEmpty(ship.ShipEmail))
            {
                cmd.Parameters.AddWithValue("@ShipEmail", ship.ShipEmail);
            }
            else
            {
                cmd.Parameters.AddWithValue("@ShipEmail", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(ship.ShipEmail2))
            {
                cmd.Parameters.AddWithValue("@ShipEmail2", ship.ShipEmail2);
            }
            else
            {
                cmd.Parameters.AddWithValue("@ShipEmail2", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(ship.Voices1))
            {
                cmd.Parameters.AddWithValue("@Voices1", ship.Voices1);
            }
            else
            {
                cmd.Parameters.AddWithValue("@Voices1", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(ship.Voices2))
            {
                cmd.Parameters.AddWithValue("@Voices2", ship.Voices2);
            }
            else
            {
                cmd.Parameters.AddWithValue("@Voices2", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(ship.Fax1))
            {
                cmd.Parameters.AddWithValue("@Fax1", ship.Fax1);
            }
            else
            {
                cmd.Parameters.AddWithValue("@Fax1", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(ship.Fax2))
            {
                cmd.Parameters.AddWithValue("@Fax2", ship.Fax2);
            }
            else
            {
                cmd.Parameters.AddWithValue("@Fax2", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(ship.VOIP1))
            {
                cmd.Parameters.AddWithValue("@VOIP1", ship.VOIP1);
            }
            else
            {
                cmd.Parameters.AddWithValue("@VOIP1", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(ship.VOIP2))
            {
                cmd.Parameters.AddWithValue("@VOIP2", ship.VOIP2);
            }
            else
            {
                cmd.Parameters.AddWithValue("@VOIP2", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(ship.Mobile1))
            {
                cmd.Parameters.AddWithValue("@Mobile1", ship.Mobile1);
            }
            else
            {
                cmd.Parameters.AddWithValue("@Mobile1", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(ship.Mobile2))
            {
                cmd.Parameters.AddWithValue("@Mobile2", ship.Mobile2);
            }
            else
            {
                cmd.Parameters.AddWithValue("@Mobile2", DBNull.Value);
            }

            //cmd.Parameters.AddWithValue("@VesselID", VesselID);

            int recordsAffected = cmd.ExecuteNonQuery();
			con.Close();

			return recordsAffected;
		}

		public int SaveShip(ShipPOCO ship,int VesselID)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpSaveShipDetails", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@ShipName", ship.ShipName.ToString());
            cmd.Parameters.AddWithValue("@IMONumber", ship.IMONumber.ToString());    ////////////////////////////////////////////////////////////////////
            cmd.Parameters.AddWithValue("@FlagOfShip", ship.FlagOfShip.ToString());
            cmd.Parameters.AddWithValue("@VesselID", VesselID);
            //cmd.Parameters.AddWithValue("@Regime", ship.Regime.ToString());

            if (ship.ID > 0)
            {
                cmd.Parameters.AddWithValue("@ID", ship.ID);
            }
            else
            {
                cmd.Parameters.AddWithValue("@ID", DBNull.Value);
            }
            int recordsAffected = cmd.ExecuteNonQuery();
            con.Close();

            return recordsAffected;
        }

        public int SaveNewShip(ShipPOCO ship)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpSaveNewShipDetails", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@ShipName", ship.ShipName.ToString());
            cmd.Parameters.AddWithValue("@IMONumber", ship.IMONumber.ToString());    ////////////////////////////////////////////////////////////////////
            cmd.Parameters.AddWithValue("@FlagOfShip", ship.FlagOfShip.ToString());
            cmd.Parameters.AddWithValue("@SuperAdminUserName", ship.SuperAdminUserName.ToString());
            cmd.Parameters.AddWithValue("@SuperAdminPassword", ship.SuperAdminPassword.ToString());
            //cmd.Parameters.AddWithValue("@VesselID", VesselID);
            //cmd.Parameters.AddWithValue("@Regime", ship.Regime.ToString());

            //if (ship.ID > 0)
            //{
            //    cmd.Parameters.AddWithValue("@ID", ship.ID);
            //}
            //else
            //{
            //    cmd.Parameters.AddWithValue("@ID", DBNull.Value);
            //}
            int recordsAffected = cmd.ExecuteNonQuery();
            con.Close();

            return recordsAffected;
        }

        public List<ShipPOCO> GetAllShip()
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpGetAllShipDetails", con);
            cmd.CommandType = CommandType.StoredProcedure;
            DataSet ds = new DataSet();
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(ds);
            DataTable myTable = ds.Tables[0];
            List<ShipPOCO> ShipList = myTable.AsEnumerable().Select(m => new ShipPOCO()
            {
                ID = m.Field<int>("ID"),
                ShipName = m.Field<string>("ShipName")
               // IMONumber = m.Field<string>("IMONumber"),
                //FlagOfShip = m.Field<string>("FlagOfShip"),
                //Regime = m.Field<string>("Regime"),

            }).ToList();
            con.Close();
            return ShipList;
            

        }

        public List<ShipPOCO> GetShipPageWise(int pageIndex, ref int recordCount, int length)
        {

            List<ShipPOCO> shipPOList = new List<ShipPOCO>();
            List<ShipPOCO> shipPO = new List<ShipPOCO>();

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetShipDetailsPageWise", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
                    cmd.Parameters.AddWithValue("@PageSize", length);
                    cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4);
                    cmd.Parameters["@RecordCount"].Direction = ParameterDirection.Output;
                    con.Open();

                    DataSet ds = new DataSet();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    //prodPOList = Common.CommonDAL.ConvertDataTable<ProductPOCO>(ds.Tables[0]);

                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        shipPOList.Add(new ShipPOCO
                        {
                            ID = Convert.ToInt32(dr["ID"]),
                            ShipName = Convert.ToString(dr["ShipName"]),
                            IMONumber = Convert.ToString(dr["IMONumber"]),
                            FlagOfShip = Convert.ToString(dr["FlagOfShip"])
                        });
                    }
                    recordCount = Convert.ToInt32(cmd.Parameters["@RecordCount"].Value);
                    con.Close();
                }
            }
            return shipPOList;
        }

        

        public int DeleteShip(int ID)
        {

            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpDeleteShipDetails", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@ID", ID);

            int recordsAffected = cmd.ExecuteNonQuery();
            con.Close();

            return recordsAffected;

        }

       

        public List<ShipPOCO> GetShipByID()
        {
            List<ShipPOCO> prodPOList = new List<ShipPOCO>();
            List<ShipPOCO> prodPO = new List<ShipPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetShipDetailsByID", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                   // cmd.Parameters.AddWithValue("@ID", ID);
                    con.Open();
                
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    //prodPOList = Common.CommonDAL.ConvertDataTable<ProductPOCO>(ds.Tables[0]);
                    con.Close();                 
                }
            }
            return ConvertDataTableToShipList(ds);
        }



        private List<ShipPOCO> ConvertDataTableToShipList(DataSet ds)
        {
            List<ShipPOCO> crewtimesheetList = new List<ShipPOCO>();
            //check if there is at all any data
            if (ds.Tables.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    ShipPOCO crewtimesheet = new ShipPOCO();

                    if (item["ID"] != null)
                        crewtimesheet.ID = Convert.ToInt32(item["ID"].ToString());

                    if (item["ShipName"] != null)
                        crewtimesheet.ShipName = item["ShipName"].ToString();

                    if (item["IMONumber"] != null)
                        crewtimesheet.IMONumber = item["IMONumber"].ToString();

                    if (item["FlagOfShip"] != null)
                        crewtimesheet.FlagOfShip = item["FlagOfShip"].ToString();

                    if (item["Regime"] != null)
                        crewtimesheet.Regime = item["Regime"].ToString();



                    if (item["ShipEmail"] != null)
                        crewtimesheet.ShipEmail = item["ShipEmail"].ToString();


                    crewtimesheetList.Add(crewtimesheet);
                }
            }
            return crewtimesheetList;
        }





        //for Ship drp
        public List<ShipPOCO> GetAllShipForDrp()
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("usp_GetAllShipForDrp", con);
            cmd.CommandType = CommandType.StoredProcedure;
            DataSet ds = new DataSet();
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(ds);
            DataTable myTable = ds.Tables[0];
            List<ShipPOCO> ranksList = myTable.AsEnumerable().Select(m => new ShipPOCO()
            {
                ID = m.Field<int>("ID"),
                ShipName = m.Field<string>("ShipName"),

            }).ToList();

            return ranksList;
            con.Close();
        }





       
        ///////////////////////////////////////////////////////////////////////////////////    
        public int SaveInitialShipValues(ShipPOCO ship)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpSaveInitialShipValues", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@Vessel", ship.Vessel.ToString());
            cmd.Parameters.AddWithValue("@Flag", ship.Flag.ToString());    
            cmd.Parameters.AddWithValue("@IMO", ship.IMO.ToString());
            cmd.Parameters.AddWithValue("@AdminUser", ship.AdminUser.ToString());
            cmd.Parameters.AddWithValue("@AdminPassword", ship.AdminPassword.ToString());
            cmd.Parameters.AddWithValue("@DeactivationDate", ship.DeactivationDate);
           
            int recordsAffected = cmd.ExecuteNonQuery();
            con.Close();

            return recordsAffected;
        }

        public int SaveConfigData(ShipPOCO ship)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpSaveConfigData", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@SmtpServer", ship.SmtpServer.ToString());
            cmd.Parameters.AddWithValue("@Port", ship.Port.ToString());
            /////////////////////////////////////////////////////////////////////////////////
            if (!String.IsNullOrEmpty(ship.MailFrom))
            {
                cmd.Parameters.AddWithValue("@MailFrom", ship.MailFrom);
            }
            else
            {
                cmd.Parameters.AddWithValue("@MailFrom", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(ship.MailTo))
            {
                cmd.Parameters.AddWithValue("@MailTo", ship.MailTo);
            }
            else
            {
                cmd.Parameters.AddWithValue("@MailTo", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(ship.MailPassword))
            {
                cmd.Parameters.AddWithValue("@MailPassword", ship.MailPassword);
            }
            else
            {
                cmd.Parameters.AddWithValue("@MailPassword", DBNull.Value);
            }
            //////////////////////////////////////////////////////////////////////////////////
            //cmd.Parameters.AddWithValue("@MailFrom", ship.MailFrom.ToString());
            //cmd.Parameters.AddWithValue("@MailTo", ship.MailTo.ToString());
            //cmd.Parameters.AddWithValue("@MailPassword", ship.MailPassword.ToString());
            //////////////////////////////////////////////////////////////////////////////////
            ///
            //New  --> /MailServerDetails/Index

            cmd.Parameters.AddWithValue("@ShipEmail", ship.ShipEmail.ToString());
            cmd.Parameters.AddWithValue("@ShipEmailPwd", ship.ShipEmailPassword.ToString());
            cmd.Parameters.AddWithValue("@AdminCenterEmail", ship.AdminCenterEmail.ToString());
            cmd.Parameters.AddWithValue("@Pop", ship.POP3.ToString());
            cmd.Parameters.AddWithValue("@PopPort", ship.POP3Port.ToString());

            //cmd.Parameters.AddWithValue("@AttachmentSize", ship.AttachmentSize.ToString());
            //cmd.Parameters.AddWithValue("@VesselID", VesselID);
            //cmd.Parameters.AddWithValue("@Regime", ship.Regime.ToString());

            //if (ship.ID > 0)
            //{
            //    cmd.Parameters.AddWithValue("@ID", ship.ID);
            //}
            //else
            //{
            //    cmd.Parameters.AddWithValue("@ID", DBNull.Value);
            //}
            int recordsAffected = cmd.ExecuteNonQuery();
            con.Close();

            return recordsAffected;
        }






        public string GetConfigData(string KeyName)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpGetAlltblConfig", con);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@KeyName", KeyName);

            DataSet ds = new DataSet();
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(ds);
            con.Close();
            return ds.Tables[0].Rows[0]["ConfigValue"].ToString();

            //if (ds.Tables[0].Rows.Count > 0)
            //{
            //    ds.WriteXml(path + "\\" + ConfigurationManager.AppSettings["Crewxml"].ToString(), XmlWriteMode.WriteSchema);
            //}
        }







        //for VesselType drp
        public List<ShipPOCO> GetVesselTypeForDrp()
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("usp_GetVesselTypeForDrp", con);
            cmd.CommandType = CommandType.StoredProcedure;
            DataSet ds = new DataSet();
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(ds);
            DataTable myTable = ds.Tables[0];
            List<ShipPOCO> ranksList = myTable.AsEnumerable().Select(m => new ShipPOCO()
            {
                VesselTypeID = m.Field<int>("ID"),
                Description = m.Field<string>("Description"),

            }).ToList();

            return ranksList;
            con.Close();

        }

        //for VesselSubTypeByVesselTypeIDForDrp drp
        public List<ShipPOCO> GetVesselSubTypeByVesselTypeIDForDrp(string VesselTypeID)
        {
           // List<ShipPOCO> POCOList = new List<ShipPOCO>();
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("usp_GetVesselSubTypeByVesselTypeIDForDrp", con);
            cmd.Parameters.AddWithValue("@VesselTypeID", VesselTypeID);
            cmd.CommandType = CommandType.StoredProcedure;
            DataSet ds = new DataSet();
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(ds);

            //POCOList = ds.Tables[0].DataTableToList<ShipPOCO>(); 
            DataTable myTable = ds.Tables[0];
            List<ShipPOCO> POCOList = myTable.AsEnumerable().Select(m => new ShipPOCO()
            {
                VesselSubTypeID = m.Field<int>("ID"),
                SubTypeDescription = m.Field<string>("SubTypeDescription"),

            }).ToList();

            return POCOList;
            con.Close();
        }

        //for VesselSubSubTypeByVesselSubTypeIDForDrp drp
        public List<ShipPOCO> GetVesselSubSubTypeByVesselSubTypeIDForDrp(string VesselSubTypeID)
        {
            //List<ShipPOCO> POCOList = new List<ShipPOCO>();
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("usp_GetVesselSubSubTypeByVesselSubTypeIDForDrp", con);
            cmd.Parameters.AddWithValue("@VesselSubTypeID", VesselSubTypeID);
            cmd.CommandType = CommandType.StoredProcedure;
            DataSet ds = new DataSet();
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(ds);

            //POCOList = ds.Tables[0].DataTableToList<ShipPOCO>(); 
            DataTable myTable = ds.Tables[0];
            List<ShipPOCO> POCOList = myTable.AsEnumerable().Select(m => new ShipPOCO()
            {
                VesselSubSubTypeID = m.Field<int>("ID"),
                VesselSubSubTypeDecsription = m.Field<string>("VesselSubSubTypeDecsription"),

            }).ToList();

            return POCOList;
            con.Close();
        }



    }
}
