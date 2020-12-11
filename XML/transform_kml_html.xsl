<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:kml="http://www.opengis.net/kml/2.2" version="1.0">

    <xsl:template match="/">
        <html>
            <body>
                <h1>Bachtellen</h1>
                <table>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Description</th>
                        <th>Coordinates</th>
                    </tr>
                    <xsl:for-each select="/kml:kml/kml:Document/kml:Placemark">
                        <tr>
                            <td>
                                <xsl:value-of select="@id"/>
                            </td>
                            <td>
                                <xsl:value-of select="kml:name"/>
                            </td>
                            <td>
                                <xsl:value-of select="kml:description"/>
                            </td>
                            <td>
                                <xsl:value-of select="kml:Point/kml:coordinates"/>
                            </td>
                        </tr>
                    </xsl:for-each>
                </table>
            </body>
        </html>
    </xsl:template>

</xsl:transform>