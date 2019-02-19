using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.Base.Entities
{
    public class RanksPOCO
    {
       
        
        public int ID { get; set; }
        public string RankName { get; set; }
        public string Description { get; set; }
        public Boolean Scheduled { get; set; }
        public int Order { get; set; }

        public string SelectedGroups { get; set; }
    }
}
