USE [RestHourClient]
GO
/****** Object:  StoredProcedure [dbo].[stpSaveMedicine]    Script Date: 18/12/2019 4:13:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  exec stpSaveMedicine NULL,'A Das' , 3, '17-Dec-2019', 'Kolkata'

ALTER PROCEDURE [dbo].[stpSaveMedicine]
(
	@MedicineID int,
	@MedicineName varchar(500),
	@Quantity varchar(500),
    @ExpiryDate varchar(50),
	@Location varchar(50)
)
AS
BEGIN
IF @MedicineID IS NULL
 BEGIN
	INSERT INTO tblMedicine(MedicineName,Quantity,ExpiryDate,Location)
	VALUES (@MedicineName,@Quantity,@ExpiryDate,@Location)
END
ELSE
BEGIN
UPDATE tblMedicine
SET MedicineName=@MedicineName,Quantity=@Quantity,ExpiryDate=@ExpiryDate,Location=@Location
Where MedicineID=@MedicineID
END
END