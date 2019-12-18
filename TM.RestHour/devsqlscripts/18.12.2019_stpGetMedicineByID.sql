USE [RestHourClient]
GO
/****** Object:  StoredProcedure [dbo].[stpGetMedicineByID]    Script Date: 18/12/2019 4:13:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec stpGetMedicineByID 11

ALTER PROCEDURE [dbo].[stpGetMedicineByID]
(
	@MedicineID int
	--,@VesselID int
)
AS
Begin
Select  MedicineID,MedicineName,Quantity, ExpiryDate, Location
FROM dbo.tblMedicine
WHERE MedicineID= @MedicineID
--AND VesselID=@VesselID
End