
--DECLARE @X DECIMAL(5,2)
--EXEC stpGetWorkSessionsByValidOn 08,10,2018,19,@X OUTPUT
--PRINT @X
ALTER PROCEDURE [dbo].[stpGetWorkSessionsByValidOn]
(
	@day int,
	@month int,
	@year int,
	@CrewId int,
	@SevenDayRest varchar(10) OUTPUT
)
AS
Begin

--DECLARE @day int 
--SET @day =1

DECLARE @ValidOn datetime
DECLARE @SubstractedDate datetime
DECLARE @SubstractorFactor int
DECLARE @RecordCount int

SET @ValidOn = CAST(DATEFROMPARTS(@year,@month,@day) AS DATETIME)--dateadd(mm, (@year - 1900) * 12 + @month - 1 , @day - 1)
--print @ValidOn
SET @RecordCount =0


		SELECT @SevenDayRest=
		CASE
			WHEN ComplianceInfo.value('(/ncdetails/minsevendaysrest)[1]','varchar(10)') = '200' Then '-'
			ELSE ComplianceInfo.value('(/ncdetails/minsevendaysrest)[1]','varchar(10)')
		END 
		from NCDetails s
		WHERE s.CrewID=@CrewId
		--AND OccuredOn = @ValidOn
		--AND ISNULL(REPLACE(REPLACE(CONVERT(varchar(12),s.OccuredOn,dbo.ufunc_GetDateFormat()), ' ','-'), ',',''), '-') = ISNULL(REPLACE(REPLACE(CONVERT(varchar(12),@ValidOn,dbo.ufunc_GetDateFormat()), ' ','-'), ',',''), '-')
		--AND CAST(OccuredOn AS FLOAT) = CAST(@ValidOn AS FLOAT)
		 --AND CONVERT(VARCHAR(12),s.OccuredOn,101) = CONVERT(VARCHAR(12),@ValidOn,101)
		 AND MONTH(s.OccuredOn) = MONTH(@month)
		 AND DAY(s.OccuredOn) = DAY(@day)
		 AND YEAR(s.OccuredOn) = YEAR(@year)
		ORDER BY s.OccuredOn



END


