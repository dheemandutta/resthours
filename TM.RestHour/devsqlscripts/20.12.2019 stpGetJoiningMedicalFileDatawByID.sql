-- stpGetJoiningMedicalFileDatawByID 1

create PROCEDURE [dbo].[stpGetJoiningMedicalFileDatawByID]
(
	@CrewId int
)
AS
Begin
Select  JoiningMedicalFile
FROM JoiningMedicalFileData
WHERE CrewId= @CrewId
End