CREATE FUNCTION [dataDeidentification].[fnModuloDividendAndMultiplier]
(
	@ModuloDividend INT
	,@ModuloDividendMultiplier TINYINT = 1
)
RETURNS TABLE
AS
RETURN
	SELECT CAST(@ModuloDividend AS BIGINT) * CAST(@ModuloDividendMultiplier AS BIGINT) AS ModuloDividendAndMultiplier;
GO