CREATE PROCEDURE [dataDeidentificationIdentifier].[StoLoadTinyIntIdentifier]
(
	@MaxIdentifierValue TINYINT = 255
)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @CurrentTinyIntIdentifierMax TINYINT;

	SELECT @CurrentTinyIntIdentifierMax = MAX(TII.ExistingIdentifier)
	FROM dataDeidentificationIdentifier.TinyIntIdentifier AS TII;

	WHILE (COALESCE(@CurrentTinyIntIdentifierMax, 0) < @MaxIdentifierValue)
	BEGIN
		INSERT INTO dataDeidentificationIdentifier.TinyIntIdentifier
		(
			NewIdentifier
		)
		SELECT TOP(@MaxIdentifierValue - COALESCE(@CurrentTinyIntIdentifierMax, 0))
		0 AS NewIdentifier /* StoFinalizeTinyIntIdentifier will populate this with its offical value */
		FROM sys.objects AS O;

		SELECT @CurrentTinyIntIdentifierMax = MAX(TII.ExistingIdentifier)
		FROM dataDeidentificationIdentifier.TinyIntIdentifier AS TII;
	END;
END;
GO