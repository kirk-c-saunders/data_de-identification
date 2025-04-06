CREATE PROCEDURE [dataDeidentificationIdentifier].[StoFinalizeTinyIntIdentifier]
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE TII
	SET TII.NewIdentifier = NID.NewIdentifier
	FROM dataDeidentificationIdentifier.TinyIntIdentifier AS TII
	JOIN
	(
		SELECT TIIt.ExistingIdentifier
		,ROW_NUMBER() OVER (ORDER BY TIIt.SortingRandomizer) AS NewIdentifier
		FROM dataDeidentificationIdentifier.TinyIntIdentifier AS TIIt
	) AS NID ON NID.ExistingIdentifier = TII.ExistingIdentifier;

	ALTER INDEX UQ_DataDeidentificationIdentifier_TinyIntIdentifier_NewIdentifier
	ON dataDeidentificationIdentifier.TinyIntIdentifier REBUILD
	/* WITH (ONLINE = ON) - Add In if desired and able to */ ;	

	ALTER TABLE dataDeidentificationIdentifier.TinyIntIdentifier
	DROP CONSTRAINT TempTinyIntDefault;

	ALTER TABLE dataDeidentificationIdentifier.TinyIntIdentifier
	DROP COLUMN SortingRandomizer;
END;