using TM.RestHour.DAL;
using TM.Base.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.RestHour.BL
{
    public class UserGroupsBL
    {
        public UserGroupsPOCO GetUserGroupsByUserID(int UserID)
        {
            UserGroupsDAL userGroupsDAL = new UserGroupsDAL();
            return userGroupsDAL.GetUserGroupsByUserID(UserID);
        }
    }
}
