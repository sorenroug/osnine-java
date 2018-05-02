<?xml version='1.0'?>
<xsl:stylesheet
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:d="http://docbook.org/ns/docbook"
        xmlns:fo="http://www.w3.org/1999/XSL/Format"
        xmlns:xlink='http://www.w3.org/1999/xlink'
        exclude-result-prefixes="xlink d"
        version="1.0">

<xsl:import href="/usr/share/sgml/docbook/xsl-ns-stylesheets/fo/docbook.xsl"/>

<xsl:param name="paper.type" select="'A4'"/>
<xsl:param name="double.sided" select="1"/>
<xsl:param name="chapter.autolabel" select="0"/>
<xsl:param name="generate.toc" select="'book toc'"/>

<!--
<xsl:template match="d:replaceable">
  <xsl:text>&lt;</xsl:text><xsl:call-template name="inline.italicmonoseq"/><xsl:text>&gt;</xsl:text>
</xsl:template>
-->

<xsl:template name="inline.keycapseq">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>

  <xsl:param name="contentwithlink">
    <xsl:call-template name="simple.xlink">
      <xsl:with-param name="content" select="$content"/>
    </xsl:call-template>
  </xsl:param>

  <fo:inline font-size=".85em" border-style="outset" border-width="1pt" padding-top=".1em">
    <xsl:if test="@dir">
      <xsl:attribute name="direction">
        <xsl:choose>
          <xsl:when test="@dir = 'ltr' or @dir = 'lro'">ltr</xsl:when>
          <xsl:otherwise>rtl</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </xsl:if>
    <xsl:copy-of select="$contentwithlink"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:keycap">
  <xsl:call-template name="inline.keycapseq"/>
</xsl:template>


</xsl:stylesheet>
