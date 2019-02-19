USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpGetAllCrewByCrewID]    Script Date: 10-May-18 11:17:40 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpGetAllCrewByCrewID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stpGetAllCrewByCrewID]
GO
/****** Object:  StoredProcedure [dbo].[stpGetAllCrewByCrewID]    Script Date: 10-May-18 11:17:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpGetAllCrewByCrewID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[stpGetAllCrewByCrewID]

(

	@ID int

)

AS



Begin

Select  C.ID ,FirstName + ''  '' +LastName AS Name, RankName, ISNULL(Notes,'' '') Notes ,

ISNULL(CONVERT(varchar(12),ST.ActiveFrom,101), ''-'') ActiveFrom1,

ISNULL(CONVERT(varchar(12),ST.ActiveTo,101), ''-'') ActiveTo1,

C.FirstName,C.LastName,

ISNULL(CONVERT(varchar(12),DOB,101), ''-'') DOB1,

ISNULL(C.Nationality,'''') Nationality,ISNULL(C.POB,'''') POB, 

ISNULL(C.CrewIdentity,'''') CrewIdentity,ISNULL(C.PassportSeamanPassportBook,'''') PassportSeamanPassportBook,

--

ISNULL(CONVERT(varchar(12),C.CreatedOn,101), ''-'') CreatedOn,

ISNULL(CONVERT(varchar(12),C.LatestUpdate,101), ''-'') LatestUpdate,

--

C.OvertimeEnabled,C.Watchkeeper,C.RankID





FROM dbo.Crew C 

LEFT OUTER JOIN ServiceTerms ST

ON C.ID = ST.CrewID

INNER JOIN Ranks R 

ON R.ID = C.RankID

WHERE C.ID= @ID

End



-- exec stpGetAllCrewByCrewID 21' 
END
GO
