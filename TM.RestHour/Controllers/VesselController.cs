﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using TM.RestHour.BL;
using TM.RestHour.Models;
using TM.Base.Entities;
using System.Globalization;
using System.Configuration;

using System.Web.Script.Serialization;
using System.Collections;
using TM.Compliance;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Net;
using ExcelDataReader;
using TM.Base.Common;

namespace TM.RestHour.Controllers
{
    [TraceFilterAttribute]
    public class VesselController : BaseController
    {
		//
		// GET: /Vessel/
		[TraceFilterAttribute]
		public ActionResult Index()
        {
            GetVesselTypeForDrp();
            return View();
        }



        
       // [TraceFilterAttribute]
        public ActionResult InsertVessel()
        {
            return View();
        }

        public JsonResult GetCompanyDetails(string hash)
        {
            CompanyDetails decryptedCompanyInfo = new CompanyDetails();
            decryptedCompanyInfo = decryptedCompanyInfo.GetCompanyInfoFromHash(CryptoEngine.Decrypt(hash));
            decryptedCompanyInfo.SecureKey = hash;

            CompanyDetailsPOCO companydetails = new CompanyDetailsPOCO();

            companydetails.ID = decryptedCompanyInfo.ID;
            companydetails.Name = decryptedCompanyInfo.Name;
            companydetails.Address = decryptedCompanyInfo.Address;
            companydetails.Website = decryptedCompanyInfo.Website;
            companydetails.AdminContact = decryptedCompanyInfo.AdminContact;
            companydetails.AdminContactEmail = decryptedCompanyInfo.AdminContactEmail;
            companydetails.ContactNumber = decryptedCompanyInfo.ContactNumber;
            companydetails.Domain = decryptedCompanyInfo.Domain;
            companydetails.SecureKey = decryptedCompanyInfo.SecureKey;

            CompanyDetailsBL companyBL = new CompanyDetailsBL();
            companyBL.SaveCompanyDetails(companydetails);

            return Json(decryptedCompanyInfo, JsonRequestBehavior.AllowGet);



            //Console.WriteLine("Company Values Decrypted");
            //Console.WriteLine("Company ID: " + decryptedCompanyInfo.ID.ToString());
            //Console.WriteLine("Company Name: " + decryptedCompanyInfo.Name);
            //Console.WriteLine("Company Address: " + decryptedCompanyInfo.Address);
            //Console.WriteLine("Company Website: " + decryptedCompanyInfo.Website);
            //Console.WriteLine("Admin Contact: " + decryptedCompanyInfo.AdminContact);
            //Console.WriteLine("Admin Contact email: " + decryptedCompanyInfo.AdminContactEmail);
            //Console.WriteLine("Contact Number: " + decryptedCompanyInfo.ContactNumber);
            //Console.WriteLine("Company Domain: " + decryptedCompanyInfo.Domain);

        }

        [HttpPost]
        public ActionResult InsertVessel(HttpPostedFileBase postedFile)
        {
            object dtData = new object();
            EquipmentsBL eqipmentBL = new EquipmentsBL();
            string fileName = string.Empty;

            if (postedFile != null)
            {
                string path = Server.MapPath(ConfigurationManager.AppSettings["companylogoUploadPath"].ToString());
                if (!Directory.Exists(path))
                {
                    Directory.CreateDirectory(path);
                }

                fileName = Path.Combine(Server.MapPath("~/companylogo"), "companylogo.png");

                if (System.IO.File.Exists( fileName))
                {
                    System.IO.File.Delete(fileName);
                }

                postedFile.SaveAs(fileName);
                ViewBag.Message = "File uploaded successfully.";

               

            }

            return View();
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
                length = 10;
            }

            if (start == 0)
            {
                pageIndex = 1;
            }
            else
            {
                pageIndex = (start / length) + 1;
            }

            ShipBL shipBL = new ShipBL();
            int totalrecords = 0;

            List<ShipPOCO> shippocoList = new List<ShipPOCO>();
            shippocoList = shipBL.GetShipPageWise(pageIndex, ref totalrecords, length);
            List<Vessel> shipList = new List<Vessel>();
            foreach (ShipPOCO shipPC in shippocoList)
            {
                Vessel ship = new Vessel();
                ship.ID = shipPC.ID;
                ship.ShipName = shipPC.ShipName;
                ship.FlagOfShip = shipPC.FlagOfShip;
                ship.IMONumber = shipPC.IMONumber;
                shipList.Add(ship);
            }

