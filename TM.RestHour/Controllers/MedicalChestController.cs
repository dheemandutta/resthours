using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using TM.RestHour.BL;
using TM.RestHour.Models;
using TM.Base.Entities;
using System.Globalization;
using System.Web.Script.Serialization;
using System.Collections;
using TM.Compliance;
using System.Text;
using System.IO;
using System.Configuration;

using System.Net;
using System.Net.Mail;

namespace TM.RestHour.Controllers
{
    public class MedicalChestController : Controller
    {
        // GET: MedicalChest

        #region Action Methods
        public ActionResult MedicalChestCertificate()
        {
            return View();
        }
        #endregion

        #region Get Methods

        public JsonResult GetLatestMedicalChestCertificate()
        {
            MedicalChest mediChest = new MedicalChest();
            MedicalChestPOCO mediChestPoco = new MedicalChestPOCO();

            MedicalChestBL mediChestBl = new MedicalChestBL();

            mediChestPoco = mediChestBl.GetLatestMedicalChestCertificate(int.Parse(Session["VesselID"].ToString()));


            mediChest.ChestID               = mediChestPoco.ChestID;
            mediChest.VesselId              = mediChestPoco.VesselId;
            mediChest.IssuingAuthorityName  = mediChestPoco.IssuingAuthorityName;
            mediChest.IssueDate             = mediChestPoco.IssueDate;
            mediChest.ExpiryDate            = mediChestPoco.ExpiryDate;
            mediChest.CertificateImageName  = mediChestPoco.CertificateImageName;
            mediChest.CertificateImagePath  = mediChestPoco.CertificateImagePath;



            return Json(mediChest, JsonRequestBehavior.AllowGet);
        }

        #endregion


        #region Save Methods


        public JsonResult SaveMedicalChestCertificate(MedicalChestPOCO medicalChest)
        {
            MedicalChestBL mediChestBl = new MedicalChestBL();
            medicalChest.VesselId = int.Parse(Session["VesselID"].ToString());
            return Json(mediChestBl.SaveMedicalChestCerticate(medicalChest), JsonRequestBehavior.AllowGet);
        }

        #endregion


        #region Upload Methods


        public JsonResult UploadMedicalChestCertificateImage()
        {
            if (Request.Files.Count > 0)
            {
                try
                {
                    string path = Server.MapPath(ConfigurationManager.AppSettings["MedicalChestImagesPath"].ToString());
                    string filePath = ConfigurationManager.AppSettings["MedicalChestImagesPath"].ToString();
                    if (!Directory.Exists(path))
                    {
                        Directory.CreateDirectory(path);
                    }
                    List<string> returnMsg = new List<string>();
                    int vesselId = int.Parse(Session["VesselID"].ToString());
                    int fileCount = 0;
                    string fileName = String.Empty; //Path.GetFileNameWithoutExtension(postedFile.FileName);
                    fileName = "MedicalChestCertificate" + "_" + vesselId + "_";
                    DirectoryInfo di = new DirectoryInfo(path);

                    fileCount = di.GetFiles("*.*").Where(file => file.Name.StartsWith(fileName)).Count();
                    //var count = (from file in Directory.EnumerateFiles(path, "*.*", SearchOption.AllDirectories)
                    //                 select file).Count();

                    fileName = fileName + (fileCount + 1);

                    //  Get all files from Request object  
                    HttpFileCollectionBase files = Request.Files;
                    for (int i = 0; i < files.Count; i++)
                    {

                        HttpPostedFileBase file = files[i];
                        string fname;
                        string extn;

                        // Checking for Internet Explorer  
                        if (Request.Browser.Browser.ToUpper() == "IE" || Request.Browser.Browser.ToUpper() == "INTERNETEXPLORER")
                        {
                            string[] testfiles = file.FileName.Split(new char[] { '\\' });
                            fname = testfiles[testfiles.Length - 1];
                            extn = Path.GetExtension(fname);
                        }
                        else
                        {
                            fname = file.FileName;
                            extn = Path.GetExtension(file.FileName);
                        }
                        
                        if (System.IO.File.Exists(path + fileName))
                        {
                            System.IO.File.Delete(path + fileName);
                        }
                        fileName = fileName + extn;
                        // Get the complete folder path and store the file inside it.  
                        string fnameWithServerPath = Path.Combine(path, fileName);
                        string fnameWithPath = Path.Combine(filePath, fileName);
                        file.SaveAs(fnameWithServerPath);
                        returnMsg.Add(fnameWithPath);

                    }

                    returnMsg.Add(fileName);


                    return Json(returnMsg, JsonRequestBehavior.AllowGet);
                }
                catch (Exception ex)
                {
                    return Json("Error occurred. Error details: " + ex.Message);
                }
            }
            else
            {
                return Json("No files selected.");
            }
        }



        #endregion
    }
}