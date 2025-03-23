CREATE FUNCTION [dataDeidentificationPersonName].[fnLastName]
(
	@ModuloDividend INT
	,@ModuloDividendMultiplier TINYINT = 1
)
RETURNS TABLE
AS
RETURN
	SELECT LN.LastName
	FROM dataDeidentification.fnModuloDividendAndMultiplier (@ModuloDividend, @ModuloDividendMultiplier) AS MDAM
	JOIN (SELECT MAX(tLN.LastNameId) AS MaxLastNameId FROM dataDeidentificationPersonName.LastName AS tLN) AS MLN ON 1 = 1
	JOIN dataDeidentificationPersonName.LastName AS LN ON LN.LastNameId = (MDAM.ModuloDividendAndMultiplier % MLN.MaxLastNameId) + 1;
GO