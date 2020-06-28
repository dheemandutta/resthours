USE [RestHourClient]
GO
/****** Object:  StoredProcedure [dbo].[stpGetMedicineAll]    Script Date: 27-Jun-20 7:18:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpGetMedicineAll]
AS
BEGIN
Select MedicineID, MedicineName, Quantity, ExpiryDate, Location from tblMedicine
END




USE [RestHourClient]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpGetEqipmentAll]
AS
BEGIN
Select EquipmentsID, EquipmentsName, Comment, Quantity, ExpiryDate, Location from tblEquipments
END
