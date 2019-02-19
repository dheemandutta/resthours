using TM.RestHour.DAL;
using TM.Base.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.RestHour.BL
{
    public class PermissionsBL
    {
        public List<PermissionsPOCO> GetParentNodes( int VesselID)
        {
            PermissionsDAL permissionsDAL = new PermissionsDAL();
            return permissionsDAL.GetParentNodes(VesselID);
        }
    }
}
