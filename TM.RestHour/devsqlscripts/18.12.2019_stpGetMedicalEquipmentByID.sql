
-- exec stpGetMedicalEquipmentByID 11

CREATE PROCEDURE [dbo].[stpGetMedicalEquipmentByID]
(
	@EquipmentsID int
	--,@VesselID int
)
AS
Begin
Select  EquipmentsID,EquipmentsName,Comment,Quantity, ExpiryDate, Location
FROM dbo.tblEquipments
WHERE EquipmentsID= @EquipmentsID
--AND VesselID=@VesselID
End