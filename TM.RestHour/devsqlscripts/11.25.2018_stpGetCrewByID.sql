-- stpGetCrewByID 18

ALTER PROCEDURE [dbo].[stpGetCrewByID]
(
	@ID int
)
AS
Begin
Select  DOB,FirstName + ' ' + LastName As Name
FROM Crew
WHERE ID= @ID
End







