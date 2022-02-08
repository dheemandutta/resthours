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
        [TraceFilterAttribute]
        public ActionResult Index()
        {
            return View();
        }

        [TraceFilterAttribute]
        public ActionResult LocusOfControl(string mode, string jc)
        {
            PsychologicalEvaluation psychologicalEvaluation = new PsychologicalEvaluation();
            if (!string.IsNullOrEmpty(mode))
            {
                psychologicalEvaluation.Mode = mode;
            }
            if (!string.IsNullOrEmpty(jc))
            {
                psychologicalEvaluation.JoiningCondition = int.Parse(jc);
            }
            psychologicalEvaluation.CrewId= int.Parse(Session["LoggedInUserId"].ToString());

            return View(psychologicalEvaluation);
        }
        [TraceFilterAttribute]
        public ActionResult InstructionsForPSSFinal()
        {
            return View();
        }
        [TraceFilterAttribute]
        public ActionResult MASSMindfulnessScaleFinal(string mode, string jc)
        {
            PsychologicalEvaluation psychologicalEvaluation = new PsychologicalEvaluation();
            if (!string.IsNullOrEmpty(mode))
            {
                psychologicalEvaluation.Mode = mode;
            }
            if (!string.IsNullOrEmpty(jc))
            {
                psychologicalEvaluation.JoiningCondition = int.Parse(jc);
            }
            psychologicalEvaluation.CrewId = int.Parse(Session["LoggedInUserId"].ToString());

            return View(psychologicalEvaluation);
        }
        [TraceFilterAttribute]
        public ActionResult BeckDepressionInventoryIIFinal(string mode, string jc)
        {
            PsychologicalEvaluation psychologicalEvaluation = new PsychologicalEvaluation();
            if (!string.IsNullOrEmpty(mode))
            {
                psychologicalEvaluation.Mode = mode;
            }
            if (!string.IsNullOrEmpty(jc))
            {
                psychologicalEvaluation.JoiningCondition = int.Parse(jc);
            }
            psychologicalEvaluation.CrewId = int.Parse(Session["LoggedInUserId"].ToString());

            return View(psychologicalEvaluation);
        }
        [TraceFilterAttribute]
        public ActionResult PSQ30_PERCIEVED_STRESS_QUESTIONAIRE(string mode, string jc)
        {
            PsychologicalEvaluation psychologicalEvaluation = new PsychologicalEvaluation();
            if (!string.IsNullOrEmpty(mode))
            {
                psychologicalEvaluation.Mode = mode;
            }
            if (!string.IsNullOrEmpty(jc))
            {
                psychologicalEvaluation.JoiningCondition = int.Parse(jc);
            }
            psychologicalEvaluation.CrewId = int.Parse(Session["LoggedInUserId"].ToString());

            return View(psychologicalEvaluation);
        }
        [TraceFilterAttribute]
        public ActionResult ROSENBERG_SELF_esteem_scale_final(string mode, string jc)
        {
            PsychologicalEvaluation psychologicalEvaluation = new PsychologicalEvaluation();
            if (!string.IsNullOrEmpty(mode))
            {
                psychologicalEvaluation.Mode = mode;
            }
            if (!string.IsNullOrEmpty(jc))
            {
                psychologicalEvaluation.JoiningCondition = int.Parse(jc);
            }
            psychologicalEvaluation.CrewId = int.Parse(Session["LoggedInUserId"].ToString());

            return View(psychologicalEvaluation);
        }
        [TraceFilterAttribute]
        public ActionResult Zhao_ANXIETY_Y1(string mode, string jc)
        {
            PsychologicalEvaluation psychologicalEvaluation = new PsychologicalEvaluation();
            if (!string.IsNullOrEmpty(mode))
            {
                psychologicalEvaluation.Mode = mode;
            }
            if (!string.IsNullOrEmpty(jc))
            {
                psychologicalEvaluation.JoiningCondition = int.Parse(jc);
            }
            psychologicalEvaluation.CrewId = int.Parse(Session["LoggedInUserId"].ToString());

            return View(psychologicalEvaluation);
        }
        [TraceFilterAttribute]
        public ActionResult EmotionalIntelligenceQuizForLeadership(string mode, string jc)
        {
            PsychologicalEvaluation psychologicalEvaluation = new PsychologicalEvaluation();
            if (!string.IsNullOrEmpty(mode))
            {
                psychologicalEvaluation.Mode = mode;
            }
            if (!string.IsNullOrEmpty(jc))
            {
                psychologicalEvaluation.JoiningCondition = int.Parse(jc);
            }
            psychologicalEvaluation.CrewId = int.Parse(Session["LoggedInUserId"].ToString());

            return View(psychologicalEvaluation);
        }
        [TraceFilterAttribute]
        public ActionResult Zhao_ANXIETY_Y2(string mode, string jc)
        {
            PsychologicalEvaluation psychologicalEvaluation = new PsychologicalEvaluation();
            if (!string.IsNullOrEmpty(mode))
            {
                psychologicalEvaluation.Mode = mode;
            }
            if (!string.IsNullOrEmpty(jc))
            {
                psychologicalEvaluation.JoiningCondition = int.Parse(jc);
            }
            psychologicalEvaluation.CrewId = int.Parse(Session["LoggedInUserId"].ToString());

            return View(psychologicalEvaluation);
        }




        public JsonResult SaveForms(string LocusOfControl, string StoredProcedure, string Validator, string CrewID)
        {
            PsychologicalEvaluationBL psychologicalEvaluationBL = new PsychologicalEvaluationBL();
            string[] arr = JsonConvert.DeserializeObject<string[]>(LocusOfControl);

            //psychologicalEvaluationBL.Save_LocusOfControl(LocusOfControl);
            //return Json(null, JsonRequestBehavior.AllowGet);
            return Json(psychologicalEvaluationBL.SaveForms(arr, int.Parse(Session["LoggedInUserId"].ToString()), int.Parse(Session["VesselID"].ToString()), StoredProcedure, int.Parse(Validator)), JsonRequestBehavior.AllowGet);

        }


        public JsonResult GetTestValues()
        {
            PsychologicalEvaluationBL psychologicalEvaluationBL = new PsychologicalEvaluationBL();
            return Json(psychologicalEvaluationBL.GetTestValues(int.Parse(Session["LoggedInUserId"].ToString())), JsonRequestBehavior.AllowGet);

        }
    }
}