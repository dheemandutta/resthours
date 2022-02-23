using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TM.RestHour.Models
{
    public class ExaminationForMedicalAdvise
    {
        public int Id { get; set; }
        public string Examination { get; set; }
        public string ExaminationPath { get; set; }
        public DateTime ExaminationDate { get; set; }
        public int MedicalAdviseId { get; set; }
    }
}