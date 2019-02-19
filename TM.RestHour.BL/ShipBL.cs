using TM.RestHour.DAL;
using TM.Base.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.RestHour.BL
{
    public class ShipBL
    {
		public int UpdateShip(ShipPOCO shipPOCO, int VesselID)
		{
			ShipDAL shipDAL = new ShipDAL();
			return shipDAL.UpdateVessel(shipPOCO, VesselID);
		}

		public int SaveShip(ShipPOCO shipPOCO,int VesselID)
        {
            ShipDAL shipDAL = new ShipDAL();
            return shipDAL.SaveShip(shipPOCO, VesselID);
        }
        public int SaveNewShip(ShipPOCO shipPOCO)
        {
            ShipDAL shipDAL = new ShipDAL();
            return shipDAL.SaveNewShip(shipPOCO);
        }
        public List<ShipPOCO> GetAllShip()
        {
            ShipDAL shipDAL = new ShipDAL();
            return shipDAL.GetAllShip();
        }
        public List<ShipPOCO> GetShipPageWise(int pageIndex, ref int recordCount, int length)
        {
            ShipDAL shipDAL = new ShipDAL();
            return shipDAL.GetShipPageWise(pageIndex, ref recordCount, length);
        }
        public ShipPOCO GetShipByID()
        {
            ShipDAL shipDAL = new ShipDAL();
			ShipPOCO ship = new ShipPOCO();
            ship = shipDAL.GetShipByID().FirstOrDefault();
			ship.IMONumber = ship.IMONumber.Substring(ship.IMONumber.Length - 7);
			return ship;
		}
        public int DeleteShip(int ID)
        {
            ShipDAL shipDAL = new ShipDAL();
            return shipDAL.DeleteShip(ID);

        }


        //for Ship drp
        public List<ShipPOCO> GetAllShipForDrp()
        {
            ShipDAL crew = new ShipDAL();
            return crew.GetAllShipForDrp();
        }



        public int SaveInitialShipValues(ShipPOCO shipPOCO)
        {
            ShipDAL shipDAL = new ShipDAL();
            return shipDAL.SaveInitialShipValues(shipPOCO);
        }

        public int SaveConfigData(ShipPOCO shipPOCO)
        {
            ShipDAL shipDAL = new ShipDAL();
            return shipDAL.SaveConfigData(shipPOCO);
        }


        public string GetConfigData(string KeyName)
        {
            ShipDAL shipDAL = new ShipDAL();
            return shipDAL.GetConfigData(KeyName);
        }
    }
}
