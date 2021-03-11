using System;
using System.IO;
using System.Linq;
using System.Text;
using System.Data;
using System.Net.Mail;
using System.Reflection;
using System.Diagnostics;
using System.Configuration;
using System.Globalization;
using System.Data.SqlClient;
using System.Threading.Tasks;
using System.Collections.Generic;

using Ionic.Zip;
using Quartz;

namespace TM.RestHour
{
    public class Export:IJob
    {
        static String path = Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().GetName().CodeBase.Substring(8)), "xml");
        static String zippath = Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().GetName().CodeBase.Substring(8)), "ZipFile");
        static String ziparchivePath = Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().GetName().CodeBase.Substring(8)), "Archive");
        public static bool isMailSendSuccessful = false;
        static NLog.Logger logger = NLog.LogManager.GetCurrentClassLogger();

		public void Execute(IJobExecutionContext context)
		{
			logger.Info("Process Started. - {0}", DateTime.Now.ToString());
			ArchiveZipFiles();
			if (ZipDirectoryContainsZipFiles())
			{
				SendMail();
				if (isMailSendSuccessful)
				{
					ArchiveZipFiles();
					//redo the whole process again
					isMailSendSuccessful = false;
					ExportData();
					CreateZip();
					SendMail();
					if (isMailSendSuccessful)
					{
						ArchiveZipFiles();
					}
				}
			}
			else
			{
				isMailSendSuccessful = false;
				ExportData();
				CreateZip();
				SendMail();
				if (isMailSendSuccessful)
				{
					ArchiveZipFiles();
				}
			}

			//throw new NotImplementedException();
		}



		public static void CreateZip()
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

		public static void ExportData()
		{
			try
			{
				ExportCrew();
				ExportDepartmentAdmin();
				ExportDepartmentMaster();
				//ExportFirstRun();
				//  ExportGroupRank();
				// ExportGroups();
				ExportNCDetails();
				ExportRanks();
				//ExportRegimes();
				ExportServiceTerms();
				ExportShip();
				ExporttblRegime();
				ExportTimeAdjustment();
				//ExportUserGroups();
				//ExportUsers();
				ExportWorkSessions();
				ExportCrewRegimeTR();
				//ExportCompanyDetails();
			}
			catch (Exception ex)
			{

				logger.Error("Error in ExportData. - {0}", ex.Message + " :" + ex.InnerException);
				logger.Info("Export process terminated unsuccessfully in ExportData.");
				//Environment.Exit(0);
			}
		}

		/// <summary>
		/// Moves file from ZipFile directory to Archive Directory
		/// </summary>
		public static void ArchiveZipFiles()
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
		public static void SendMail()
		{

			try
			{
				using (MailMessage mail = new MailMessage())
				{
					mail.Subject = GetConfigData("subject");
					mail.From = new MailAddress(GetConfigData("mailfrom"));

					mail.To.Add(GetConfigData("mailto"));

					if (ZipDirectoryContainsZipFiles())
					{
						mail.Attachments.Add(new Attachment(zippath + "\\" + GetZipFileName()));
					}

					SmtpClient smtp = new SmtpClient(GetConfigData("smtp"));
					smtp.EnableSsl = true;
					smtp.Port = int.Parse(GetConfigData("port"));
					smtp.Credentials = new System.Net.NetworkCredential(GetConfigData("mailfrom").Trim(), GetConfigData("frompwd").Trim());

					smtp.Send(mail);

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
		/// <summary>
		/// Returns true if Zip files directory contains zip files
		/// </summary>
		/// <returns></returns>
		public static bool ZipDirectoryContainsZipFiles()
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
		public static string GetZipFileName()
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

			//if (ds.Tables[0].Rows.Count > 0)
			//{
			//    ds.WriteXml(path + "\\" + ConfigurationManager.AppSettings["Crewxml"].ToString(), XmlWriteMode.WriteSchema);
			//}
		}





		public static void ExportCrew()
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

		public static void ExportDepartmentAdmin()
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

		public static void ExportDepartmentMaster()
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

		public static void ExportFirstRun()
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

		public static void ExportGroupRank()
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

		public static void ExportGroups()
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

		public static void ExportNCDetails()
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

		public static void ExportRanks()
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

		public static void ExportRegimes()
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

		public static void ExportServiceTerms()
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

		public static void ExportShip()
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

		public static void ExporttblRegime()
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

		public static void ExportTimeAdjustment()
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

		public static void ExportUserGroups()
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

		public static void ExportUsers()
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

		public static void ExportWorkSessions()
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

		public static void ExportCrewRegimeTR()
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

		public static void ExportCompanyDetails()
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

        
    }
}