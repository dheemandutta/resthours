﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TM.RestHour.Models
{
    public class Crew
    {
        public int ID { get; set; }
        public string Name { get; set; }
        public int RankID { get; set; }
        public string RankName { get; set; }  
        public DateTime CreatedOn { get; set; }
        public string CreatedOn1 { get; set; } 
        public DateTime? LatestUpdate { get; set; }
        public string LatestUpdate1 { get; set; } 
        public string PayNum { get; set; }
        public string EmployeeNumber { get; set; }
        public string Notes { get; set; }
        public Boolean Watchkeeper { get; set; }
        public Boolean OvertimeEnabled { get; set; }
        public string PassportSeamanIndicator { get; set; }
        public ServiceTerms  ServiceTerms { get; set; }

        public string StartDate { get; set; }
        public string EndDate { get; set; }
        public string DiffDays { get; set; }
        public string Active { get; set; }



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
        public int Passport { get; set; }


        public string ActiveTo1 { get; set; }
        public string ActiveFrom1 { get; set; }

        public string FlagOfShip { get; set; }


        public int? DepartmentMasterID { get; set; }
        public string DepartmentMasterName { get; set; }

        public int CountryID { get; set; }
        public string CountryName { get; set; }

        public int RowNumber { get; set; }

        public string JoiningMedicalFile { get; set; }

        public int TemperatureModeID { get; set; }
        public string TemperatureMode { get; set; }





        public string IssuingStateOfIdentityDocument { get; set; }

        public DateTime? ExpiryDateOfIdentityDocument { get; set; }
        public string ExpiryDateOfIdentityDocument1 { get; set; }


        public Boolean AllowPsychologyForms { get; set; }


        public string PassportOrSeaman { get; set; }
    }
}