<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" />
<xsl:output method="html" />

	<xsl:template match="people">
      <html>
		<head>
			<title>Waltis Phonebook</title>
			<link rel="stylesheet" href="FirstCssEaxmple.css" />
		</head>
		<body>
		   <h1>Waltis Phonebook (2)</h1>
		   <xsl:apply-templates />
		</body>
	</html>
	</xsl:template>
	
	<xsl:template match="person">
	     Position: <xsl:value-of select="position()"/><xsl:text>    </xsl:text>

	        <xsl:apply-templates select="phone"/>
	        <br />
	</xsl:template>
	
	<xsl:template match="name">
	        <xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="pet">
	        <xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="phone">
	       <xsl:value-of select="position()"/><xsl:text>    </xsl:text>
	        <xsl:value-of select="text()"/>
	</xsl:template>



</xsl:stylesheet>
