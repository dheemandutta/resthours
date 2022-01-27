using TM.RestHour.DAL;
using TM.Base.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.RestHour.BL
{
    public class MedicalChestBL
    {
        public int SaveMedicalChestCerticate(MedicalChestPOCO mdeiChest)
        {
            MedicalChestDAL mediChestDal = new MedicalChestDAL();
            return mediChestDal.SaveMedicalChestCerticate(mdeiChest);
        }

        public MedicalChestPOCO GetLatestMedicalChestCertificate(int vesselId)
        {
            MedicalChestDAL mediChestDal = new MedicalChestDAL();
            return mediChestDal.GetLatestMedicalChestCertificate(vesselId);
        }
    }
}
