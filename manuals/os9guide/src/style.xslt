<?xml version="1.0"?>
<xsl:stylesheet
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:d="http://docbook.org/ns/docbook"
        xmlns:fo="http://www.w3.org/1999/XSL/Format"
        xmlns:xlink='http://www.w3.org/1999/xlink'
        exclude-result-prefixes="xlink d"
        version="1.0">

  <xsl:import href="urn:docbkx:stylesheet" />

  <xsl:param name="paper.type" select="'A4'"/>
  <xsl:param name="double.sided" select="1"/>
  <xsl:param name="chapter.autolabel" select="1"/>
  <xsl:param name="generate.toc" select="'book toc'"/>
  <xsl:param name="section.label.includes.component.label" select="'A'"/>
  <xsl:param name="refentry.pagebreak" select="0"/>
  <xsl:param name="section.autolabel" select="1"/>

  <xsl:attribute-set name="section.title.level1.properties">
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master * 1.728"/>
      <xsl:text>pt</xsl:text>
    </xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="section.title.level2.properties">
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master * 1.44"/>
      <xsl:text>pt</xsl:text>
    </xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="section.title.level3.properties">
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master * 1.2"/>
      <xsl:text>pt</xsl:text>
    </xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="refentry.title.properties">
    <xsl:attribute name="font-size">14pt</xsl:attribute>
  </xsl:attribute-set>

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

  <xsl:template match="d:refentry">
    <fo:block break-before='page'>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

</xsl:stylesheet>
