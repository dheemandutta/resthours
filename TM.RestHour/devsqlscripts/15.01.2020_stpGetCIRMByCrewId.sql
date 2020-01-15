USE [RestHourClient]
GO
/****** Object:  StoredProcedure [dbo].[stpGetCIRMByCrewId]    Script Date: 15/01/2020 12:04:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec stpGetCIRMByCrewId 19

create PROCEDURE [dbo].[stpGetCIRMByCrewId]
(
	@CrewId int
)
AS
Begin
Select IsEquipmentUploaded, IsJoiningReportUloaded, IsMedicalHistoryUploaded, IsmedicineUploaded
FROM CIRM
WHERE CrewId = @CrewId
End