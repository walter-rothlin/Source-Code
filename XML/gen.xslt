<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:n1="x-schema:Y:\Data\SourceCode\XML\people.xdr">
	<xsl:template match="/">
		<html>
			<head/>
			<body>
				<xsl:apply-templates/>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="n1:name">
		<xsl:apply-templates/>
	</xsl:template>
</xsl:stylesheet>
