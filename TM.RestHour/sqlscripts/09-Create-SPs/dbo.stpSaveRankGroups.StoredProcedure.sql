USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpSaveRankGroups]    Script Date: 10-May-18 11:17:40 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpSaveRankGroups]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stpSaveRankGroups]
GO
/****** Object:  StoredProcedure [dbo].[stpSaveRankGroups]    Script Date: 10-May-18 11:17:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpSaveRankGroups]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[stpSaveRankGroups]

(

	@RankId int,

	@Groups varchar(1000)

)

AS

BEGIN



	DECLARE @GroupTab TABLE

  (

	RankId int,

	GrpId int

	

  )







  INSERT INTO @GroupTab(RankId,GrpId)

	SELECT @RankId,String FROM ufn_CSVToTable(@Groups,'','')



	--select * from @GroupTab



	INSERT INTO GroupRank(GroupId,RankID)

	SELECT GrpId,RankId FROM @GroupTab



END' 
END
GO
