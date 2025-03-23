CREATE FUNCTION [dataDeidentification].[fnUserNameProvidedEmail]
(
	@UserName VARCHAR(100)
	,@EmailAddressDomain VARCHAR(100) = '@YourOrTheAppropriateEmailDomain.com'
)
RETURNS TABLE
AS
RETURN
	SELECT 
	CONCAT
	(
		@UserName
		,IIF(CHARINDEX('@', @EmailAddressDomain, 1) = 0, '@', '')
		,@EmailAddressDomain
	) AS EmailAddress;
GO