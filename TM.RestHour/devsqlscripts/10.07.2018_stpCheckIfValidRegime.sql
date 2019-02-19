
--exec stpCheckIfValidRegime
CREATE PROCEDURE stpCheckIfValidRegime
AS
BEGIN

	SELECT COUNT(*) FROM tblRegime WHERE IsActiveRegime=1 
	AND CONVERT(varchar(10),RegimeEndDate,101) >= CONVERT(varchar(10),GETDATE(),101)
	AND CONVERT(varchar(10),RegimeStartDate,101) <= CONVERT(varchar(10),GETDATE(),101)

END	