USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpGetAllRanks]    Script Date: 10-May-18 11:17:40 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpGetAllRanks]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stpGetAllRanks]
GO
/****** Object:  StoredProcedure [dbo].[stpGetAllRanks]    Script Date: 10-May-18 11:17:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpGetAllRanks]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[stpGetAllRanks]

AS



Begin

Select ID,RankName,[Description],Scheduled

from dbo.Ranks  

End' 
END
GO
