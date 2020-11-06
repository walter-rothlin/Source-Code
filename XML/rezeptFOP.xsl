<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
 	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
 	xmlns:fo="http://www.w3.org/1999/XSL/Format">
 	
	<xsl:template match="/">
		<fo:root>
			<fo:layout-master-set>
				<fo:simple-page-master master-name="erste" margin-right="1in"
														margin-left="1in"
														margin-top="1in"
														margin-bottom="1in"
														page-width="8.5in"
														page-height="11in"
														>
					<fo:region-body/>
				</fo:simple-page-master>
			</fo:layout-master-set>
			
			<fo:page-sequence master-reference="erste">
				<fo:flow flow-name="xsl-region-body">
					<xsl:apply-templates/>
				</fo:flow>
			</fo:page-sequence>
		</fo:root>
	</xsl:template>
	
	
	<xsl:template match="gericht|zutat|anweisungen|geschichte">
		<fo:block>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

</xsl:stylesheet>