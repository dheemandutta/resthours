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






        public JsonResult Save_LocusOfControl(string[] LocusOfControl)
        {
            PsychologicalEvaluationBL psychologicalEvaluationBL = new PsychologicalEvaluationBL();
            //psychologicalEvaluationBL.Save_LocusOfControl(LocusOfControl);
            //return Json(null, JsonRequestBehavior.AllowGet);
            return Json(psychologicalEvaluationBL.Save_LocusOfControl(LocusOfControl, int.Parse(Session["LoggedInUserId"].ToString()), int.Parse(Session["VesselID"].ToString())), JsonRequestBehavior.AllowGet);

        }

        public JsonResult Save_BeckDepressionInventoryIIFinal(string[] BeckDepressionInventoryIIFinal)
        {
            PsychologicalEvaluationBL psychologicalEvaluationBL = new PsychologicalEvaluationBL();
            //psychologicalEvaluationBL.Save_BeckDepressionInventoryIIFinal(BeckDepressionInventoryIIFinal);
            //return Json(null, JsonRequestBehavior.AllowGet);
            return Json(psychologicalEvaluationBL.Save_BeckDepressionInventoryIIFinal(BeckDepressionInventoryIIFinal, int.Parse(Session["LoggedInUserId"].ToString()), int.Parse(Session["VesselID"].ToString())), JsonRequestBehavior.AllowGet);

        }

        public JsonResult Save_EmotionalIntelligenceQuizForLeadership(string[] EmotionalIntelligenceQuizForLeadership)
        {
            PsychologicalEvaluationBL psychologicalEvaluationBL = new PsychologicalEvaluationBL();
            //psychologicalEvaluationBL.Save_EmotionalIntelligenceQuizForLeadership(EmotionalIntelligenceQuizForLeadership);
            //return Json(null, JsonRequestBehavior.AllowGet);
            return Json(psychologicalEvaluationBL.Save_EmotionalIntelligenceQuizForLeadership(EmotionalIntelligenceQuizForLeadership, int.Parse(Session["LoggedInUserId"].ToString()), int.Parse(Session["VesselID"].ToString())), JsonRequestBehavior.AllowGet);

        }

        public JsonResult Save_InstructionsForPSSFinal(string[] InstructionsForPSSFinal)
        {
            PsychologicalEvaluationBL psychologicalEvaluationBL = new PsychologicalEvaluationBL();
            //psychologicalEvaluationBL.Save_InstructionsForPSSFinal(InstructionsForPSSFinal);
            //return Json(null, JsonRequestBehavior.AllowGet);
            return Json(psychologicalEvaluationBL.Save_InstructionsForPSSFinal(InstructionsForPSSFinal, int.Parse(Session["LoggedInUserId"].ToString()), int.Parse(Session["VesselID"].ToString())), JsonRequestBehavior.AllowGet);

        }

        public JsonResult Save_MASSMindfulnessScaleFinal(string[] MASSMindfulnessScaleFinal)
        {
            PsychologicalEvaluationBL psychologicalEvaluationBL = new PsychologicalEvaluationBL();
            //psychologicalEvaluationBL.Save_MASSMindfulnessScaleFinal(MASSMindfulnessScaleFinal);
            //return Json(null, JsonRequestBehavior.AllowGet);
            return Json(psychologicalEvaluationBL.Save_MASSMindfulnessScaleFinal(MASSMindfulnessScaleFinal, int.Parse(Session["LoggedInUserId"].ToString()), int.Parse(Session["VesselID"].ToString())), JsonRequestBehavior.AllowGet);

        }

        public JsonResult Save_PSQ30_PERCIEVED_STRESS_QUESTIONAIRE(string[] PSQ30_PERCIEVED_STRESS_QUESTIONAIRE)
        {
            PsychologicalEvaluationBL psychologicalEvaluationBL = new PsychologicalEvaluationBL();
            //psychologicalEvaluationBL.Save_PSQ30_PERCIEVED_STRESS_QUESTIONAIRE(PSQ30_PERCIEVED_STRESS_QUESTIONAIRE);
            //return Json(null, JsonRequestBehavior.AllowGet);
            return Json(psychologicalEvaluationBL.Save_PSQ30_PERCIEVED_STRESS_QUESTIONAIRE(PSQ30_PERCIEVED_STRESS_QUESTIONAIRE, int.Parse(Session["LoggedInUserId"].ToString()), int.Parse(Session["VesselID"].ToString())), JsonRequestBehavior.AllowGet);

        }

        public JsonResult Save_ROSENBERG_SELF_esteem_scale_final(string[] ROSENBERG_SELF_esteem_scale_final)
        {
            PsychologicalEvaluationBL psychologicalEvaluationBL = new PsychologicalEvaluationBL();
            //psychologicalEvaluationBL.Save_ROSENBERG_SELF_esteem_scale_final(ROSENBERG_SELF_esteem_scale_final);
            //return Json(null, JsonRequestBehavior.AllowGet);
            return Json(psychologicalEvaluationBL.Save_ROSENBERG_SELF_esteem_scale_final(ROSENBERG_SELF_esteem_scale_final, int.Parse(Session["LoggedInUserId"].ToString()), int.Parse(Session["VesselID"].ToString())), JsonRequestBehavior.AllowGet);

        }

        public JsonResult Save_Zhao_ANXIETY(string[] Zhao_ANXIETY)
        {
            PsychologicalEvaluationBL psychologicalEvaluationBL = new PsychologicalEvaluationBL();
            //psychologicalEvaluationBL.Save_Zhao_ANXIETY(Zhao_ANXIETY);
            //return Json(null, JsonRequestBehavior.AllowGet);
            return Json(psychologicalEvaluationBL.Save_Zhao_ANXIETY(Zhao_ANXIETY, int.Parse(Session["LoggedInUserId"].ToString()), int.Parse(Session["VesselID"].ToString())), JsonRequestBehavior.AllowGet);

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