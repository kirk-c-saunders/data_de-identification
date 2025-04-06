CREATE PROCEDURE [dataDeidentificationIdentifier].[StoFinalizeBigIntIdentifier]
(
	@MaxBatchSize INT = 10000
)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @RowNumberModifier BIGINT = 0
			,@TableRowCount BIGINT;

	IF(@MaxBatchSize <= 0 OR @MaxBatchSize IS NULL)
	BEGIN
		RAISERROR('@MaxBatchSize must have a positive value or have a value of 0', 16, 1);
	END;

	IF NOT EXISTS
	(
		SELECT 1
		FROM sys.indexes AS I
		WHERE I.name='IX_DataDeidentificationIdentifier_BigIntIdentifier_SortingRandomizer'
		AND I.object_id = OBJECT_ID('dataDeidentificationIdentifier.BigIntIdentifier')
	)
	BEGIN
		CREATE NONCLUSTERED INDEX IX_DataDeidentificationIdentifier_BigIntIdentifier_SortingRandomizer
		ON dataDeidentificationIdentifier.BigIntIdentifier (SortingRandomizer)
		INCLUDE (NewIdentifier)
		WHERE (NewIdentifier = 0)
		/* WITH (ONLINE = ON) - Add In if desired and able to */ ;
	END;

	SELECT @TableRowCount = MAX(BII.ExistingIdentifier)
	FROM dataDeidentificationIdentifier.BigIntIdentifier AS BII;

	SELECT @RowNumberModifier = @TableRowCount -
	(
		SELECT COUNT(*)
		FROM dataDeidentificationIdentifier.BigIntIdentifier AS BII
		WHERE BII.NewIdentifier = 0
	);

	IF(@MaxBatchSize > 0)
	BEGIN
		WHILE (@RowNumberModifier < @TableRowCount)
		BEGIN
			UPDATE BII
			SET NewIdentifier = NID.NewIdentifier
			FROM dataDeidentificationIdentifier.BigIntIdentifier AS BII
			JOIN
			(
				SELECT TOP(@MaxBatchSize) BIIt.ExistingIdentifier
				,(ROW_NUMBER() OVER (ORDER BY BIIt.SortingRandomizer ASC)) + @RowNumberModifier AS NewIdentifier
				FROM dataDeidentificationIdentifier.BigIntIdentifier AS BIIt
				WHERE BIIt.NewIdentifier = 0
				ORDER BY BIIt.SortingRandomizer ASC
			) AS NID ON NID.ExistingIdentifier = BII.ExistingIdentifier;

			SET @RowNumberModifier = @RowNumberModifier + @@ROWCOUNT;
		END;
	END;
	ELSE /* @MaxBatchSize = 0 */
	BEGIN
		UPDATE BII
		SET NewIdentifier = NID.NewIdentifier
		FROM dataDeidentificationIdentifier.BigIntIdentifier AS BII
		JOIN
		(
			SELECT TOP(@TableRowCount) BIIt.ExistingIdentifier
			,(ROW_NUMBER() OVER (ORDER BY BIIt.SortingRandomizer ASC)) + @RowNumberModifier AS NewIdentifier
			FROM dataDeidentificationIdentifier.BigIntIdentifier AS BIIt
			WHERE BIIt.NewIdentifier = 0
			ORDER BY BIIt.SortingRandomizer ASC
		) AS NID ON NID.ExistingIdentifier = BII.ExistingIdentifier;
	END;

	DROP INDEX IX_DataDeidentificationIdentifier_BigIntIdentifier_SortingRandomizer
	ON dataDeidentificationIdentifier.BigIntIdentifier;

	ALTER INDEX UQ_DataDeidentificationIdentifier_BigIntIdentifier_NewIdentifier
	ON dataDeidentificationIdentifier.BigIntIdentifier REBUILD
	/* WITH (ONLINE = ON) - Add In if desired and able to */ ;

	ALTER TABLE dataDeidentificationIdentifier.BigIntIdentifier
	DROP CONSTRAINT TempBigIntDefault;

	ALTER TABLE dataDeidentificationIdentifier.BigIntIdentifier
	DROP COLUMN SortingRandomizer;
END;