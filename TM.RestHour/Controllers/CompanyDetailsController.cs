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
    public class CompanyDetailsController : Controller
    {
        // GET: CompanyDetails
        [TraceFilterAttribute]
        public ActionResult Index()
        {
            return View();
        }


        [HttpGet]
        public JsonResult GetCompanyDetailsNew()
        {
            CompanyDetailsBL companyDetailsBL = new CompanyDetailsBL();
            CompanyDetailsPOCO companydetails = new CompanyDetailsPOCO();

            companydetails = companyDetailsBL.GetCompanyDetailsNew();

            CompanyDetails um = new CompanyDetails();

            um.ID = companydetails.ID;
            um.Name = companydetails.Name;
            um.Address = companydetails.Address;
            um.Website = companydetails.Website;
            um.AdminContact = companydetails.AdminContact;
            um.AdminContactEmail = companydetails.AdminContactEmail;
            um.ContactNumber = companydetails.ContactNumber;
            um.Domain = companydetails.Domain;

            var cm = um;

            return Json(cm, JsonRequestBehavior.AllowGet);
        }

    }
}