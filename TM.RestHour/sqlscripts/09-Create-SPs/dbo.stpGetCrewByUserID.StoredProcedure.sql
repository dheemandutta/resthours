USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpGetCrewByUserID]    Script Date: 10-May-18 11:17:40 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpGetCrewByUserID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stpGetCrewByUserID]
GO
/****** Object:  StoredProcedure [dbo].[stpGetCrewByUserID]    Script Date: 10-May-18 11:17:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpGetCrewByUserID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create PROCEDURE [dbo].[stpGetCrewByUserID]

(

	@UserID int

)

AS



Begin

Select  GroupID,G.GroupName

FROM UserGroups UG

INNER JOIN Groups G

ON UG.ID = G.ID

	  

WHERE UserID= @UserID

End' 
END
GO
