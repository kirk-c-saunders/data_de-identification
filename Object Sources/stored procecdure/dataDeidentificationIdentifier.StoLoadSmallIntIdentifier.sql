CREATE PROCEDURE [dataDeidentificationIdentifier].[StoLoadSmallIntIdentifier]
(
	@MaxIdentifierValue SMALLINT = 32767
)
AS
BEGIN	
	SET NOCOUNT ON;
	
	DECLARE @CurrentIdentifierMax SMALLINT = 0;

	IF(@MaxIdentifierValue <= 0 OR @MaxIdentifierValue IS NULL)
	BEGIN
		RAISERROR('@MaxIdentifierValue must have a positive value', 16, 1);
	END;

	SELECT @CurrentIdentifierMax = MAX(SII.ExistingIdentifier)
	FROM dataDeidentificationIdentifier.SmallIntIdentifier AS SII;

	IF(COALESCE(@CurrentIdentifierMax, 0) = 0)
	BEGIN
		INSERT INTO dataDeidentificationIdentifier.SmallIntIdentifier
		(
			NewIdentifier
		)
		VALUES
		(
			0 /* StoFinalizeSmallIntIdentifier will populate this with its offical value */
		);

		SET @CurrentIdentifierMax = 1;
	END;

	WHILE (@CurrentIdentifierMax < @MaxIdentifierValue)
	BEGIN
		INSERT INTO dataDeidentificationIdentifier.SmallIntIdentifier
		(
			NewIdentifier
		)
		SELECT TOP(@MaxIdentifierValue - @CurrentIdentifierMax)
		0 AS NewIdentifier /* StoFinalizeSmallIntIdentifier will populate this with its offical value */
		FROM dataDeidentificationIdentifier.SmallIntIdentifier;

		SELECT @CurrentIdentifierMax = MAX(SII.ExistingIdentifier)
		FROM dataDeidentificationIdentifier.SmallIntIdentifier AS SII;
	END;
END;