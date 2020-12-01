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
using System.Threading.Tasks;
using System.IO;
using System.Net;
using ExcelDataReader;
using System.Configuration;

using TM.Base.Common;
//using System.Threading.Tasks;

namespace TM.RestHour.Controllers
{
    [TraceFilterAttribute]
    public class EquipmentsController : BaseController
    {
        // GET: Equipments
        [TraceFilterAttribute]
        public ActionResult Index()
        {
            return View();
        }

        [TraceFilterAttribute]
        public ActionResult Index2()
        {
            return View();
        }

        public JsonResult SaveEquipments(Equipments equipments)
        {
            EquipmentsBL equipmentsBL = new EquipmentsBL();
            EquipmentsPOCO equipmentsPC = new EquipmentsPOCO();

            equipmentsPC.EquipmentsID = equipments.EquipmentsID;
            equipmentsPC.EquipmentsName = equipments.EquipmentsName;       
            equipmentsPC.Comment = equipments.Comment;
            equipmentsPC.Quantity = equipments.Quantity;

            equipmentsPC.ExpiryDate = equipments.ExpiryDate;
            equipmentsPC.Location = equipments.Location;

            return Json(equipmentsBL.SaveEquipments(equipmentsPC  /*, int.Parse(Session["VesselID"].ToString())*/  ), JsonRequestBehavior.AllowGet);
        }

        public JsonResult LoadData()
        {
            int draw, start, length;
            int pageIndex = 0;

            if (null != Request.Form.GetValues("draw"))
            {
                draw = int.Parse(Request.Form.GetValues("draw").FirstOrDefault().ToString());
                start = int.Parse(Request.Form.GetValues("start").FirstOrDefault().ToString());
                length = int.Parse(Request.Form.GetValues("length").FirstOrDefault().ToString());
            }
            else
            {
                draw = 1;
                start = 0;
                length = 500;
            }

            if (start == 0)
            {
                pageIndex = 1;
            }
            else
            {
                pageIndex = (start / length) + 1;
            }

            EquipmentsBL equipmentsBL = new EquipmentsBL();
            int totalrecords = 0;

            List<EquipmentsPOCO> equipmentspocoList = new List<EquipmentsPOCO>();
            equipmentspocoList = equipmentsBL.GetEquipmentsPageWise(pageIndex, ref totalrecords, length/*, int.Parse(Session["VesselID"].ToString())*/);
            List<Equipments> equipmentsList = new List<Equipments>();
            foreach (EquipmentsPOCO equipmentsPC in equipmentspocoList)
            {
                Equipments equipments = new Equipments();
                equipments.EquipmentsID = equipmentsPC.EquipmentsID;
                equipments.EquipmentsName = equipmentsPC.EquipmentsName;
                equipments.Comment = equipmentsPC.Comment;
                equipments.Quantity = equipmentsPC.Quantity;
                equipments.ExpiryDate = equipmentsPC.ExpiryDate;
                equipments.Location = equipmentsPC.Location;

                equipmentsList.Add(equipments);
            }

            var data = equipmentsList;

            return Json(new { draw = draw, recordsFiltered = totalrecords, recordsTotal = totalrecords, data = data }, JsonRequestBehavior.AllowGet);
        }


