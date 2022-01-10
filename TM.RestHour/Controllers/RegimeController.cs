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

using System.Configuration;
using TM.Base.Common;
namespace TM.RestHour.Controllers
{
    [TraceFilterAttribute]
    public class RegimeController : BaseController
    {
		// GET: Regime
		[TraceFilterAttribute]
		public ActionResult Index()
        {
            return View();
        }


        public JsonResult GetDataForRegimes()
        {

            RegimesBL regimesBL = new RegimesBL();
            //int totalrecords = 0;

            List<RegimesPOCO> regimespocoList = new List<RegimesPOCO>();
            regimespocoList = regimesBL.GetDataForRegimes(/*int.Parse(Session["VesselID"].ToString())*/);
            List<Regimes> regimesList = new List<Regimes>();
            foreach (RegimesPOCO regimesPC in regimespocoList)
            {
                Regimes regimes = new Regimes();
                regimes.ID = regimesPC.ID;
                regimes.RegimeName = regimesPC.RegimeName;
                regimes.Description = regimesPC.Description;
                regimes.Basis = regimesPC.Basis;
                regimes.MinTotalRestIn7Days = regimesPC.MinTotalRestIn7Days;
                regimes.MaxTotalWorkIn24Hours = regimesPC.MaxTotalWorkIn24Hours;
                regimes.MinContRestIn24Hours = regimesPC.MinContRestIn24Hours;
                regimes.MinTotalRestIn24Hours = regimesPC.MinTotalRestIn24Hours;
                regimes.MaxTotalWorkIn7Days = regimesPC.MaxTotalWorkIn7Days;
                regimes.CheckFor2Days = regimesPC.CheckFor2Days;
                regimes.OPA90 = regimesPC.OPA90;
                //regimes.Timestamp = regimesPC.Timestamp;
                regimes.ManilaExceptions = regimesPC.ManilaExceptions;
                regimes.UseHistCalculationOnly = regimesPC.UseHistCalculationOnly;
                regimes.CheckOnlyWorkHours = regimesPC.CheckOnlyWorkHours;
                regimesList.Add(regimes);
            }

            var data = regimesList;

            return Json(data, JsonRequestBehavior.AllowGet);
        }



        public JsonResult Add(Regimes regimes)
        {
            RegimesBL regimesBL = new RegimesBL();
            RegimesPOCO regimesPC = new RegimesPOCO();

            //regimesPC.ID = regimes.ID;

            regimesPC.Regime = regimes.Regime;
          
            regimesPC.RegimeStartDate = System.DateTime.Today;
            //regimesPC.RegimeStartDate = System.DateTime(regimes.RegimeStartDate1, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            regimesPC.RegimeID = regimes.RegimeID;

			Session["Regime"] = regimes.Regime;


			return Json(regimesBL.SaveRegime(regimesPC, int.Parse(Session["VesselID"].ToString())), JsonRequestBehavior.AllowGet);
        }

 
        public JsonResult GetIsActiveRegime()
        {
            
            RegimesBL regimesBL = new RegimesBL();
            RegimesPOCO regimesPC = new RegimesPOCO();

            regimesPC = regimesBL.GetIsActiveRegime();

            Regimes um = new Regimes();

            um.RegimeID = regimesPC.RegimeID;

            var cm = um;

            return Json(cm, JsonRequestBehavior.AllowGet);
        }
    }
}