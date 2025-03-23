CREATE FUNCTION [dataDeidentification].[fnPhoneNumber]
(
	@Format VARCHAR(20) = '[AC][CO][SN]'
	,@ModuloDividend INT
	,@ModuloDividendMultiplier TINYINT = 1
)
RETURNS TABLE
RETURN
	SELECT
	REPLACE
	(
		REPLACE
		(
			REPLACE
			(
				@Format
				,'[SN]'
				,SUBSTRING(PN.StationNumber, LEN(PN.StationNumber)-3, 4)
			)
			,'[CO]'
			,PN.CentralOfficeNumber
		)
		,'[AC]'
		,SUBSTRING(PN.AreaCodeNumber, LEN(PN.AreaCodeNumber)-2, 3)
	) AS PhoneNumber
	FROM dataDeidentification.fnModuloDividendAndMultiplier (@ModuloDividend, @ModuloDividendMultiplier) AS MDAM
	CROSS APPLY
	(
		SELECT '00' + CAST((MDAM.ModuloDividendAndMultiplier % 999) + 1 AS VARCHAR(5)) AS AreaCodeNumber
				,'555' AS CentralOfficeNumber
				,'000' + CAST((MDAM.ModuloDividendAndMultiplier % 9999) + 1 AS VARCHAR(7)) AS StationNumber
	) AS PN
GO