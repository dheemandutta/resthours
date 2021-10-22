using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.Base.Entities
{
    public class CrewTemperaturePOCO
    {
        public int ID { get; set; }
        public int CrewID { get; set; }
        public decimal Temperature { get; set; }
        public string Unit { get; set; }
        public string ReadingDate { get; set; }
        public string ReadingTime { get; set; }
        public string Comment { get; set; }

        public int TemperatureModeID { get; set; }
        public string TemperatureMode { get; set; }

        public string Place { get; set; }
        public string Means { get; set; }
        public string CrewName { get; set; }
        public string RankName { get; set; }



        public string SPO2Level { get; set; }

        public Boolean Fever { get; set; }
        public Boolean Cough { get; set; }
        public Boolean LossOfTesteOrSmell { get; set; }
        public Boolean Tiredness { get; set; }
        public Boolean Headache { get; set; }
        public Boolean Diarrhoea { get; set; }
        public Boolean Breathlessness { get; set; }
        public Boolean Vomiting { get; set; }
        public Boolean ChestPain { get; set; }

        public string Others { get; set; }
    }
}
