using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text;
using System.Threading.Tasks;

namespace TM.RestHour.Models
{
    public class CompanyDetails
    {
        public int ID { get; set; }
        public string Name { get; set; }
        public string Address { get; set; }
        public string Website { get; set; }
        public string AdminContact { get; set; }
        public string AdminContactEmail { get; set; }
        public string ContactNumber { get; set; }
        public string Domain { get; set; }
        public string SecureKey { get; set; }


        public CompanyDetails()
        {

        }

        public CompanyDetails(int iD, string name, string address, string website, string adminContact, string adminContactEmail, string contactNumber, string domain)
        {
            ID = iD;
            Name = name;
            Address = address;
            Website = website;
            AdminContact = adminContact;
            AdminContactEmail = adminContactEmail;
            ContactNumber = contactNumber;
            Domain = domain;
        }



        public string ConvertToSingleString(CompanyDetails companyInfo)
        {
            StringBuilder _returnValue = new StringBuilder();
            _returnValue.Append(companyInfo.ID + "|");
            _returnValue.Append(companyInfo.Name + "|");
            _returnValue.Append(companyInfo.Address + "|");
            _returnValue.Append(companyInfo.Website + "|");
            _returnValue.Append(companyInfo.AdminContact + "|");
            _returnValue.Append(companyInfo.AdminContactEmail + "|");
            _returnValue.Append(companyInfo.ContactNumber + "|");
            _returnValue.Append(companyInfo.Domain + "|");
            return _returnValue.ToString();
        }

        public CompanyDetails GetCompanyInfoFromHash(string hashValue)
        {

            CompanyDetails _returnCompanyInfo = new CompanyDetails();
            string[] companyValuesArray = hashValue.Split('|');
            if (companyValuesArray.Length < 1)
            {
                return null;
            }

            _returnCompanyInfo.ID = int.Parse(companyValuesArray[0]);
            _returnCompanyInfo.Name = companyValuesArray[1];
            _returnCompanyInfo.Address = companyValuesArray[2];
            _returnCompanyInfo.Website = companyValuesArray[3];
            _returnCompanyInfo.AdminContact = companyValuesArray[4];
            _returnCompanyInfo.AdminContactEmail = companyValuesArray[5];
            _returnCompanyInfo.ContactNumber = companyValuesArray[6];
            _returnCompanyInfo.Domain = companyValuesArray[7];

            return _returnCompanyInfo;
        }
    }
}