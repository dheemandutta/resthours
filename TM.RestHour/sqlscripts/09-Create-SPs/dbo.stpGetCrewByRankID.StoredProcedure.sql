USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpGetCrewByRankID]    Script Date: 10-May-18 11:17:40 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpGetCrewByRankID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stpGetCrewByRankID]
GO
/****** Object:  StoredProcedure [dbo].[stpGetCrewByRankID]    Script Date: 10-May-18 11:17:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpGetCrewByRankID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create PROCEDURE [dbo].[stpGetCrewByRankID]

(

	@RankID int

)

AS



Begin

Select  *

FROM dbo.Crew

	  

WHERE RankID= @RankID

End' 
END
GO
