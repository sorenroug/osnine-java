<?xml version='1.0'?>
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
  <xsl:param name="toc.section.depth" select="5"/>

<xsl:attribute-set name="toc.line.properties">
  <xsl:attribute name="font-weight">
   <xsl:choose>
    <xsl:when test="self::chapter | self::preface | self::appendix">bold</xsl:when>
    <xsl:otherwise>normal</xsl:otherwise>
   </xsl:choose>
  </xsl:attribute>
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

<xsl:template match="d:phrase">
  <xsl:choose>
    <xsl:when test="@role='extension'">
      <xsl:call-template name="inline.extension"/>
    </xsl:when>
    <xsl:otherwise>
      <fo:inline>
        <xsl:call-template name="anchor"/>
        <xsl:call-template name="inline.charseq"/>
      </fo:inline>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="inline.extension">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>

  <xsl:param name="contentwithlink">
    <xsl:call-template name="simple.xlink">
      <xsl:with-param name="content" select="$content"/>
    </xsl:call-template>
  </xsl:param>

  <fo:inline background-color="#c0c0c0">
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


</xsl:stylesheet>
