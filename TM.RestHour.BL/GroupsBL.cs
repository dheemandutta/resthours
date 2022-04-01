using TM.RestHour.DAL;
using TM.Base.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.RestHour.BL
{
    public class GroupsBL
    {
        public int SaveGroups(GroupsPOCO groups,int VesselID)
        {
            GroupsDAL groupsDAL = new GroupsDAL();
            return groupsDAL.SaveGroups(groups, VesselID);
        }

        public int SaveRankPermission(RanksPOCO rank,int VesselID)
        {
            GroupsDAL groupsDAL = new GroupsDAL();
            return groupsDAL.SaveRankPermission(rank, VesselID);
        }

        //for Groups drp
        public List<GroupsPOCO> GetAllGroupsForDrp( int VesselID)
        {
            GroupsDAL groups = new GroupsDAL();
            return groups.GetAllGroupsForDrp(VesselID);
        }

        //for Groups drp2
        public List<GroupsPOCO> GetAllGroupsForDrp2(int VesselID)
        {
            GroupsDAL groups = new GroupsDAL();
            return groups.GetAllGroupsForDrp2(VesselID);
        }
    }
}
