using TM.RestHour.DAL;
using TM.Base.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.RestHour.BL
{
    public class MedicalAdviseBL
    {
        public MedicalAdvisePOCO GetMedicalAdvise(int CrewId, DateTime TestDate)
        {
            MedicalAdviseDAL medicalAdviseDAL = new MedicalAdviseDAL();
            return medicalAdviseDAL.GetMedicalAdvise(CrewId, TestDate);
        }
    }
}
