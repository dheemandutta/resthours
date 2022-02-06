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
using Newtonsoft.Json;

namespace TM.RestHour.Controllers
{
    public class PsychologicalEvaluationController : BaseController
    {
        // GET: PsychologicalEvaluation
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult LocusOfControl()
        {
            return View();
        }

        public ActionResult _pvLocusOfControl(string id)
        {
            return PartialView();
        }

        public ActionResult InstructionsForPSSFinal()
        {
            return View();
        }

        public ActionResult MASSMindfulnessScaleFinal()
        {
            return View();
        }

        public ActionResult BeckDepressionInventoryIIFinal()
        {
            return View();
        }

        public ActionResult PSQ30_PERCIEVED_STRESS_QUESTIONAIRE()
        {
            return View();
        }

        public ActionResult ROSENBERG_SELF_esteem_scale_final()
        {
            return View();
        }

        public ActionResult Zhao_ANXIETY_Y1()
        {
            return View();
        }

        public ActionResult EmotionalIntelligenceQuizForLeadership()
        {
            return View();
        }

        public ActionResult Zhao_ANXIETY_Y2()
        {
            return View();
        }




        public JsonResult SaveForms(string LocusOfControl, string StoredProcedure, string Validator)
        {
            PsychologicalEvaluationBL psychologicalEvaluationBL = new PsychologicalEvaluationBL();
            string[] arr = JsonConvert.DeserializeObject<string[]>(LocusOfControl);

            //psychologicalEvaluationBL.Save_LocusOfControl(LocusOfControl);
            //return Json(null, JsonRequestBehavior.AllowGet);
            return Json(psychologicalEvaluationBL.SaveForms(arr, int.Parse(Session["LoggedInUserId"].ToString()), int.Parse(Session["VesselID"].ToString()), StoredProcedure, int.Parse(Validator)), JsonRequestBehavior.AllowGet);

        }

       
    }
}