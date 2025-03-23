CREATE FUNCTION [dataDeidentification].[fnNameDrivenEmail]
(
	@EmailAddressTemplate VARCHAR(100) = '[FN].[MI].[LN]@YourOrTheAppropriateEmailDomain.com'
	,@ModuloDividend INT
	,@ModuloDividendMultiplier TINYINT = 1
)
RETURNS TABLE
AS
RETURN
	SELECT
	REPLACE
	(
		REPLACE
		(
			REPLACE
			(
				@EmailAddressTemplate
				,'[LN]'
				,LOWER(LN.LastName)
			)
			,'[MI]'
			,LOWER(CHAR(65 + (MDAM.ModuloDividendAndMultiplier % 26)))
		)
		,'[FN]'
		,LOWER(FN.FirstName)
	) AS EmailAddress
	FROM dataDeidentification.fnModuloDividendAndMultiplier (@ModuloDividend, @ModuloDividendMultiplier) AS MDAM
	JOIN (SELECT MAX(tFN.FirstNameId) AS MaxFirstNameId FROM dataDeidentification.FirstName AS tFN) AS MFN ON 1 = 1
	JOIN dataDeidentification.FirstName AS FN ON FN.FirstNameId = (MDAM.ModuloDividendAndMultiplier % MFN.MaxFirstNameId) + 1
	JOIN (SELECT MAX(tLN.LastNameId) AS MaxLastNameId FROM dataDeidentification.LastName AS tLN) AS MLN ON 1 = 1
	JOIN dataDeidentification.LastName AS LN ON LN.LastNameId = (MDAM.ModuloDividendAndMultiplier % MLN.MaxLastNameId) + 1;
GO