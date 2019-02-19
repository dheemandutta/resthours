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

namespace TM.RestHour.Controllers
{
    [TraceFilterAttribute]
    public class RanksController : BaseController
    {
		//
		// GET: /Ranks/
		[TraceFilterAttribute]
		public ActionResult Index()
        {
            return View();
        }

		[TraceFilterAttribute]
		public ActionResult CrewList()
        {
            return View();
        }
        public JsonResult LoadData()
        {
            int draw, start, length;
            int pageIndex = 0;

            if (null != Request.Form.GetValues("draw"))//Koushik: What is "draw"
            {
                draw = int.Parse(Request.Form.GetValues("draw").FirstOrDefault().ToString());
                start = int.Parse(Request.Form.GetValues("start").FirstOrDefault().ToString());
                length = int.Parse(Request.Form.GetValues("length").FirstOrDefault().ToString());
            }
            else
            {
                draw = 1;
                start = 0;
                length = 50; //Koushik: Changed to 50. Why has this been set to 15??
            }

            if (start == 0)
            {
                pageIndex = 1;
            }
            else
            {
                pageIndex = (start / length) + 1;
            }

            RanksBL ranksBL = new RanksBL();
            int totalrecords = 0;

            List<RanksPOCO> rankspocoList = new List<RanksPOCO>();
            rankspocoList = ranksBL.GetRanksPageWise(pageIndex, ref totalrecords, length, int.Parse(Session["VesselID"].ToString()));
            List<Ranks> ranksList = new List<Ranks>();
            foreach (RanksPOCO ranksPC in rankspocoList)
            {
                Ranks ranks = new Ranks();
                ranks.ID = ranksPC.ID;
                ranks.RankName = ranksPC.RankName;
                ranks.Description = ranksPC.Description;
                ranks.Scheduled = ranksPC.Scheduled;
                ranks.Order = ranksPC.Order;
                ranksList.Add(ranks);
            }

            var data = ranksList;

            return Json(new { draw = draw, recordsFiltered = totalrecords, recordsTotal = totalrecords, data = data }, JsonRequestBehavior.AllowGet);
        }


        public JsonResult LoadChildData(int ID)
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
                length = 50;
            }

            if (start == 0)
            {
                pageIndex = 1;
            }
            else
            {
                pageIndex = (start / length) + 1;
            }

            RanksBL ranksBL = new RanksBL();
            int totalrecords = 0;

            List<CrewPOCO> rankspocoList = new List<CrewPOCO>();
            rankspocoList = ranksBL.GetCrewPageWise(ID,pageIndex, ref totalrecords, length, int.Parse(Session["VesselID"].ToString()));
            List<Crew> ranksList = new List<Crew>();
            foreach (CrewPOCO ranksPC in rankspocoList)
            {
                Crew ranks = new Crew();
                ranks.ID = ranksPC.ID;
                ranks.Name = ranksPC.Name;
                ranksList.Add(ranks);
            }

            var data = ranksList;

            return Json(new { draw = draw, recordsFiltered = totalrecords, recordsTotal = totalrecords, data = data }, JsonRequestBehavior.AllowGet);
        }

        public JsonResult Add(Ranks ranks)
        {
            RanksBL ranksBL = new RanksBL();
            RanksPOCO ranksPC = new RanksPOCO();
            ranksPC.ID = ranks.ID;
            ranksPC.RankName = ranks.RankName;
            ranksPC.Description = ranks.Description;
            ranksPC.Scheduled = ranks.Scheduled;
            return Json(ranksBL.SaveRanks(ranksPC, int.Parse(Session["VesselID"].ToString())), JsonRequestBehavior.AllowGet);
        }

        public JsonResult AddNewRanks(Ranks ranks)
        {
            RanksBL ranksBL = new RanksBL();
            RanksPOCO ranksPC = new RanksPOCO();
            ranksPC.ID = ranks.ID;
            ranksPC.RankName = ranks.RankName;
            ranksPC.Description = ranks.Description;
            ranksPC.Scheduled = ranks.Scheduled;

            int rowaffected = ranksBL.SaveRanks(ranksPC, int.Parse(Session["VesselID"].ToString()));
            if (rowaffected > 0)
            {
                return Json(new { result = "Redirect", url = Url.Action("Index", "Home") });
            }
            else
            {
                return Json(new { result = "Error" }, JsonRequestBehavior.AllowGet);
            }
        }


        public JsonResult Update(string ranks)
        {
            RanksBL ranksBL = new RanksBL();
            //RanksPOCO ranksPC = new RanksPOCO();

            List<RanksPOCO> ranksList = new List<RanksPOCO>();
            JavaScriptSerializer JsonSerializer = new JavaScriptSerializer();
            IDictionary<string, object> ranksdict = (IDictionary<string, object>)JsonSerializer.DeserializeObject(ranks);

            object[] objwf = (object[])ranksdict["WF"];

            foreach (object item in objwf)
            {
                Dictionary<string, object> RanksDictionaryObject = (Dictionary<string, object>)item;
                RanksPOCO rankss = new RanksPOCO();

                if (!String.IsNullOrEmpty(RanksDictionaryObject["Id"].ToString()))
                    rankss.Order = Convert.ToInt32(RanksDictionaryObject["Id"]);
                if (!String.IsNullOrEmpty(RanksDictionaryObject["RankName"].ToString()))
                    rankss.RankName = RanksDictionaryObject["RankName"].ToString();


                ranksList.Add(rankss);
            }

            ranksBL.Update(ranksList, int.Parse(Session["VesselID"].ToString()));

            return Json("1", JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetRanksByID(int ID)
        {
            RanksBL rankBL = new RanksBL();
            RanksPOCO rankPC = new RanksPOCO();

            rankPC = rankBL.GetRanksByID(ID, int.Parse(Session["VesselID"].ToString()));

            Ranks um = new Ranks();

            um.ID = rankPC.ID;
            um.RankName = rankPC.RankName;
            um.Description = rankPC.Description;
            um.Scheduled = rankPC.Scheduled;

            var cm = um;

            return Json(cm, JsonRequestBehavior.AllowGet);
        }

        public JsonResult DeleteRanks(string ID)
        {
            RanksBL rankBL = new RanksBL();
            return Json(rankBL.DeleteRankByID(int.Parse(ID)), JsonRequestBehavior.AllowGet);

            int recordsAffected = 0;
            return Json(recordsAffected, JsonRequestBehavior.AllowGet);
        }

	}
}