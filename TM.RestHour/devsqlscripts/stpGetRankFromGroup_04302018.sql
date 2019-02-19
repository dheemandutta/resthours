ALTER PROCEDURE stpGetRankFromGroup
(
	@RankId int
)
AS
BEGIN
	SELECT GroupId FROM GroupRank
	WHERE RankID = @RankId
END