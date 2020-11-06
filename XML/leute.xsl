<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

   
   
   

	<xsl:template match="name">
	    <xsl:value-of select="name()"/>:<xsl:value-of select="nachname"/>,
		<xsl:value-of select="mittelinitial"/>
		<xsl:value-of select="vorname"/>
		Gestorben:<xsl:value-of select="../@gestorben"/>
	</xsl:template>

	<xsl:template match="person">
		<p><xsl:text>
		
            PERSON:		
		</xsl:text>
        <xsl:apply-templates select="name"/>
		Geboren:<xsl:value-of select="@geboren"/>
		<xsl:apply-templates/>   

		</p>
	</xsl:template>

	<xsl:template match="leute">
		<html>
			<head>
				<title>Berühmte Wissenschaftler</title>
			</head>
			<body><xsl:apply-templates select="person"/></body>
		</html>
	</xsl:template>

<!--

<xsl:template match="*|/">
      <xsl:apply-templates/>   
   </xsl:template>

<xsl:template match="/leute/person[2]">
        <p>Template matches:
		<xsl:value-of select="name/nachname"/>,
		<xsl:value-of select="name/mittelinitial"/>
		<xsl:value-of select="name/vorname"/>
		Gestorben:<xsl:value-of select="@gestorben"/>
		...template ended</p>
	</xsl:template>


  <xsl:template match="/">
      HEADER
      <xsl:apply-templates/>   
   </xsl:template>
   
   <xsl:template match="processing-instruction()|comment()">
          COMMENT found
   </xsl:template>
   
   <xsl:template match="text()|@*">
     
   </xsl:template>
-->

</xsl:stylesheet>
