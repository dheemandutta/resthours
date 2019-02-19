
-- exec stpGetWrokSessionsByDate 12,2018,8940557,1

ALTER PROCEDURE [dbo].[stpGetWrokSessionsByDate]

(

	@Month int,
	@Year int,
	@VesselID int,
	@UserID int

)

AS

BEGIN

	Declare @SuperAdminID int
	Declare @UserGroupID int 
	DECLARE @Crewtab TABLE
	(
		CrewId int
	)

	Select @SuperAdminID = ID from Groups Where GroupName = 'Super Admin'

	Select @UserGroupID = GroupID from UserGroups Where UserID = @UserID

	if @UserGroupID = @SuperAdminID
	Begin

	INSERT INTO @Crewtab(CrewId)
	Select DISTINCT ID --, FirstName + '  ' +LastName AS Name, VesselID
	from dbo.Crew
	Where VesselID=@VesselID 
	--and ID IN (8,10)
	
	End
	Else 
	Begin

	INSERT INTO @Crewtab(CrewId)
	Select ID --, FirstName + '  ' +LastName AS Name, C.VesselID
	from dbo.Crew C
	Left Outer Join DepartmentAdmin DA
	ON C.ID = DA.CrewID
	Where C.VesselID= @VesselID 
	And DA.CrewID = (Select CrewID From Users Where ID = @UserID)
	  AND Deletiondate >= GetDate()

	Union 

	Select ID --, FirstName + '  ' +LastName AS Name, C.VesselID
	from dbo.Crew C
	Left Outer Join DepartmentAdmin DA
	ON C.ID = DA.CrewID
	Where C.VesselID= @VesselID 
	And C.DepartmentMasterID IN (Select DepartmentMasterID From DepartmentAdmin Where CrewID = (Select CrewID From Users Where ID = @UserID))
	  AND Deletiondate >= GetDate()

	Union

	Select ID --, FirstName + '  ' +LastName AS Name, C.VesselID
	from dbo.Crew C
	--Left Outer Join DepartmentAdmin DA
	--ON C.ID = DA.CrewID
	Where C.VesselID= @VesselID 
	--And C.DepartmentMasterID = (Select DepartmentMasterID From DepartmentAdmin Where CrewID = 5)
	And C.ID = (Select CrewID From Users Where ID = @UserID)
	  AND Deletiondate >= GetDate()
	End
    

	DECLARE @SelectedDay DateTime
	SET @SelectedDay =  datefromparts(@Year, @Month, 1)

	SELECT *,NCD.NCDetailsID,C.FirstName + ' ' + C.LastName AS CrewName, WS.VesselID,RegimeName,
	 CASE 
	   WHEN DAY(ValidOn) < 10 THEN '0' + DAY(ValidOn)
	   ELSE DAY(ValidOn)
	END As DateNumber FROM WorkSessions WS
	INNER JOIN NCDetails NCD
	ON WS.ID = NCD.WorkSessionId 
	INNER JOIN Crew C
	ON C.ID = NCD.CrewID
	INNER JOIN Regimes REG
	ON REG.ID = WS.RegimeID
	WHERE MONTH(@SelectedDay) = MONTH(ValidOn)
	AND YEAR(@SelectedDay) =  YEAR(ValidOn)
	AND WS.VesselID=@VesselID
	AND C.ID IN (SELECT CrewId FROm @Crewtab)
	ORDER BY NCD.CrewID,DateNumber,WS.Timestamp DESC



END