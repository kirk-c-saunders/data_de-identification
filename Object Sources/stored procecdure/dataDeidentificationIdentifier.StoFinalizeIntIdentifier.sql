CREATE PROCEDURE [dataDeidentificationIdentifier].[StoFinalizeIntIdentifier]
(
	@MaxBatchSize INT = 100000
)
AS
BEGIN
	DECLARE @RowNumberModifier INT = 0
			,@TableRowCount INT;

	IF(@MaxBatchSize <= 0 OR @MaxBatchSize IS NULL)
	BEGIN
		RAISERROR('@MaxBatchSize must have a positive value or have a value of 0', 16, 1);
	END;

	IF NOT EXISTS
	(
		SELECT 1
		FROM sys.indexes AS I
		WHERE I.name='IX_DataDeidentificationIdentifier_IntIdentifier_SortingRandomizer'
		AND I.object_id = OBJECT_ID('dataDeidentificationIdentifier.IntIdentifier')
	)
	BEGIN
		CREATE NONCLUSTERED INDEX IX_DataDeidentificationIdentifier_IntIdentifier_SortingRandomizer
		ON dataDeidentificationIdentifier.IntIdentifier (SortingRandomizer)
		INCLUDE (NewInt)
		WHERE (NewInt) IS NULL
		/* WITH (ONLINE = ON) - Add In if desired and able to */ ;
	END;

	SELECT @TableRowCount = MAX(II.ExistingInt)
	FROM dataDeidentificationIdentifier.IntIdentifier AS II;

	SELECT @RowNumberModifier = @TableRowCount -
	(
		SELECT COUNT(*)
		FROM dataDeidentificationIdentifier.IntIdentifier AS II
		WHERE II.NewInt IS NULL
	);

	IF(@MaxBatchSize > 0)
	BEGIN
		WHILE (@RowNumberModifier < @TableRowCount)
		BEGIN
			UPDATE II
			SET II.NewInt = NID.NewInt
			FROM dataDeidentificationIdentifier.IntIdentifier II
			JOIN
			(
				SELECT TOP(@MaxBatchSize) IIt.ExistingInt
				,(ROW_NUMBER() OVER (ORDER BY IIt.SortingRandomizer ASC)) + @RowNumberModifier AS NewInt
				FROM dataDeidentificationIdentifier.IntIdentifier IIt
				WHERE IIt.NewInt IS NULL
				ORDER BY IIt.SortingRandomizer ASC
			) AS NID ON NID.ExistingInt = II.ExistingInt;

			SET @RowNumberModifier = @RowNumberModifier + @@ROWCOUNT;
		END;
	END;
	ELSE /* @MaxBatchSize = 0 */
	BEGIN
		UPDATE II
		SET II.NewInt = NID.NewInt
		FROM dataDeidentificationIdentifier.IntIdentifier II
		JOIN
		(
			SELECT TOP(@MaxBatchSize) IIt.ExistingInt
			,(ROW_NUMBER() OVER (ORDER BY IIt.SortingRandomizer)) + @RowNumberModifier AS NewInt
			FROM dataDeidentificationIdentifier.IntIdentifier IIt
			WHERE IIt.NewInt IS NULL
		) AS NID ON NID.ExistingInt = II.ExistingInt;
	END;

	DROP INDEX UQ_DataDeidentificationIdentifier_IntIdentifier_NewInt
	ON dataDeidentificationIdentifier.IntIdentifier;

	DROP INDEX IX_DataDeidentificationIdentifier_IntIdentifier_SortingRandomizer
	ON dataDeidentificationIdentifier.IntIdentifier

	ALTER TABLE dataDeidentificationIdentifier.IntIdentifier
	ALTER COLUMN NewInt INT NOT NULL;

	CREATE UNIQUE NONCLUSTERED INDEX [UQ_DataDeidentificationIdentifier_IntIdentifier_NewInt]
	ON [dataDeidentificationIdentifier].[IntIdentifier] ([NewInt] ASC)
	/* WITH (ONLINE = ON) - Add In if desired and able to */ ;

	ALTER TABLE dataDeidentificationIdentifier.IntIdentifier
	DROP CONSTRAINT TempIntDefault;

	ALTER TABLE dataDeidentificationIdentifier.IntIdentifier
	DROP COLUMN SortingRandomizer;
END;