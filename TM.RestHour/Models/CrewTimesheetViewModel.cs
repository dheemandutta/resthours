﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TM.RestHour.Models
{
    public class CrewTimesheetViewModel
    {
        public CrewTimesheetViewModel()
       {
           last7DaysBookedHours = new string[960];
       } 
       
       public Crew Crew { get; set; }

        public int[] BookedHours { get; set; }

        public DateTime BookDate { get; set; }

        public DayOfWeek DayOfWeek { get; set; }

        public string[] last7DaysBookedHours { get; set; }

        public int Increament { get; set; }

        public string Comment { get; set; }

        public int ID { get; set; }

        //public List<Crew> MyProperty { get; set; }

        public int RegimeID { get; set; }

		public string AdminStatus { get; set; }

		public int CrewAdminId { get; set; }



        public int CountryID { get; set; }
        public string CountryName { get; set; }
    }
}