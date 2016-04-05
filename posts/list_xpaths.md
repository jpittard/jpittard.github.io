Listing all XPaths in a document
================================

```xsl
<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
 	xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	version="1.0">
  <xsl:output indent="no" method="text" />
  
  <xsl:template match="/">
  	<!-- Don't ask me why, but I have to put a condition on '*' to get it to select anything -->
      <xsl:apply-templates select="*[.]"/>
  </xsl:template>

  <!-- Print the XPath for elements and their attributes -->
  <xsl:template match="node()">
	<xsl:if test="not(namespace-uri()='urn:us:mil:ces:metadata:ddms:5') and not(namespace-uri()='urn:us:mil:ces:metadata:domex')">
		  <!-- Skip printing elements that do not take values -->
		<xsl:if test="not(*)">
			<xsl:apply-templates select="." mode="getXPath"/>
		</xsl:if>
		<xsl:apply-templates select="@*"/>
		<xsl:apply-templates select="*"/>
	</xsl:if>
  </xsl:template>

  <!-- Print the XPath for attributes -->
  <xsl:template match="@*">
	<xsl:apply-templates select="." mode="getXPath"/>
	<xsl:text>/@</xsl:text>
	<xsl:value-of select="name(.)"/>
  </xsl:template>

  <!-- Print the XPath hierarchical path for any node -->
  <xsl:template match="node() | @*" mode="getXPath">
	<xsl:text>
</xsl:text>
    <xsl:for-each select="ancestor-or-self::*">
      <xsl:text>/</xsl:text>
      <xsl:value-of select="name(.)"/>
    </xsl:for-each>
  </xsl:template>
  
</xsl:transform>
```
