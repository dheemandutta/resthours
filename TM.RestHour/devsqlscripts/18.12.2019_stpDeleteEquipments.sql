
-- stpDeleteEquipments 25

create procedure [dbo].[stpDeleteEquipments] 
( 
@EquipmentsID int
) 
AS 
BEGIN 
DELETE FROM tblEquipments where EquipmentsID=@EquipmentsID
RETURN  
END