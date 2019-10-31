
-- exec stpGetPreviousBlankDates 19,'11/01/2018',9876543
ALTER PROCEDURE stpGetPreviousBlankDates
(
	@CrewId int,
	@BookDate Datetime,
	@VesselId int
)
AS
BEGIN
DECLARE @MinDate DATETIME = DATEADD(day,-14,@BookDate),
        @MaxDate DATETIME = @BookDate ; --GETDATE();


--print @MinDate

DECLARE @TempTab TABLE
(
	Dt VARCHAR(10)
)
DECLARE @Counter int 
SET @Counter = -14
WHILE @MinDate < @MaxDate
BEGIN

	INSERT INTO @TempTab(Dt) VALUES (CONVERT(varchar,@MinDate,101))

	SET @Counter =  @Counter +1 
	SET @MinDate = DATEADD(day,@Counter,@BookDate)
	

END

--SELECT CONVERT(DATE,ValidOn,110) FROM WorkSessions 
-- WHERE CONVERT(DATE,ValidOn,112) IN (SELECT Dt FROM @TempTab) 
-- AND CrewID = @CrewId

 --SELECT * FROM @TempTab


DELETE FROM @TempTab
WHERE Dt IN ( SELECT CONVERT(varchar,ValidOn,101) FROM WorkSessions 
			WHERE CONVERT(varchar,ValidOn,101) IN (SELECT Dt FROM @TempTab) AND CrewID = @CrewId 
			And VesselID = @VesselId)


DECLARE @RowCount int
SELECT @RowCount = COUNT(*) FROM @TempTab
IF( @RowCount = 14 )
BEGIN
	DELETE FROM @TempTab
END

--SELECT * FROM @TempTab
---***********READING FORWARD DATES******************

DECLARE @ForwardMinDate Datetime
DECLARE @ForwardMaxDate Datetime
DECLARE @MaxBookDate Datetime


SET @ForwardMinDate = DATEADD(day,1,@BookDate)

SET @ForwardMaxDate = DATEADD(day,6,@BookDate)

SELECT @MaxBookDate = MAX(ValidOn) FROM WorkSessions 
WHERE CrewID = @CrewId 
AND VesselID = @VesselId 
AND ValidOn <= @ForwardMaxDate

--print @MaxBookDate

IF @MaxBookDate < @ForwardMaxDate
BEGIN
	SET @ForwardMaxDate = @MaxBookDate
END
print @ForwardMaxDate
print @ForwardMinDate
SET @Counter = 1

WHILE @ForwardMinDate <= @ForwardMaxDate
BEGIN
    print CONVERT(varchar,@ForwardMinDate,110)
	print @Counter
	IF NOT EXISTS (SELECT * FROM WorkSessions WHERE CONVERT(varchar,ValidOn,101) = CONVERT(varchar,@ForwardMinDate,101) AND ActualHours NOT LIKE '0000,0000,0000,0000,0000,0000')
	BEGIN
	    
		INSERT INTO @TempTab(Dt) VALUES (CONVERT(varchar,@ForwardMinDate,101))
	END

	SET @Counter =  @Counter +1 
	SET @ForwardMinDate = DATEADD(day,@Counter,@BookDate)
	

END



---*************************************************

SELECT Dt AS BlankDate FROM @TempTab

END
