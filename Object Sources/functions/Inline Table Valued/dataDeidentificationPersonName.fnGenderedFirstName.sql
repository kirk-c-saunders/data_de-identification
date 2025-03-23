CREATE FUNCTION [dataDeidentificationPersonName].[fnGenderedFirstName]
(
	@Gender CHAR(1)
	,@ModuloDividend INT
	,@ModuloDividendMultiplier TINYINT = 1
)
RETURNS TABLE
AS
RETURN
	SELECT FN.FirstName
	FROM dataDeidentification.fnModuloDividendAndMultiplier (@ModuloDividend, @ModuloDividendMultiplier) AS MDAM
	JOIN (SELECT MAX(tFN.GenderSequenceId) AS MaxGenderSequenceId FROM dataDeidentificationPersonName.FirstName AS tFN WHERE tFN.Gender = @Gender) AS MFN ON 1 = 1
	JOIN dataDeidentificationPersonName.FirstName AS FN ON FN.Gender = @Gender AND FN.GenderSequenceId = (MDAM.ModuloDividendAndMultiplier % MFN.MaxGenderSequenceId) + 1;
GO