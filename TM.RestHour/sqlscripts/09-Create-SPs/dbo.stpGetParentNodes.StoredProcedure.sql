USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpGetParentNodes]    Script Date: 10-May-18 11:17:40 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpGetParentNodes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stpGetParentNodes]
GO
/****** Object:  StoredProcedure [dbo].[stpGetParentNodes]    Script Date: 10-May-18 11:17:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpGetParentNodes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[stpGetParentNodes]

AS



Begin

Select ID,PermissionName 

from dbo.[Permissions]  

Where ParentPermissionID IS NULL

End' 
END
GO
