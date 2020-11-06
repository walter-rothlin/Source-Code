<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns="http://www.w3.org/TR/xhtml1/strict">

  <xsl:template match="/">
     <HTML><HEAD><TITLE>Test Walti</TITLE></HEAD><BODY><xsl:apply-templates/><BR/>Fertig</BODY></HTML>
  </xsl:template>
  	
  <xsl:template match="*">
     Unknown Tag:<xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="book">
     Book:<xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="title">
     <H1><xsl:apply-templates/></H1>
  </xsl:template>
  
  <xsl:template match="author">
     <H2><xsl:apply-templates/></H2>
  </xsl:template>
  
  <xsl:template match="author/name">
     <H2>Autor:<xsl:apply-templates/></H2>
  </xsl:template>
  
  <xsl:template match="name">
     <text>Sonstiger Name:</text><xsl:apply-templates/>    <!-- boilerplate text -->
  </xsl:template>
  
  <xsl:template match="publisher">
     <P><I><xsl:apply-templates/></I></P>
  </xsl:template>
  
</xsl:stylesheet>