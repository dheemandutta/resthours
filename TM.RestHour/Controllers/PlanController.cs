using System;
using System.IO;
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
using System.Configuration;

namespace TM.RestHour.Controllers
{
    public class PlanController : Controller
    {
        string parentPdfPath = "/PlanImages/";
        // GET: Plan
        public ActionResult Index()
        {
            PlanCategoryVM planCatVM = new PlanCategoryVM();
            planCatVM.PlanCategoryList = GetAllPlanCategoryDetails();

            return View(planCatVM);
        }

        [HttpPost]
        public JsonResult AddPlanCategory(Plan planCategory)
        {
            PlanBL planBl = new PlanBL();
            PlanPOCO planCatPo = new PlanPOCO();
            string crewUserId = string.Empty;

            planCatPo.CategoryId = planCategory.CategoryId;
            planCatPo.CategoryName = planCategory.CategoryName;


            return Json(planBl.SavePlanCategory(planCatPo), JsonRequestBehavior.AllowGet);
        }
        [HttpPost]
        public JsonResult AddPlan(Plan plan)
        {
            PlanBL planBl = new PlanBL();
            PlanPOCO planPo = new PlanPOCO();
            string crewUserId = string.Empty;

            planPo.PlanId = plan.PlanId;
            planPo.CategoryId = plan.CategoryId;
            planPo.PlanName = plan.PlanName;
            planPo.PlanImagePath = plan.PlanImagePath;
            planPo.CreatedBy = Convert.ToInt32(Session["UserID"].ToString());

            
            return Json(planBl.SavePlan(planPo), JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetAllPlanCategory()
        {
            PlanBL planBl = new PlanBL();
            return Json(planBl.GetAllPlanCategory(), JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetPlanById(string planId)
        {
            PlanBL planBl = new PlanBL();
            Plan plan = new Plan();
            PlanPOCO planPo = new PlanPOCO();
            planPo.PlanId = Convert.ToInt32(planId);
            planPo = planBl.GetPlanById(planPo);
            Vessel um = new Vessel();

            plan.PlanId = planPo.PlanId;
            plan.PlanName = planPo.PlanName;
            plan.PlanImagePath = plan.PlanImagePath;

            return Json(plan, JsonRequestBehavior.AllowGet);
        }


        public List<Plan> GetAllPlanCategoryDetails()
        {
            List<Plan> planCatList = new List<Plan>();
            List<PlanPOCO> planCatPoList = new List<PlanPOCO>();
            
            PlanBL planBl = new PlanBL();
            PlanPOCO planPo = new PlanPOCO();
            planCatPoList = planBl.GetAllPlanCategory();

            if(planCatPoList.Count > 0)
            {
                foreach(PlanPOCO pCatPo in planCatPoList)
                {
                    Plan planCat = new Plan();
                    planCat.CategoryId = pCatPo.CategoryId;
                    planCat.CategoryName = pCatPo.CategoryName;

                    planCat.PlanList = GetAllPlanDetails(pCatPo.CategoryId);

                    planCatList.Add(planCat);
                }
            }


            return planCatList;
        }

        public List<Plan> GetAllPlanDetails(int categoryId)
        {
            PlanBL planBl = new PlanBL();
            List<Plan> planList = new List<Plan>();

            List<PlanPOCO> planPoList = new List<PlanPOCO>();
            planPoList = planBl.GetPlanByCategory(categoryId);
            if(planPoList.Count > 0)
            {
                foreach(PlanPOCO pPo in planPoList)
                {
                    Plan plan           = new Plan();
                    plan.PlanId         = pPo.PlanId;
                    plan.PlanName       = pPo.PlanName;
                    plan.PlanImagePath  = pPo.PlanImagePath;

                    planList.Add(plan);
                }
            }
            return planList;
        }
        public JsonResult GetPlanByCategoryForDropDown(string categoryId)
        {
            
            PlanBL planBl = new PlanBL();
            List<Plan> planList = new List<Plan>();

            List<PlanPOCO> planPoList = new List<PlanPOCO>();
            planPoList = planBl.GetPlanByCategory(Convert.ToInt32(categoryId));
            if (planPoList.Count > 0)
            {
                foreach (PlanPOCO pPo in planPoList)
                {
                    Plan plan = new Plan();
                    plan.PlanId = pPo.PlanId;
                    plan.PlanName = pPo.PlanName;
                    planList.Add(plan);
                }
            }


            var data = planList;

            return Json(data, JsonRequestBehavior.AllowGet);
        }

        public JsonResult PreviewModal(string relPDFPath)
        {
            Plan file = new Plan();
            string filePath = "";
            filePath = Path.ChangeExtension(relPDFPath, "pdf");
            file.PlanName = Path.GetFileName(filePath);
            file.PlanImagePath = parentPdfPath + filePath;
            return Json(file, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult UploadPlanImages(string category, string planName)
        {
            if (Request.Files.Count > 0)
            {
                try
                {
                    List<string> returnMsg = new List<string>();
                    string fileName = String.Empty; //Path.GetFileNameWithoutExtension(postedFile.FileName);
                    fileName = category + "_" + planName;//Useless
                    
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
                        string path = Server.MapPath(ConfigurationManager.AppSettings["PlanImagesPath"].ToString());
                        string filePath = ConfigurationManager.AppSettings["PlanImagesPath"].ToString();
                        if (!Directory.Exists(path))
                        {
                            Directory.CreateDirectory(path);
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

                    returnMsg.Add(planName + " File Uploaded Successfully!");


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


    }
}