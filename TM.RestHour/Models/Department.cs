using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TM.RestHour.Models
{
    public class Department
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

        public string CName { get; set; }
    }
}