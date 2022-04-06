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
using System.Threading;

namespace TM.RestHour.ExportImport
{
	public class Export
	{
		static String path = Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().GetName().CodeBase.Substring(8)), "xml");
		static String zippath = Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().GetName().CodeBase.Substring(8)), "ZipFile");
		static String ziparchivePath = Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().GetName().CodeBase.Substring(8)), "Archive");
		public static bool isMailSendSuccessful = false;
		static NLog.Logger logger = NLog.LogManager.GetCurrentClassLogger();


        public void Execute()
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




		private   void CreateZip()
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
				fileName = fileName + "_" + DateTime.Now.ToString("MMddyyyyhhmmss");
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

		private   void ExportData()
		{
			try
			{
				//ExportCIRMPath();
				//ExportCIRM();

				ExportCIRMUploadedImagesPath();
				ExportCIRMUploadedImages();

				ExportExaminationForMedicalAdvisePath();
				ExportExaminationForMedicalAdvise();

				ExportMedicalAdvisePath();
				ExportMedicalAdvise();


				ExportCIRMAccidentDetails();
				ExportCIRMAffectedFindings();
				ExportCIRMMedicalSymtomology();
				ExportCIRMMedicalTreatmentGivenOnboard();
				ExportCIRMMedicationTaken();
				ExportCIRMTeleMedicalConsultation();
				ExportCIRMVitalStatistics();
				ExportCIRMVoyageDetails();
				ExportCIRMWeatherDetails();
				ExportFirstRun();
				ExportGroupRank();
				ExportGroups();
				ExportCrew();
				ExportDepartmentAdmin();
				ExportDepartmentMaster();
				ExportNCDetails();
				ExportRanks();
				ExportServiceTerms();
				ExportShip();
				ExporttblRegime();
				ExportTimeAdjustment();
				ExportWorkSessions();
				ExportCrewRegimeTR();
				ExportRegimes();
				ExportUserGroups();
				ExportUsers();
                ExportJoiningMedicalFileData();
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


		public void ExportCIRMPath(/*string ID*/)
		{
			SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
			con.Open();
			SqlCommand cmd = new SqlCommand("stpExportCIRMPath", con);
			//cmd.Parameters.AddWithValue("@ID", ID);
			cmd.CommandType = CommandType.StoredProcedure;
			DataSet ds = new DataSet();
			SqlDataAdapter da = new SqlDataAdapter(cmd);
			da.Fill(ds);
			DataTable myTable = ds.Tables[0];
			List<string> stig = new List<string>();
			
				//PictureUploadPath = m.Field<string>("PictureUploadPath")
				for (int i = 0; i < myTable.Rows.Count; i++)
				{
				stig.Add(myTable.Rows[i]["PictureUploadPath"].ToString());
				string path = myTable.Rows[i]["PictureUploadPath"].ToString();


				string currentDirectory = Path.GetDirectoryName(path);

				string result;

				result = Path.GetFileNameWithoutExtension(currentDirectory);
				Console.WriteLine("GetFileName('{0}') returns '{1}'",
					currentDirectory, result);

				result = Path.GetFileName(path);
				Console.WriteLine("GetFileName('{0}') returns '{1}'",
					path, result);
			    }

			con.Close();
			//return stig;
		}
		public async void ExportCIRM()
		{
			SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
			con.Open();
			SqlCommand cmd = new SqlCommand("stpExportCIRM", con);
			cmd.CommandType = CommandType.StoredProcedure;
			DataSet ds = new DataSet();
			SqlDataAdapter da = new SqlDataAdapter(cmd);
			da.Fill(ds);

			if (ds.Tables[0].Rows.Count > 0)
			{
				ds.WriteXml(path + "\\" + ConfigurationManager.AppSettings["CIRMxml"].ToString(), XmlWriteMode.WriteSchema);
			}
			con.Close();
		}







		private void ExportCrew()
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

		private   void ExportDepartmentAdmin()
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

		private   void ExportDepartmentMaster()
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

		private   void ExportFirstRun()
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

		private   void ExportGroupRank()
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

		private   void ExportGroups()
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

		private   void ExportNCDetails()
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

		private   void ExportRanks()
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

		private   void ExportRegimes()
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

		private   void ExportServiceTerms()
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

		private   void ExportShip()
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

		private   void ExporttblRegime()
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

		private   void ExportTimeAdjustment()
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

		private   void ExportUserGroups()
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

		private   void ExportUsers()
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

		private   void ExportWorkSessions()
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

		private   void ExportCrewRegimeTR()
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

		private   void ExportCompanyDetails()
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





		//for new table ....

		private void ExportCIRMAccidentDetails()
		{
			SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
			con.Open();
			SqlCommand cmd = new SqlCommand("stpExportCIRMAccidentDetails", con);
			cmd.CommandType = CommandType.StoredProcedure;
			DataSet ds = new DataSet();
			SqlDataAdapter da = new SqlDataAdapter(cmd);
			da.Fill(ds);
			if (ds.Tables[0].Rows.Count > 0)
			{
				ds.WriteXml(path + "\\" + ConfigurationManager.AppSettings["CIRMAccidentDetailsxml"].ToString(), XmlWriteMode.WriteSchema);
			}
			con.Close();
		}

		private void ExportCIRMAffectedFindings()
		{
			SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
			con.Open();
			SqlCommand cmd = new SqlCommand("stpExportCIRMAffectedFindings", con);
			cmd.CommandType = CommandType.StoredProcedure;
			DataSet ds = new DataSet();
			SqlDataAdapter da = new SqlDataAdapter(cmd);
			da.Fill(ds);
			if (ds.Tables[0].Rows.Count > 0)
			{
				ds.WriteXml(path + "\\" + ConfigurationManager.AppSettings["CIRMAffectedFindingsxml"].ToString(), XmlWriteMode.WriteSchema);
			}
			con.Close();
		}

		private void ExportCIRMMedicalSymtomology()
		{
			SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
			con.Open();
			SqlCommand cmd = new SqlCommand("stpExportCIRMMedicalSymtomology", con);
			cmd.CommandType = CommandType.StoredProcedure;
			DataSet ds = new DataSet();
			SqlDataAdapter da = new SqlDataAdapter(cmd);
			da.Fill(ds);
			if (ds.Tables[0].Rows.Count > 0)
			{
				ds.WriteXml(path + "\\" + ConfigurationManager.AppSettings["CIRMMedicalSymtomologyxml"].ToString(), XmlWriteMode.WriteSchema);
			}
			con.Close();
		}

		private void ExportCIRMMedicalTreatmentGivenOnboard()
		{
			SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
			con.Open();
			SqlCommand cmd = new SqlCommand("stpExportCIRMMedicalTreatmentGivenOnboard", con);
			cmd.CommandType = CommandType.StoredProcedure;
			DataSet ds = new DataSet();
			SqlDataAdapter da = new SqlDataAdapter(cmd);
			da.Fill(ds);
			if (ds.Tables[0].Rows.Count > 0)
			{
				ds.WriteXml(path + "\\" + ConfigurationManager.AppSettings["CIRMMedicalTreatmentGivenOnboardxml"].ToString(), XmlWriteMode.WriteSchema);
			}
			con.Close();
		}

		private void ExportCIRMMedicationTaken()
		{
			SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
			con.Open();
			SqlCommand cmd = new SqlCommand("stpExportCIRMMedicationTaken", con);
			cmd.CommandType = CommandType.StoredProcedure;
			DataSet ds = new DataSet();
			SqlDataAdapter da = new SqlDataAdapter(cmd);
			da.Fill(ds);
			if (ds.Tables[0].Rows.Count > 0)
			{
				ds.WriteXml(path + "\\" + ConfigurationManager.AppSettings["CIRMMedicationTakenxml"].ToString(), XmlWriteMode.WriteSchema);
			}
			con.Close();
		}

		private void ExportCIRMTeleMedicalConsultation()
		{
			SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
			con.Open();
			SqlCommand cmd = new SqlCommand("stpExportCIRMTeleMedicalConsultation", con);
			cmd.CommandType = CommandType.StoredProcedure;
			DataSet ds = new DataSet();
			SqlDataAdapter da = new SqlDataAdapter(cmd);
			da.Fill(ds);
			if (ds.Tables[0].Rows.Count > 0)
			{
				ds.WriteXml(path + "\\" + ConfigurationManager.AppSettings["CIRMTeleMedicalConsultationxml"].ToString(), XmlWriteMode.WriteSchema);
			}
			con.Close();
		}


		public void ExportCIRMUploadedImagesPath(/*string ID*/)
		{
			SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
			con.Open();
			SqlCommand cmd = new SqlCommand("stpExportCIRMUploadedImagesPath", con);
			//cmd.Parameters.AddWithValue("@ID", ID);
			cmd.CommandType = CommandType.StoredProcedure;
			DataSet ds = new DataSet();
			SqlDataAdapter da = new SqlDataAdapter(cmd);
			da.Fill(ds);
			DataTable myTable = ds.Tables[0];
			List<string> stig = new List<string>();

			//PictureUploadPath = m.Field<string>("PictureUploadPath")
			for (int i = 0; i < myTable.Rows.Count; i++)
			{
				stig.Add(myTable.Rows[i]["FilePath"].ToString());
				string path = myTable.Rows[i]["FilePath"].ToString();


				string currentDirectory = Path.GetDirectoryName(path);

				string result;

				result = Path.GetFileNameWithoutExtension(currentDirectory);
				Console.WriteLine("GetFileName('{0}') returns '{1}'",
					currentDirectory, result);

				result = Path.GetFileName(path);
				Console.WriteLine("GetFileName('{0}') returns '{1}'",
					path, result);
			}

			con.Close();
			//return stig;
		}
		public async void ExportCIRMUploadedImages()
		{
			SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
			con.Open();
			SqlCommand cmd = new SqlCommand("stpExportCIRMUploadedImages", con);
			cmd.CommandType = CommandType.StoredProcedure;
			DataSet ds = new DataSet();
			SqlDataAdapter da = new SqlDataAdapter(cmd);
			da.Fill(ds);
			if (ds.Tables[0].Rows.Count > 0)
			{
				ds.WriteXml(path + "\\" + ConfigurationManager.AppSettings["CIRMUploadedImagesxml"].ToString(), XmlWriteMode.WriteSchema);
			}
			con.Close();
		}

		private void ExportCIRMVitalStatistics()
		{
			SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
			con.Open();
			SqlCommand cmd = new SqlCommand("stpExportCIRMVitalStatistics", con);
			cmd.CommandType = CommandType.StoredProcedure;
			DataSet ds = new DataSet();
			SqlDataAdapter da = new SqlDataAdapter(cmd);
			da.Fill(ds);
			if (ds.Tables[0].Rows.Count > 0)
			{
				ds.WriteXml(path + "\\" + ConfigurationManager.AppSettings["CIRMVitalStatisticsxml"].ToString(), XmlWriteMode.WriteSchema);
			}
			con.Close();
		}

		private void ExportCIRMVoyageDetails()
		{
			SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
			con.Open();
			SqlCommand cmd = new SqlCommand("stpExportCIRMVoyageDetails", con);
			cmd.CommandType = CommandType.StoredProcedure;
			DataSet ds = new DataSet();
			SqlDataAdapter da = new SqlDataAdapter(cmd);
			da.Fill(ds);
			if (ds.Tables[0].Rows.Count > 0)
			{
				ds.WriteXml(path + "\\" + ConfigurationManager.AppSettings["CIRMVoyageDetailsxml"].ToString(), XmlWriteMode.WriteSchema);
			}
			con.Close();
		}

		private void ExportCIRMWeatherDetails()
		{
			SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
			con.Open();
			SqlCommand cmd = new SqlCommand("stpExportCIRMWeatherDetails", con);
			cmd.CommandType = CommandType.StoredProcedure;
			DataSet ds = new DataSet();
			SqlDataAdapter da = new SqlDataAdapter(cmd);
			da.Fill(ds);
			if (ds.Tables[0].Rows.Count > 0)
			{
				ds.WriteXml(path + "\\" + ConfigurationManager.AppSettings["CIRMWeatherDetailsxml"].ToString(), XmlWriteMode.WriteSchema);
			}
			con.Close();
		}



		public void ExportExaminationForMedicalAdvisePath(/*string ID*/)
		{
			SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
			con.Open();
			SqlCommand cmd = new SqlCommand("stpExportExaminationForMedicalAdvisePath", con);
			//cmd.Parameters.AddWithValue("@ID", ID);
			cmd.CommandType = CommandType.StoredProcedure;
			DataSet ds = new DataSet();
			SqlDataAdapter da = new SqlDataAdapter(cmd);
			da.Fill(ds);
			DataTable myTable = ds.Tables[0];
			List<string> stig = new List<string>();

			//PictureUploadPath = m.Field<string>("PictureUploadPath")
			for (int i = 0; i < myTable.Rows.Count; i++)
			{
				stig.Add(myTable.Rows[i]["ExaminationPath"].ToString());
				string path = myTable.Rows[i]["ExaminationPath"].ToString();


				string currentDirectory = Path.GetDirectoryName(path);

				string result;

				result = Path.GetFileNameWithoutExtension(currentDirectory);
				Console.WriteLine("GetFileName('{0}') returns '{1}'",
					currentDirectory, result);

				result = Path.GetFileName(path);
				Console.WriteLine("GetFileName('{0}') returns '{1}'",
					path, result);
			}

			con.Close();
			//return stig;
		}

		private void ExportExaminationForMedicalAdvise()
		{
			SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
			con.Open();
			SqlCommand cmd = new SqlCommand("stpExportExaminationForMedicalAdvise", con);
			cmd.CommandType = CommandType.StoredProcedure;
			DataSet ds = new DataSet();
			SqlDataAdapter da = new SqlDataAdapter(cmd);
			da.Fill(ds);
			if (ds.Tables[0].Rows.Count > 0)
			{
				ds.WriteXml(path + "\\" + ConfigurationManager.AppSettings["ExaminationForMedicalAdvisexml"].ToString(), XmlWriteMode.WriteSchema);
			}
			con.Close();
		}

		private void ExportJoiningMedicalFileData()
		{
			SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
			con.Open();
			SqlCommand cmd = new SqlCommand("stpExportJoiningMedicalFileData", con);
			cmd.CommandType = CommandType.StoredProcedure;
			DataSet ds = new DataSet();
			SqlDataAdapter da = new SqlDataAdapter(cmd);
			da.Fill(ds);
			if (ds.Tables[0].Rows.Count > 0)
			{
				ds.WriteXml(path + "\\" + ConfigurationManager.AppSettings["JoiningMedicalFileDataxml"].ToString(), XmlWriteMode.WriteSchema);
			}
			con.Close();
		}


		public void ExportMedicalAdvisePath(/*string ID*/)
		{
			SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
			con.Open();
			SqlCommand cmd = new SqlCommand("stpExportMedicalAdvisePath", con);
			//cmd.Parameters.AddWithValue("@ID", ID);
			cmd.CommandType = CommandType.StoredProcedure;
			DataSet ds = new DataSet();
			SqlDataAdapter da = new SqlDataAdapter(cmd);
			da.Fill(ds);
			DataTable myTable = ds.Tables[0];
			List<string> stig = new List<string>();

			//PictureUploadPath = m.Field<string>("PictureUploadPath")
			for (int i = 0; i < myTable.Rows.Count; i++)
			{
				stig.Add(myTable.Rows[i]["Path"].ToString());
				string path = myTable.Rows[i]["Path"].ToString();


				string currentDirectory = Path.GetDirectoryName(path);

				string result;

				result = Path.GetFileNameWithoutExtension(currentDirectory);
				Console.WriteLine("GetFileName('{0}') returns '{1}'",
					currentDirectory, result);

				result = Path.GetFileName(path);
				Console.WriteLine("GetFileName('{0}') returns '{1}'",
					path, result);
			}

			con.Close();
			//return stig;
		}
		private void ExportMedicalAdvise()
		{
			SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
			con.Open();
			SqlCommand cmd = new SqlCommand("stpExportMedicalAdvise", con);
			cmd.CommandType = CommandType.StoredProcedure;
			DataSet ds = new DataSet();
			SqlDataAdapter da = new SqlDataAdapter(cmd);
			da.Fill(ds);
			if (ds.Tables[0].Rows.Count > 0)
			{
				ds.WriteXml(path + "\\" + ConfigurationManager.AppSettings["MedicalAdvisexml"].ToString(), XmlWriteMode.WriteSchema);
			}
			con.Close();
		}




		/// <summary>
		/// Moves file from ZipFile directory to Archive Directory
		/// </summary>
		private void ArchiveZipFiles()
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
		private   void SendMail()
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

		private   string GetConfigData(string KeyName)
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

		private   bool ZipDirectoryContainsZipFiles()
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
		private   string GetZipFileName()
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
