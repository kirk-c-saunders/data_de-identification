CREATE FUNCTION [dataDeidentificationPersonName].[fnIgnoreGenderFirstName]
(
	@ModuloDividend INT
	,@ModuloDividendMultiplier TINYINT = 1
)
RETURNS TABLE
AS
RETURN
	SELECT FN.FirstName
	FROM dataDeidentification.fnModuloDividendAndMultiplier (@ModuloDividend, @ModuloDividendMultiplier) AS MDAM
	JOIN (SELECT MAX(tFN.FirstNameId) AS MaxFirstNameId FROM dataDeidentificationPersonName.FirstName AS tFN) AS MFN ON 1 = 1
	JOIN dataDeidentificationPersonName.FirstName AS FN ON FN.FirstNameId = (MDAM.ModuloDividendAndMultiplier % MFN.MaxFirstNameId) + 1;
GO