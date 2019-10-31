Create procedure [dbo].[stpGetFirstRun]
(
@RunCount int
)

AS
Begin

Select RunCount

from FirstRun
Where RunCount = @RunCount

End