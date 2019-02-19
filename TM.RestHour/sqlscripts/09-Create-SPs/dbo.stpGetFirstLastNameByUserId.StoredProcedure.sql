USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpGetFirstLastNameByUserId]    Script Date: 10-May-18 11:17:40 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpGetFirstLastNameByUserId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stpGetFirstLastNameByUserId]
GO
/****** Object:  StoredProcedure [dbo].[stpGetFirstLastNameByUserId]    Script Date: 10-May-18 11:17:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpGetFirstLastNameByUserId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- exec stpGetFirstLastNameByUserId 34

CREATE PROCEDURE [dbo].[stpGetFirstLastNameByUserId]

(

	@UserId int

)

AS



Begin



DECLARE @CrewId int

SET @CrewId = 0

IF EXISTS(SELECT COUNT(*) FROM Users WHERE ID = @UserId)

	begin

		SELECT @CrewId = CrewID FROM Users WHERE ID = @UserId

	end

IF @CrewId IS NOT NULL

BEGIN

	Select  C.FirstName, C.LastName,C.ID AS CrewId

	FROM Crew C

	INNER JOIN Users U

	ON C.ID = U.CrewId

	WHERE U.ID= @UserId

END

ELSE IF @CrewId IS NULL

BEGIN

	SELECT ''Admin'' FirstName,''Admin'' LastName,0 CrewId

	FROM Users WHERE ID = @UserId

	 

END









End' 
END
GO
