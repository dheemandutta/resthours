--exec stpSaveDepartmentMaster 'dfsdf','CODE gf', '7654321'
alter procedure [dbo].[stpSaveDepartmentMaster] 
( 
--@DepartmentMasterID int,
@DepartmentMasterName varchar(50),
@DepartmentMasterCode varchar(10),
@VesselID int
) 
AS 
BEGIN 

INSERT INTO DepartmentMaster 
       (DepartmentMasterName,  DepartmentMasterCode, IsActive,VesselID)
Values(@DepartmentMasterName, @DepartmentMasterCode, 1,@VesselID)

END