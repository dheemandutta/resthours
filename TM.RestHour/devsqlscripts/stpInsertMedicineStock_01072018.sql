CREATE PROCEDURE stpInsertMedicineStock
(
	@XMLDoc XML
)
AS
BEGIN
	
		DECLARE @XMLDocPointer INT      

        EXEC sp_xml_preparedocument @XMLDocPointer OUTPUT, @XMLDoc


		INSERT INTO tblMedicine(MedicineName,Quantity,ExpiryDate)
		SELECT MedicineName,Quantity,ExpiryDate
		FROM OPENXML(@XMLDocPointer,'/NewDataSet/Medicine',2)
		WITH
		(
			MedicineName varchar(500),
			Quantity varchar(500),
			ExpiryDate varchar(50)

		)


END
