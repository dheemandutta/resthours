USE [RestHourClient]
GO
/****** Object:  StoredProcedure [dbo].[stpDeleteEquipments]    Script Date: 18/12/2019 4:14:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- stpDeleteEquipments 25

ALTER procedure [dbo].[stpDeleteEquipments] 
( 
@EquipmentsID int
) 
AS 
BEGIN 
DELETE FROM tblEquipments where EquipmentsID=@EquipmentsID
RETURN  
END