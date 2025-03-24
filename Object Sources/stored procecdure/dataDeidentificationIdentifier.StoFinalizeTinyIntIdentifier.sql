CREATE PROCEDURE [dataDeidentificationIdentifier].[StoFinalizeTinyIntIdentifier]
AS
BEGIN
	UPDATE TII
	SET TII.NewTinyInt = NID.NewTinyInt
	FROM dataDeidentificationIdentifier.TinyIntIdentifier AS TII
	JOIN
	(
		SELECT TIIt.ExistingTinyInt
		,(ROW_NUMBER() OVER (ORDER BY TIIt.SortingRandomizer) - 1) AS NewTinyInt /* -1 since ROW_NUMBER starts at 1, and the identity started at 0 */
		FROM dataDeidentificationIdentifier.TinyIntIdentifier AS TIIt
	) AS NID ON NID.ExistingTinyInt = TII.ExistingTinyInt;

	DROP INDEX UQ_DataDeidentificationIdentifier_TinyIntIdentifier_NewTinyInt
		ON dataDeidentificationIdentifier.TinyIntIdentifier

	ALTER TABLE dataDeidentificationIdentifier.TinyIntIdentifier
	ALTER COLUMN NewTinyInt TINYINT NOT NULL;

	CREATE UNIQUE NONCLUSTERED INDEX UQ_DataDeidentificationIdentifier_TinyIntIdentifier_NewTinyInt
	ON dataDeidentificationIdentifier.TinyIntIdentifier (NewTinyInt ASC);

	ALTER TABLE dataDeidentificationIdentifier.TinyIntIdentifier
	DROP CONSTRAINT [TempTinyIntDefault];

	ALTER TABLE dataDeidentificationIdentifier.TinyIntIdentifier
	DROP COLUMN SortingRandomizer;
END;