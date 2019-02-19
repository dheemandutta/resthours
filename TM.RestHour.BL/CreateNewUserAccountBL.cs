using TM.RestHour.DAL;
using TM.Base.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.RestHour.BL
{
    public class CreateNewUserAccountBL
    {
        public int SaveCreateNewUserAccount(UserGroupsPOCO userGroupsPOCO,int VesselID)
        {
            CreateNewUserAccountDAL createNewUserAccountDAL = new CreateNewUserAccountDAL();
            return createNewUserAccountDAL.SaveCreateNewUserAccount(userGroupsPOCO, VesselID);
        }

        public List<UsersPOCO> GetUsersPageWise(int pageIndex, ref int recordCount, int length, int VesselID)
        {
            CreateNewUserAccountDAL createNewUserAccountDAL = new CreateNewUserAccountDAL();
            return createNewUserAccountDAL.GetUsersPageWise(pageIndex, ref recordCount, length, VesselID);
        }

		public UsersPOCO GetUserByCrewId(int crewId )
		{
			CreateNewUserAccountDAL createNewUserAccountDAL = new CreateNewUserAccountDAL();
			return createNewUserAccountDAL.GetUserByCrewId(crewId);
		}
	}
}
