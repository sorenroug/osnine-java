<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:import href="/usr/share/sgml/docbook/xsl-ns-stylesheets/fo/docbook.xsl"/>
<xsl:param name="paper.type" select="'A4'"/>
<xsl:param name="double.sided" select="1"/>
<xsl:param name="chapter.autolabel" select="1"/>
<xsl:param name="generate.toc" select="'book toc'"/>
<xsl:param name="variablelist.term.break.after" select="1"/>
<xsl:param name="variablelist.term.separator" select="''"/>
<!--
<xsl:param name="fop.extensions" select="1"/>
-->
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

</xsl:stylesheet>
