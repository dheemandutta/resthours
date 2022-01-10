﻿using System;
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

namespace TM.RestHour.ExportImport
{
    public class Import : IJob
    {
        static String extractPath = Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().GetName().CodeBase.Substring(8)), "xml\\Import");
        static String zipPath = Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().GetName().CodeBase.Substring(8)), "ZipFile\\Import");
        static String zipArchivePath = Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().GetName().CodeBase.Substring(8)), "Archive\\Import");
        static NLog.Logger logger = NLog.LogManager.GetCurrentClassLogger();
        public static bool isMailReadSuccessful = false;


        public async Task Execute(IJobExecutionContext context)
        {
            ImportMail();
            if (isMailReadSuccessful)
            {
                if (ZipDirectoryContainsFiles())
                {
                    StartImport();
                }
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

        public static bool ZipDirectoryContainsFiles()
        {
            try
            {
                DirectoryInfo di = new DirectoryInfo(zipPath + "\\");
                return di.GetFiles("*.zip").Length > 0;
            }
            catch (Exception ex)
            {

                logger.Error("Directory not found. - {0}", ex.Message + " :" + ex.InnerException);
                logger.Info("Import process terminated unsuccessfully in ZipDirectoryContainsZipFiles.");
                return false;
                //Environment.Exit(0);
            }
        }
        public static void ImportData()
        {
            try
            {

                ImportWorkSession();
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


        public static void ImportWorkSession()
        {
            try
            {
                string imoNo = GetShipIMO();
                // Here your xml file
                //string xmlFile = extractPath + "\\" + ConfigurationManager.AppSettings["xmlCrew"].ToString();
                string xmlFile = extractPath + "\\" + imoNo + ".xml";


                DataSet dataSet = new DataSet();
                dataSet.ReadXmlSchema(xmlFile);
                dataSet.ReadXml(xmlFile, XmlReadMode.ReadSchema);

                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
                con.Open();
                SqlCommand cmd = new SqlCommand("stpImportWorkSessionsApprovalData", con);
                cmd.CommandType = CommandType.StoredProcedure;
                //SqlDataAdapter da = new SqlDataAdapter(cmd);

                // Then display informations to test
                foreach (DataRow row in dataSet.Tables[0].Rows)
                {
                    cmd.Parameters.AddWithValue("@ID", int.Parse(row["ID"].ToString()));

                    cmd.Parameters.AddWithValue("@CrewID", row["CrewID"].ToString());

                    if (row["VesselID"] != DBNull.Value)
                    {
                        cmd.Parameters.AddWithValue("@VesselID", row["VesselID"].ToString());
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@VesselID", DBNull.Value);
                    }

                    if (row["Comments"] != DBNull.Value)
                    {
                        cmd.Parameters.AddWithValue("@Comments", row["Comments"].ToString());
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@Comments", DBNull.Value);
                    }

                    if (row["isApproved"] != DBNull.Value)
                    {
                        cmd.Parameters.AddWithValue("@isApproved", Boolean.Parse(row["isApproved"].ToString()));
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@isApproved", DBNull.Value);
                    }





                    cmd.ExecuteNonQuery();
                    cmd.Parameters.Clear();
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "WorkSession Import");
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

        private static string GetShipIMO()
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            // Prasenjit // "r" is a Typo "stpExportCrewApprovalData" to "stpExpotrCrewApprovalData"
            SqlCommand cmd = new SqlCommand("GetIMONumber", con);
            cmd.CommandType = CommandType.StoredProcedure;
            DataSet ds = new DataSet();
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(ds);

            return ds.Tables[0].Rows[0]["IMONumber"].ToString();
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

                    // MailId              = GetShipEmail(),
                    MailId = GetConfigData("shipemail"),
                    MailPassword = GetConfigData("shipemailpwd"),

                    //SubjectLine         = "RHDATASYNC",
                    SubjectLine = GetConfigData("rhsubject"),

                    MailServerDomain = GetConfigData("imappopServer"),
                    Port = int.Parse(GetConfigData("imappopport")),
                    MailServerType = mTyp,

                    AttachmentPath = zipPath

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