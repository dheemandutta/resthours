using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using TM.RestHour.BL;
using System.Configuration;
using System.Web.SessionState;


namespace TM.RestHour.Controllers
{

    [SessionState(SessionStateBehavior.Default)]
    public class BaseController : Controller
    {
        UserGroupsBL userGroup;
        int _userId;
        bool _isSuperAdmin = false;
        bool _isAdmin = false;
        bool _isNormalUser = false;
        string groupName;

        
        // GET: Base
        

        public void GetUserDetails( int userId)
        {
            userGroup = new UserGroupsBL();
            _userId = userId;

            groupName = userGroup.GetUserGroupsByUserID(_userId).GroupName;

            if (groupName.ToUpper().Trim() == ConfigurationManager.AppSettings["SuperAdmin"].Trim().ToUpper())
            {
                _isSuperAdmin = true;
                Session["SuperAdmin"] = _isSuperAdmin;
                Session["Admin"] = false;
                Session["User"] = false;

            }
            else if (groupName.ToUpper().Trim() == ConfigurationManager.AppSettings["Admin"].Trim().ToUpper())
            {
                _isAdmin = true;
                Session["Admin"] = _isAdmin;
                Session["SuperAdmin"] = false;
                Session["User"] = false;
            }
            else
            {
                _isNormalUser = true;
                Session["User"] = _isNormalUser;
                Session["SuperAdmin"] = false;
                Session["Admin"] = false;
            }



        }

        public string MyGroup
        {
            get
            {
            
                return groupName;
            }
           

        }

        public bool IsSuperAdmin
        {
            get
            {

                return _isSuperAdmin;
            }


        }

        public bool IsAdmin
        {
            get
            {

                return _isAdmin;
            }


        }

        public bool IsUser
        {
            get
            {

                return _isNormalUser;
            }


        }
    }
}