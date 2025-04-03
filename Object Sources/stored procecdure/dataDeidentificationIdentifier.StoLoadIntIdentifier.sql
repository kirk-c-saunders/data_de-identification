CREATE PROCEDURE [dataDeidentificationIdentifier].[StoLoadIntIdentifier]
(
	@MaxIntIdentifierValue INT = 2147483647
	,@MaxBatchSize INT = 100000
)
AS
BEGIN
	DECLARE @CurrentIntIdentifierMax INT = 0;

	IF(@MaxIntIdentifierValue <= 0 OR @MaxIntIdentifierValue IS NULL)
	BEGIN
		RAISERROR('@MaxSmallIntIdentifierValue must have a positive value', 16, 1);
	END;

	IF(@MaxBatchSize <= 0 OR @MaxBatchSize IS NULL)
	BEGIN
		RAISERROR('@MaxBatchSize must have a positive value or have a value of 0', 16, 1);
	END;

	SELECT @CurrentIntIdentifierMax = MAX(II.ExistingInt)
	FROM dataDeidentificationIdentifier.IntIdentifier AS II;

	IF(COALESCE(@CurrentIntIdentifierMax, 0) = 0)
	BEGIN
		INSERT INTO dataDeidentificationIdentifier.IntIdentifier
		(
			SortingRandomizer
		)
		VALUES
		(
			NEWID()
		);

		SET @CurrentIntIdentifierMax = 1;
	END;

	WHILE (@CurrentIntIdentifierMax < @MaxIntIdentifierValue)
	BEGIN
		IF((@MaxIntIdentifierValue - @CurrentIntIdentifierMax) > @MaxBatchSize AND @MaxBatchSize > 0)
		BEGIN
			INSERT INTO dataDeidentificationIdentifier.IntIdentifier
			(
				SortingRandomizer
			)
			SELECT TOP(@MaxBatchSize)
			NEWID() AS SortingRandomizer
			FROM dataDeidentificationIdentifier.IntIdentifier;
		END;
		ELSE /* ((@MaxIntIdentifierValue - @CurrentIntIdentifierMax) <= @MaxBatchSize OR @MaxBatchSize = 0) */
		BEGIN
			INSERT INTO dataDeidentificationIdentifier.IntIdentifier
			(
				SortingRandomizer
			)
			SELECT TOP(@MaxIntIdentifierValue - @CurrentIntIdentifierMax)
			NEWID() AS SortingRandomizer
			FROM dataDeidentificationIdentifier.IntIdentifier;
		END;

		SELECT @CurrentIntIdentifierMax = MAX(II.ExistingInt)
		FROM dataDeidentificationIdentifier.IntIdentifier AS II;
	END;
END;