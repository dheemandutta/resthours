USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpLastBookedSession]    Script Date: 10-May-18 11:17:40 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpLastBookedSession]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stpLastBookedSession]
GO
/****** Object:  StoredProcedure [dbo].[stpLastBookedSession]    Script Date: 10-May-18 11:17:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpLastBookedSession]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[stpLastBookedSession]

(

	@CrewId int

	

)

AS

BEGIN



	





	SELECT * FROM WorkSessions

	WHERE CrewId = @CrewId

	AND CONVERT(varchar(12),ValidOn,103) = (



		SELECT TOP 1 CONVERT(varchar(12),VAlidOn,103)  

	FROM WorkSessions 

	WHERE CrewID = @CrewId

	ORDER BY ValidOn DESC

	)



END' 
END
GO
