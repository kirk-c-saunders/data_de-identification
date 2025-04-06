CREATE PROCEDURE [dataDeidentificationIdentifier].[StoFinalizeIntIdentifier]
(
	@MaxBatchSize INT = 10000
)
AS
BEGIN
	SET NOCOUNT ON;
	
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
		INCLUDE (NewIdentifier)
		WHERE (NewIdentifier = 0)
		/* WITH (ONLINE = ON) - Add In if desired and able to */ ;
	END;

	SELECT @TableRowCount = MAX(II.ExistingIdentifier)
	FROM dataDeidentificationIdentifier.IntIdentifier AS II;

	SELECT @RowNumberModifier = @TableRowCount -
	(
		SELECT COUNT(*)
		FROM dataDeidentificationIdentifier.IntIdentifier AS II
		WHERE II.NewIdentifier = 0
	);

	IF(@MaxBatchSize > 0)
	BEGIN
		WHILE (@RowNumberModifier < @TableRowCount)
		BEGIN
			UPDATE II
			SET II.NewIdentifier = NID.NewIdentifier
			FROM dataDeidentificationIdentifier.IntIdentifier AS II
			JOIN
			(
				SELECT TOP(@MaxBatchSize) IIt.ExistingIdentifier
				,(ROW_NUMBER() OVER (ORDER BY IIt.SortingRandomizer ASC)) + @RowNumberModifier AS NewIdentifier
				FROM dataDeidentificationIdentifier.IntIdentifier IIt
				WHERE IIt.NewIdentifier = 0
				ORDER BY IIt.SortingRandomizer ASC
			) AS NID ON NID.ExistingIdentifier = II.ExistingIdentifier;

			SET @RowNumberModifier = @RowNumberModifier + @@ROWCOUNT;
		END;
	END;
	ELSE /* @MaxBatchSize = 0 */
	BEGIN
		UPDATE II
		SET II.NewIdentifier = NID.NewIdentifier
		FROM dataDeidentificationIdentifier.IntIdentifier II
		JOIN
		(
			SELECT TOP(@TableRowCount) IIt.ExistingIdentifier
			,(ROW_NUMBER() OVER (ORDER BY IIt.SortingRandomizer)) + @RowNumberModifier AS NewIdentifier
			FROM dataDeidentificationIdentifier.IntIdentifier IIt
			WHERE IIt.NewIdentifier = 0
		) AS NID ON NID.ExistingIdentifier = II.ExistingIdentifier;
	END;

	DROP INDEX IX_DataDeidentificationIdentifier_IntIdentifier_SortingRandomizer
	ON dataDeidentificationIdentifier.IntIdentifier

	ALTER INDEX UQ_DataDeidentificationIdentifier_IntIdentifier_NewIdentifier
	ON dataDeidentificationIdentifier.IntIdentifier REBUILD
	/* WITH (ONLINE = ON) - Add In if desired and able to */ ;

	ALTER TABLE dataDeidentificationIdentifier.IntIdentifier
	DROP CONSTRAINT TempIntDefault;

	ALTER TABLE dataDeidentificationIdentifier.IntIdentifier
	DROP COLUMN SortingRandomizer;
END;