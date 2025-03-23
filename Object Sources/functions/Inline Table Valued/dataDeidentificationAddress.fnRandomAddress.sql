CREATE FUNCTION [dataDeidentificationAddress].[fnRandomAddress]
(
	@PercentOfAddressesWithLine2 DECIMAL(2,2)
	,@ModuloDividend INT
	,@ModuloDividendMultiplier TINYINT = 1
)
RETURNS TABLE
AS
RETURN
	SELECT 
	((MDAM.ModuloDividendAndMultiplier % 10000) + 1) AS AddressLine1Number
	,ALN.[Name] AS AddressLine1Name
	,SS.FullName AS AddressLine1SuffixFull
	,SS.Abbreviation AddressLine1SuffixFullAbbreviation
	,IIF((MDAM.ModuloDividendAndMultiplier % 100) <= (@PercentOfAddressesWithLine2 * 100), AL2S.[Name], '') AS AddressLine2
	,CSZ.CityName
	,CSZ.StateName
	,CSZ.StateAbbreviation
	,CSZ.ZipCode
	FROM dataDeidentification.fnModuloDividendAndMultiplier (@ModuloDividend, @ModuloDividendMultiplier) AS MDAM
	JOIN (SELECT MAX(ALNt.AddressLineNameId) AS MaxAddressLineId FROM dataDeidentificationAddress.AddressLineName AS ALNt) AS MALN ON 1 = 1
	JOIN (SELECT MAX(SSt.StreetStuffixId) AS MaxStreetStuffixId FROM dataDeidentificationAddress.StreetSuffix AS SSt) AS MSS ON 1 = 1
	JOIN (SELECT MAX(AL2St.AddressLine2SuffixId) AS MaxAddressLine2SuffixId FROM dataDeidentificationAddress.AddressLine2Suffix AS AL2St) AS MAL2S ON 1 = 1
	JOIN (SELECT MAX(CSZt.CityStateZipId) AS MaxCityStateZipId FROM dataDeidentificationAddress.CityStateZip AS CSZt) AS MCSZ ON 1 = 1
	JOIN dataDeidentificationAddress.AddressLineName AS ALN ON ALN.AddressLineNameId = (MDAM.ModuloDividendAndMultiplier % MALN.MaxAddressLineId) + 1
	JOIN dataDeidentificationAddress.StreetSuffix AS SS ON SS.StreetStuffixId = (MDAM.ModuloDividendAndMultiplier % MSS.MaxStreetStuffixId) + 1
	JOIN dataDeidentificationAddress.AddressLine2Suffix AS AL2S ON AL2S.AddressLine2SuffixId = (MDAM.ModuloDividendAndMultiplier % MAL2S.MaxAddressLine2SuffixId) + 1
	JOIN dataDeidentificationAddress.CityStateZip AS CSZ ON CSZ.CityStateZipId = (MDAM.ModuloDividendAndMultiplier % MCSZ.MaxCityStateZipId) + 1
GO