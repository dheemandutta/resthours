USE [resthoursclient]
GO
/****** Object:  StoredProcedure [dbo].[stpGetCrewDetailsForHealthByIDNew]    Script Date: 12/19/2019 9:39:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  Exec stpGetCrewDetailsForHealthByIDNew 3
ALTER PROCEDURE [dbo].[stpGetCrewDetailsForHealthByIDNew]
(
@LoggedInUserId int
)
AS
Begin
Select ISNULL(FirstName,' ')+'  '+ISNULL(LastName,' ') AS Name, 
--CONVERT(varchar(12),DOB,dbo.ufunc_GetDateFormat())DOB, 
ISNULL(REPLACE(REPLACE(CONVERT(varchar(12),DOB,dbo.ufunc_GetDateFormat()), ' ','-'), ',',''), '-') DOB,
R.RankName,  
--CONVERT(varchar(12),ST.ActiveFrom,dbo.ufunc_GetDateFormat())ActiveFrom
ISNULL(REPLACE(REPLACE(CONVERT(varchar(12),ST.ActiveFrom,dbo.ufunc_GetDateFormat()), ' ','-'), ',',''), '-') ActiveFrom
FROM Crew C
LEFT OUTER JOIN Ranks R
ON R.ID = C.RankID
LEFT OUTER JOIN ServiceTerms ST
ON ST.CrewID = C.ID
WHERE C.ID= @LoggedInUserId
End
