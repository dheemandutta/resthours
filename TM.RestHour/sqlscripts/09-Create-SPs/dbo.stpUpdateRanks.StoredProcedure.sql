USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpUpdateRanks]    Script Date: 10-May-18 11:17:40 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpUpdateRanks]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stpUpdateRanks]
GO
/****** Object:  StoredProcedure [dbo].[stpUpdateRanks]    Script Date: 10-May-18 11:17:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpUpdateRanks]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[stpUpdateRanks]

(

	@RankOrder AS XML

)

AS

BEGIN



	DECLARE @RankTab TABLE

	  (

		RankOrder int,

		RankName varchar(50)

	  )



	  INSERT INTO @RankTab(RankOrder,RankName)

	  SELECT DISTINCT

			''RankOrder'' = x.v.value(''rankid[1]'',''INT''),

			''RankName'' = x.v.value(''rankname[1]'',''VARCHAR(50)'')

			 FROM @RankOrder.nodes(''/root/row'') x(v)





	 UPDATE r

	 SET r.[Order] = rt.RankOrder

	 from Ranks r

	 INNER JOIN @RankTab rt 

	 ON r.RankName = rt.RankName



	

END' 
END
GO
