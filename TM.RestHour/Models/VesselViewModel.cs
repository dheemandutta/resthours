using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TM.RestHour.Models
{
    public class VesselViewModel
    {
        public Vessel Vessel { get; set; }
        public List<Vessel> VesselList { get; set; }
    }
}