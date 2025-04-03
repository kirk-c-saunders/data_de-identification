CREATE PROCEDURE [dataDeidentificationIdentifier].[StoFinalizeSmallIntIdentifier]
AS
BEGIN
	UPDATE SII
	SET SII.NewSmallInt = NID.NewSmallInt
	FROM dataDeidentificationIdentifier.SmallIntIdentifier AS SII
	JOIN
	(
		SELECT SIIt.ExistingSmallInt
		,ROW_NUMBER() OVER (ORDER BY SIIt.SortingRandomizer) AS NewSmallInt
		FROM dataDeidentificationIdentifier.SmallIntIdentifier AS SIIt
	) AS NID ON NID.ExistingSmallInt = SII.ExistingSmallInt;

	DROP INDEX UQ_DataDeidentificationIdentifier_SmallIntIdentifier_NewSmallInt
	ON dataDeidentificationIdentifier.SmallIntIdentifier;

	ALTER TABLE dataDeidentificationIdentifier.SmallIntIdentifier
	ALTER COLUMN NewSmallInt SMALLINT NOT NULL;	
	
	CREATE UNIQUE NONCLUSTERED INDEX [UQ_DataDeidentificationIdentifier_SmallIntIdentifier_NewSmallInt]
	ON [dataDeidentificationIdentifier].[SmallIntIdentifier] ([NewSmallInt] ASC)
	/* WITH (ONLINE = ON) - Add In if desired and able to */ ;

	ALTER TABLE dataDeidentificationIdentifier.SmallIntIdentifier
	DROP CONSTRAINT TempSmallIntDefault;

	ALTER TABLE dataDeidentificationIdentifier.SmallIntIdentifier
	DROP COLUMN SortingRandomizer;
END;
GO