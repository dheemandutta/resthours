using TM.RestHour.DAL;
using TM.Base.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.RestHour.BL
{
    public class CompanyDetailsBL
    {
        public int SaveCompanyDetails(CompanyDetailsPOCO companyDetailsPOCO)
        {
            CompanyDetailsDAL companyDetailsDAL = new CompanyDetailsDAL();
            return companyDetailsDAL.SaveCompanyDetails(companyDetailsPOCO);
        }
        

        public CompanyDetailsPOCO GetCompanyDetailsByID(int ID)
        {
            CompanyDetailsDAL companyDetailsDAL = new CompanyDetailsDAL();
            return companyDetailsDAL.GetCompanyDetailsByID(ID);
        }

        public CompanyDetailsPOCO GetCompanyDetailsNew()
        {
            CompanyDetailsDAL companyDetailsDAL = new CompanyDetailsDAL();
            return companyDetailsDAL.GetCompanyDetailsNew();
        }


    }
}
