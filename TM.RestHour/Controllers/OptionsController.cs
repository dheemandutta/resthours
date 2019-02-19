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
    public class OptionsController : BaseController
    {
		//
		// GET: /Options/
		[TraceFilterAttribute]
		public ActionResult Index()
        {
            return View();
        }

        public JsonResult Add(Options options)
        {
            OptionsBL optionsBL = new OptionsBL();
            OptionsPOCO optionsPC = new OptionsPOCO();

            optionsPC.AdjustmentValue = options.AdjustmentValue;
            //optionsPC.AdjustmentDate = options.AdjustmentDate1;
            //optionsPC.AdjustmentDate = DateTime.ParseExact(options.AdjustmentDate1, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            DateTime dt11 = options.AdjustmentDate1.FormatDate
                      (ConfigurationManager.AppSettings["InputDateFormat"].ToString(), ConfigurationManager.AppSettings["InputDateSeperator"].ToString(),
                       ConfigurationManager.AppSettings["OutputDateFormat"].ToString(), ConfigurationManager.AppSettings["OutputDateSeperator"].ToString());

            optionsPC.AdjustmentDate = dt11;

            return Json(optionsBL.SaveTimeAdjustment(optionsPC, int.Parse(Session["VesselID"].ToString())), JsonRequestBehavior.AllowGet);
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

            TimeAdjustmentBL TimeAdjustmentBL = new TimeAdjustmentBL();
            int totalrecords = 0;

            List<TimeAdjustmentPOCO> TimeAdjustmentpocoList = new List<TimeAdjustmentPOCO>();
            TimeAdjustmentpocoList = TimeAdjustmentBL.GetTimeAdjustmentDetailsPageWise(pageIndex, ref totalrecords, length, int.Parse(Session["VesselID"].ToString()));
            List<TimeAdjustment> TimeAdjustmentList = new List<TimeAdjustment>();
            foreach (TimeAdjustmentPOCO TimeAdjustmentPC in TimeAdjustmentpocoList)
            {
                TimeAdjustment timeAdjustment = new TimeAdjustment();

                timeAdjustment.AdjustmentDate1 = TimeAdjustmentPC.AdjustmentDate1;
                timeAdjustment.AdjustmentValue = TimeAdjustmentPC.AdjustmentValue;
                TimeAdjustmentList.Add(timeAdjustment);
            }

            var data = TimeAdjustmentList;

            return Json(new { draw = draw, recordsFiltered = totalrecords, recordsTotal = totalrecords, data = data }, JsonRequestBehavior.AllowGet);
        }
    }
}