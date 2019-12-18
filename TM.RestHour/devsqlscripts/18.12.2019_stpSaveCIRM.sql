USE [RestHourClient]
GO
/****** Object:  StoredProcedure [dbo].[stpSaveCIRM]    Script Date: 18/12/2019 4:12:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  exec stpSaveCIRM .......................

ALTER PROCEDURE [dbo].[stpSaveCIRM]
(
  @CIRMId int,
  @NameOfVessel varchar(50),
  @RadioCallSign varchar(50),
  @PortofDestination varchar(50),
  @Route varchar(50),
  @LocationOfShip varchar(50),
  @PortofDeparture varchar(50),
  @EstimatedTimeOfarrivalhrs varchar(50),
  @Speed varchar(50),
  @Nationality varchar(50),
  @Qualification varchar(50),
  @RespiratoryRate varchar(50),
  @Pulse varchar(50),
  @Temperature varchar(50),
  @Systolic varchar(50),
  @Diastolic varchar(50),
  @Symptomatology varchar(50),
  @LocationAndTypeOfPain varchar(50),
  @RelevantInformationForDesease varchar(50),
  @WhereAndHowAccidentIsCausedCHK bit,
  @UploadMedicalHistory varchar(500),
  @UploadMedicinesAvailable varchar(500),
  @MedicalProductsAdministered varchar(500),
  @WhereAndHowAccidentIsausedARA varchar(500),
  @CrewId int
)

AS
BEGIN

 IF @CIRMId IS NULL

BEGIN 
	INSERT INTO CIRM(NameOfVessel,RadioCallSign,PortofDestination,[Route],LocationOfShip,PortofDeparture,EstimatedTimeOfarrivalhrs,Speed,
	                 Nationality,Qualification,RespiratoryRate,Pulse,Temperature,Systolic,Diastolic,Symptomatology,
					 LocationAndTypeOfPain,RelevantInformationForDesease,WhereAndHowAccidentIsCausedCHK,UploadMedicalHistory,
					 UploadMedicinesAvailable,MedicalProductsAdministered,WhereAndHowAccidentIsausedARA,CrewId)

	VALUES (@NameOfVessel,@RadioCallSign,@PortofDestination,@Route,@LocationOfShip,@PortofDeparture,@EstimatedTimeOfarrivalhrs,@Speed,
	        @Nationality,@Qualification,@RespiratoryRate,@Pulse,@Temperature,@Systolic,@Diastolic,@Symptomatology,
		    @LocationAndTypeOfPain,@RelevantInformationForDesease,@WhereAndHowAccidentIsCausedCHK,@UploadMedicalHistory,
		    @UploadMedicinesAvailable,@MedicalProductsAdministered,@WhereAndHowAccidentIsausedARA,@CrewId)
END

END
