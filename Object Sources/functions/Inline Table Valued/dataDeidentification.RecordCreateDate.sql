CREATE FUNCTION [dataDeidentification].[RecordCreateDate]
(
	@RangeStartDate DATETIME = '2015-01-01'
	,@IncludeTime BIT = 1
	,@ProvidedTime TIME = NULL
	,@ModuloDividend INT
	,@ModuloDividendMultiplier TINYINT = 1
)
RETURNS TABLE
AS
RETURN
	SELECT
	CASE
		WHEN @IncludeTime IS NULL OR @IncludeTime = 0
			THEN NRCD.NewRecordCreateDate 
		WHEN @ProvidedTime IS NULL /* AND @IncludeTime = 1 */
			/* Add Random number of milliseconds up to 24 hours */
			THEN DATEADD(MILLISECOND, NRCD.ModuloDividendAndMultiplier % 86400000, NRCD.NewRecordCreateDate)
		ELSE /* @ProvidedTime IS NULL AND @IncludeTime = 1 */
			DATEADD(MILLISECOND, DATEDIFF(MILLISECOND, '00:00:00', @ProvidedTime), NRCD.NewRecordCreateDate)
		END AS NewRecordCreateDate
	FROM 
	(
		SELECT MDAM.ModuloDividendAndMultiplier
				,DATEADD(DAY, MDAM.ModuloDividendAndMultiplier % DATEDIFF(DAY, @RangeStartDate, CURRENT_TIMESTAMP), @RangeStartDate) AS NewRecordCreateDate
		FROM [dataDeidentification].[ModuloDividendAndMultiplier] (@ModuloDividend, @ModuloDividendMultiplier) AS MDAM
	) AS NRCD
GO