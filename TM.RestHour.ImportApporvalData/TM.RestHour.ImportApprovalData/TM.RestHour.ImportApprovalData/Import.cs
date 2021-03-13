using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Reflection;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Threading.Tasks;
using Quartz;
using Ionic.Zip;

namespace TM.RestHour.ImportApprovalData
{
    public class Import : IJob
    {
        static String extractPath = Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().GetName().CodeBase.Substring(8)), "xml");
        static String zipPath = Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().GetName().CodeBase.Substring(8)), "ZipFile");
        static String zipArchivePath = Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().GetName().CodeBase.Substring(8)), "Archive");
        static NLog.Logger logger = NLog.LogManager.GetCurrentClassLogger();
        public static bool isMailReadSuccessful = false;


        public async Task Execute(IJobExecutionContext context)
        {
            ImportMail();
            if (isMailReadSuccessful)
            {
                StartImport();
            }

            //throw new NotImplementedException();
        }



        #region Import Data To Database
        static void StartImport()
        {
            logger.Info("Import Process Started. - {0}", DateTime.Now.ToString());

            String TargetDirectory = zipPath + "\\";
            string[] filePaths = null;

            try
            {
                filePaths = Directory.GetFiles(TargetDirectory);
            }
            catch (Exception ex)
            {

                logger.Error("Directory not found. - {0}", DateTime.Now.ToString(), ex.Message);
                logger.Info("Import process terminated unsuccessfully.  - {0}", DateTime.Now.ToString());
                //Environment.Exit(0);
            }

            foreach (string filePath in filePaths)
            {
                //read file name
                string fileName = Path.GetFileName(filePath);

                //extract IMO number 
                string[] vesselIMONumber = fileName.Split('_');

                ////check for valid IMO
                //bool isValidIMO = CheckValidIMO(int.Parse(vesselIMONumber[0].ToString())) == 0 ? false : true;


                logger.Info("IMO- {0}", vesselIMONumber[0].ToString());
                //unzip the file
                using (ZipFile zip1 = ZipFile.Read(filePath))
                {
                    //Unzip a file
                    try
                    {
                        zip1.ExtractAll(extractPath + "\\", ExtractExistingFileAction.DoNotOverwrite);
                    }
                    catch (Exception ex)
                    {

                        logger.Error("Could not unzip file {0}", extractPath);
                        logger.Info("Import process terminated unsuccessfully.  - {0}", DateTime.Now.ToString());
                        //Environment.Exit(0);
                    }

                }

                logger.Info("UnZip Complete. - {0}", DateTime.Now.ToString());

                // start DB sync process
                ImportData();
                logger.Info("Data Import Complete. - {0}", DateTime.Now.ToString());
                //Update last stnc date for IMO
                UpdateLastSyncDate(int.Parse(vesselIMONumber[0].ToString()));
                logger.Info("Update Sync Date Complete. - {0}", DateTime.Now.ToString());
                //Delete extracted files
                string[] extractedFiles = Directory.GetFiles(extractPath + "\\");
                foreach (string files in extractedFiles)
                {
                    File.Delete(files);
                }
                logger.Info("Files Deleted . - {0}", DateTime.Now.ToString());
                //Archive zip file
                ArchiveZipFiles(fileName);
                logger.Info("Archive Complete . - {0}", DateTime.Now.ToString());


            }
        }

        public static void ArchiveZipFiles(string f)
        {
            string sourceFilePath = zipPath + "\\";
            string destinationFilePath = zipArchivePath + "\\";

            string[] sourceFiles = Directory.GetFiles(sourceFilePath);

            foreach (string sourceFile in sourceFiles)
            {
                try
                {
                    string fName = Path.GetFileName(sourceFile);
                    if (fName == f)
                    {
                        string destFile = Path.Combine(destinationFilePath, fName);

                        File.Move(sourceFile, destFile);
                    }
                }
                catch (Exception ex)
                {

                    logger.Error(ex.Message);
                    logger.Info("Import process terminated unsuccessfully in ArchiveZipFiles. - {0}", DateTime.Now.ToString());
                    //Environment.Exit(0);
                }

            }

            //System.IO.File.Move(sourceFilePath, destinationFilePath);
        }

        public static void ImportData()
        {
            try
            {
                
                Crew();
                logger.Info("Crew Import Complete. - {0}", DateTime.Now.ToString());
                
            }
            catch (Exception ex)
            {
                logger.Error(ex.Message);
                logger.Info("Import process terminated unsuccessfully. - {0}", DateTime.Now.ToString());
            }

        }

        public static int CheckValidIMO(int IMONumber)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpGetShipByIMONumber", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@IMONumber", IMONumber);

            int recordsAffected = (int)cmd.ExecuteScalar();
            con.Close();

            return recordsAffected;
        }

        public static void UpdateLastSyncDate(int IMONumber)
        {
            try
            {
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
                con.Open();
                SqlCommand cmd = new SqlCommand("stpUpdateShipByLastSyncDate", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@IMONumber", IMONumber);

                int recordsAffected = cmd.ExecuteNonQuery();
                con.Close();
            }
            catch (Exception ex)
            {

                logger.Error(ex.Message);
                logger.Info("Import process terminated unsuccessfully while updating last sysn date. - {0}", DateTime.Now.ToString());
                
            }


        }



        public static void Crew()
        {
            try
            {
                // Here your xml file
                string xmlFile = extractPath + "\\" + ConfigurationManager.AppSettings["xmlCrew"].ToString();

                DataSet dataSet = new DataSet();
                dataSet.ReadXmlSchema(xmlFile);
                dataSet.ReadXml(xmlFile, XmlReadMode.ReadSchema);

                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
                con.Open();
                SqlCommand cmd = new SqlCommand("stpImportCrew", con);
                cmd.CommandType = CommandType.StoredProcedure;

                foreach (DataRow row in dataSet.Tables[0].Rows)
                {
                    cmd.Parameters.AddWithValue("@ID", int.Parse(row["ID"].ToString()));

                    cmd.Parameters.AddWithValue("@Name", row["Name"].ToString());

                    if (row["Watchkeeper"] != DBNull.Value)
                    {
                        cmd.Parameters.AddWithValue("@Watchkeeper", Boolean.Parse(row["Watchkeeper"].ToString()));
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@Watchkeeper", DBNull.Value);
                    }

                    if (row["Notes"] != DBNull.Value)
                    {
                        cmd.Parameters.AddWithValue("@Notes", row["Notes"].ToString());
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@Notes", DBNull.Value);
                    }

                    if (row["Deleted"] != DBNull.Value)
                    {
                        cmd.Parameters.AddWithValue("@Deleted", Boolean.Parse(row["Deleted"].ToString()));
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@Deleted", DBNull.Value);
                    }

                    if (row["LatestUpdate"] != DBNull.Value)
                    {
                        cmd.Parameters.AddWithValue("@LatestUpdate", DateTime.Parse(row["LatestUpdate"].ToString()));
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@LatestUpdate", DBNull.Value);
                    }

                    if (row["CompleteHistory"] != DBNull.Value)
                    {
                        cmd.Parameters.AddWithValue("@CompleteHistory", Boolean.Parse(row["CompleteHistory"].ToString()));
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@CompleteHistory", DBNull.Value);
                    }

                    if (row["PayNum"] != DBNull.Value)
                    {
                        cmd.Parameters.AddWithValue("@PayNum", row["PayNum"].ToString());
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@PayNum", DBNull.Value);
                    }

                    if (row["CreatedOn"] != DBNull.Value)
                    {
                        cmd.Parameters.AddWithValue("@CreatedOn", DateTime.Parse(row["CreatedOn"].ToString()));
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@CreatedOn", DBNull.Value);
                    }

                    if (row["OvertimeEnabled"] != DBNull.Value)
                    {
                        cmd.Parameters.AddWithValue("@OvertimeEnabled", Boolean.Parse(row["OvertimeEnabled"].ToString()));
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@OvertimeEnabled", DBNull.Value);
                    }

                    if (row["EmployeeNumber"] != DBNull.Value)
                    {
                        cmd.Parameters.AddWithValue("@EmployeeNumber", row["EmployeeNumber"].ToString());
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@EmployeeNumber", DBNull.Value);
                    }

                    if (row["NWKHoursMayVary"] != DBNull.Value)
                    {
                        cmd.Parameters.AddWithValue("@NWKHoursMayVary", Boolean.Parse(row["NWKHoursMayVary"].ToString()));
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@NWKHoursMayVary", DBNull.Value);
                    }

                    if (row["RankID"] != DBNull.Value)
                    {
                        cmd.Parameters.AddWithValue("@RankID", int.Parse(row["RankID"].ToString()));
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@RankID", DBNull.Value);
                    }

                    if (row["FirstName"] != DBNull.Value)
                    {
                        cmd.Parameters.AddWithValue("@FirstName", row["FirstName"].ToString());
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@FirstName", DBNull.Value);
                    }

                    if (row["LastName"] != DBNull.Value)
                    {
                        cmd.Parameters.AddWithValue("@LastName", row["LastName"].ToString());
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@LastName", DBNull.Value);
                    }


                    if (row["DOB"] != DBNull.Value)
                    {
                        cmd.Parameters.AddWithValue("@DOB", DateTime.Parse(row["DOB"].ToString()));
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@DOB", DBNull.Value);
                    }

                    if (row["POB"] != DBNull.Value)
                    {
                        cmd.Parameters.AddWithValue("@POB", row["POB"].ToString());
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@POB", DBNull.Value);
                    }

                    if (row["CrewIdentity"] != DBNull.Value)
                    {
                        cmd.Parameters.AddWithValue("@CrewIdentity", row["CrewIdentity"].ToString());
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@CrewIdentity", DBNull.Value);
                    }

                    if (row["PassportSeamanPassportBook"] != DBNull.Value)
                    {
                        cmd.Parameters.AddWithValue("@PassportSeamanPassportBook", row["PassportSeamanPassportBook"].ToString());
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@PassportSeamanPassportBook", DBNull.Value);
                    }

                    if (row["Seaman"] != DBNull.Value)
                    {
                        cmd.Parameters.AddWithValue("@Seaman", row["Seaman"].ToString());
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@Seaman", DBNull.Value);
                    }

                    if (row["MiddleName"] != DBNull.Value)
                    {
                        cmd.Parameters.AddWithValue("@MiddleName", row["MiddleName"].ToString());
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@MiddleName", DBNull.Value);
                    }

                    if (row["IsActive"] != DBNull.Value)
                    {
                        cmd.Parameters.AddWithValue("@IsActive", Boolean.Parse(row["IsActive"].ToString()));
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@IsActive", DBNull.Value);
                    }

                    cmd.Parameters.AddWithValue("@VesselID", int.Parse(row["VesselID"].ToString()));

                    if (row["DepartmentMasterID"] != DBNull.Value)
                    {
                        cmd.Parameters.AddWithValue("@DepartmentMasterID", int.Parse(row["DepartmentMasterID"].ToString()));
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@DepartmentMasterID", DBNull.Value);
                    }

                    if (row["CountryID"] != DBNull.Value)
                    {
                        cmd.Parameters.AddWithValue("@CountryID", int.Parse(row["CountryID"].ToString()));
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@CountryID", DBNull.Value);
                    }
                    if (row["DeactivationDate"] != DBNull.Value)
                    {
                        cmd.Parameters.AddWithValue("@DeactivationDate", DateTime.Parse(row["DeactivationDate"].ToString()));
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@DeactivationDate", DBNull.Value);
                    }
                    if (row["DeletionDate"] != DBNull.Value)
                    {
                        cmd.Parameters.AddWithValue("@DeletionDate", DateTime.Parse(row["DeletionDate"].ToString()));
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@DeletionDate", DBNull.Value);
                    }
                    if (row["Gender"] != DBNull.Value)
                    {
                        cmd.Parameters.AddWithValue("@Gender", row["Gender"].ToString());
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@Gender", DBNull.Value);
                    }
                    if (row["IssuingStateOfIdentityDocument"] != DBNull.Value)
                    {
                        cmd.Parameters.AddWithValue("@IssuingStateOfIdentityDocument", row["IssuingStateOfIdentityDocument"].ToString());
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@IssuingStateOfIdentityDocument", DBNull.Value);
                    }

                    if (row["ExpiryDateOfIdentityDocument"] != DBNull.Value)
                    {
                        cmd.Parameters.AddWithValue("@ExpiryDateOfIdentityDocument", DateTime.Parse(row["ExpiryDateOfIdentityDocument"].ToString()));
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@ExpiryDateOfIdentityDocument", DBNull.Value);
                    }


                    cmd.ExecuteNonQuery();
                    cmd.Parameters.Clear();
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Crew Import");
                //throw;
            }
        }

        public static void FirstRun()
        {
            // Here your xml file
            string xmlFile = extractPath + "\\" + ConfigurationManager.AppSettings["xmlFirstRun"].ToString();

            DataSet dataSet = new DataSet();
            dataSet.ReadXmlSchema(xmlFile);
            dataSet.ReadXml(xmlFile, XmlReadMode.ReadSchema);

            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpImportFirstRun", con);
            cmd.CommandType = CommandType.StoredProcedure;

            foreach (DataRow row in dataSet.Tables[0].Rows)
            {
                cmd.Parameters.AddWithValue("@RunCount", int.Parse(row["RunCount"].ToString()));



                cmd.ExecuteNonQuery();
                cmd.Parameters.Clear();
            }
        }


        #endregion

        #region Import Zip from Mail

        static void ImportMail()
        {
            try
            {
                logger.Info("Import Zip from Mailbox Started. - {0}", DateTime.Now.ToString());

                string mTyp = GetConfigData("protocol");
                //Creating Mail configuration 
                MailServiceConfiguration serviceconf = new MailServiceConfiguration
                {

                    //MailId              = GetShipEmail(),
                    MailId              = GetConfigData("shipemail"),
                    MailPassword        = GetConfigData("shipemailpwd"),

                    //SubjectLine         = "RHDATASYNC",
                    SubjectLine         = GetConfigData("rhsubject"),

                    MailServerDomain    = GetConfigData("imappopServer"),
                    Port                = int.Parse(GetConfigData("imappopport")),
                    MailServerType      = mTyp,

                    AttachmentPath      = zipPath

                    ///---------------------------
                    //MailId              = "cableman24x7@gmail.com",
                    //MailPassword        = "cableman24x712345",
                    //MailServerDomain    = "imap.gmail.com",
                    //Port = 993,
                    //AttachmentPath      = zipPath,
                    //SubjectLine         = "RHDATASYNC",
                    ////SubjectLine = "DATASYNCFILE",

                    //MailServerType      = mTyp
                    //---------------------------------
                };

                MailOps mailops = new MailOps
                {
                    MailServerType = serviceconf.MailServerType
                };
                //mailops.Connect(serviceconf.MailId, Security.DecryptString(serviceconf.MailPassword), serviceconf.MailServerDomain, serviceconf.Port);
                mailops.Connect(serviceconf.MailId, serviceconf.MailPassword, serviceconf.MailServerDomain, serviceconf.Port);
                mailops.DownloadAllNewMailsNew(serviceconf.SubjectLine, serviceconf.AttachmentPath);

                isMailReadSuccessful = true;
                logger.Info("Import Zip from Mailbox process Successfully Completed. - {0}", DateTime.Now.ToString());
            }
            catch (Exception ex)
            {
                logger.Error("Import Zip from Mailbox. - {0}", DateTime.Now.ToString(), ex.Message + " :" + ex.InnerException);
                logger.Info("Import Zip from Mailbox process terminated unsuccessfully in Importmail. - {0}", DateTime.Now.ToString());
            }




        }


        public static string GetConfigData(string KeyName)
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

        }

        private static string GetShipEmail()
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("GetShipEmailWithOutIMO", con);
            cmd.CommandType = CommandType.StoredProcedure;
            DataSet ds = new DataSet();
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(ds);
            con.Close();
            return ds.Tables[0].Rows[0]["ShipEmail"].ToString();
        }

        #endregion
    }
}
