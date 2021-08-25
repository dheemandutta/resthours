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


        public JsonResult Save_LocusOfControl(CIRMPOCO cIRM)
        {
            CIRMBL CIRMBL = new CIRMBL();
            return Json(CIRMBL.SaveCIRM(cIRM, int.Parse(Session["VesselID"].ToString())), JsonRequestBehavior.AllowGet);
        }
    }
}