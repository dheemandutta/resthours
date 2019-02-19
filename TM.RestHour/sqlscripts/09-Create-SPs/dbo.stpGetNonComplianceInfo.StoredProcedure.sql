USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpGetNonComplianceInfo]    Script Date: 10-May-18 11:17:40 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpGetNonComplianceInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stpGetNonComplianceInfo]
GO
/****** Object:  StoredProcedure [dbo].[stpGetNonComplianceInfo]    Script Date: 10-May-18 11:17:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpGetNonComplianceInfo]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create PROCEDURE [dbo].[stpGetNonComplianceInfo]

(

	@NCDetailsID int

)

AS



Begin

Select  ComplianceInfo

FROM NCDetails

  

WHERE NCDetailsID= @NCDetailsID

End' 
END
GO
