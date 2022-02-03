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
using System.Web.Security;
using TM.Base.Common;


namespace TM.RestHour.Controllers
{
    public class LoginController : BaseController
    {
        public ActionResult ResetPasswordOfID()
        {
          
            return View();
        }
        public ActionResult ResetPasswordNew()
        {
            return View();
        }


        // GET: /Login/
        public ActionResult Index()
        {
            //GetAllShipForDrp();

            LoginBL loginBL = new LoginBL();
            int? runCount = loginBL.GetFirstRun();

            if (runCount.HasValue)
            {

                System.Web.HttpContext.Current.Session["LoggedInUserName"] = "";
                System.Web.HttpContext.Current.Session["LoggedInUserPassword"] = "";
                System.Web.HttpContext.Current.Session["LoggedInUserType"] = "";
                System.Web.HttpContext.Current.Session["Regime"] = "ILO Rest";
                //System.Web.HttpContext.Current.Session["VesselID"] = "1";

                return View();
            }
            else
            {
                return new RedirectToRouteResult(new System.Web.Routing.RouteValueDictionary(new { controller = "MailServerDetails", action = "FirstRun", Id = new int?() }));
            }
        }


        public ActionResult Login()
        {
			//GetAllShipForDrp();

			LoginModel logmodel = new LoginModel();
			

            System.Web.HttpContext.Current.Session["LoggedInUserName"] = "";
            System.Web.HttpContext.Current.Session["LoggedInUserPassword"] = "";
            System.Web.HttpContext.Current.Session["LoggedInUserType"] = "";
            System.Web.HttpContext.Current.Session["Regime"] = "ILO Rest";
			//System.Web.HttpContext.Current.Session["VesselID"] = "1";

			return View();
        }

		public ActionResult CountryLookup()
		{
			var countries = new List<SearchTypeAheadEntity>
		{
			new SearchTypeAheadEntity {ShortCode = "US", Name = "United States"},
			new SearchTypeAheadEntity {ShortCode = "CA", Name = "Canada"},
			new SearchTypeAheadEntity {ShortCode = "AF", Name = "Afghanistan"},
			new SearchTypeAheadEntity {ShortCode = "AL", Name = "Albania"},
			new SearchTypeAheadEntity {ShortCode = "DZ", Name = "Algeria"},
			new SearchTypeAheadEntity {ShortCode = "DS", Name = "American Samoa"},
			new SearchTypeAheadEntity {ShortCode = "AD", Name = "Andorra"},
			new SearchTypeAheadEntity {ShortCode = "AO", Name = "Angola"},
			new SearchTypeAheadEntity {ShortCode = "AI", Name = "Anguilla"},
			new SearchTypeAheadEntity {ShortCode = "AQ", Name = "Antarctica"},
			new SearchTypeAheadEntity {ShortCode = "AG", Name = "Antigua and/or Barbuda"}
		};

			return Json(countries, JsonRequestBehavior.AllowGet);
		}

