USE [RestHourClient]
GO
/****** Object:  StoredProcedure [dbo].[stpDeleteMedicine]    Script Date: 18/12/2019 4:14:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- stpDeleteMedicine 9

ALTER procedure [dbo].[stpDeleteMedicine] 
( 
@MedicineID int
) 
AS 
BEGIN 
DELETE FROM tblMedicine where MedicineID=@MedicineID
RETURN  
END