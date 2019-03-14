-- exec stpGetPreviousBlankDates 15,'03/07/2019',8940557
ALTER PROCEDURE [dbo].[stpGetPreviousBlankDates]
(
	@CrewId int,
	@BookDate Datetime,
	@VesselId int
)
AS
BEGIN
DECLARE @MinDate DATETIME = DATEADD(day,-14,@BookDate),
        @MaxDate DATETIME = @BookDate ; --GETDATE();

DECLARE @PlusOneDayAdvCnt int
 SET @PlusOneDayAdvCnt =0

SELECT @PlusOneDayAdvCnt = COUNT(*) FROM TimeAdjustment
 WHERE AdjustmentValue = '+1D'
 AND CONVERT(varchar,AdjustmentDate,101) >= CONVERT(varchar,@MinDate,101)
 AND CONVERT(varchar,AdjustmentDate,101) <= CONVERT(varchar,@MaxDate,101)

 PRINT @PlusOneDayAdvCnt
 PRINT @MinDate

IF @PlusOneDayAdvCnt >= 1
BEGIN
	
	SET @MinDate = DATEADD(day,(@PlusOneDayAdvCnt*-1),@MinDate)

END

PRINT @MinDate


--print @MinDate

DECLARE @TempTab TABLE
(
	Dt VARCHAR(10)
)
DECLARE @Counter int 
SET @Counter = -14 + ( @PlusOneDayAdvCnt * -1)
WHILE @MinDate < @MaxDate
BEGIN

	INSERT INTO @TempTab(Dt) VALUES (CONVERT(varchar,@MinDate,101))

	SET @Counter =  @Counter +1 
	SET @MinDate = DATEADD(day,@Counter,@BookDate)
	

END

DELETE FROM @TempTab 
WHERE Dt IN (
SELECT CONVERT(varchar,AdjustmentDate,101) FROM TimeAdjustment
 WHERE AdjustmentValue = '+1D'
 AND CONVERT(varchar,AdjustmentDate,101) >= CONVERT(varchar,@MinDate,101)
 AND CONVERT(varchar,AdjustmentDate,101) <= CONVERT(varchar,@MaxDate,101))


DELETE FROM @TempTab
WHERE Dt IN (
			SELECT CONVERT(varchar,ValidOn,101) FROM WorkSessions 
			WHERE CONVERT(varchar,ValidOn,101) IN (SELECT Dt FROM @TempTab) AND CrewID = @CrewId 
			And VesselID = @VesselId)


DECLARE @RowCount int
SELECT @RowCount = COUNT(*) FROM @TempTab
IF( @RowCount = 14 )
BEGIN
	DELETE FROM @TempTab
END

SET @MinDate = DATEADD(day,-14,@BookDate)

print 'here'
print @MinDate
print @BookDate

DELETE FROM @TempTab
WHERE Dt <
(SELECT CONVERT(VARCHAR(10),MIN(ValidOn),101) FROM WorkSessions 
WHERE ValidOn <= CONVERT(DATETIME,@BookDate) 
AND ValidOn >= CONVERT(DATETIME,@MinDate)
AND Hours <> '000000000000000000000000000000000000000000000000'
AND CrewID =  @CrewId)


 

 








--SELECT * FROM @TempTab
---***********READING FORWARD DATES******************

DECLARE @ForwardMinDate Datetime
DECLARE @ForwardMaxDate Datetime
DECLARE @MaxBookDate Datetime


SET @ForwardMinDate = DATEADD(day,1,@BookDate)
SET @ForwardMaxDate = DATEADD(day,6,@BookDate)
SET @PlusOneDayAdvCnt =0


SELECT @PlusOneDayAdvCnt = COUNT(*) FROM TimeAdjustment
WHERE CONVERT(varchar,AdjustmentDate,101) >= CONVERT(varchar,@ForwardMinDate,101)
AND  CONVERT(varchar,AdjustmentDate,101) <= CONVERT(varchar,@ForwardMaxDate,101)

print @PlusOneDayAdvCnt
print @ForwardMaxDate

IF @PlusOneDayAdvCnt >=1 
BEGIN
	
	SET @ForwardMaxDate = DATEADD(day,@PlusOneDayAdvCnt,@ForwardMaxDate)

END
print @ForwardMaxDate


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

IF @PlusOneDayAdvCnt >=1 
BEGIN

	DELETE FROM @TempTab WHERE Dt IN
	(SELECT CONVERT(varchar,AdjustmentDate,101) FROM TimeAdjustment
	 WHERE CONVERT(varchar,AdjustmentDate,101) >= CONVERT(varchar,@ForwardMinDate,101)
	 AND  CONVERT(varchar,AdjustmentDate,101) <= CONVERT(varchar,@ForwardMaxDate,101)) 

END


---*************************************************

SELECT Dt AS BlankDate FROM @TempTab

END