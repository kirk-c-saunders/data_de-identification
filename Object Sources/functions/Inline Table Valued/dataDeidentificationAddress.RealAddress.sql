CREATE FUNCTION [dataDeidentificationAddress].[RealAddress]
(
	@ModuloDividend INT
	,@ModuloDividendMultiplier TINYINT = 1
)
RETURNS TABLE
AS
RETURN
	SELECT CA.AddressLine1
	,CA.AddressLine2
	,CA.CityName
	,CA.StateName
	,CA.StateAbbreviation
	,CA.ZipCode
	FROM dataDeidentificationAddress.CompleteAddress AS CA
	JOIN (SELECT MAX(CompleteAddressId) AS MaxCompleteAddressId FROM dataDeidentificationAddress.CompleteAddress AS tCA) AS MCA ON 1 = 1
	CROSS APPLY dataDeidentification.ModuloDividendAndMultiplier (@ModuloDividend, @ModuloDividendMultiplier) AS MDAM
	WHERE (CAST(MDAM.ModuloDividendAndMultiplier AS INT) % MCA.MaxCompleteAddressId) + 1 = CA.CompleteAddressId
GO