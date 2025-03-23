CREATE FUNCTION [dataDeidentification].[MiddleInitial]
(
	@ModuloDividend INT
	,@ModuloDividendMultiplier TINYINT = 1
)
RETURNS TABLE
AS
RETURN
	SELECT CHAR(65 + (MDAM.ModuloDividendAndMultiplier % 26)) AS MiddleInitial
	FROM [dataDeidentification].[ModuloDividendAndMultiplier] (@ModuloDividend, @ModuloDividendMultiplier) AS MDAM;
GO