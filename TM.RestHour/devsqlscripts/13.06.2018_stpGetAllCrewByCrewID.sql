USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpGetAllCrewByCrewID]    Script Date: 13-Jun-18 7:41:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[stpGetAllCrewByCrewID]
(
	@ID int,
	@VesselID int
)

AS

Begin

Select  C.ID ,FirstName + '  ' +LastName AS Name, RankName, ISNULL(Notes,' ') Notes , C.VesselID,

ISNULL(CONVERT(varchar(12),ST.ActiveFrom,101), '-') ActiveFrom1,

ISNULL(CONVERT(varchar(12),ST.ActiveTo,101), '-') ActiveTo1,

C.FirstName,C.LastName,

ISNULL(CONVERT(varchar(12),DOB,101), '-') DOB1,

ISNULL(C.Nationality,'') Nationality,ISNULL(C.POB,'') POB, 

ISNULL(C.CrewIdentity,'') CrewIdentity,ISNULL(C.PassportSeamanPassportBook,'') PassportSeamanPassportBook,
ISNULL(C.Seaman,'') Seaman,

--

ISNULL(CONVERT(varchar(12),C.CreatedOn,101), '-') CreatedOn,

ISNULL(CONVERT(varchar(12),C.LatestUpdate,101), '-') LatestUpdate,

--

C.OvertimeEnabled,C.Watchkeeper,C.RankID





FROM dbo.Crew C 

LEFT OUTER JOIN ServiceTerms ST

ON C.ID = ST.CrewID

INNER JOIN Ranks R 

ON R.ID = C.RankID

WHERE C.ID= @ID AND C.VesselID=@VesselID

End



-- exec stpGetAllCrewByCrewID 21







