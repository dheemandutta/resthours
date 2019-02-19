USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpGetCrewOvertimeValue]    Script Date: 10-May-18 11:17:40 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpGetCrewOvertimeValue]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stpGetCrewOvertimeValue]
GO
/****** Object:  StoredProcedure [dbo].[stpGetCrewOvertimeValue]    Script Date: 10-May-18 11:17:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpGetCrewOvertimeValue]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[stpGetCrewOvertimeValue]
(
	@CrewId int
)
AS
BEGIN
	SELECT OvertimeEnabled FROM Crew WHERE ID = @CrewId
END' 
END
GO
