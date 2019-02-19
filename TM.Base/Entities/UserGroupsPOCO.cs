using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.Base.Entities
{
    public class UserGroupsPOCO
    {
        public UserGroupsPOCO()
        {
            Users = new UsersPOCO();
        }
        
        public UsersPOCO Users { get; set; }
        public int GroupID { get; set; }
        public string GroupName { get; set; }
        public string SelectedGroupID { get; set; }
        public int? CrewID { get; set; }

        public int ID { get; set; }
    }
}
