/*
	To Avoid running dataDeidentification.fnModuloDividendAndMultiplier three times
	we copied the logic for the First Name, Middle Initial and Last Name functions
	instead of re-using them directly
*/
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
	JOIN (SELECT MAX(tFN.FirstNameId) AS MaxFirstNameId FROM dataDeidentificationPersonName.FirstName AS tFN) AS MFN ON 1 = 1
	JOIN dataDeidentificationPersonName.FirstName AS FN ON FN.FirstNameId = (MDAM.ModuloDividendAndMultiplier % MFN.MaxFirstNameId) + 1
	JOIN (SELECT MAX(tLN.LastNameId) AS MaxLastNameId FROM dataDeidentificationPersonName.LastName AS tLN) AS MLN ON 1 = 1
	JOIN dataDeidentificationPersonName.LastName AS LN ON LN.LastNameId = (MDAM.ModuloDividendAndMultiplier % MLN.MaxLastNameId) + 1;
GO