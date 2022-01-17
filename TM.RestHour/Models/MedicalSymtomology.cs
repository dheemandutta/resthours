using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TM.RestHour.Models
{
    public class MedicalSymtomology
    {

        public int ID { get; set; }
        public int CIRMId { get; set; }
        public string ObservationDate { get; set; }
        public string ObservationTime { get; set; }
        public string Vomiting { get; set; }
        public string FrequencyOfVomiting { get; set; }
        public string Fits { get; set; }
        public string FrequencyOfFits { get; set; }
        public string Giddiness { get; set; }
        public string FrequencyOfGiddiness { get; set; }
        public string Lethargy { get; set; }
        public string FrequencyOfLethargy { get; set; }
        public string SymptomologyDetails { get; set; }
        public string MedicinesAdministered { get; set; }
        public string AnyOtherRelevantInformation { get; set; }
    }
}