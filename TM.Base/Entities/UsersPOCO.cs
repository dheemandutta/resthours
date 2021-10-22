using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.Base.Entities
{
    public class UsersPOCO
    {
        public int ID { get; set; }
        public string Username { get; set; }
        public string Password { get; set; }
        public Boolean Active { get; set; }

        public int UserId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
		public int CrewId { get; set; }
		public string AdminGroup { get; set; }
		public string MName { get; set; }


        public Boolean AllowPsychologyForms { get; set; }
    }
}
