using TM.RestHour.DAL;
using TM.Base.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace TM.RestHour.BL
{
    public class UploadMedicalInventoryBL
    {
        public void ImportMedicalInventory(object dataTable, int vesselId)
        {
            UploadMedicalInventoryDAL crewImportDAL = new UploadMedicalInventoryDAL();
            crewImportDAL.ImportMedicalInventory(dataTable, vesselId);
        }
    }
}
