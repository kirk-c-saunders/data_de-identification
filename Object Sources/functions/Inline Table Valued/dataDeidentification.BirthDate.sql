CREATE FUNCTION [dataDeidentification].[BirthDate]
(
	@InputBirthDate DATETIME
	,@DayRange INT = 1095 /* Approximately 3 years in days */
	,@ModuloDividend INT
	,@ModuloDividendMultiplier TINYINT = 1
)
RETURNS TABLE
AS
RETURN
	SELECT
	CASE
		WHEN MDAM.ModuloDividendAndMultiplier % 2 = 0
			THEN DATEADD(DAY, (MDAM.ModuloDividendAndMultiplier % @DayRange), @InputBirthDate)
		ELSE /* MDAM.ModuloDividendAndMultiplier % 2 <> 0 */
			DATEADD(DAY, (MDAM.ModuloDividendAndMultiplier % @DayRange) * -1, @InputBirthDate)
		END AS NewBirthDate
	FROM dataDeidentification.ModuloDividendAndMultiplier (@ModuloDividend, @ModuloDividendMultiplier) AS MDAM
GO