﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.Base.Entities
{
    public class EquipmentsPOCO
    {
        public int EquipmentsID { get; set; }
        public string EquipmentsName { get; set; }
        public string Comment { get; set; }
        public string Quantity { get; set; }
        //public DateTime ExpiryDate { get; set; }
        public string ExpiryDate { get; set; }

        public int MedicineID { get; set; }
        public string MedicineName { get; set; }
        //public int Quantity { get; set; }

        public int ID { get; set; }
        public string Name { get; set; }
        public string DOB { get; set; }
        public string RankName { get; set; }

        public string ActiveFrom { get; set; }
        public string LatestUpdate { get; set; }
        public string FirstName { get; set; }
        public string MiddleName { get; set; }
        public string LastName { get; set; }
        public string PassportSeamanPassportBook { get; set; }
        public string Seaman { get; set; }
        public string POB { get; set; }

        public int CrewID { get; set; }
        public string ActiveTo { get; set; }

        public string Location { get; set; }



        public string BatchNo { get; set; }
        public string BatchQuantity { get; set; }
        public string PrescribedFor { get; set; }
    }
}
