<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
    <xsl:template match="/">
        <html>
            <head />
            <body>
                <xsl:apply-templates />
            </body>
        </html>
    </xsl:template>
    <xsl:template match="Address">
        <xsl:apply-templates />
    </xsl:template>
    <xsl:template match="Command">
        <xsl:apply-templates />
    </xsl:template>
    <xsl:template match="Destination">
        <xsl:for-each select="@protokol">
            <input value="">
                <xsl:attribute name="value"><xsl:value-of select="." /></xsl:attribute>
            </input>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="Email">
        <xsl:apply-templates />
    </xsl:template>
</xsl:stylesheet>
