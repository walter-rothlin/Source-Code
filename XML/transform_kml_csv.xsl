<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:kml="http://www.opengis.net/kml/2.2" version="1.0">
<xsl:template match="/">
id|name|description|coordinates|
<xsl:for-each select="/kml:kml/kml:Document/kml:Placemark">
<xsl:sort select="kml:name"  data-type="number"/>
<!-- 
     <xsl:value-of select="@id"/>
     <xsl:value-of select="kml:name"/>
     <xsl:value-of select="kml:description"/>
     <xsl:value-of select="kml:Style/kml:IconStyle/kml:Icon/kml:href"/>
     <xsl:value-of select="kml:Style/kml:LabelStyle/kml:color"/>
     <xsl:value-of select="kml:Point/kml:coordinates"/>
-->
<xsl:value-of select="@id"/>|<xsl:value-of select="kml:name"/>|<xsl:value-of select="kml:description"/>|<xsl:value-of select="kml:Point/kml:coordinates"/>|
</xsl:for-each>
</xsl:template>
</xsl:transform>