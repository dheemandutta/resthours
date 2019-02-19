USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpGetFirstLastNameByUserId]    Script Date: 30-Apr-18 11:45:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[stpGetFirstLastNameByUserId]
(
	@UserId int
)
AS

Begin
Select  C.FirstName, C.LastName,C.ID AS CrewId
FROM Crew C
INNER JOIN Users U
ON C.ID = U.CrewId
	  
WHERE U.ID= @UserId
End