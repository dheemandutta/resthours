using TM.RestHour.DAL;
using TM.Base.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.RestHour.BL
{
    public class EquipmentsBL
    {
        public int SaveEquipments(EquipmentsPOCO equipmentsPOCO /*,int VesselID*/)
        {
            EquipmentsDAL equipmentsDAL = new EquipmentsDAL();
            return equipmentsDAL.SaveEquipments(equipmentsPOCO/*, VesselID*/);
        }

        public List<EquipmentsPOCO> GetEquipmentsPageWise(int pageIndex, ref int recordCount, int length/*, int VesselID*/)
        {
            EquipmentsDAL equipmentsDAL = new EquipmentsDAL();
            return equipmentsDAL.GetEquipmentsPageWise(pageIndex, ref recordCount, length/*, VesselID*/);
        }


		public void ImportMedicine(object dataTable)
		{
			EquipmentsDAL equipmentsDAL = new EquipmentsDAL();
			equipmentsDAL.ImportMedicine(dataTable);
		}

		public void ImportEquipment(object dataTable)
		{
			EquipmentsDAL equipmentsDAL = new EquipmentsDAL();
			equipmentsDAL.ImportEquipment(dataTable);
		}


		public int SaveMedicine(EquipmentsPOCO equipmentsPOCO /*,int VesselID*/)
        {
            EquipmentsDAL equipmentsDAL = new EquipmentsDAL();
            return equipmentsDAL.SaveMedicine(equipmentsPOCO/*, VesselID*/);
        }

        public List<EquipmentsPOCO> GetMedicinePageWise(int pageIndex, ref int recordCount, int length/*, int VesselID*/)
        {
            EquipmentsDAL equipmentsDAL = new EquipmentsDAL();
            return equipmentsDAL.GetMedicinePageWise(pageIndex, ref recordCount, length/*, VesselID*/);
        }

        public EquipmentsPOCO GetCrewDetailsForHealthByID(int ID)
        {
            EquipmentsDAL equipmentsDAL = new EquipmentsDAL();
            EquipmentsPOCO Health = new EquipmentsPOCO();
            Health = equipmentsDAL.GetCrewDetailsForHealthByID(ID).FirstOrDefault();
            //ship.IMONumber = ship.IMONumber.Substring(ship.IMONumber.Length - 7);
            return Health;
        }

        public EquipmentsPOCO GetCrewDetailsForHealthByID2(int ID)
        {
            EquipmentsDAL equipmentsDAL = new EquipmentsDAL();
            EquipmentsPOCO Health = new EquipmentsPOCO();
            Health = equipmentsDAL.GetCrewDetailsForHealthByID2(ID).FirstOrDefault();
            //ship.IMONumber = ship.IMONumber.Substring(ship.IMONumber.Length - 7);
            return Health;
        }

        public int SaveServiceTerms(EquipmentsPOCO equipmentsPOCO ,int VesselID)
        {
            EquipmentsDAL equipmentsDAL = new EquipmentsDAL();
            return equipmentsDAL.SaveServiceTerms(equipmentsPOCO, VesselID);
        }

        public List<EquipmentsPOCO> GetServiceTermsListPageWise(int pageIndex, ref int recordCount, int length/*, int VesselID*/)
        {
            EquipmentsDAL equipmentsDAL = new EquipmentsDAL();
            return equipmentsDAL.GetServiceTermsListPageWise(pageIndex, ref recordCount, length/*, VesselID*/);
        }

        public EquipmentsPOCO GetMedicalEquipmentByID(int EquipmentsID/*, int VesselID*/)
        {
            EquipmentsDAL equipmentsDAL = new EquipmentsDAL();
            return equipmentsDAL.GetMedicalEquipmentByID(EquipmentsID/*, VesselID*/);
        }

        public EquipmentsPOCO GetMedicineByID(int MedicineID/*, int VesselID*/)
        {
            EquipmentsDAL equipmentsDAL = new EquipmentsDAL();
            return equipmentsDAL.GetMedicineByID(MedicineID/*, VesselID*/);
        }

        public int DeleteEquipments(int EquipmentsID/*, ref string oUTPUT*/)
        {
            EquipmentsDAL equipmentsDAL = new EquipmentsDAL();
            return equipmentsDAL.DeleteEquipments(EquipmentsID/*, ref oUTPUT*/);
        }
        public int DeleteMedicine(int MedicineID/*, ref string oUTPUT*/)
        {
            EquipmentsDAL equipmentsDAL = new EquipmentsDAL();
            return equipmentsDAL.DeleteMedicine(MedicineID/*, ref oUTPUT*/);
        }
    }
}
