
-- exec stpGetMedicineByID 11

create PROCEDURE [dbo].[stpGetMedicineByID]
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