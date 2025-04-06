CREATE PROCEDURE [dataDeidentificationIdentifier].[StoLoadBigIntIdentifier]
(
	@MaxIdentifierValue BIGINT = 9223372036854775807
	,@MaxBatchSize INT = 100000
)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @CurrentIdentifierMax BIGINT = 0;

	IF(@MaxIdentifierValue <= 0 OR @MaxIdentifierValue IS NULL)
	BEGIN
		RAISERROR('@MaxIdentifierValue must have a positive value', 16, 1);
	END;

	IF(@MaxBatchSize < 0 OR @MaxBatchSize IS NULL)
	BEGIN
		RAISERROR('@MaxBatchSize must have a positive value or have a value of 0', 16, 1);
	END;

	SELECT @CurrentIdentifierMax = MAX(BII.ExistingIdentifier)
	FROM dataDeidentificationIdentifier.BigIntIdentifier AS BII;

	IF(COALESCE(@CurrentIdentifierMax, 0) = 0)
	BEGIN
		INSERT INTO dataDeidentificationIdentifier.BigIntIdentifier
		(
			NewIdentifier
		)
		VALUES
		(
			0 /* StoFinalizeBigIntIdentifier will populate this with its offical value */
		);

		SET @CurrentIdentifierMax = 1;
	END;

	WHILE (@CurrentIdentifierMax < @MaxIdentifierValue)
	BEGIN
		IF((@MaxIdentifierValue - @CurrentIdentifierMax) > @MaxBatchSize AND @MaxBatchSize > 0)
		BEGIN
			INSERT INTO dataDeidentificationIdentifier.BigIntIdentifier
			(
				NewIdentifier
			)
			SELECT TOP(@MaxBatchSize)
			0 AS NewIdentifier /* StoFinalizeBigIntIdentifier will populate this with its offical value */
			FROM dataDeidentificationIdentifier.BigIntIdentifier;
		END;
		ELSE /* ((@MaxIntIdentifierValue - @CurrentIntIdentifierMax) <= @MaxBatchSize OR @MaxBatchSize = 0) */
		BEGIN
			INSERT INTO dataDeidentificationIdentifier.BigIntIdentifier
			(
				NewIdentifier
			)
			SELECT TOP(@MaxIdentifierValue - @CurrentIdentifierMax)
			0 AS NewIdentifier /* StoFinalizeBigIntIdentifier will populate this with its offical value */
			FROM dataDeidentificationIdentifier.BigIntIdentifier;
		END;

		SELECT @CurrentIdentifierMax = MAX(BII.ExistingIdentifier)
		FROM dataDeidentificationIdentifier.BigIntIdentifier AS BII;
	END;
END;