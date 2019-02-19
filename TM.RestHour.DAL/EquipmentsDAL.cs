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
    public class EquipmentsDAL
    {
        public int SaveEquipments(EquipmentsPOCO equipments /*,int VesselID*/)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpSavetblEquipments", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@EquipmentsName", equipments.EquipmentsName.ToString());
            //cmd.Parameters.AddWithValue("@Comment", equipments.Comment.ToString());
            if (!String.IsNullOrEmpty(equipments.Comment))
            {
                cmd.Parameters.AddWithValue("@Comment", equipments.Comment);
            }
            else
            {
                cmd.Parameters.AddWithValue("@Comment", DBNull.Value);
            }
            
            cmd.Parameters.AddWithValue("@Quantity", equipments.Quantity);

            //cmd.Parameters.AddWithValue("@VesselID", VesselID);

            //if (ship.ID > 0)
            //{
            //    cmd.Parameters.AddWithValue("@ID", equipments.ID);
            //}
            //else
            //{
            //    cmd.Parameters.AddWithValue("@ID", DBNull.Value);
            //}
            int recordsAffected = cmd.ExecuteNonQuery();
            con.Close();

            return recordsAffected;
        }

        public List<EquipmentsPOCO> GetEquipmentsPageWise(int pageIndex, ref int recordCount, int length/*, int VesselID*/)
        {
            List<EquipmentsPOCO> equipmentsPOList = new List<EquipmentsPOCO>();
            List<EquipmentsPOCO> equipmentsPO = new List<EquipmentsPOCO>();

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetEquipmentsPageWise", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
                    cmd.Parameters.AddWithValue("@PageSize", length);
                    cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4);
                    cmd.Parameters["@RecordCount"].Direction = ParameterDirection.Output;
                    //cmd.Parameters.AddWithValue("@VesselID", VesselID);
                    con.Open();

                    DataSet ds = new DataSet();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    //prodPOList = Common.CommonDAL.ConvertDataTable<ProductPOCO>(ds.Tables[0]);

                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        equipmentsPOList.Add(new EquipmentsPOCO
                        {
                            EquipmentsID = Convert.ToInt32(dr["EquipmentsID"]),
                            EquipmentsName = Convert.ToString(dr["EquipmentsName"]),
                            Comment = Convert.ToString(dr["Comment"]),
                            Quantity = Convert.ToString(dr["Quantity"]),
                            ExpiryDate = Convert.ToString(dr["ExpiryDate"]),
                            Location = Convert.ToString(dr["Location"])
                            //CrewID = Convert.ToInt32(dr["CrewID"])
                        });
                    }
                    recordCount = Convert.ToInt32(cmd.Parameters["@RecordCount"].Value);
                    con.Close();
                }
            }
            return equipmentsPOList;
        }


		public void ImportMedicine(object dataTable)
		{
			DataTable dTable = (DataTable)dataTable;
			DataSet ds = new DataSet("MedicineList");
			ds = dTable.DataSet;
			string strXMl = ds.GetXml();

			using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))

			{

				con.Open();
				SqlCommand command = new SqlCommand("stpInsertMedicineStock", con);
				command.CommandType = CommandType.StoredProcedure;
				command.Parameters.Add(new SqlParameter("@XMLDoc", SqlDbType.VarChar));
				command.Parameters[0].Value = strXMl; //passing the string form of XML generated above
				int i = command.ExecuteNonQuery();

			}


		}

		public void ImportEquipment(object dataTable)
		{
			DataTable dTable = (DataTable)dataTable;
			DataSet ds = new DataSet("EquipmentList");
			ds = dTable.DataSet;
			string strXMl = ds.GetXml();

			using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))

			{

				con.Open();
				SqlCommand command = new SqlCommand("stpInsertEquipmentStock", con);
				command.CommandType = CommandType.StoredProcedure;
				command.Parameters.Add(new SqlParameter("@XMLDoc", SqlDbType.VarChar));
				command.Parameters[0].Value = strXMl; //passing the string form of XML generated above
				int i = command.ExecuteNonQuery();

			}


		}



		public int SaveMedicine(EquipmentsPOCO equipments /*,int VesselID*/)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpSaveMedicine", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@MedicineName", equipments.MedicineName.ToString());
            //if (!String.IsNullOrEmpty(equipments.Comment))
            //{
            //    cmd.Parameters.AddWithValue("@Comment", equipments.Comment);
            //}
            //else
            //{
            //    cmd.Parameters.AddWithValue("@Comment", DBNull.Value);
            //}

            cmd.Parameters.AddWithValue("@Quantity", equipments.Quantity);

            //cmd.Parameters.AddWithValue("@VesselID", VesselID);

            //if (ship.ID > 0)
            //{
            //    cmd.Parameters.AddWithValue("@ID", equipments.ID);
            //}
            //else
            //{
            //    cmd.Parameters.AddWithValue("@ID", DBNull.Value);
            //}
            int recordsAffected = cmd.ExecuteNonQuery();
            con.Close();

            return recordsAffected;
        }

        public List<EquipmentsPOCO> GetMedicinePageWise(int pageIndex, ref int recordCount, int length/*, int VesselID*/)
        {
            List<EquipmentsPOCO> equipmentsPOList = new List<EquipmentsPOCO>();
            List<EquipmentsPOCO> equipmentsPO = new List<EquipmentsPOCO>();

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetMedicinePageWise", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
                    cmd.Parameters.AddWithValue("@PageSize", length);
                    cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4);
                    cmd.Parameters["@RecordCount"].Direction = ParameterDirection.Output;
                    //cmd.Parameters.AddWithValue("@VesselID", VesselID);
                    con.Open();

                    DataSet ds = new DataSet();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    //prodPOList = Common.CommonDAL.ConvertDataTable<ProductPOCO>(ds.Tables[0]);

                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        //String x = Convert.ToString(dr["ExpiryDate"]);
                        //x = x.ToString("dd-MMM-yyyy");
                        equipmentsPOList.Add(new EquipmentsPOCO
                        {
                            MedicineID = Convert.ToInt32(dr["MedicineID"]),
                            MedicineName = Convert.ToString(dr["MedicineName"]),
                            //Comment = Convert.ToString(dr["Comment"]),
                            Quantity = Convert.ToString(dr["Quantity"]),
                            ExpiryDate = Convert.ToString(dr["ExpiryDate"]),
                            Location = Convert.ToString(dr["Location"])
                            //CrewID = Convert.ToInt32(dr["CrewID"])
                        });
                    }
                    recordCount = Convert.ToInt32(cmd.Parameters["@RecordCount"].Value);
                    con.Close();
                }
            }
            return equipmentsPOList;
        }





        public List<EquipmentsPOCO> GetCrewDetailsForHealthByID(int ID)
        {
            List<EquipmentsPOCO> prodPOList = new List<EquipmentsPOCO>();
            List<EquipmentsPOCO> prodPO = new List<EquipmentsPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetCrewDetailsForHealthByIDNew", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    // cmd.Parameters.AddWithValue("@LoggedInUserId", ID);


                    if (ID > 0)
                    {
                        cmd.Parameters.AddWithValue("@LoggedInUserId", ID);
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@LoggedInUserId", DBNull.Value);
                    }


                    con.Open();


                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    //prodPOList = Common.CommonDAL.ConvertDataTable<ProductPOCO>(ds.Tables[0]);
                    con.Close();


                }
            }
            return ConvertDataTableToCrewDetailsForHealthList(ds);
        }

        private List<EquipmentsPOCO> ConvertDataTableToCrewDetailsForHealthList(DataSet ds)
        {
            List<EquipmentsPOCO> crewtimesheetList = new List<EquipmentsPOCO>();
            //check if there is at all any data
            if (ds.Tables.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    EquipmentsPOCO crewtimesheet = new EquipmentsPOCO();

                    //if (item["ID"] != null)
                    //    crewtimesheet.ID = Convert.ToInt32(item["ID"].ToString());

                    if (item["Name"] != null)
                        crewtimesheet.Name = item["Name"].ToString();

                    if (item["DOB"] != null)
                        crewtimesheet.DOB = item["DOB"].ToString();

                    if (item["RankName"] != null)
                        crewtimesheet.RankName = item["RankName"].ToString();

                    if (item["ActiveFrom"] != null)
                        crewtimesheet.ActiveFrom = item["ActiveFrom"].ToString();


                    crewtimesheetList.Add(crewtimesheet);
                }
            }
            return crewtimesheetList;
        }






        public List<EquipmentsPOCO> GetCrewDetailsForHealthByID2(int ID)
        {
            List<EquipmentsPOCO> prodPOList = new List<EquipmentsPOCO>();
            List<EquipmentsPOCO> prodPO = new List<EquipmentsPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetCrewDetailsForHealthByIDNew2", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    // cmd.Parameters.AddWithValue("@LoggedInUserId", ID);


                    if (ID > 0)
                    {
                        cmd.Parameters.AddWithValue("@LoggedInUserId", ID);
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@LoggedInUserId", DBNull.Value);
                    }


                    con.Open();


                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    //prodPOList = Common.CommonDAL.ConvertDataTable<ProductPOCO>(ds.Tables[0]);
                    con.Close();


                }
            }
            return ConvertDataTableToCrewDetailsForHealthList2(ds);
        }

        private List<EquipmentsPOCO> ConvertDataTableToCrewDetailsForHealthList2(DataSet ds)
        {
            List<EquipmentsPOCO> crewtimesheetList = new List<EquipmentsPOCO>();
            //check if there is at all any data
            if (ds.Tables.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    EquipmentsPOCO crewtimesheet = new EquipmentsPOCO();

                    //if (item["ID"] != null)
                    //    crewtimesheet.ID = Convert.ToInt32(item["ID"].ToString());

                    if (item["Name"] != null)
                        crewtimesheet.Name = item["Name"].ToString();

                    if (item["DOB"] != null)
                        crewtimesheet.DOB = item["DOB"].ToString();

                    if (item["RankName"] != null)
                        crewtimesheet.RankName = item["RankName"].ToString();

                    if (item["ActiveFrom"] != null)
                        crewtimesheet.ActiveFrom = item["ActiveFrom"].ToString();

                    if (item["LatestUpdate"] != null)
                        crewtimesheet.LatestUpdate = item["LatestUpdate"].ToString();

                    if (item["FirstName"] != null)
                        crewtimesheet.FirstName = item["FirstName"].ToString();

                    if (item["MiddleName"] != null)
                        crewtimesheet.MiddleName = item["MiddleName"].ToString();

                    if (item["LastName"] != null)
                        crewtimesheet.LastName = item["LastName"].ToString();

                    if (item["PassportSeamanPassportBook"] != null)
                        crewtimesheet.PassportSeamanPassportBook = item["PassportSeamanPassportBook"].ToString();

                    if (item["Seaman"] != null)
                        crewtimesheet.Seaman = item["Seaman"].ToString();

                    if (item["POB"] != null)
                        crewtimesheet.POB = item["POB"].ToString();


                    crewtimesheetList.Add(crewtimesheet);
                }
            }
            return crewtimesheetList;
        }




        public int SaveServiceTerms(EquipmentsPOCO equipments, int VesselID)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpSaveServiceTerms", con);
            cmd.CommandType = CommandType.StoredProcedure;          

            //if (!String.IsNullOrEmpty(equipments.Description))
            //{
            //    cmd.Parameters.AddWithValue("@Description", equipments.Description);
            //}
            //else
            //{
            //    cmd.Parameters.AddWithValue("@Description", DBNull.Value);
            //}
     
            cmd.Parameters.AddWithValue("@VesselID", VesselID);
            cmd.Parameters.AddWithValue("@CrewID", equipments.CrewID);
            cmd.Parameters.AddWithValue("@ActiveTo", equipments.ActiveTo.ToString());

            //if (equipments.ID > 0)
            //{
            //    cmd.Parameters.AddWithValue("@ID", equipments.ID);
            //}
            //else
            //{
            //    cmd.Parameters.AddWithValue("@ID", DBNull.Value);
            //}
            int recordsAffected = cmd.ExecuteNonQuery();
            con.Close();

            return recordsAffected;
        }



        public List<EquipmentsPOCO> GetServiceTermsListPageWise(int pageIndex, ref int recordCount, int length/*, int VesselID*/)
        {
            List<EquipmentsPOCO> equipmentsPOList = new List<EquipmentsPOCO>();
            List<EquipmentsPOCO> equipmentsPO = new List<EquipmentsPOCO>();

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetServiceTermsListPageWise", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
                    cmd.Parameters.AddWithValue("@PageSize", length);
                    cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4);
                    cmd.Parameters["@RecordCount"].Direction = ParameterDirection.Output;
                    //cmd.Parameters.AddWithValue("@VesselID", VesselID);
                    con.Open();

                    DataSet ds = new DataSet();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    //prodPOList = Common.CommonDAL.ConvertDataTable<ProductPOCO>(ds.Tables[0]);

                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        //String x = Convert.ToString(dr["ExpiryDate"]);
                        //x = x.ToString("dd-MMM-yyyy");
                        equipmentsPOList.Add(new EquipmentsPOCO
                        {
                            Name = Convert.ToString(dr["Name"]),
                            ActiveFrom = Convert.ToString(dr["ActiveFrom"]),
                            ActiveTo = Convert.ToString(dr["ActiveTo"])
                        });
                    }
                    recordCount = Convert.ToInt32(cmd.Parameters["@RecordCount"].Value);
                    con.Close();
                }
            }
            return equipmentsPOList;
        }
    }
}
