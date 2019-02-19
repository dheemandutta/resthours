USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpGetNonComplianceByCrewId]    Script Date: 10-May-18 11:17:40 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpGetNonComplianceByCrewId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stpGetNonComplianceByCrewId]
GO
/****** Object:  StoredProcedure [dbo].[stpGetNonComplianceByCrewId]    Script Date: 10-May-18 11:17:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpGetNonComplianceByCrewId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--exec stpGetNonComplianceByCrewId 19,11,2017



CREATE PROCEDURE [dbo].[stpGetNonComplianceByCrewId]

(

	@CrewId int,

	@Month int,

	@Year int

)

AS

BEGIN



	SELECT ComplianceInfo,TotalNCHours

	FROM NCDetails

	WHERE CrewId = @CrewId

	AND MONTH(OccuredOn) = @Month

	AND YEAR(OccuredOn) = @Year



END' 
END
GO
