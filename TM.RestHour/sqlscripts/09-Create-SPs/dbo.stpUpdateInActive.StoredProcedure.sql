USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpUpdateInActive]    Script Date: 10-May-18 11:17:40 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpUpdateInActive]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stpUpdateInActive]
GO
/****** Object:  StoredProcedure [dbo].[stpUpdateInActive]    Script Date: 10-May-18 11:17:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpUpdateInActive]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[stpUpdateInActive]

(
	@ID int
)

AS



Begin

UPDATE Crew 
  SET IsActive= 0
WHERE ID= @ID AND IsActive = 1

End' 
END
GO
