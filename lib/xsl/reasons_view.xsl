<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "entities.dtd">
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" version="1.0" indent="yes" encoding="UTF-8" />
	
	
	<xsl:template match="reason_multy_select">
  	<xsl:variable name="pattern">
    	<xsl:value-of select="@pattern" />
  	</xsl:variable>
  	<xsl:variable name="order">
    	<xsl:value-of select="/order/id" />
  	</xsl:variable>

  	<xsl:variable name="isRequired">
    	<xsl:value-of select="'required' = @required" />
  	</xsl:variable>

  	<xsl:variable name="uid" select="generate-id(.)" />
  	<xsl:element name="span">
    	<xsl:attribute name="data-uid">
      	<xsl:value-of select="$uid" />
    	</xsl:attribute>
    	<xsl:choose>
      	<xsl:when test="@required">
        	<xsl:choose>
          	<xsl:when test="/order/reasons/reason/object[text() = $order]/../pattern[text() = $pattern]">
            <xsl:attribute name="class">meta-marker valid</xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">meta-marker invalid</xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="style">display: none;</xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
    &lowast;
  </xsl:element>
  <xsl:element name="a">
    <xsl:attribute name="id">
      <xsl:value-of select="$uid" />
    </xsl:attribute>
    <xsl:attribute name="data-reason">
      <xsl:value-of select="$uid" />
    </xsl:attribute>

    <xsl:choose>
      <xsl:when test="/order/reasons/reason/object[text() = $order]/../pattern[text() = $pattern]">
        <xsl:attribute name="data-reason-text">
          <xsl:value-of select="/order/metas/meta/object[text() = $order]/../pattern[text() = $pattern]/../value" />
        </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="data-reason-id"></xsl:attribute>
        <xsl:attribute name="data-reason-text"></xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>


    <xsl:attribute name="data-reason-order">
      <xsl:value-of select="/order/id" />
    </xsl:attribute>
    <xsl:attribute name="data-reason-pattern">
      <xsl:value-of select="$pattern" />
    </xsl:attribute>
    <xsl:attribute name="data-reason-options">
      <xsl:value-of select="@options" />
    </xsl:attribute>
    <xsl:attribute name="data-reason-options-text">
      <xsl:value-of select="@options-text" />
    </xsl:attribute>
    <xsl:attribute name="data-required">
      <xsl:value-of select="$isRequired" />
    </xsl:attribute>
    <xsl:attribute name="data-multiple">true</xsl:attribute>

    <xsl:attribute name="class">order-reason</xsl:attribute>
    <xsl:attribute name="data-toggle">popover</xsl:attribute>
    <xsl:attribute name="data-placement">top</xsl:attribute>
    <xsl:attribute name="data-original-title">
      <xsl:value-of select="@title" />
    </xsl:attribute>
  </xsl:element>
  <xsl:element name="script">
    <xsl:attribute name="type">text/javascript</xsl:attribute>
    $(function() {
      initOrderReasonMultySelect('<xsl:value-of select="$uid" />');
    });
  </xsl:element>
</xsl:template>

</xsl:stylesheet>