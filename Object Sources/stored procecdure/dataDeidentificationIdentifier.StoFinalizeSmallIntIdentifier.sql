CREATE PROCEDURE [dataDeidentificationIdentifier].[StoFinalizeSmallIntIdentifier]
AS
BEGIN
	SET NOCOUNT ON;
	
	UPDATE SII
	SET SII.NewIdentifier = NID.NewIdentifier
	FROM dataDeidentificationIdentifier.SmallIntIdentifier AS SII
	JOIN
	(
		SELECT SIIt.ExistingIdentifier
		,ROW_NUMBER() OVER (ORDER BY SIIt.SortingRandomizer) AS NewIdentifier
		FROM dataDeidentificationIdentifier.SmallIntIdentifier AS SIIt
	) AS NID ON NID.ExistingIdentifier = SII.ExistingIdentifier;

	ALTER INDEX UQ_DataDeidentificationIdentifier_SmallIntIdentifier_NewIdentifier
	ON dataDeidentificationIdentifier.SmallIntIdentifier REBUILD
	/* WITH (ONLINE = ON) - Add In if desired and able to */ ;

	ALTER TABLE dataDeidentificationIdentifier.SmallIntIdentifier
	DROP CONSTRAINT TempSmallIntDefault;

	ALTER TABLE dataDeidentificationIdentifier.SmallIntIdentifier
	DROP COLUMN SortingRandomizer;
END;
GO