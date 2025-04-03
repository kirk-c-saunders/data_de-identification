CREATE PROCEDURE [dataDeidentificationIdentifier].[StoLoadSmallIntIdentifier]
(
	@MaxSmallIntIdentifierValue SMALLINT = 32767
)
AS
BEGIN	
	DECLARE @CurrentSmallIntIdentifierMax SMALLINT = 0;

	IF(@MaxSmallIntIdentifierValue <= 0 OR @MaxSmallIntIdentifierValue IS NULL)
	BEGIN
		RAISERROR('@MaxSmallIntIdentifierValue must have a positive value', 16, 1);
	END;

	SELECT @CurrentSmallIntIdentifierMax = MAX(SII.ExistingSmallInt)
	FROM dataDeidentificationIdentifier.SmallIntIdentifier AS SII;

	IF(COALESCE(@CurrentSmallIntIdentifierMax, 0) = 0)
	BEGIN
		INSERT INTO dataDeidentificationIdentifier.SmallIntIdentifier
		(
			SortingRandomizer
		)
		VALUES
		(
			NEWID()
		);

		SET @CurrentSmallIntIdentifierMax = 1;
	END;

	WHILE (@CurrentSmallIntIdentifierMax < @MaxSmallIntIdentifierValue)
	BEGIN
		INSERT INTO dataDeidentificationIdentifier.SmallIntIdentifier
		(
			SortingRandomizer
		)
		SELECT TOP(@MaxSmallIntIdentifierValue - @CurrentSmallIntIdentifierMax)
		NEWID() AS SortingRandomizer
		FROM dataDeidentificationIdentifier.SmallIntIdentifier;

		SELECT @CurrentSmallIntIdentifierMax = MAX(SII.ExistingSmallInt)
		FROM dataDeidentificationIdentifier.SmallIntIdentifier AS SII;
	END;
END;