using TM.RestHour.DAL;
using TM.Base.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.RestHour.BL
{
    public class DepartmentBL
    {
        //for Admin Crew drp
        public List<DepartmentPOCO> GetAllAdminCrewForDrp(int VesselID)
        {
            DepartmentDAL departmentDAL = new DepartmentDAL();
            return departmentDAL.GetAllAdminCrewForDrp( VesselID);
        }

        //for User Crew drp
        public List<DepartmentPOCO> GetAllUserCrewForDrp(int VesselID)
        {
            DepartmentDAL departmentDAL = new DepartmentDAL();
            return departmentDAL.GetAllUserCrewForDrp(VesselID);
        }

        public int SaveDepartment(DepartmentPOCO departmentPOCO, int VesselID)
        {
            DepartmentDAL departmentDAL = new DepartmentDAL();
            return departmentDAL.SaveDepartment(departmentPOCO,  VesselID);
        }

        public List<DepartmentPOCO> GetDepartmentPageWise(int pageIndex, ref int recordCount, int length, int VesselID)
        {
            DepartmentDAL departmentDAL = new DepartmentDAL();
            return departmentDAL.GetDepartmentPageWise(pageIndex, ref recordCount, length, VesselID);
        }

        public DepartmentPOCO GetDepartmentByID(int DepartmentMasterID, int VesselID)
        {
            DepartmentDAL departmentDAL = new DepartmentDAL();
            return departmentDAL.GetDepartmentByID(DepartmentMasterID, VesselID);
        }

        public int DeleteDepartment(int DepartmentMasterID)
        {
            DepartmentDAL departmentDAL = new DepartmentDAL();
            return departmentDAL.DeleteDepartment(DepartmentMasterID);

        }

        //for Crew DualListbox
        public List<DepartmentPOCO> GetAllCrewForAssign(int VesselID)
        {
            DepartmentDAL departmentDAL = new DepartmentDAL();
            return departmentDAL.GetAllCrewForAssign(VesselID);
        }

        //public DepartmentPOCO GetDepartmentByIDForAssignCrew(GetDepartmentByIDForAssignCrewGetDepartmentByIDForAssignCrewGetDepartmentByIDForAssignCrew, int VesselID)
        //{
        //    DepartmentDAL departmentDAL = new DepartmentDAL();
        //    return departmentDAL.GetDepartmentByIDForAssignCrew(DepartmentMasterID, VesselID);
        //}

        //for GetDepartmentByIDForAssignCrew drp
        public List<DepartmentPOCO> GetDepartmentByIDForAssignCrew(int GetDepartmentByIDForAssignCrew, int VesselID)
        {
            DepartmentDAL departmentDAL = new DepartmentDAL();
            return departmentDAL.GetDepartmentByIDForAssignCrew(GetDepartmentByIDForAssignCrew, VesselID);
        }

     
        public int SaveDepartmentMaster(DepartmentPOCO departmentPOCO, int VesselID)
        {
            DepartmentDAL departmentDAL = new DepartmentDAL();
            return departmentDAL.SaveDepartmentMaster(departmentPOCO, VesselID);
        }
    }
}