            var data = shipList;

            return Json(new { draw = draw, recordsFiltered = totalrecords, recordsTotal = totalrecords, data = data }, JsonRequestBehavior.AllowGet);
        }

        public JsonResult Add(Vessel ship)
        {
            ShipBL shipBL = new ShipBL();
            ShipPOCO shipPC = new ShipPOCO();
            shipPC.ID = ship.ID;
            shipPC.ShipName = ship.ShipName;
            shipPC.FlagOfShip = ship.FlagOfShip;
            shipPC.IMONumber = ship.IMONumber;
            return Json(shipBL.SaveShip(shipPC, int.Parse(Session["VesselID"].ToString())), JsonRequestBehavior.AllowGet);
        }

		public JsonResult Update(Vessel ship)
		{
			ShipBL shipBL = new ShipBL();
			ShipPOCO shipPC = new ShipPOCO();
			shipPC.ID = ship.ID;
			shipPC.ShipName = ship.ShipName;
			shipPC.FlagOfShip = ship.FlagOfShip;
			shipPC.IMONumber = ship.IMONumber;

            shipPC.ShipEmail = ship.ShipEmail;

            return Json(shipBL.UpdateShip(shipPC, int.Parse(Session["VesselID"].ToString())), JsonRequestBehavior.AllowGet);
		}

		public JsonResult NewAdd(Vessel ship)
        {
            ShipBL shipBL = new ShipBL();
            ShipPOCO shipPC = new ShipPOCO();
            //shipPC.ID = ship.ID;
            shipPC.ShipName = ship.ShipName;
            shipPC.FlagOfShip = ship.FlagOfShip;
            shipPC.IMONumber = ship.IMONumber;
            shipPC.SuperAdminUserName = ship.SuperAdminUserName;
            shipPC.SuperAdminPassword = ship.SuperAdminPassword;
            return Json(shipBL.SaveNewShip(shipPC), JsonRequestBehavior.AllowGet);
        }


        public JsonResult GetAllShip()
        {
            ShipBL shipBL = new ShipBL();
            //ShipPOCO shipPC = new ShipPOCO();
            //shipPC.ID = ship.ID;
            //shipPC.ShipName = ship.ShipName;
            return Json(shipBL.GetAllShip(), JsonRequestBehavior.AllowGet);
        }



        public JsonResult AddNewVessel(Vessel ship)
        {
            ShipBL shipBL = new ShipBL();
            ShipPOCO shipPC = new ShipPOCO();
            shipPC.ID = ship.ID;
            shipPC.ShipName = ship.ShipName;
            shipPC.FlagOfShip = ship.FlagOfShip;
            shipPC.IMONumber = ship.IMONumber;

            int rowaffected = shipBL.SaveShip(shipPC, int.Parse(Session["VesselID"].ToString()));
            if (rowaffected > 0)
            {
                return Json(new { result = "Redirect", url = Url.Action("Index", "Home") });
            }
            else
            {
                return Json(new { result = "Error" }, JsonRequestBehavior.AllowGet);
            }
        }

        public JsonResult DeleteVessel(string ID)
        {
            ShipBL shipBL = new ShipBL();
            return Json(shipBL.DeleteShip(int.Parse(ID)), JsonRequestBehavior.AllowGet);
            int recordaffected = 0;
            return Json(recordaffected, JsonRequestBehavior.AllowGet);
        }

        [HttpGet]
        public JsonResult GetShipByID()
        {
            ShipBL shipBL = new ShipBL();
            ShipPOCO shipPC = new ShipPOCO();

            shipPC = shipBL.GetShipByID();

            Vessel um = new Vessel();

            um.ID = shipPC.ID;
            um.ShipName = shipPC.ShipName;
            um.FlagOfShip = shipPC.FlagOfShip;
            um.IMONumber = shipPC.IMONumber;

            um.ShipEmail = shipPC.ShipEmail;

            var cm = um;

            return Json(cm, JsonRequestBehavior.AllowGet);
        }





