
-- stpDeleteMedicine 9

create procedure [dbo].[stpDeleteMedicine] 
( 
@MedicineID int
) 
AS 
BEGIN 
DELETE FROM tblMedicine where MedicineID=@MedicineID
RETURN  
END