<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html" />

	<xsl:template match="people">
      <html>
		<head>
			<title>Waltis Phonebook</title>
			<link rel="stylesheet" href="FirstCssEaxmple.css" />
		</head>
		<body>
		   <h1>Waltis Phonebook</h1>
		   <table border="2" cellpadding="5" cellspacing="0">
		   <xsl:apply-templates/>
		   </table>
		</body>
	</html>
	</xsl:template>
	
	<xsl:template match="person">
	        <tr>
	        <xsl:apply-templates/>
		</tr>
	</xsl:template>
	
	<xsl:template match="name">
	        <td>
	        <xsl:apply-templates/>
		</td>
	</xsl:template>
	
		<xsl:template match="pet">
	        <td>
	        <xsl:apply-templates/>
		</td>
	</xsl:template>


</xsl:stylesheet>
