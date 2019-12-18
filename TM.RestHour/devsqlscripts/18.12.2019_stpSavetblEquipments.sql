USE [RestHourClient]
GO
/****** Object:  StoredProcedure [dbo].[stpSavetblEquipments]    Script Date: 18/12/2019 4:13:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  exec stpSavetblEquipments NULL,'EquipmentsName', 'Comment' , 2, '24-Dec-2019', 'Kolkata555'

ALTER PROCEDURE [dbo].[stpSavetblEquipments]
(
	@EquipmentsID int,
	@EquipmentsName varchar(500),
	@Comment varchar(500),
	@Quantity int,
	@ExpiryDate varchar(50),
	@Location varchar(50)
)
AS
BEGIN
 IF @EquipmentsID IS NULL
 BEGIN
	INSERT INTO tblEquipments(EquipmentsName,Comment,Quantity,ExpiryDate,Location)
	VALUES (@EquipmentsName,@Comment,@Quantity,@ExpiryDate,@Location)
END
ELSE
BEGIN
UPDATE tblEquipments
SET EquipmentsName=@EquipmentsName,Comment=@Comment,Quantity=@Quantity,ExpiryDate=@ExpiryDate,Location=@Location
Where EquipmentsID=@EquipmentsID
END
END