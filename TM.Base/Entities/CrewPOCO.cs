using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.Base.Entities
{
    public class CrewPOCO
    {

        
        
        public int ID { get; set; }
        public string Name { get; set; }
        public int RankID { get; set; }
        public string RankName { get; set; }  
        public DateTime CreatedOn { get; set; }
        public string CreatedOn1 { get; set; }
        public string StartDate { get; set; } 
        public DateTime? LatestUpdate { get; set; }
        public string LatestUpdate1 { get; set; }
        public string EndDate { get; set; } 
        public string PayNum { get; set; }
        public string EmployeeNumber { get; set; }
        public string Notes { get; set; }
        public Boolean Watchkeeper { get; set; }
        public Boolean OvertimeEnabled { get; set; }
        public  string AdjustmentFactor{ get; set; }
        public ServiceTermsPOCO  ServiceTermsPOCO { get; set; }

        public string DiffDays { get; set; }
        public string Active { get; set; }
        public string PassportSeamanIndicator { get; set; }
       


        public string FirstName { get; set; }
        public string MiddleName { get; set; }
        public string LastName { get; set; }
        public string Gender { get; set; }





        public string Nationality { get; set; }

        public DateTime DOB { get; set; }
        public string DOB1 { get; set; }

        public string POB { get; set; }
        public string CrewIdentity { get; set; }
        public string PassportSeamanPassportBook { get; set; }
        public string Seaman { get; set; }
        public int PassportSeaman { get; set; }
        public string Passport { get; set; }
        

        public string ActiveTo1 { get; set; }

        public string ActiveFrom1 { get; set; }

        public string FlagOfShip { get; set; }

        public int? DepartmentMasterID { get; set; }
        public string DepartmentMasterName { get; set; }

        public int CountryID { get; set; }
        public string CountryName { get; set; }

        public int RowNumber { get; set; }

        public int CrewId { get; set; }

        public string File { get; set; }

        public string JoiningMedicalFile { get; set; }
    }
}
