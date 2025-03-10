CREATE FUNCTION [dataDeidentification].[PhoneNumber]
(
	@AreaCodePrefix VARCHAR(10) = ''
	,@BetweenAreaCodeAndCentralOffice VARCHAR(10) = ''
	,@BetweenCentralOfficeAndStation VARCHAR(10) = ''
	,@ModuloDividend INT
	,@ModuloDividendMultiplier TINYINT = 1
)
RETURNS TABLE
RETURN
	SELECT COALESCE(@AreaCodePrefix, '')
			+ SUBSTRING(PN.AreaCodeNumber, LEN(PN.AreaCodeNumber)-2, 3)
			+ COALESCE(@BetweenAreaCodeAndCentralOffice, '')
			+ '555'
			+ COALESCE(@BetweenCentralOfficeAndStation, '')
			+ SUBSTRING(PN.StationNumber, LEN(PN.StationNumber)-3, 4) AS NewPhoneNumber
	FROM [dataDeidentification].[ModuloDividendAndMultiplier] (@ModuloDividend, @ModuloDividendMultiplier) AS MDAM
	CROSS APPLY
	(
		SELECT '00' + CAST((MDAM.ModuloDividendAndMultiplier % 999) + 1 AS VARCHAR(5)) AS AreaCodeNumber
				,'000' + CAST((MDAM.ModuloDividendAndMultiplier % 9999) + 1 AS VARCHAR(7)) AS StationNumber
	) AS PN
GO