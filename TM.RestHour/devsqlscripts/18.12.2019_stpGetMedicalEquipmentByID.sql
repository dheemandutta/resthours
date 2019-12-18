USE [RestHourClient]
GO
/****** Object:  StoredProcedure [dbo].[stpGetMedicalEquipmentByID]    Script Date: 18/12/2019 4:13:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec stpGetMedicalEquipmentByID 11

ALTER PROCEDURE [dbo].[stpGetMedicalEquipmentByID]
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