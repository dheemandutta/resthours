USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpGetRanksByID]    Script Date: 10-May-18 11:17:40 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpGetRanksByID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stpGetRanksByID]
GO
/****** Object:  StoredProcedure [dbo].[stpGetRanksByID]    Script Date: 10-May-18 11:17:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpGetRanksByID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create PROCEDURE [dbo].[stpGetRanksByID]

(

	@ID int

)

AS



Begin

Select  ID,RankName,[Description],Scheduled

FROM dbo.Ranks

	  

WHERE ID= @ID

End' 
END
GO
