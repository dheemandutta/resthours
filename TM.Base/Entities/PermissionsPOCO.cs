using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.Base.Entities
{
    public class PermissionsPOCO
    {
       
        public int ID { get; set; }
        public string PermissionName { get; set; }
        public List<PermissionsPOCO> ChildPermissions { get; set; }

        public string SelectedPermissionIds { get; set; }
    }
}
