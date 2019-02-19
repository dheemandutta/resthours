using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace TM.RestHour
{
    [AttributeUsage(AttributeTargets.All)]
    public sealed class TraceFilterAttribute : ActionFilterAttribute
    {
        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            if (filterContext != null)
            {
                HttpSessionStateBase objHttpSessionStateBase = filterContext.HttpContext.Session;
                var userSession = objHttpSessionStateBase["LoggedInUserId"];
                if (((userSession == null) && (!objHttpSessionStateBase.IsNewSession)) || (objHttpSessionStateBase.IsNewSession))
                {
                    objHttpSessionStateBase.RemoveAll();
                    objHttpSessionStateBase.Clear();
                    objHttpSessionStateBase.Abandon();
                    if (filterContext.HttpContext.Request.IsAjaxRequest())
                    {
                        filterContext.HttpContext.Response.StatusCode = 403;
                        filterContext.Result = new JsonResult { Data = "Session Expired" };
                    }
                    else
                    {
                        filterContext.Result = new RedirectToRouteResult(
                                                    new RouteValueDictionary {{ "Controller", "Login" },
                                                                             { "Action", "Index" } });
                    }

                }


            }
        }

    }
}