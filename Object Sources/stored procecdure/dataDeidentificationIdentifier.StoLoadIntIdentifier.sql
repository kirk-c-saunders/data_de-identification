CREATE PROCEDURE [dataDeidentificationIdentifier].[StoLoadIntIdentifier]
(
	@MaxIdentifierValue INT = 2147483647
	,@MaxBatchSize INT = 100000
)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @CurrentIdentifierMax INT = 0;

	IF(@MaxIdentifierValue <= 0 OR @MaxIdentifierValue IS NULL)
	BEGIN
		RAISERROR('@MaxIdentifierValue must have a positive value', 16, 1);
	END;

	IF(@MaxBatchSize < 0 OR @MaxBatchSize IS NULL)
	BEGIN
		RAISERROR('@MaxBatchSize must have a positive value or have a value of 0', 16, 1);
	END;

	SELECT @CurrentIdentifierMax = MAX(II.ExistingIdentifier)
	FROM dataDeidentificationIdentifier.IntIdentifier AS II;

	IF(COALESCE(@CurrentIdentifierMax, 0) = 0)
	BEGIN
		INSERT INTO dataDeidentificationIdentifier.IntIdentifier
		(
			NewIdentifier
		)
		VALUES
		(
			0 /* StoFinalizeIntIdentifier will populate this with its offical value */
		);

		SET @CurrentIdentifierMax = 1;
	END;

	WHILE (@CurrentIdentifierMax < @MaxIdentifierValue)
	BEGIN
		IF((@MaxIdentifierValue - @CurrentIdentifierMax) > @MaxBatchSize AND @MaxBatchSize > 0)
		BEGIN
			INSERT INTO dataDeidentificationIdentifier.IntIdentifier
			(
				NewIdentifier
			)
			SELECT TOP(@MaxBatchSize)
			0 AS NewIdentifier /* StoFinalizeIntIdentifier will populate this with its offical value */
			FROM dataDeidentificationIdentifier.IntIdentifier;
		END;
		ELSE /* ((@MaxIntIdentifierValue - @CurrentIntIdentifierMax) <= @MaxBatchSize OR @MaxBatchSize = 0) */
		BEGIN
			INSERT INTO dataDeidentificationIdentifier.IntIdentifier
			(
				NewIdentifier
			)
			SELECT TOP(@MaxIdentifierValue - @CurrentIdentifierMax)
			0 AS NewIdentifier /* StoFinalizeIntIdentifier will populate this with its offical value */
			FROM dataDeidentificationIdentifier.IntIdentifier;
		END;

		SELECT @CurrentIdentifierMax = MAX(II.ExistingIdentifier)
		FROM dataDeidentificationIdentifier.IntIdentifier AS II;
	END;
END;