		[HttpPost]
        public ActionResult Index(LoginModel user)
        {
            //GetAllShipForDrp();
            List<AccessRightsPOCO> accessRightsPOCOs = new List<AccessRightsPOCO>();
            RightsBL rightsBL = new RightsBL();
            UsersBL usersBL = new UsersBL();
            int existingUsers = 0;
            UsersPOCO usersPCm = new UsersPOCO();

            existingUsers = usersBL.GetUserAuthentication(user.Users.Username, user.Users.Password);




            if (existingUsers > 0)
            {
                user.Users.IsAuthenticated = true;


				FormsAuthentication.SetAuthCookie(user.Users.Username.Trim(), false);

				GetUserDetails(existingUsers);

				System.Web.HttpContext.Current.Session["LoggedInUserName"] = user.Users.Username.Trim();
				System.Web.HttpContext.Current.Session["LoggedInUserPassword"] = user.Users.Password.Trim();
				System.Web.HttpContext.Current.Session["LoggedInUserType"] = MyGroup;
                System.Web.HttpContext.Current.Session["UserID"] = existingUsers;


                ShipBL ship = new ShipBL();
                ShipPOCO shipPoco = ship.GetShipByID();

                System.Web.HttpContext.Current.Session["ShipName"] = shipPoco.ShipName;
                System.Web.HttpContext.Current.Session["Regime"] = shipPoco.Regime;
                System.Web.HttpContext.Current.Session["Flag"] = shipPoco.FlagOfShip;

                System.Web.HttpContext.Current.Session["IMONumber"] = shipPoco.IMONumber;


                System.Web.HttpContext.Current.Session["VesselID"] = shipPoco.IMONumber;


                UsersBL users = new UsersBL();
				UsersPOCO usersPoco = users.GetUserNameByUserId(existingUsers, int.Parse(Session["VesselID"].ToString()));

				System.Web.HttpContext.Current.Session["FirstName"] = usersPoco.FirstName;            /////
				System.Web.HttpContext.Current.Session["LastName"] = usersPoco.LastName;
				System.Web.HttpContext.Current.Session["LoggedInUserId"] = usersPoco.CrewId;
				System.Web.HttpContext.Current.Session["AdminStatus"] = usersPoco.AdminGroup;

                System.Web.HttpContext.Current.Session["AllowPsychologyForms"] = usersPoco.AllowPsychologyForms;

                accessRightsPOCOs = rightsBL.GetAccessRightsByCrewId(existingUsers);
                System.Web.HttpContext.Current.Session["AccessRights"] = accessRightsPOCOs;

                System.Web.HttpContext.Current.Session["UserId"] = existingUsers;

                UsersBL usersn = new UsersBL();
                UsersPOCO usersPocon = usersn.GetShipMaster();
                if (usersPocon != null)
                    System.Web.HttpContext.Current.Session["Master"] = usersPocon.MName;
                else
                    System.Web.HttpContext.Current.Session["Master"] = String.Empty;

            }
            else
            {
                user.Users.IsAuthenticated = false;
                ViewBag.Message = "Invalid Login/Password";
            }



            if (user.Users.IsAuthenticated && (MyGroup == "Super Admin" || MyGroup == "Admin"))
            {
                //return RedirectToAction("NCReportByMonth", "ReportsNCReportByMonth");
                return RedirectToAction("Index", "Home");
            }
            else if (user.Users.IsAuthenticated && MyGroup == "User")
            {
                //GetUserDetails();
                return RedirectToAction("CrewTimeSheet", "TimeSheet");
            }
        
            else
            {
                return View(user);
            }


        }

