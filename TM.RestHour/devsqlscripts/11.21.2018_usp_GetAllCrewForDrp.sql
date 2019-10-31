-- exec usp_GetAllCrewForDrp 9876543, 42
ALTER procedure [dbo].[usp_GetAllCrewForDrp]
(
	@VesselID int,
	@UserID int
)
AS

Begin
Declare @SuperAdminID int
Declare @UserGroupID int 

Select @SuperAdminID = ID from Groups Where GroupName = 'Super Admin'

Select @UserGroupID = GroupID from UserGroups Where UserID = @UserID

if @UserGroupID = @SuperAdminID
Begin

Select DISTINCT ID, FirstName + '  ' +LastName AS Name, VesselID
from dbo.Crew
Where VesselID=@VesselID
End
Else 
Begin
Select ID, FirstName + '  ' +LastName AS Name, C.VesselID
from dbo.Crew C
Left Outer Join DepartmentAdmin DA
ON C.ID = DA.CrewID
Where C.VesselID= @VesselID 
And DA.CrewID = (Select CrewID From Users Where ID = @UserID)
  AND Deletiondate >= GetDate()

Union 

Select ID, FirstName + '  ' +LastName AS Name, C.VesselID
from dbo.Crew C
Left Outer Join DepartmentAdmin DA
ON C.ID = DA.CrewID
Where C.VesselID= @VesselID 
And C.DepartmentMasterID IN (Select DepartmentMasterID From DepartmentAdmin Where CrewID = (Select CrewID From Users Where ID = @UserID))
  AND Deletiondate >= GetDate()

Union

Select ID, FirstName + '  ' +LastName AS Name, C.VesselID
from dbo.Crew C
--Left Outer Join DepartmentAdmin DA
--ON C.ID = DA.CrewID
Where C.VesselID= @VesselID 
--And C.DepartmentMasterID = (Select DepartmentMasterID From DepartmentAdmin Where CrewID = 5)
And C.ID = (Select CrewID From Users Where ID = @UserID)
  AND Deletiondate >= GetDate()
End
End





