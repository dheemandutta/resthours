using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.Base.Entities
{
    public class GroupsPOCO
    {
        public GroupsPOCO()
        {
            Permissions = new PermissionsPOCO();
        }
        
        public int ID { get; set; }
        public string GroupName { get; set; }

        public PermissionsPOCO Permissions { get; set; }

     
    }
}