        public JsonResult SaveInitialShipValues(Vessel ship)
        {
            ShipBL shipBL = new ShipBL();
            ShipPOCO shipPC = new ShipPOCO();
            //shipPC.ID = ship.ID;
            shipPC.Vessel = ship.Vessel1;
            shipPC.Flag = ship.Flag;
            shipPC.IMO = ship.IMO;
            shipPC.AdminUser = ship.AdminUser;
            shipPC.AdminPassword = ship.AdminPassword;
            return Json(shipBL.SaveInitialShipValues(shipPC), JsonRequestBehavior.AllowGet);
        }

        public JsonResult SaveConfigData(Vessel ship)
        {
            ShipBL shipBL = new ShipBL();
            ShipPOCO shipPC = new ShipPOCO();
            shipPC.SmtpServer = ship.SmtpServer;
            shipPC.Port = ship.Port;
            //shipPC.MailFrom = ship.MailFrom;
            //shipPC.MailTo = ship.MailTo;
            //shipPC.MailPassword = ship.MailPassword;
            shipPC.ShipEmail = ship.ShipEmail;
            shipPC.ShipEmailPassword = ship.ShipEmailPassword;
            shipPC.AdminCenterEmail = ship.AdminCenterEmail;
            shipPC.POP3 = ship.POP3;
            shipPC.POP3Port = ship.POP3Port;

            return Json(shipBL.SaveConfigData(shipPC), JsonRequestBehavior.AllowGet);
        }


        public JsonResult GetConfigData(string KeyName)
        {
            ShipBL shipBL = new ShipBL();
            //return shipBL.GetConfigData(KeyName);

            return Json(shipBL.GetConfigData(KeyName), JsonRequestBehavior.AllowGet);
        }








        //for VesselType drp
        public void GetVesselTypeForDrp()
        {
            ShipBL shipBL = new ShipBL();
            List<ShipPOCO> pocoList = new List<ShipPOCO>();

            pocoList = shipBL.GetVesselTypeForDrp(/*int.Parse(Session["VesselID"].ToString())*/);


            List<Vessel> itmasterList = new List<Vessel>();

            foreach (ShipPOCO up in pocoList)
            {
                Vessel unt = new Vessel();
                unt.VesselTypeID = up.VesselTypeID;
                unt.Description = up.Description;

                itmasterList.Add(unt);
            }

            ViewBag.VesselType = itmasterList.Select(x =>
                                            new SelectListItem()
                                            {
                                                Text = x.Description,
                                                Value = x.VesselTypeID.ToString()
                                            });

        }


        //for VesselSubTypeByVesselTypeIDForDrp drp
        public JsonResult GetVesselSubTypeByVesselTypeIDForDrp(string VesselTypeID)
        {
            ShipBL shipBL = new ShipBL();
            List<ShipPOCO> blockpocoList = new List<ShipPOCO>();

            blockpocoList = shipBL.GetVesselSubTypeByVesselTypeIDForDrp(VesselTypeID);

            List<Vessel> blockList = new List<Vessel>();

            foreach (ShipPOCO up in blockpocoList)
            {
                Vessel comp = new Vessel();
                comp.SubTypeDescription = up.SubTypeDescription;
                comp.VesselSubTypeID = up.VesselSubTypeID;

                blockList.Add(comp);
            }
            var data = blockList;

            return Json(data, JsonRequestBehavior.AllowGet);
        }


        //for VesselSubSubTypeByVesselSubTypeIDForDrp drp
        public JsonResult GetVesselSubSubTypeByVesselSubTypeIDForDrp(string VesselSubTypeID)
        {
            ShipBL shipBL = new ShipBL();
            List<ShipPOCO> blockpocoList = new List<ShipPOCO>();

            blockpocoList = shipBL.GetVesselSubSubTypeByVesselSubTypeIDForDrp(VesselSubTypeID);

            List<Vessel> blockList = new List<Vessel>();

            foreach (ShipPOCO up in blockpocoList)
            {
                Vessel comp = new Vessel();
                comp.VesselSubSubTypeDecsription = up.VesselSubSubTypeDecsription;
                comp.VesselSubSubTypeID = up.VesselSubSubTypeID;

                blockList.Add(comp);
            }
            var data = blockList;

            return Json(data, JsonRequestBehavior.AllowGet);
        }
    }
}