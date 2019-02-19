using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.Base.Entities
{
    public class DepartmentPOCO
    {
        public int DepartmentMasterID { get; set; }

        public string DepartmentMasterName { get; set; }
        public string DepartmentMasterCode { get; set; }

        public int CrewID { get; set; }
        public string CrewName { get; set; }


        public int ID { get; set; }
        public string Name { get; set; }

        public int IDUser { get; set; }
        public string NameUser { get; set; }

        public string SelectedCrewID { get; set; }

        public List<int> SelectedID { get; set; }

        public string CName { get; set; }
    }
}
