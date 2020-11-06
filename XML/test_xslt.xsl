<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="employee">
		<p>
			<xsl:value-of select="firstName[@home='Peterliwiese']"/>
		</p>
	</xsl:template>
</xsl:stylesheet>