        public ActionResult Keepalive()
        {
            return Json("OK", JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
		public ActionResult Login(LoginModel user)
		{
            //GetAllShipForDrp();
            List<AccessRightsPOCO> accessRightsPOCOs = new List<AccessRightsPOCO>();
            RightsBL rightsBL = new RightsBL();
            UsersBL usersBL = new UsersBL();
			int existingUsers = 0;
			UsersPOCO usersPCm = new UsersPOCO();
            OptionsBL optionsBL = new OptionsBL();
            string deactivationHash = optionsBL.GetConfigValues("InstallationHash").ConfigValue;

            existingUsers = usersBL.GetUserAuthentication(user.Users.Username, user.Users.Password);

			if (existingUsers > 0)
			{
				user.Users.IsAuthenticated = true;

                FormsAuthentication.SetAuthCookie(user.Users.Username.Trim(), false);

				GetUserDetails(existingUsers);

				System.Web.HttpContext.Current.Session["LoggedInUserName"] = user.Users.Username.Trim();
				System.Web.HttpContext.Current.Session["LoggedInUserPassword"] = user.Users.Password.Trim();
				System.Web.HttpContext.Current.Session["LoggedInUserType"] = MyGroup;


				ShipBL ship = new ShipBL();
				ShipPOCO shipPoco = ship.GetShipByID();

                string deactivationDate = CryptoEngine.Decrypt(deactivationHash, shipPoco.IMONumber);



                UsersBL users = new UsersBL();
				UsersPOCO usersPoco = users.GetUserNameByUserId(existingUsers, int.Parse(Session["VesselID"].ToString()));

				System.Web.HttpContext.Current.Session["FirstName"] = usersPoco.FirstName;
				System.Web.HttpContext.Current.Session["LastName"] = usersPoco.LastName;
				System.Web.HttpContext.Current.Session["LoggedInUserId"] = usersPoco.CrewId;

                accessRightsPOCOs = rightsBL.GetAccessRightsByCrewId(usersPoco.CrewId);
                System.Web.HttpContext.Current.Session["AccessRights"] = accessRightsPOCOs;

                System.Web.HttpContext.Current.Session["ShipName"] = shipPoco.ShipName;
				System.Web.HttpContext.Current.Session["Regime"] = shipPoco.Regime;
				System.Web.HttpContext.Current.Session["Flag"] = shipPoco.FlagOfShip;

			}
			else
			{
				user.Users.IsAuthenticated = false;
				ViewBag.Message = "Invalid Login/Password";
			}



			if (user.Users.IsAuthenticated && (MyGroup == "Super Admin" || MyGroup == "Admin"))
			{
				return RedirectToAction("NCReportByMonth", "ReportsNCReportByMonth");
				//return RedirectToAction("Index", "Home");
			}
			else if (user.Users.IsAuthenticated && MyGroup == "User")
			{
				//GetUserDetails();
				return RedirectToAction("CrewTimeSheet", "TimeSheet");
			}

			else
			{
				return View(user);
			}


		}

        [HttpPost]
        public ActionResult ResetPasswordOfID(LoginModel user)
        {
            LoginBL loginBL = new LoginBL();
            LoginPOCO loginPC = new LoginPOCO();
            //loginPC.ID = login.ID;
            loginPC.UserName = user.Users.Username;
            loginBL.UpdateResetPassword(loginPC);

            return RedirectToAction("Index", "Login");
        }


        //for Ship drp
        public void GetAllShipForDrp()
        {
            ShipBL crewDAL = new ShipBL();
            List<ShipPOCO> crewpocoList = new List<ShipPOCO>();

            crewpocoList = crewDAL.GetAllShipForDrp();

            List<Vessel> itmasterList = new List<Vessel>();

            foreach (ShipPOCO up in crewpocoList)
            {
                Vessel unt = new Vessel();
                unt.ID = up.ID;
                unt.ShipName = up.ShipName;

                itmasterList.Add(unt);
            }

            ViewBag.Vessel = itmasterList.Select(x =>
                                            new SelectListItem()
                                            {
                                                Text = x.ShipName,
                                                Value = x.ID.ToString()
                                            });

        }


        public ActionResult ResetPassword()
        {
            return View();
        }

        public JsonResult Reset(Login login)
        {
            LoginBL loginBL = new LoginBL();
            LoginPOCO loginPC = new LoginPOCO();
            loginPC.ID = login.ID;

            //loginPC.UserName = login.UserName;
            loginPC.OldPassword = login.OldPassword;
            loginPC.NewPassword = login.NewPassword;
            loginPC.UserName = Session["LoggedInUserName"].ToString();

            //crewPC.ServiceTermsPOCO = serviceTermsPOCO;

            return Json(loginBL.ResetPassword(loginPC), JsonRequestBehavior.AllowGet);
        }







        //[HttpGet]
        //public JsonResult GetUserNameByUserId(int UserId)
        //{
        //    UsersBL usersBL = new UsersBL();
        //    UsersPOCO usersPC = new UsersPOCO();

        //    usersPC = usersBL.GetUserNameByUserId(UserId);

        //    Users um = new Users();

        //    um.UserId = usersPC.UserId;
        //    um.FirstName = usersPC.FirstName;
        //    um.LastName = usersPC.LastName;

        //    var cm = um;

        //    return Json(cm, JsonRequestBehavior.AllowGet);
        //}






        //public JsonResult GetFirstRun(string RunCount)
        //{
        //    LoginBL loginBL = new LoginBL();
        //    return Json(loginBL.GetFirstRun(int.Parse(RunCount)), JsonRequestBehavior.AllowGet);
        //}

    }

}