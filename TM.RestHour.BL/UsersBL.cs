using TM.RestHour.DAL;
using TM.Base.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.RestHour.BL
{
    public class UsersBL
    {
        public int GetUserAuthentication(string Username, string Password)
        {
            UsersDAL usersDAL = new UsersDAL();
            return usersDAL.GetUserAuthentication(Username, Password);
        }

        public UsersPOCO GetUserNameByUserId(int UserId,int VesselID)
        {
            UsersDAL usersDAL = new UsersDAL();
            return usersDAL.GetUserNameByUserId(UserId, VesselID).FirstOrDefault();
        }

        public bool CheckUserNameValidity(string username)
        {
            UsersDAL usersDAL = new UsersDAL();
            return usersDAL.CheckUserNameValidity(username);
        }

            public UsersPOCO GetShipMaster()
        {
            UsersDAL usersDAL = new UsersDAL();
            return usersDAL.GetShipMaster().FirstOrDefault();
        }
    }
}
