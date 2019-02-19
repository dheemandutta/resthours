USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpGetRankFromGroup]    Script Date: 10-May-18 11:17:40 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpGetRankFromGroup]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stpGetRankFromGroup]
GO
/****** Object:  StoredProcedure [dbo].[stpGetRankFromGroup]    Script Date: 10-May-18 11:17:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpGetRankFromGroup]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[stpGetRankFromGroup]

(

	@RankId int

)

AS

BEGIN

	SELECT GroupId FROM GroupRank

	WHERE RankID = @RankId

END' 
END
GO
