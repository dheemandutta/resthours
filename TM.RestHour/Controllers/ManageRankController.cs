using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace TM.RestHour.Controllers
{
    [TraceFilterAttribute]
    public class ManageRankController : BaseController
    {
		//
		// GET: /ManageRank/
		[TraceFilterAttribute]
		public ActionResult Index()
        {
            return View();
        }
	}
}