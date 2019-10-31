-- exec usp_GetAllCrewForTimeSheet 9876543, 1
ALTER procedure [dbo].[usp_GetAllCrewForTimeSheet]
(
	@VesselID int,
	@UserID int
)
AS

Begin
Declare @SuperAdminID int
Declare @UserGroupID int 
DECLARE @CrewTab TABLE
(
	ID int,
	Name varchar(100),
	VesselID int
)

Select @SuperAdminID = ID from Groups Where GroupName = 'Super Admin'

Select @UserGroupID = GroupID from UserGroups Where UserID = @UserID

IF @UserGroupID = @SuperAdminID
Begin

Select DISTINCT C.ID, FirstName + '  ' +LastName AS Name, C.VesselID
from dbo.Crew C
INNER JOIN ServiceTerms ST
ON C.ID = ST.CrewID
Where C.VesselID=@VesselID

End
Else 
Begin

Select DISTINCT c.ID, FirstName + '  ' +LastName AS Name, C.VesselID
from dbo.Crew C
INNER JOIN ServiceTerms ST
ON C.ID = ST.CrewID
Left Outer Join DepartmentAdmin DA
ON C.ID = DA.CrewID
Where C.VesselID= @VesselID 
And DA.CrewID = (Select CrewID From Users Where ID = @UserID)
  AND Deletiondate >= GetDate()
  

Union 

Select C.ID, FirstName + '  ' +LastName AS Name, C.VesselID
from dbo.Crew C
INNER JOIN ServiceTerms ST
ON C.ID = ST.CrewID
Left Outer Join DepartmentAdmin DA
ON C.ID = DA.CrewID
Where C.VesselID= @VesselID 
And C.DepartmentMasterID IN (Select DepartmentMasterID From DepartmentAdmin Where CrewID = (Select CrewID From Users Where ID = @UserID))
  AND Deletiondate >= GetDate()

Union

Select C.ID, FirstName + '  ' +LastName AS Name, C.VesselID
from dbo.Crew C
INNER JOIN ServiceTerms ST
ON C.ID = ST.CrewID
Where C.VesselID= @VesselID 
And C.ID = (Select CrewID From Users Where ID = @UserID)
  AND Deletiondate >= GetDate()


End
End





