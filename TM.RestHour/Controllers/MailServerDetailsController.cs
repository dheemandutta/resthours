using System;
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
    public class MailServerDetailsController : Controller
    {
        // GET: MailServerDetails
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult IndexIn()
        {
            return View();
        }























        //
        // GET: /Vessel/
        //[TraceFilterAttribute]
        public ActionResult FirstRun()
        {
            return View();
        }




        // [TraceFilterAttribute]
        //public ActionResult InsertVessel()
        //{
        //    return View();
        //}

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
        public ActionResult FirstRun(HttpPostedFileBase postedFile)
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

                if (System.IO.File.Exists(fileName))
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

            string deactivationDate =  CryptoEngine.Encrypt(System.DateTime.Today.AddDays(90).ToString(), ship.IMO.ToString());

            shipPC.DeactivationDate = deactivationDate;


            return Json(shipBL.SaveInitialShipValues(shipPC), JsonRequestBehavior.AllowGet);
        }

        public JsonResult SaveConfigData(Vessel ship)
        {
            ShipBL shipBL = new ShipBL();
            ShipPOCO shipPC = new ShipPOCO();
            //shipPC.ID = ship.ID;
            shipPC.SmtpServer = ship.SmtpServer;
            shipPC.Port = ship.Port;
            shipPC.MailFrom = ship.MailFrom;
            shipPC.MailTo = ship.MailTo;
            shipPC.MailPassword = ship.MailPassword;
            //shipPC.AttachmentSize = ship.AttachmentSize;
            return Json(shipBL.SaveConfigData(shipPC), JsonRequestBehavior.AllowGet);
        }


        public JsonResult GetConfigData(string KeyName)
        {
            ShipBL shipBL = new ShipBL();
            //return shipBL.GetConfigData(KeyName);

            return Json(shipBL.GetConfigData(KeyName), JsonRequestBehavior.AllowGet);
        }
    }
}