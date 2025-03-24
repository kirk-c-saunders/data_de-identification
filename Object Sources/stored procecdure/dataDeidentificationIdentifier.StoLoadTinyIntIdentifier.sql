CREATE PROCEDURE [dataDeidentificationIdentifier].[StoLoadTinyIntIdentifier]
(
	@MaxTinyIntIdentifierValue TINYINT = 255
)
AS
BEGIN
	DECLARE @CurrentTinyIntIdentifierMax TINYINT;

	SELECT @CurrentTinyIntIdentifierMax = MAX(TII.ExistingTinyInt)
	FROM dataDeidentificationIdentifier.TinyIntIdentifier AS TII;

	WHILE (COALESCE(@CurrentTinyIntIdentifierMax, 0) < @MaxTinyIntIdentifierValue)
	BEGIN
		INSERT INTO dataDeidentificationIdentifier.TinyIntIdentifier
		(
			SortingRandomizer
		)
		SELECT TOP(@MaxTinyIntIdentifierValue - COALESCE(@CurrentTinyIntIdentifierMax, 0))
		NEWID() AS SortingRandomizer
		FROM sys.objects AS O;

		SELECT @CurrentTinyIntIdentifierMax = MAX(TII.ExistingTinyInt)
		FROM dataDeidentificationIdentifier.TinyIntIdentifier AS TII;
	END;
END;
GO