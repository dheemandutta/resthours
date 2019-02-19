using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.RestHour.Entities
{
    public class ShipPOCO
    {
        public int ID { get; set; }
        public string ShipName { get; set; }
        public string IMONumber { get; set; }
        public string FlagOfShip { get; set; }
        public string Regime { get; set; }
    }
}
