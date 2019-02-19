

--DECLARE @X DECIMAL(5,2)
--EXEC stpGetWorkSessionsByValidOn 23,09,2018,23,@X OUTPUT
--PRINT @X
ALTER PROCEDURE [dbo].[stpGetWorkSessionsByValidOn]
(
	@day int,
	@month int,
	@year int,
	@CrewId int,
	@SevenDayRest decimal(5,2) OUTPUT
)
AS
Begin

--DECLARE @day int 
--SET @day =1

DECLARE @ValidOn datetime
DECLARE @SubstractedDate datetime
DECLARE @SubstractorFactor int
DECLARE @RecordCount int

SET @ValidOn = dateadd(mm, (@year - 1900) * 12 + @month - 1 , @day - 1)

SET @RecordCount =0

DECLARE @RestHoursTab TABLE
(
	_id int IDENTITY ,
	_ValidOn datetime,
	_hours nchar(48),
	_zerocnt int,
	_resthours decimal(5,2)
)

--DECLARE @TempTabRecordCount int
--DECLARE @RecordDifference int
--DECLARE @FurthestDate datetime
--DECLARE @NewCheckDate datetime
--DECLARE @Counter int



IF @day >= 1 AND @day <8
BEGIN
	SET @SubstractorFactor = 1
END
ELSE
BEGIN
	SET @SubstractorFactor =@day - 6
END

--print @month
SET @SubstractedDate = datefromparts(@year,@month,@SubstractorFactor)
--print @SubstractedDate

IF @SubstractorFactor = 1
BEGIN

	SELECT @RecordCount = COUNT(s.CrewID)
	from NCDetails s
	WHERE s.CrewID=@CrewId
	AND OccuredOn BETWEEN  DATEADD(day,-6,@SubstractedDate) AND @SubstractedDate

	--SELECT COUNT(s.CrewID)
	--from NCDetails s
	--WHERE s.CrewID=@CrewId
	--AND OccuredOn BETWEEN  DATEADD(day,-6,@SubstractedDate) AND @SubstractedDate

	
	IF @RecordCount > 1
	BEGIN
		INSERT INTO @RestHoursTab(_resthours,_ValidOn)
		SELECT 
		CONVERT(decimal(5,2),m.c.value('.','varchar(max)')) ,s.OccuredOn
		from NCDetails s
		cross apply s.ComplianceInfo.nodes('//ncdetails/mintwentyfourhoursrest') as m(c)
		WHERE s.CrewID=@CrewId
		AND OccuredOn BETWEEN  DATEADD(day,-6, @ValidOn) AND @ValidOn
		ORDER BY s.OccuredOn

		

		
		

			

	END
	ELSE
	BEGIN
		INSERT INTO @RestHoursTab(_resthours,_ValidOn) VALUES (0.0,@ValidOn)
	END


	
END
ELSE
BEGIN
	SELECT @RecordCount = COUNT(s.CrewID)
	from NCDetails s
	WHERE s.CrewID=@CrewId
	AND OccuredOn BETWEEN  DATEADD(day,-6,@SubstractedDate) AND @ValidOn

	
	IF @RecordCount <> 0
	BEGIN
	INSERT INTO @RestHoursTab(_resthours,_ValidOn)
		SELECT 
		CONVERT(decimal(5,2),m.c.value('.','varchar(max)')) ,s.OccuredOn
		from NCDetails s
		cross apply s.ComplianceInfo.nodes('//ncdetails/minsevendaysrest') as m(c)
		WHERE s.CrewID=@CrewId
		AND OccuredOn BETWEEN  DATEADD(day,-6, @ValidOn) AND @ValidOn
		ORDER BY s.OccuredOn

		

	END
	ELSE
	BEGIN
		INSERT INTO @RestHoursTab(_resthours,_ValidOn) VALUES (0.0,@ValidOn)
	END

END




--SELECT * FROM @RestHoursTab ORDER BY _ValidOn DESC


SELECT TOP 1  @SevenDayRest = _resthours 
 FROM @RestHoursTab a
 ORDER BY _ValidOn DESC



END

