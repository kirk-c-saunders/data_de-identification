CREATE FUNCTION [dataDeidentification].[fnLastName]
(
	@ModuloDividend INT
	,@ModuloDividendMultiplier TINYINT = 1
)
RETURNS TABLE
AS
RETURN
	SELECT LN.LastName
	FROM [dataDeidentification].[ModuloDividendAndMultiplier] (@ModuloDividend, @ModuloDividendMultiplier) AS MDAM
	JOIN (SELECT MAX(tLN.LastNameId) AS MaxLastNameId FROM [dataDeidentification].[LastName] AS tLN) AS MLN ON 1 = 1
	JOIN [dataDeidentification].[LastName] AS LN ON LN.LastNameId = (MDAM.ModuloDividendAndMultiplier % MLN.MaxLastNameId) + 1;
GO