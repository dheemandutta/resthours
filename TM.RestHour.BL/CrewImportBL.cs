using TM.RestHour.DAL;
using TM.Base.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.RestHour.BL
{
    public class CrewImportBL
    {
        public void ImportCrew(object dataTable,int vesselId)
        {
            CrewImportDAL crewImportDAL = new CrewImportDAL();
            crewImportDAL.ImportCrew(dataTable,vesselId);
        }
    }
}
