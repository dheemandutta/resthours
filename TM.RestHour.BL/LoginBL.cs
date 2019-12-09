using TM.RestHour.DAL;
using TM.Base.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.RestHour.BL
{
    public class LoginBL
    {
        public int ResetPassword(LoginPOCO login)
        {
            LoginDAL loginDAL = new LoginDAL();
            return loginDAL.ResetPassword(login);
        }

        public int? GetFirstRun()
        {
            LoginDAL loginDAL = new LoginDAL();
            return loginDAL.GetFirstRun();
        }

        public int UpdateResetPassword(LoginPOCO pOCO/*, int VesselID*/)
        {
            LoginDAL loginDAL = new LoginDAL();
            return loginDAL.UpdateResetPassword(pOCO/*, VesselID*/);
        }
    }
}
