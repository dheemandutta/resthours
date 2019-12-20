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
    public class CrewDAL
    {
        public int SaveCrew(CrewPOCO crew,int VesselID)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpSaveCrew", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@FirstName", crew.FirstName.ToString());

            if (!String.IsNullOrEmpty(crew.MiddleName))
            {
                cmd.Parameters.AddWithValue("@MiddleName", crew.MiddleName.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@MiddleName", DBNull.Value);
            }

            cmd.Parameters.AddWithValue("@LastName", crew.LastName.ToString());
           // cmd.Parameters.AddWithValue("@Gender", crew.Gender.ToString());
            if (!String.IsNullOrEmpty(crew.Gender))
            {
                cmd.Parameters.AddWithValue("@Gender", crew.Gender.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@Gender", DBNull.Value);
            }

            cmd.Parameters.AddWithValue("@RankID", crew.RankID);


            cmd.Parameters.AddWithValue("@CountryID", crew.CountryID);
            //cmd.Parameters.AddWithValue("@Nationality", crew.Nationality.ToString());
            cmd.Parameters.AddWithValue("@DOB", crew.DOB);
            cmd.Parameters.AddWithValue("@POB", crew.POB.ToString());
            cmd.Parameters.AddWithValue("@VesselID", VesselID);
            //////////////////////////
            //cmd.Parameters.AddWithValue("@DepartmentMasterID", crew.DepartmentMasterID);
            if (crew.DepartmentMasterID.HasValue)
            {
                cmd.Parameters.AddWithValue("@DepartmentMasterID", crew.DepartmentMasterID);
            }
            else
            {
                cmd.Parameters.AddWithValue("@DepartmentMasterID", DBNull.Value);
            }
            //////////////////////////


            //if (!String.IsNullOrEmpty(crew.Seaman))
            //    {
            //    cmd.Parameters.AddWithValue("@Seaman", crew.Seaman);
            //}
            //else
            //{
            //    cmd.Parameters.AddWithValue("@Seaman", DBNull.Value);
            //}
            //cmd.Parameters.AddWithValue("@Seaman", crew.Seaman.ToString());
            // cmd.Parameters.AddWithValue("@PassportSeaman", crew.PassportSeaman.ToString());

            if (crew.PassportSeaman == 1)
            {
                //cmd.Parameters.AddWithValue("@Passport", crew.Passport);
                cmd.Parameters.AddWithValue("@Seaman", crew.PassportSeamanPassportBook.ToString());
                cmd.Parameters.AddWithValue("@PassportSeamanPassportBook", DBNull.Value);
            }
            else
            {
                //cmd.Parameters.AddWithValue("@Passport", DBNull.Value);
                cmd.Parameters.AddWithValue("@Seaman", DBNull.Value);
                cmd.Parameters.AddWithValue("@PassportSeamanPassportBook", crew.PassportSeamanPassportBook.ToString());
            }



            cmd.Parameters.AddWithValue("@CreatedOn", crew.ServiceTermsPOCO.ActiveFrom);
            
            
            if (crew.ServiceTermsPOCO.ActiveTo.HasValue )
            {
                cmd.Parameters.AddWithValue("@ActiveTo", crew.ServiceTermsPOCO.ActiveTo);
            }
            else
            {
                cmd.Parameters.AddWithValue("@ActiveTo", DBNull.Value);
            }

            //if (!string.IsNullOrEmpty(crew.PayNum))
            //cmd.Parameters.AddWithValue("@PayNum", crew.PayNum);
            //else
            //    cmd.Parameters.AddWithValue("@PayNum", DBNull.Value );




            //if (!String.IsNullOrEmpty(crew.EmployeeNumber))
            //cmd.Parameters.AddWithValue("@EmployeeNumber", crew.EmployeeNumber);
            //else
            //    cmd.Parameters.AddWithValue("@EmployeeNumber", DBNull.Value );





            //cmd.Parameters.AddWithValue("@Notes", crew.Notes.ToString());
            if (!String.IsNullOrEmpty(crew.Notes))
            {
                cmd.Parameters.AddWithValue("@Notes", crew.Notes.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@Notes", DBNull.Value);
            }

            cmd.Parameters.AddWithValue("@Watchkeeper", crew.Watchkeeper);
           

            cmd.Parameters.AddWithValue("@OvertimeEnabled", crew.OvertimeEnabled);
           
         

            if (crew.ID > 0)
            {
                cmd.Parameters.AddWithValue("@ID", crew.ID);
            }
            else
            {
                cmd.Parameters.AddWithValue("@ID", DBNull.Value);
            }


			SqlParameter param = new SqlParameter("@NewCrewId", SqlDbType.Int);
			param.Direction = ParameterDirection.Output;
			cmd.Parameters.Add(param);

            int recordsAffected = cmd.ExecuteNonQuery();

			int crewId = (int)cmd.Parameters["@NewCrewId"].Value;

            con.Close();

            return crewId;
        }

        //for Ranks drp
        public List<CrewPOCO> GetAllRanksForDrp(int VesselID)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("usp_GetAllRanksForDrp", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@VesselID", VesselID);
            DataSet ds = new DataSet();
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(ds);
            DataTable myTable = ds.Tables[0];
            List<CrewPOCO> ranksList = myTable.AsEnumerable().Select(m => new CrewPOCO()
            {
                RankID = m.Field<int>("RankID"),
                RankName = m.Field<string>("RankName"),
               
            }).ToList();
            con.Close();
            return ranksList;
            
        }




        public List<CrewPOCO> GetCrewPageWise(int pageIndex, ref int recordCount, int length, int VesselID)
        {

            List<CrewPOCO> crewPOList = new List<CrewPOCO>();
            List<CrewPOCO> crewPO = new List<CrewPOCO>();

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetCrewListingPageWise", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
                    cmd.Parameters.AddWithValue("@PageSize", length);
                    cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4);
                    cmd.Parameters["@RecordCount"].Direction = ParameterDirection.Output;
                    cmd.Parameters.AddWithValue("@VesselID", VesselID);
                    con.Open();

                    DataSet ds = new DataSet();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    //prodPOList = Common.CommonDAL.ConvertDataTable<ProductPOCO>(ds.Tables[0]);

                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        crewPOList.Add(new CrewPOCO
                        {
                            ID = Convert.ToInt32(dr["ID"]),
                            Name = Convert.ToString(dr["Name"]),
                            RankName = Convert.ToString(dr["RankName"]),
                            StartDate = Convert.ToString(dr["StartDate"]),
                            // EndDate = Convert.ToString(dr["EndDate"]),
                            // DiffDays = Convert.ToString(dr["DiffDays"]),
                            // Active = Convert.ToString(dr["Active"])
                        });
                    }
                    recordCount = Convert.ToInt32(cmd.Parameters["@RecordCount"].Value);
                    con.Close();
                }
            }
            return crewPOList;
        }


        public List<CrewPOCO> GetCrewForInactivPageWise(int pageIndex, ref int recordCount, int length, int VesselID)
        {

            List<CrewPOCO> crewPOList = new List<CrewPOCO>();
            List<CrewPOCO> crewPO = new List<CrewPOCO>();

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetCrewListingForInactivPageWise", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
                    cmd.Parameters.AddWithValue("@PageSize", length);
                    cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4);
                    cmd.Parameters["@RecordCount"].Direction = ParameterDirection.Output;
                    cmd.Parameters.AddWithValue("@VesselID", VesselID);
                    con.Open();

                    DataSet ds = new DataSet();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    //prodPOList = Common.CommonDAL.ConvertDataTable<ProductPOCO>(ds.Tables[0]);

                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        crewPOList.Add(new CrewPOCO
                        {
                            ID = Convert.ToInt32(dr["ID"]),
                            Name = Convert.ToString(dr["Name"]),
                            RankName = Convert.ToString(dr["RankName"]),
                            StartDate = Convert.ToString(dr["StartDate"]),
                            // EndDate = Convert.ToString(dr["EndDate"]),
                            // DiffDays = Convert.ToString(dr["DiffDays"]),
                            // Active = Convert.ToString(dr["Active"])
                        });
                    }
                    recordCount = Convert.ToInt32(cmd.Parameters["@RecordCount"].Value);
                    con.Close();
                }
            }
            return crewPOList;
        }



        public int[] AddCrewTimeSheet(CrewTimesheetPOCO crewtimesheetData,int VesselID)

        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpSaveWorkSessions", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@CrewID", crewtimesheetData.Crew.ID);

            cmd.Parameters.AddWithValue("@ValidOn", crewtimesheetData.BookDate);
            string bookData = String.Join("",crewtimesheetData.BookedHours);
            
            cmd.Parameters.AddWithValue("@Hours", bookData);
            //TO DO: Need to update
            cmd.Parameters.AddWithValue("@Increment", 0);
            cmd.Parameters.AddWithValue("@Comment", crewtimesheetData.Comment );
            cmd.Parameters.AddWithValue("@Deleted", 1);
            cmd.Parameters.AddWithValue("@ActualHours", crewtimesheetData.ActualHours);
            cmd.Parameters.AddWithValue("@AdjustmentFator", crewtimesheetData.AdjustmentFactor);

            cmd.Parameters.AddWithValue("@OccuredOn", crewtimesheetData.BookDate);
            cmd.Parameters.AddWithValue("@ComplianceInfo", crewtimesheetData.NCDetails.ComplianceInfo );
            cmd.Parameters.AddWithValue("@TotalNCHours", crewtimesheetData.NCDetails.TotalNCHours);
            cmd.Parameters.AddWithValue("@Day1Update", crewtimesheetData.DayUpdate);
            cmd.Parameters.AddWithValue("@isNonCompliant", crewtimesheetData.isNonCompliant);
            cmd.Parameters.AddWithValue("@VesselID", VesselID);
            cmd.Parameters.AddWithValue("@RegimeID", crewtimesheetData.RegimeID);

            if (crewtimesheetData.ID > 0)
            {
                cmd.Parameters.AddWithValue("@ID", crewtimesheetData.ID);
            }
            else
            {
                cmd.Parameters.AddWithValue("@ID", DBNull.Value);
            }

            if (crewtimesheetData.NCDetailsID > 0)
            {
                cmd.Parameters.AddWithValue("@NCDetailsID", crewtimesheetData.NCDetailsID);
            }
            else
            {
                cmd.Parameters.AddWithValue("@NCDetailsID", DBNull.Value);
            }

            SqlParameter paramoutput = new SqlParameter("@WorkSessionId", SqlDbType.Int);
            paramoutput.Direction = ParameterDirection.Output;
            cmd.Parameters.Add(paramoutput); //@NewNCDetailsId

            SqlParameter paramoutput2 = new SqlParameter("@NewNCDetailsId", SqlDbType.Int);
            paramoutput2.Direction = ParameterDirection.Output;
            cmd.Parameters.Add(paramoutput2);

            cmd.Parameters.AddWithValue("@IsTechnicalNC", crewtimesheetData.IsTechnicalNC);
            cmd.Parameters.AddWithValue("@Is24HoursCompliant", crewtimesheetData.Is24HoursCompliant);
            cmd.Parameters.AddWithValue("@IsSevenDaysCompliant", crewtimesheetData.IsSevenDaysCompliant);
            cmd.Parameters.AddWithValue("@PaintOrange", crewtimesheetData.PaintOrange);

            int recordsAffected = cmd.ExecuteNonQuery();

            int workSessionId = (int)cmd.Parameters["@WorkSessionId"].Value;
            int newncdetailsId = (int)cmd.Parameters["@NewNCDetailsId"].Value;

            con.Close();

            int[] returnValues = new int[2];
            returnValues[0] = workSessionId;
            returnValues[1] = newncdetailsId;
            return returnValues;
        }



        public List<CrewPOCO> GetAllCrewByCrewID(int ID, int VesselID)
        {
            List<CrewPOCO> prodPOList = new List<CrewPOCO>();
            List<CrewPOCO> prodPO = new List<CrewPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetAllCrewByCrewID", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@ID", ID);
                    cmd.Parameters.AddWithValue("@VesselID", VesselID);
                    con.Open();

                   
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    //prodPOList = Common.CommonDAL.ConvertDataTable<ProductPOCO>(ds.Tables[0]);
                    con.Close();

                }
            }
            return ConvertDataTableToCrewList(ds);
        }

        private List<CrewPOCO> ConvertDataTableToCrewList(DataSet ds)
        {
            List<CrewPOCO> crewtimesheetList = new List<CrewPOCO>();
            //check if there is at all any data
            if(ds.Tables.Count> 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows )
                {
                    CrewPOCO crewtimesheet = new CrewPOCO();

                    if (item["ID"] != System.DBNull.Value)
                    crewtimesheet.ID = Convert.ToInt32(item["ID"].ToString());

                    if (item["Name"] != System.DBNull.Value)
                        crewtimesheet.Name = item["Name"].ToString();

                    if (item["FirstName"] != System.DBNull.Value)
                        crewtimesheet.FirstName = item["FirstName"].ToString();

                    if (item["LastName"] != System.DBNull.Value)
                        crewtimesheet.LastName = item["LastName"].ToString();

                    if (item["MiddleName"] != System.DBNull.Value)
                        crewtimesheet.MiddleName = item["MiddleName"].ToString();

                    if (item["Gender"] != System.DBNull.Value)
                        crewtimesheet.Gender = item["Gender"].ToString();

                    if (item["RankName"] != System.DBNull.Value)
                        crewtimesheet.RankName = item["RankName"].ToString();

                    if (item["Notes"] != System.DBNull.Value)
                        crewtimesheet.Notes = item["Notes"].ToString();

                    if (item["DOB1"] != System.DBNull.Value)
                        crewtimesheet.DOB1 = item["DOB1"].ToString();

                    if (item["ActiveFrom1"] != System.DBNull.Value)
                        crewtimesheet.ActiveFrom1 = item["ActiveFrom1"].ToString();

                    if (item["ActiveTo1"] != System.DBNull.Value)
                        crewtimesheet.ActiveTo1 = item["ActiveTo1"].ToString();

                    //if (item["Nationality"] != System.DBNull.Value)
                    //    crewtimesheet.Nationality = item["Nationality"].ToString();


                    if (item["CountryName"] != System.DBNull.Value)
                        crewtimesheet.CountryName = item["CountryName"].ToString();

                    if (item["CountryID"] != System.DBNull.Value)
                        crewtimesheet.CountryID = Convert.ToInt16(item["CountryID"]);

                    if (item["POB"] != System.DBNull.Value)
                        crewtimesheet.POB = item["POB"].ToString();

                    if (item["CrewIdentity"] != System.DBNull.Value)
                        crewtimesheet.CrewIdentity = item["CrewIdentity"].ToString();

                    //if (item["PassportSeamanPassportBook"] != System.DBNull.Value)
                    if (!String.IsNullOrEmpty(item["PassportSeamanPassportBook"].ToString()))
                    {
                        crewtimesheet.PassportSeamanPassportBook = item["PassportSeamanPassportBook"].ToString();
                        crewtimesheet.PassportSeamanIndicator = "P";
                    }
                    else
                    {
                        crewtimesheet.Seaman = item["Seaman"].ToString();
                        crewtimesheet.PassportSeamanIndicator = "S";
                    }

                    ////if (item["Seaman"] != System.DBNull.Value)
                    //crewtimesheet.PassportSeamanPassportBook = 

					if (item["OvertimeEnabled"] != System.DBNull.Value)
                        crewtimesheet.OvertimeEnabled = Convert.ToBoolean(item["OvertimeEnabled"]);

                    if (item["Watchkeeper"] != System.DBNull.Value)
                        crewtimesheet.Watchkeeper = Convert.ToBoolean(item["Watchkeeper"]);

                    if (item["RankID"] != System.DBNull.Value)
                        crewtimesheet.RankID = Convert.ToInt16(item["RankID"]);




                    if (item["DepartmentMasterName"] != System.DBNull.Value)
                        crewtimesheet.DepartmentMasterName = item["DepartmentMasterName"].ToString();

                    if (item["DepartmentMasterID"] != System.DBNull.Value)
                        crewtimesheet.DepartmentMasterID = Convert.ToInt16(item["DepartmentMasterID"]);



                    crewtimesheetList.Add(crewtimesheet);
                }
            }


            return crewtimesheetList;
        }



        public CrewPOCO GetCrewByID(int ID)
        {
            List<ConsultantPOCO> prodPOList = new List<ConsultantPOCO>();
            List<ConsultantPOCO> prodPO = new List<ConsultantPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetCrewByID", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@ID", ID);
                    con.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    //prodPOList = Common.CommonDAL.ConvertDataTable<ProductPOCO>(ds.Tables[0]);
                    con.Close();

                }
            }
            return ConvertdstoCrewPOCO(ds);
        }

        private CrewPOCO ConvertdstoCrewPOCO(DataSet ds)
        {
            CrewPOCO crewpoco = new CrewPOCO();
            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                if(ds.Tables[0].Rows[i]["Name"] != DBNull.Value)
                    crewpoco.Name = ds.Tables[0].Rows[i]["Name"].ToString();
            }

            return crewpoco;
        }

        public List<CrewTimesheetPOCO> GetLastSevenDaysWorkSchedule(int CrewId,DateTime bookDate,int VesselID,int numDays)
        {
            List<CrewTimesheetPOCO> prodPOList = new List<CrewTimesheetPOCO>();
            List<CrewTimesheetPOCO> prodPO = new List<CrewTimesheetPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetLastSevenDaysWorkScheduleForComplianceCheck", con)) //stpGetLastSevenDaysWorkSchedule
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@CrewId", CrewId);
                    cmd.Parameters.AddWithValue("@BookDate", bookDate);
                    cmd.Parameters.AddWithValue("@VesselID", VesselID);
                    cmd.Parameters.AddWithValue("@NumDays", numDays);

                    con.Open();

                    
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    con.Close();

                   
                }
            }
            return ConvertDataTableToList(ds);
        }

        private List<CrewTimesheetPOCO> ConvertDataTableToList(DataSet ds)
        {
			List<CrewTimesheetPOCO> crewtimesheetList = new List<CrewTimesheetPOCO>();
			DateTime dt;
			CultureInfo provider = CultureInfo.InvariantCulture;
			//check if there is at all any data
			if (ds.Tables[0].Rows.Count> 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows )
                {
                    CrewTimesheetPOCO crewtimesheet = new CrewTimesheetPOCO();

                    if (item["Hours"] != System.DBNull.Value )
                    crewtimesheet.BookedHours = item["Hours"].ToString().ToCharArray().Select(c => Convert.ToInt32(c.ToString())).ToArray();

					if (item["ValidOn"] != System.DBNull.Value)
					{
						crewtimesheet.BookDate = Convert.ToDateTime(item["ValidOn"].ToString());
					}
						//crewtimesheet.BookDate = DateTime.ParseExact(item["ValidOn"].ToString(), "MM/dd/yyyy", CultureInfo.InvariantCulture);


					crewtimesheetList.Add(crewtimesheet);

					
				}
            }
			//else
			//{

				
			//	for (int i = 0; i < 7; i++)
			//	{
			//		CrewTimesheetPOCO crewtimesheet = new CrewTimesheetPOCO();
			//		crewtimesheet.BookedHours = arr;
			//		crewtimesheetList.Add(crewtimesheet);
			//	}

				

			//}


            return crewtimesheetList;
        }

        public int UpdateInActive(int ID)
        {

            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpUpdateInActive", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@ID", ID);

            int recordsAffected = cmd.ExecuteNonQuery();
            con.Close();

            return recordsAffected;

        }


        public CrewPOCO GetCrewOvertimeValue(int ID, int VesselID)
        {
            List<CrewPOCO> prodPOList = new List<CrewPOCO>();
            List<CrewPOCO> prodPO = new List<CrewPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetCrewOvertimeValue", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@CrewId", ID);
                    cmd.Parameters.AddWithValue("@VesselID", VesselID);
                    con.Open();


                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    //prodPOList = Common.CommonDAL.ConvertDataTable<ProductPOCO>(ds.Tables[0]);
                    con.Close();

                }
            }
            return ConvertDataTableToCrewOvertimeValueList(ds).FirstOrDefault();
        }

        private List<CrewPOCO> ConvertDataTableToCrewOvertimeValueList(DataSet ds)
        {
            List<CrewPOCO> crewtimesheetList = new List<CrewPOCO>();
            //check if there is at all any data
            if (ds.Tables.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    CrewPOCO crewtimesheet = new CrewPOCO();

                    //if (item["ID"] != System.DBNull.Value)
                    //    crewtimesheet.ID = Convert.ToInt32(item["ID"].ToString());

                    if (item["OvertimeEnabled"] != System.DBNull.Value)
                        crewtimesheet.OvertimeEnabled = Convert.ToBoolean(item["OvertimeEnabled"]);

                    crewtimesheetList.Add(crewtimesheet);
                }
            }

            return crewtimesheetList;
        }

        //for Department drp
        public List<DepartmentPOCO> GetAllDepartmentForDrp(int VesselID)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("usp_GetAllDepartmentForDrp", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@VesselID", VesselID);
            DataSet ds = new DataSet();
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(ds);
            DataTable myTable = ds.Tables[0];
            List<DepartmentPOCO> ranksList = myTable.AsEnumerable().Select(m => new DepartmentPOCO()
            {
                DepartmentMasterID = m.Field<int>("DepartmentMasterID"),
                DepartmentMasterName = m.Field<string>("DepartmentMasterName"),

            }).ToList();
            con.Close();
            return ranksList;

        }


        //for CountryMaster drp
        public List<CrewPOCO> GetAllCountryForDrp(/*int VesselID*/)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("usp_GetAllCountryForDrp", con);
            cmd.CommandType = CommandType.StoredProcedure;
           // cmd.Parameters.AddWithValue("@VesselID", VesselID);
            DataSet ds = new DataSet();
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(ds);
            DataTable myTable = ds.Tables[0];
            List<CrewPOCO> countryList = myTable.AsEnumerable().Select(m => new CrewPOCO()
            {
                CountryID = m.Field<int>("CountryID"),
                CountryName = m.Field<string>("CountryName"),

            }).ToList();
            con.Close();
            return countryList;

        }



        public int SaveJoiningMedicalFilePath(int crewId, string filepath)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpSaveJoiningMedicalFilePath", con);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@CrewId", crewId);
            cmd.Parameters.AddWithValue("@File", filepath);

            

            int recordsAffected = cmd.ExecuteNonQuery();
            con.Close();

            return recordsAffected;
        }



        public CrewPOCO GetJoiningMedicalFileDatawByID(int CrewId /*,int VesselID*/)
        {
            List<CrewPOCO> prodPOList = new List<CrewPOCO>();
            List<CrewPOCO> prodPO = new List<CrewPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetJoiningMedicalFileDatawByID", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@CrewId", CrewId);
                    //cmd.Parameters.AddWithValue("@VesselID", VesselID);
                    con.Open();


                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    //prodPOList = Common.CommonDAL.ConvertDataTable<ProductPOCO>(ds.Tables[0]);
                    con.Close();

                }
            }
            return ConvertDataTableToJoiningMedicalFileDatawList(ds).FirstOrDefault();
        }

        private List<CrewPOCO> ConvertDataTableToJoiningMedicalFileDatawList(DataSet ds)
        {
            List<CrewPOCO> crewtimesheetList = new List<CrewPOCO>();
            //check if there is at all any data
            if (ds.Tables.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    CrewPOCO crewtimesheet = new CrewPOCO();

                    //if (item["ID"] != System.DBNull.Value)
                    //    crewtimesheet.ID = Convert.ToInt32(item["ID"].ToString());

                    if (item["JoiningMedicalFile"] != System.DBNull.Value)
                        crewtimesheet.JoiningMedicalFile = Convert.ToString(item["JoiningMedicalFile"]);

                    crewtimesheetList.Add(crewtimesheet);
                }
            }

            return crewtimesheetList;
        }
    }
}
