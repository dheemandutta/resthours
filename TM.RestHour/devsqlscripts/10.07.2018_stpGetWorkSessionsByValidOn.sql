
--DECLARE @X DECIMAL(5,2)
--EXEC stpGetWorkSessionsByValidOn 23,09,2018,23,@X OUTPUT
--PRINT @X
CREATE PROCEDURE [dbo].[stpGetWorkSessionsByValidOn]
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
SET @ValidOn = dateadd(mm, (@year - 1900) * 12 + @month - 1 , @day - 1)

--DECLARE @ValidOnEndDate datetime
--SET @ValidOnEndDate = DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,@ValidOnStartDate)+1,0))

DECLARE @RestHoursTab TABLE
(
	_id int IDENTITY ,
	_ValidOn datetime,
	_hours nchar(48),
	_zerocnt int,
	_resthours decimal(5,2)
)

INSERT INTO @RestHoursTab(_ValidOn,_hours,_zerocnt,_resthours)
Select ValidOn,Hours,   LEN(Hours) - LEN(REPLACE(Hours, '0', '')) AS ZeroCount,

 CASE        (LEN(Hours) - LEN(REPLACE(Hours, '0', ''))) % 2 
 WHEN 0 THEN (LEN(Hours) - LEN(REPLACE(Hours, '0', ''))) / 2
 Else        (LEN(Hours) - LEN(REPLACE(Hours, '0', ''))) / 2 + 0.5
 End AS RestHour

 --SUM (D_Count) OVER (ORDER BY Id) AS RestHour

from WorkSessions 
Where ValidOn BETWEEN DATEADD(day,-6, @ValidOn) AND @ValidOn
AND CrewID = @CrewId
ORDER BY ValidOn

SELECT TOP 1  @SevenDayRest = (SELECT SUM(b._resthours) FROM @RestHoursTab b WHERE b._id <= a._id) 
 FROM @RestHoursTab a
 ORDER BY _ValidOn DESC



END