        public JsonResult LoadDataPrint()
        {
            int draw, start, length;
            int pageIndex = 0;

            if (null != Request.Form.GetValues("draw"))
            {
                draw = int.Parse(Request.Form.GetValues("draw").FirstOrDefault().ToString());
                start = int.Parse(Request.Form.GetValues("start").FirstOrDefault().ToString());
                length = 1000;//int.Parse(Request.Form.GetValues("length").FirstOrDefault().ToString());
            }
            else
            {
                draw = 1;
                start = 0;
                length = 1000;
            }

            if (start == 0)
            {
                pageIndex = 1;
            }
            else
            {
                pageIndex = (start / length) + 1;
            }

            EquipmentsBL equipmentsBL = new EquipmentsBL();
            int totalrecords = 0;

            List<EquipmentsPOCO> equipmentspocoList = new List<EquipmentsPOCO>();
            equipmentspocoList = equipmentsBL.GetEquipmentsPageWise(pageIndex, ref totalrecords, length/*, int.Parse(Session["VesselID"].ToString())*/);
            List<Equipments> equipmentsList = new List<Equipments>();
            foreach (EquipmentsPOCO equipmentsPC in equipmentspocoList)
            {
                Equipments equipments = new Equipments();
                equipments.EquipmentsID = equipmentsPC.EquipmentsID;
                equipments.EquipmentsName = equipmentsPC.EquipmentsName;
                equipments.Comment = equipmentsPC.Comment;
                equipments.Quantity = equipmentsPC.Quantity;
                equipments.ExpiryDate = equipmentsPC.ExpiryDate;
                equipments.Location = equipmentsPC.Location;

                equipmentsList.Add(equipments);
            }

            var data = equipmentsList;

            return Json(new { draw = draw, recordsFiltered = totalrecords, recordsTotal = totalrecords, data = data }, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        [TraceFilterAttribute]
        public ActionResult Index(HttpPostedFileBase postedFile)
        {
			object dtData = new object();
			EquipmentsBL eqipmentBL = new EquipmentsBL();
			string fileName = string.Empty;

			if (postedFile != null)
            {
                string path = Server.MapPath(ConfigurationManager.AppSettings["EquipmentUploadPath"].ToString());
                if (!Directory.Exists(path))
                {
                    Directory.CreateDirectory(path);
                }
                
                fileName = Path.GetFileName(postedFile.FileName);

                if (System.IO.File.Exists(path + fileName))
                {
                    System.IO.File.Delete(path + fileName);
                }

                postedFile.SaveAs(path + Path.GetFileName(postedFile.FileName));
                ViewBag.Message = "File uploaded successfully.";

				string filePath = path + fileName;

				// read file 
				using (var stream = System.IO.File.Open(filePath, FileMode.Open, FileAccess.Read))
				{

					// Auto-detect format, supports:
					//  - Binary Excel files (2.0-2003 format; *.xls)
					//  - OpenXml Excel files (2007 format; *.xlsx)
					using (var reader = ExcelReaderFactory.CreateReader(stream))
					{

						

						// 2. Use the AsDataSet extension method
						var dataSet = reader.AsDataSet(new ExcelDataSetConfiguration()
						{
							// Gets or sets a callback to determine which row is the header row. 
							// Only called when UseHeaderRow = true.
							ConfigureDataTable = _ => new ExcelDataTableConfiguration
							{
								UseHeaderRow = true // Use first row is ColumnName here :D
							}
						});

						if (dataSet.Tables.Count > 0)
						{
							dtData = dataSet.Tables[0];
							// Do Something
						}

						// The result of each spreadsheet is in result.Tables
					}

					eqipmentBL.ImportEquipment(dtData);
				}

			}

            return View();
        }


        public JsonResult GetMedicalEquipmentByID(int EquipmentsID)
        {
            EquipmentsBL equipmentsBL = new EquipmentsBL();
            EquipmentsPOCO equipmentsPOCOList = new EquipmentsPOCO();

            equipmentsPOCOList = equipmentsBL.GetMedicalEquipmentByID(EquipmentsID /*, int.Parse(Session["VesselID"].ToString())*/);

            Equipments dept = new Equipments();

            dept.EquipmentsID = equipmentsPOCOList.EquipmentsID;
            dept.EquipmentsName = equipmentsPOCOList.EquipmentsName;
            dept.Comment = equipmentsPOCOList.Comment;
            dept.Quantity = equipmentsPOCOList.Quantity;
            dept.ExpiryDate = equipmentsPOCOList.ExpiryDate;
            dept.Location = equipmentsPOCOList.Location;

            var data = dept;

            return Json(data, JsonRequestBehavior.AllowGet);
        }





        public JsonResult GetMedicineByID(int MedicineID)
        {
            EquipmentsBL equipmentsBL = new EquipmentsBL();
            EquipmentsPOCO equipmentsPOCOList = new EquipmentsPOCO();

            equipmentsPOCOList = equipmentsBL.GetMedicineByID(MedicineID /*, int.Parse(Session["VesselID"].ToString())*/);

            Equipments dept = new Equipments();

            dept.MedicineID = equipmentsPOCOList.MedicineID;
            dept.MedicineName = equipmentsPOCOList.MedicineName;
            //dept.Comment = equipmentsPOCOList.Comment;
            dept.Quantity = equipmentsPOCOList.Quantity;
            dept.ExpiryDate = equipmentsPOCOList.ExpiryDate;
            dept.Location = equipmentsPOCOList.Location;

            var data = dept;

            return Json(data, JsonRequestBehavior.AllowGet);
        }








        public JsonResult SaveMedicine(Equipments equipments)
        {
            EquipmentsBL equipmentsBL = new EquipmentsBL();
            EquipmentsPOCO equipmentsPC = new EquipmentsPOCO();
            //consultantPC.DoctorID = consultant.DoctorID;
            equipmentsPC.MedicineID = equipments.MedicineID;
            equipmentsPC.MedicineName = equipments.MedicineName;
            equipmentsPC.Quantity = equipments.Quantity;

            equipmentsPC.ExpiryDate = equipments.ExpiryDate;
            equipmentsPC.Location = equipments.Location;

            return Json(equipmentsBL.SaveMedicine(equipmentsPC  /*, int.Parse(Session["VesselID"].ToString())*/  ), JsonRequestBehavior.AllowGet);
        }

        public JsonResult LoadData2()
        {
            int draw, start, length;
            int pageIndex = 0;

            if (null != Request.Form.GetValues("draw"))
            {
                draw = int.Parse(Request.Form.GetValues("draw").FirstOrDefault().ToString());
                start = int.Parse(Request.Form.GetValues("start").FirstOrDefault().ToString());
                length = int.Parse(Request.Form.GetValues("length").FirstOrDefault().ToString());
            }
            else
            {
                draw = 1;
                start = 0;
                length = 500;
            }

            if (start == 0)
            {
                pageIndex = 1;
            }
            else
            {
                pageIndex = (start / length) + 1;
            }

            EquipmentsBL equipmentsBL = new EquipmentsBL();
            int totalrecords = 0;

            List<EquipmentsPOCO> equipmentspocoList = new List<EquipmentsPOCO>();
            equipmentspocoList = equipmentsBL.GetMedicinePageWise(pageIndex, ref totalrecords, length/*, int.Parse(Session["VesselID"].ToString())*/);
            List<Equipments> equipmentsList = new List<Equipments>();
            foreach (EquipmentsPOCO equipmentsPC in equipmentspocoList)
            {
                Equipments equipments = new Equipments();
                equipments.MedicineID = equipmentsPC.MedicineID;
                equipments.MedicineName = equipmentsPC.MedicineName;
                equipments.Quantity = equipmentsPC.Quantity;
                equipments.ExpiryDate = equipmentsPC.ExpiryDate;
                equipments.Location = equipmentsPC.Location;

                equipmentsList.Add(equipments);
            }

            var data = equipmentsList;

            return Json(new { draw = draw, recordsFiltered = totalrecords, recordsTotal = totalrecords, data = data }, JsonRequestBehavior.AllowGet);
        }

        public JsonResult LoadData2Print()
        {
            int draw, start, length;
            int pageIndex = 0;

            if (null != Request.Form.GetValues("draw"))
            {
                draw = int.Parse(Request.Form.GetValues("draw").FirstOrDefault().ToString());
                start = int.Parse(Request.Form.GetValues("start").FirstOrDefault().ToString());
                length = 1000;//int.Parse(Request.Form.GetValues("length").FirstOrDefault().ToString());
            }
            else
            {
                draw = 1;
                start = 0;
                length = 1000;
            }

            if (start == 0)
            {
                pageIndex = 1;
            }
            else
            {
                pageIndex = (start / length) + 1;
            }

            EquipmentsBL equipmentsBL = new EquipmentsBL();
            int totalrecords = 0;

            List<EquipmentsPOCO> equipmentspocoList = new List<EquipmentsPOCO>();
            equipmentspocoList = equipmentsBL.GetMedicinePageWise(pageIndex, ref totalrecords, length/*, int.Parse(Session["VesselID"].ToString())*/);
            List<Equipments> equipmentsList = new List<Equipments>();
            foreach (EquipmentsPOCO equipmentsPC in equipmentspocoList)
            {
                Equipments equipments = new Equipments();
                equipments.MedicineID = equipmentsPC.MedicineID;
                equipments.MedicineName = equipmentsPC.MedicineName;
                equipments.Quantity = equipmentsPC.Quantity;
                equipments.ExpiryDate = equipmentsPC.ExpiryDate;
                equipments.Location = equipmentsPC.Location;

                equipmentsList.Add(equipments);
            }

            var data = equipmentsList;

            return Json(new { draw = draw, recordsFiltered = totalrecords, recordsTotal = totalrecords, data = data }, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        [TraceFilterAttribute]
        public ActionResult Index2(HttpPostedFileBase postedFile)
        {
            if (postedFile != null)
            {
                string path = Server.MapPath(ConfigurationManager.AppSettings["MedicineUploadPath"].ToString());
                if (!Directory.Exists(path))
                {
                    Directory.CreateDirectory(path);
                }


				object dtData = new object();
				EquipmentsBL eqipmentBL = new EquipmentsBL();

				string fileName = string.Empty;
                fileName = Path.GetFileName(postedFile.FileName);

                if (System.IO.File.Exists(path + fileName))
                {
                    System.IO.File.Delete(path + fileName);
                }

                postedFile.SaveAs(path + Path.GetFileName(postedFile.FileName));
                ViewBag.Message = "File uploaded successfully.";

				string filePath = path + fileName;

				// read file 
				using (var stream = System.IO.File.Open(filePath, FileMode.Open, FileAccess.Read))
				{

					// Auto-detect format, supports:
					//  - Binary Excel files (2.0-2003 format; *.xls)
					//  - OpenXml Excel files (2007 format; *.xlsx)
					using (var reader = ExcelReaderFactory.CreateReader(stream))
					{

						// Choose one of either 1 or 2:

						// 1. Use the reader methods
						//do
						//{
						//	while (reader.Read())
						//	{
						//		reader.GetString(0);
						//	}
						//} while (reader.NextResult());

						// 2. Use the AsDataSet extension method
						var dataSet = reader.AsDataSet(new ExcelDataSetConfiguration()
						{
							// Gets or sets a callback to determine which row is the header row. 
							// Only called when UseHeaderRow = true.
							ConfigureDataTable = _ => new ExcelDataTableConfiguration
							{
								UseHeaderRow = true // Use first row is ColumnName here :D
							}
						});

						if (dataSet.Tables.Count > 0)
						{
							 dtData = dataSet.Tables[0];
							// Do Something
						}

						// The result of each spreadsheet is in result.Tables
					}

					eqipmentBL.ImportMedicine(dtData);
				}
			}

            return View();
        }




        public ActionResult DeleteEquipments(int EquipmentsID/*, ref string recordCount*/)
        {
            EquipmentsBL equipmentsBL = new EquipmentsBL();
            int recordaffected = equipmentsBL.DeleteEquipments(EquipmentsID/*, ref recordCount*/);
            return Json(recordaffected, JsonRequestBehavior.AllowGet);

        }
        public ActionResult DeleteMedicine(int MedicineID/*, ref string recordCount*/)
        {
            EquipmentsBL equipmentsBL = new EquipmentsBL();
            int recordaffected = equipmentsBL.DeleteMedicine(MedicineID/*, ref recordCount*/);
            return Json(recordaffected, JsonRequestBehavior.AllowGet);

        }
    }
}