--exec stpSaveDepartment '1008','DN12', 'DC12', '17', 9876543

ALTER procedure [dbo].[stpSaveDepartment] 
( 
@DepartmentMasterID int,
@DepartmentMasterName varchar(50),
@DepartmentMasterCode varchar(10),

@CrewID varchar(1000),
@VesselID int
) 
AS 
BEGIN 

DECLARE @DepartmentID int

 BEGIN TRY
    BEGIN TRAN

 IF @DepartmentMasterID IS NULL

BEGIN   
 print 'INSERT'
INSERT INTO DepartmentMaster 
       (DepartmentMasterName,  DepartmentMasterCode, IsActive,VesselID)
Values(@DepartmentMasterName, @DepartmentMasterCode, 1,@VesselID)

SET @DepartmentID = @@IDENTITY

INSERT INTO DepartmentAdmin 
       (DepartmentMasterID, CrewID,IsAdmin,IsActive,VesselID)
	   SELECT @DepartmentID,String,1,1,@VesselID FROM ufn_CSVToTable(@CrewID,',')
--Values(@DepartmentID, @CrewID,1,1,@VesselID)


UPDATE Crew SET DepartmentMasterID = @DepartmentID

END
ELSE
BEGIN
print 'UPDATE'
UPDATE DepartmentMaster
SET DepartmentMasterName=@DepartmentMasterName, DepartmentMasterCode=@DepartmentMasterCode  
Where DepartmentMasterID=@DepartmentMasterID

--UPDATE DepartmentAdmin
--SET DepartmentMasterID=@DepartmentMasterID, CrewID=@CrewID  
--Where DepartmentMasterID=@DepartmentMasterID


DELETE From DepartmentAdmin Where DepartmentMasterID=@DepartmentMasterID

INSERT INTO DepartmentAdmin 
       (DepartmentMasterID, CrewID,IsAdmin,IsActive,VesselID)
	   SELECT @DepartmentMasterID,String,1,1,@VesselID FROM ufn_CSVToTable(@CrewID,',')

UPDATE Crew SET DepartmentMasterID = @DepartmentMasterID

END



	COMMIT TRAN
 END TRY 

 BEGIN CATCH
	ROLLBACK TRAN
	SELECT ERROR_MESSAGE() AS ErrorMessage;  
 END CATCH



END







