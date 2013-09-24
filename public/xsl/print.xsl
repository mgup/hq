<?xml version="1.0" encoding="iso-8859-1"?>

<xsl:stylesheet version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Page layout information -->

  <xsl:template match="/">
    <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">

      <fo:layout-master-set>
        <fo:simple-page-master master-name="main" page-height="29.7cm" page-width="21cm" font-family="sans-serif" margin-top="0.5cm" margin-bottom="1cm" margin-left="2cm" margin-right="2cm">
          <fo:region-body margin-top="4.0cm" margin-bottom="1cm" />
          <fo:region-before extent="1.5cm" />
        </fo:simple-page-master>
      </fo:layout-master-set>

      <fo:page-sequence master-reference="main">
        <fo:flow flow-name="xsl-region-body" >
          <xsl:apply-templates select="persons/person" />
        </fo:flow>
      </fo:page-sequence>

    </fo:root>

  </xsl:template>

  <xsl:template match="persons/person">

    <fo:block>
      Hello <xsl:value-of select="name" />
    </fo:block>

  </xsl:template>

</xsl:stylesheet>