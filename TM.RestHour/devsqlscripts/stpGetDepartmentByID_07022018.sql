USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpGetDepartmentByID]    Script Date: 7/2/2018 8:21:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[stpGetDepartmentByID]
(
	@DepartmentMasterID int,
	@VesselID int
)
AS
Begin

DECLARE @DepartmentAdminIds varchar(500)
SET @DepartmentAdminIds = ''

SELECT @DepartmentAdminIds = COALESCE(@DepartmentAdminIds + ',','') + CAST(C.ID AS varchar(4))
FROM DepartmentAdmin DA
INNER JOIN DepartmentMaster DM
ON DM.DepartmentMasterID = DA.DepartmentMasterID
INNER JOIN Crew C
ON  DA.CrewID=C.ID 
AND DM.DepartmentMasterID = @DepartmentMasterID
AND DM.VesselID=@VesselID   

--SELECT @DepartmentAdminIds

Select DM.DepartmentMasterID,DepartmentMasterName,DepartmentMasterCode,@DepartmentAdminIds AS DepartmentAdmin
FROM dbo.DepartmentMaster DM
WHERE DM.DepartmentMasterID = @DepartmentMasterID
AND DM.VesselID=@VesselID


End
