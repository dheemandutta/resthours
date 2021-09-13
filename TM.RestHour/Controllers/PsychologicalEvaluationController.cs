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

        public ActionResult Zhao_ANXIETY()
        {
            return View();
        }

        public ActionResult EmotionalIntelligenceQuizForLeadership()
        {
            return View();
        }






        public JsonResult SaveForms(string LocusOfControl, string StoredProcedure, string Validator)
        {
            PsychologicalEvaluationBL psychologicalEvaluationBL = new PsychologicalEvaluationBL();
            string[] arr = JsonConvert.DeserializeObject<string[]>(LocusOfControl);

            //psychologicalEvaluationBL.Save_LocusOfControl(LocusOfControl);
            //return Json(null, JsonRequestBehavior.AllowGet);
            return Json(psychologicalEvaluationBL.SaveForms(arr, int.Parse(Session["LoggedInUserId"].ToString()), int.Parse(Session["VesselID"].ToString()), StoredProcedure/*, Validator*/), JsonRequestBehavior.AllowGet);

        }

        public JsonResult GetLocusOfControl(int VesselID, int CrewId)
        {
            PsychologicalEvaluationBL bL = new PsychologicalEvaluationBL();
            PsychologicalEvaluationPOCO pOCOList = new PsychologicalEvaluationPOCO();

            pOCOList = bL.GetLocusOfControl(int.Parse(Session["VesselID"].ToString()), int.Parse(Session["LoggedInUserId"].ToString()));

            PsychologicalEvaluationPOCO dept = new PsychologicalEvaluationPOCO();

            dept.Id = pOCOList.Id;
            dept.Question = pOCOList.Question;
            dept.Answer = pOCOList.Answer;
            dept.FinalScore = pOCOList.FinalScore;
            dept.TestResult = pOCOList.TestResult;
            dept.VesselID = pOCOList.VesselID;
            dept.CrewId = pOCOList.CrewId;

            var data = dept;

            return Json(data, JsonRequestBehavior.AllowGet);
        }
    }
}