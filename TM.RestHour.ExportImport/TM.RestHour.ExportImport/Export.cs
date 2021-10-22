using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Data;
using System.Net.Mail;
using System.Reflection;
using System.Diagnostics;
using System.Configuration;
using System.Globalization;
using System.Data.SqlClient;
using Ionic.Zip;
using Quartz;
using System.Threading;

namespace TM.RestHour.ExportImport
{
	public class Export : IJob
	{
		static String path = Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().GetName().CodeBase.Substring(8)), "xml\\Export");
		static String zippath = Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().GetName().CodeBase.Substring(8)), "ZipFile\\Export");
		static String ziparchivePath = Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().GetName().CodeBase.Substring(8)), "Archive\\Export");
		public static bool isMailSendSuccessful = false;
		static NLog.Logger logger = NLog.LogManager.GetCurrentClassLogger();


		public async Task Execute(IJobExecutionContext context)
		{
			logger.Info("Process Started. - {0}", DateTime.Now.ToString());

			ArchiveZipFiles();
			logger.Info("Archiving Completed. - {0}", DateTime.Now.ToString());
			if (ZipDirectoryContainsZipFiles())
			{

				SendMail();
				if (isMailSendSuccessful)
				{
					ArchiveZipFiles();
					//redo the whole process again
					isMailSendSuccessful = false;
					logger.Info("Data Export Started. - {0}", DateTime.Now.ToString());
					ExportData();
					logger.Info("Data Export Completed. - {0}", DateTime.Now.ToString());
					CreateZip();
					logger.Info("Zip Created. - {0}", DateTime.Now.ToString());
					SendMail();
					logger.Info("Mail Sent. - {0}", DateTime.Now.ToString());
					if (isMailSendSuccessful)
					{
						ArchiveZipFiles();
					}
				}
			}
			else
			{
				isMailSendSuccessful = false;
				logger.Info("Data Export Started. - {0}", DateTime.Now.ToString());
				ExportData();
				logger.Info("Data Export Completed. - {0}", DateTime.Now.ToString());
				CreateZip();
				logger.Info("Zip Created. - {0}", DateTime.Now.ToString());
				SendMail();
				logger.Info("Mail Sent. - {0}", DateTime.Now.ToString());
				if (isMailSendSuccessful)
				{
					logger.Info("Archiving Started. - {0}", DateTime.Now.ToString());
					ArchiveZipFiles();
					logger.Info("Archiving Completed. - {0}", DateTime.Now.ToString());
				}
			}
		}


		public void CreateZip()
		{

			try
			{
				SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
				con.Open();
				SqlCommand cmd = new SqlCommand("stpGetShipDetailsByID", con);
				cmd.CommandType = CommandType.StoredProcedure;
				DataSet ds = new DataSet();
				SqlDataAdapter da = new SqlDataAdapter(cmd);
				da.Fill(ds);
				string fileName = ds.Tables[0].Rows[0]["IMONumber"].ToString();
				fileName = fileName + "_" + DateTime.Now.ToString("MMddyyyyhhmm");
				fileName = fileName + ".zip";

				using (ZipFile zip = new ZipFile())
				{
					zip.AddDirectory(path + "\\");
					zip.Comment = "This zip was created at " + System.DateTime.Now.ToString("G");

					zip.MaxOutputSegmentSize = int.Parse(ConfigurationManager.AppSettings["OutputSize"].ToString());
					zip.Save(zippath + "\\" + fileName);
					// SegmentsCreated = zip.NumberOfSegmentsForMostRecentSave;
				}

				//delete xml files 
				string[] filePaths = Directory.GetFiles(path + "\\");

				foreach (string filePath in filePaths)

					File.Delete(filePath);
			}
			catch (Exception ex)
			{


				logger.Error("Error in CreateZip. - {0}", ex.Message + " :" + ex.InnerException);
				logger.Info("Export process terminated unsuccessfully in CreateZip.");
				//Environment.Exit(0);
			}
		}

		public async void ExportData()
		{
			try
			{
				ExportShip();
				logger.Info("Ship Export Complete. - {0}", DateTime.Now.ToString());
				ExportRanks();
				logger.Info("Rank Export Complete. - {0}", DateTime.Now.ToString());
				ExportCrew();
				logger.Info("Crew Export Complete. - {0}", DateTime.Now.ToString());
				ExportDepartmentMaster();
				logger.Info("DepartmentMaster Export Complete. - {0}", DateTime.Now.ToString());
				ExportDepartmentAdmin();
				logger.Info("DepartmentAdmin Export Complete. - {0}", DateTime.Now.ToString());
				ExportWorkSessions();
				logger.Info("WorkSessions Export Complete. - {0}", DateTime.Now.ToString());
				ExportNCDetails();
				logger.Info("NCDetails Export Complete. - {0}", DateTime.Now.ToString());
				ExportServiceTerms();
				logger.Info("ServiceTerms Export Complete .- {0}", DateTime.Now.ToString());
				ExporttblRegime();
				logger.Info("tblRegime Export Complete. - {0}", DateTime.Now.ToString());

				//ExportTimeAdjustment();
				//ExportCrewRegimeTR();

			}

			catch (ThreadAbortException tex)
			{
				Thread.ResetAbort();
			}
			catch (Exception ex)
			{

				logger.Error("Error in ExportData. - {0}", ex.Message + " :" + ex.InnerException);
				logger.Info("Export process terminated unsuccessfully in ExportData.");
				//Environment.Exit(0);
			}
		}

		public async void ExportCrew()
		{
            try
            {
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
                con.Open();
                SqlCommand cmd = new SqlCommand("stpExportCrew", con);
                cmd.CommandType = CommandType.StoredProcedure;
                DataSet ds = new DataSet();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(ds);

                if (ds.Tables[0].Rows.Count > 0)
                {
                    ds.WriteXml(path + "\\" + ConfigurationManager.AppSettings["Crewxml"].ToString(), XmlWriteMode.WriteSchema);
                }
                con.Close();
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Crew Export");
            }
        }

		public async void ExportDepartmentAdmin()
		{
            try
            {
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
                con.Open();
                SqlCommand cmd = new SqlCommand("stpExportDepartmentAdmin", con);
                cmd.CommandType = CommandType.StoredProcedure;
                DataSet ds = new DataSet();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(ds);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    ds.WriteXml(path + "\\" + ConfigurationManager.AppSettings["DepartmentAdminxml"].ToString(), XmlWriteMode.WriteSchema);
                }
                con.Close();
            }
            catch (Exception ex)
            {
                logger.Error(ex, "DepartmentAdmin Export");
            }
        }

		public async void ExportDepartmentMaster()
		{
            try
            {
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
                con.Open();
                SqlCommand cmd = new SqlCommand("stpExportDepartmentMaster", con);
                cmd.CommandType = CommandType.StoredProcedure;
                DataSet ds = new DataSet();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(ds);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    ds.WriteXml(path + "\\" + ConfigurationManager.AppSettings["DepartmentMasterxml"].ToString(), XmlWriteMode.WriteSchema);
                }
                con.Close();
            }
            catch (Exception ex)
            {
                logger.Error(ex, "DepartmentMaster Export");
            }
        }

		public async void ExportFirstRun()
		{
			SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
			con.Open();
			SqlCommand cmd = new SqlCommand("stpExportFirstRun", con);
			cmd.CommandType = CommandType.StoredProcedure;
			DataSet ds = new DataSet();
			SqlDataAdapter da = new SqlDataAdapter(cmd);
			da.Fill(ds);
			if (ds.Tables[0].Rows.Count > 0)
			{
				ds.WriteXml(path + "\\" + ConfigurationManager.AppSettings["FirstRunxml"].ToString(), XmlWriteMode.WriteSchema);
			}
			con.Close();
		}

		public async void ExportGroupRank()
		{
			SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
			con.Open();
			SqlCommand cmd = new SqlCommand("stpExportGroupRank", con);
			cmd.CommandType = CommandType.StoredProcedure;
			DataSet ds = new DataSet();
			SqlDataAdapter da = new SqlDataAdapter(cmd);
			da.Fill(ds);
			if (ds.Tables[0].Rows.Count > 0)
			{
				ds.WriteXml(path + "\\" + ConfigurationManager.AppSettings["GroupRankxml"].ToString(), XmlWriteMode.WriteSchema);
			}
			con.Close();
		}

		public async void ExportGroups()
		{
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpExportGroups", con);
            cmd.CommandType = CommandType.StoredProcedure;
            DataSet ds = new DataSet();
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(ds);
            if (ds.Tables[0].Rows.Count > 0)
            {
                ds.WriteXml(path + "\\" + ConfigurationManager.AppSettings["Groupsxml"].ToString(), XmlWriteMode.WriteSchema);
            }
            con.Close();

        }

        public async void ExportNCDetails()
		{
            try
            {
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
                con.Open();
                SqlCommand cmd = new SqlCommand("stpExportNCDetails", con);
                cmd.CommandType = CommandType.StoredProcedure;
                DataSet ds = new DataSet();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(ds);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    ds.WriteXml(path + "\\" + ConfigurationManager.AppSettings["NCDetailsxml"].ToString(), XmlWriteMode.WriteSchema);
                }
                con.Close();
            }
            catch (Exception ex)
            {
                logger.Error(ex, "NCDetails Export");
            }
        }

        public async void ExportRanks()
		{
            try
            {
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
                con.Open();
                SqlCommand cmd = new SqlCommand("stpExportRanks", con);
                cmd.CommandType = CommandType.StoredProcedure;
                DataSet ds = new DataSet();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(ds);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    ds.WriteXml(path + "\\" + ConfigurationManager.AppSettings["Ranksxml"].ToString(), XmlWriteMode.WriteSchema);
                }
                con.Close();
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Ranks Export");
            }
        }

        public async void ExportRegimes()
		{
            try
            {
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
                con.Open();
                SqlCommand cmd = new SqlCommand("stpExportRegimes", con);
                cmd.CommandType = CommandType.StoredProcedure;
                DataSet ds = new DataSet();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(ds);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    ds.WriteXml(path + "\\" + ConfigurationManager.AppSettings["Regimesxml"].ToString(), XmlWriteMode.WriteSchema);
                }
                con.Close();
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Regimes Export");
            }
        }

        public async void ExportServiceTerms()
		{
            try
            {
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
                con.Open();
                SqlCommand cmd = new SqlCommand("stpExportServiceTerms", con);
                cmd.CommandType = CommandType.StoredProcedure;
                DataSet ds = new DataSet();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(ds);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    ds.WriteXml(path + "\\" + ConfigurationManager.AppSettings["ServiceTermsxml"].ToString(), XmlWriteMode.WriteSchema);
                }
                con.Close();
            }
            catch (Exception ex)
            {
                logger.Error(ex, "ServiceTerms Export");
            }
        }

        public async void ExportShip()
		{
            try
            {
				SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
				con.Open();
				SqlCommand cmd = new SqlCommand("stpExportShip", con);
				cmd.CommandType = CommandType.StoredProcedure;
				DataSet ds = new DataSet();
				SqlDataAdapter da = new SqlDataAdapter(cmd);
				da.Fill(ds);
				if (ds.Tables[0].Rows.Count > 0)
				{
					ds.WriteXml(path + "\\" + ConfigurationManager.AppSettings["Shipxml"].ToString(), XmlWriteMode.WriteSchema);
				}
				con.Close();
			}
			catch(Exception ex)
            {
				logger.Error(ex, "Ship Export");
			}
			
		}

		public async void ExporttblRegime()
		{
            try
            {
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
                con.Open();
                SqlCommand cmd = new SqlCommand("stpExporttblRegime", con);
                cmd.CommandType = CommandType.StoredProcedure;
                DataSet ds = new DataSet();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(ds);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    ds.WriteXml(path + "\\" + ConfigurationManager.AppSettings["tblRegimexml"].ToString(), XmlWriteMode.WriteSchema);
                }
                con.Close();
            }
            catch (Exception ex)
            {
                logger.Error(ex, "tblRegime Export");
            }
        }

		public async void ExportTimeAdjustment()
		{
            try
            {
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
                con.Open();
                SqlCommand cmd = new SqlCommand("stpExportTimeAdjustment", con);
                cmd.CommandType = CommandType.StoredProcedure;
                DataSet ds = new DataSet();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(ds);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    ds.WriteXml(path + "\\" + ConfigurationManager.AppSettings["TimeAdjustmentxml"].ToString(), XmlWriteMode.WriteSchema);
                }
                con.Close();
            }
            catch (Exception ex)
            {
                logger.Error(ex, "TimeAdjustment Export");
            }
        }

        public async void ExportUserGroups()
		{
            try
            {
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
                con.Open();
                SqlCommand cmd = new SqlCommand("stpExportUserGroups", con);
                cmd.CommandType = CommandType.StoredProcedure;
                DataSet ds = new DataSet();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(ds);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    ds.WriteXml(path + "\\" + ConfigurationManager.AppSettings["UserGroupsxml"].ToString(), XmlWriteMode.WriteSchema);
                }
                con.Close();
            }
            catch (Exception ex)
            {
                logger.Error(ex, "UserGroups Export");
            }
        }

		public async void ExportUsers()
		{
            try
            {
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
                con.Open();
                SqlCommand cmd = new SqlCommand("stpExportUsers", con);
                cmd.CommandType = CommandType.StoredProcedure;
                DataSet ds = new DataSet();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(ds);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    ds.WriteXml(path + "\\" + ConfigurationManager.AppSettings["Usersxml"].ToString(), XmlWriteMode.WriteSchema);
                }
                con.Close();
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Users Export");
            }
        }

		public async void ExportWorkSessions()
		{
            try
            {
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
                con.Open();
                SqlCommand cmd = new SqlCommand("stpExportWorkSessions", con);
                cmd.CommandType = CommandType.StoredProcedure;
                DataSet ds = new DataSet();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(ds);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    ds.WriteXml(path + "\\" + ConfigurationManager.AppSettings["WorkSessionsxml"].ToString(), XmlWriteMode.WriteSchema);
                }
                con.Close();
            }
            catch (Exception ex)
            {
                logger.Error(ex, "WorkSessions Export");
            }
        }

		public async void ExportCrewRegimeTR()
		{
            try
            {
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
                con.Open();
                SqlCommand cmd = new SqlCommand("stpExportCrewRegimeTR", con);
                cmd.CommandType = CommandType.StoredProcedure;
                DataSet ds = new DataSet();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(ds);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    ds.WriteXml(path + "\\" + ConfigurationManager.AppSettings["CrewRegimeTRxml"].ToString(), XmlWriteMode.WriteSchema);
                }
                con.Close();
            }
            catch (Exception ex)
            {
                logger.Error(ex, "CrewRegimeTR Export");
            }
        }

		public async void ExportCompanyDetails()
		{
			SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
			con.Open();
			SqlCommand cmd = new SqlCommand("stpExportCompanyDetails", con);
			cmd.CommandType = CommandType.StoredProcedure;
			DataSet ds = new DataSet();
			SqlDataAdapter da = new SqlDataAdapter(cmd);
			da.Fill(ds);
			if (ds.Tables[0].Rows.Count > 0)
			{
				ds.WriteXml(path + "\\" + ConfigurationManager.AppSettings["CompanyDetailsxml"].ToString(), XmlWriteMode.WriteSchema);
			}
			con.Close();
		}

		/// <summary>
		/// Moves file from ZipFile directory to Archive Directory
		/// </summary>
		public async void ArchiveZipFiles()
		{
			string sourceFilePath = zippath + "\\";
			string destinationFilePath = ziparchivePath + "\\";

			try
			{
				string[] sourceFiles = Directory.GetFiles(sourceFilePath);

				foreach (string sourceFile in sourceFiles)
				{
					string fName = Path.GetFileName(sourceFile);
					string destFile = Path.Combine(destinationFilePath, fName);

					File.Move(sourceFile, destFile);
				}
			}
			catch (Exception ex)
			{

				logger.Error("Directory not found. - {0}", ex.Message + " :" + ex.InnerException);
				logger.Info("Export process terminated unsuccessfully in ArchiveZipFiles.");
				//Environment.Exit(0);
			}


		}

		/// <summary>
		/// sends a mail
		/// </summary>
		public void SendMail()
		{

			try
			{
				using (MailMessage mail = new MailMessage())
				{
					mail.Subject = GetConfigData("Subject");

					//mail.From		= new MailAddress(GetConfigData("mailfrom"));
					mail.From = new MailAddress(GetConfigData("shipemail"));
					logger.Info("Mail Address From Set. - {0}", DateTime.Now.ToString());

					//mail.To.Add(GetConfigData("mailto"));
					mail.To.Add(GetConfigData("admincenteremail"));
					logger.Info("Mail Address to Set. - {0}", DateTime.Now.ToString());

					if (ZipDirectoryContainsZipFiles())
					{
						logger.Info("Adding Attachments. - {0}", DateTime.Now.ToString());
						mail.Attachments.Add(new Attachment(zippath + "\\" + GetZipFileName()));
						logger.Info("Attachments Added  - {0}", DateTime.Now.ToString());
					}

					SmtpClient smtp = new SmtpClient(GetConfigData("smtp"));
					smtp.EnableSsl = true;
					smtp.Port = int.Parse(GetConfigData("port"));
					logger.Info("Port Set. - {0}", DateTime.Now.ToString());

					//smtp.Credentials = new System.Net.NetworkCredential(GetConfigData("mailfrom").Trim(), GetConfigData("frompwd").Trim());
					smtp.Credentials = new System.Net.NetworkCredential(GetConfigData("shipemail").Trim(), GetConfigData("shipemailpwd").Trim());
					//smtp.Credentials = new System.Net.NetworkCredential("cableman24x7@gmail.com", "cableman24x712345");
					logger.Info("Mail Sending. - {0}", DateTime.Now.ToString());

					smtp.Send(mail);
					logger.Info("Mail Sent. - {0}", DateTime.Now.ToString());

					isMailSendSuccessful = true;
				}
			}
			catch (Exception ex)
			{
				//EventLog.WriteEntry("DataExport-SendMail", ex.Message + " :" + ex.InnerException, EventLogEntryType.Error);
				isMailSendSuccessful = false;
				logger.Error("Mail send failed - {0}", ex.Message + " :" + ex.InnerException);
				logger.Info("Export process terminated unsuccessfully.");
				//Environment.Exit(0);
			}

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

		public bool ZipDirectoryContainsZipFiles()
		{
			try
			{
				DirectoryInfo di = new DirectoryInfo(zippath + "\\");
				return di.GetFiles("*.zip").Length > 0;
			}
			catch (Exception ex)
			{

				logger.Error("Directory not found. - {0}", ex.Message + " :" + ex.InnerException);
				logger.Info("Export process terminated unsuccessfully in ZipDirectoryContainsZipFiles.");
				return false;
				//Environment.Exit(0);
			}
		}

		/// <summary>
		/// Returns the first zip file name from the Zipfiles folder . If no file is preset it returns an empty string
		/// </summary>
		/// <returns></returns>
		public string GetZipFileName()
		{
			if (ZipDirectoryContainsZipFiles())
			{
				DirectoryInfo di = new DirectoryInfo(zippath + "\\");
				return di.GetFiles("*.zip")[0].Name;
			}
			else
			{
				return string.Empty;
			}
		}
	}
}
