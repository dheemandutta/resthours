using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TM.RestHour.Models
{
    public class LoginModel
    {
        public Users Users { get; set; }
        //ekhane tor property add kore de

        public int ID { get; set; }
        public string ShipName { get; set; }

        public string UserName { get; set; }
    }
}