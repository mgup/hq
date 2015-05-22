<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "entities.dtd">
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" version="1.0" indent="yes" encoding="UTF-8" />

  <xsl:template match="meta_academic_year">
    <xsl:variable name="uid" select="generate-id(.)" />
    <xsl:variable name="isRequired">
      <xsl:value-of select="'required' = @required" />
    </xsl:variable>
    <xsl:element name="span">
      <xsl:attribute name="class">meta-marker valid</xsl:attribute>
      &lowast;
    </xsl:element>
    <xsl:element name="a">
      <xsl:attribute name="id">
        <xsl:value-of select="$uid" />
      </xsl:attribute>
      <xsl:attribute name="data-meta">
        <xsl:value-of select="$uid" />
      </xsl:attribute>

      <xsl:choose>
        <xsl:when test="/order/metas/meta/pattern[text() = 'Учебный год']">
          <xsl:attribute name="data-meta-id">
            <xsl:value-of select="/order/metas/meta/pattern[text() = 'Учебный год']/../id" />
          </xsl:attribute>
          <xsl:attribute name="data-meta-text">
            <xsl:value-of select="/order/metas/meta/pattern[text() = 'Учебный год']/../value" />
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="data-meta-id"></xsl:attribute>
          <xsl:attribute name="data-meta-text"></xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>


      <xsl:attribute name="data-meta-order">
        <xsl:value-of select="/order/id" />
      </xsl:attribute>
      <xsl:attribute name="data-meta-type">0</xsl:attribute>
      <xsl:attribute name="data-meta-object">
        <xsl:value-of select="/order/id" />
      </xsl:attribute>
      <xsl:attribute name="data-required">
        <xsl:value-of select="$isRequired" />
      </xsl:attribute>
      <xsl:attribute name="data-meta-pattern">Учебный год</xsl:attribute>

      <xsl:attribute name="class">order-meta nowrap</xsl:attribute>
      <xsl:attribute name="data-toggle">popover</xsl:attribute>
      <xsl:attribute name="data-placement">top</xsl:attribute>
      <xsl:attribute name="data-original-title">Выберите учебный год</xsl:attribute>
    </xsl:element>
    <xsl:element name="script">
      <xsl:attribute name="type">text/javascript</xsl:attribute>
      $(function() {
      initOrderMetaAcademicYear('<xsl:value-of select="$uid" />');
      });
    </xsl:element>
  </xsl:template>

  <xsl:template match="meta_text_student">
    <xsl:variable name="pattern">
      <xsl:value-of select="@pattern" />
    </xsl:variable>

    <xsl:variable name="student">
      <xsl:value-of select="@student" />
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
            <xsl:when test="/order/metas/meta/object[text() = $student]/../pattern[text() = $pattern]">
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
      <xsl:attribute name="data-meta">
        <xsl:value-of select="$uid" />
      </xsl:attribute>

      <xsl:choose>
        <xsl:when test="/order/metas/meta/object[text() = $student]/../pattern[text() = $pattern]">
          <xsl:attribute name="data-meta-id">
            <xsl:value-of select="/order/metas/meta/object[text() = $student]/../pattern[text() = $pattern]/../id" />
          </xsl:attribute>
          <xsl:attribute name="data-meta-text">
            <xsl:value-of select="/order/metas/meta/object[text() = $student]/../pattern[text() = $pattern]/../value" />
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="data-meta-id"></xsl:attribute>
          <xsl:attribute name="data-meta-text"></xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>


      <xsl:attribute name="data-meta-order">
        <xsl:value-of select="/order/id" />
      </xsl:attribute>
      <xsl:attribute name="data-meta-type">2</xsl:attribute>
      <xsl:attribute name="data-meta-object">
        <xsl:value-of select="$student" />
      </xsl:attribute>
      <xsl:attribute name="data-meta-pattern">
        <xsl:value-of select="$pattern" />
      </xsl:attribute>
      <xsl:attribute name="data-required">
        <xsl:value-of select="$isRequired" />
      </xsl:attribute>

      <xsl:attribute name="class">order-meta</xsl:attribute>
      <xsl:attribute name="data-toggle">popover</xsl:attribute>
      <xsl:attribute name="data-placement">top</xsl:attribute>
      <xsl:attribute name="data-original-title">
        <xsl:value-of select="@title" />
      </xsl:attribute>
    </xsl:element>
    <xsl:element name="script">
      <xsl:attribute name="type">text/javascript</xsl:attribute>
      $(function() {
      initOrderMetaTextStudent('<xsl:value-of select="$uid" />');
      });
    </xsl:element>
  </xsl:template>

  <xsl:template match="meta_employee_student">
    <xsl:variable name="pattern">
      <xsl:value-of select="@pattern" />
    </xsl:variable>

    <xsl:variable name="student">
      <xsl:value-of select="@student" />
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
            <xsl:when test="/order/metas/meta/object[text() = $student]/../pattern[text() = $pattern]">
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
      <xsl:attribute name="data-meta">
        <xsl:value-of select="$uid" />
      </xsl:attribute>

      <xsl:choose>
        <xsl:when test="/order/metas/meta/object[text() = $student]/../pattern[text() = $pattern]">
          <xsl:attribute name="data-meta-id">
            <xsl:value-of select="/order/metas/meta/object[text() = $student]/../pattern[text() = $pattern]/../id" />
          </xsl:attribute>
          <xsl:attribute name="data-meta-text">
            <xsl:value-of select="/order/metas/meta/object[text() = $student]/../pattern[text() = $pattern]/../value" />
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="data-meta-id"></xsl:attribute>
          <xsl:attribute name="data-meta-text"></xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>


      <xsl:attribute name="data-meta-order">
        <xsl:value-of select="/order/id" />
      </xsl:attribute>
      <xsl:attribute name="data-meta-type">2</xsl:attribute>
      <xsl:attribute name="data-meta-object">
        <xsl:value-of select="$student" />
      </xsl:attribute>
      <xsl:attribute name="data-meta-pattern">
        <xsl:value-of select="$pattern" />
      </xsl:attribute>
      <xsl:attribute name="data-meta-department">
        <xsl:value-of select="/order/department" />
      </xsl:attribute>
      <xsl:choose>
        <xsl:when test="@roles">
          <xsl:attribute name="data-meta-roles">
            <xsl:value-of select="@roles" />
          </xsl:attribute>
        </xsl:when>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="@mask">
          <xsl:attribute name="data-meta-mask">
            <xsl:value-of select="@mask" />
          </xsl:attribute>
        </xsl:when>
      </xsl:choose>
      <xsl:attribute name="data-required">
        <xsl:value-of select="$isRequired" />
      </xsl:attribute>

      <xsl:attribute name="class">order-meta</xsl:attribute>
      <xsl:attribute name="data-toggle">popover</xsl:attribute>
      <xsl:attribute name="data-placement">top</xsl:attribute>
      <xsl:attribute name="data-original-title">
        <xsl:value-of select="@title" />
      </xsl:attribute>
    </xsl:element>
    <xsl:element name="script">
      <xsl:attribute name="type">text/javascript</xsl:attribute>
      $(function() {
      initOrderMetaEmployeeStudent('<xsl:value-of select="$uid" />');
      });
    </xsl:element>
  </xsl:template>

  <xsl:template match="meta_date_student">
    <xsl:variable name="pattern">
      <xsl:value-of select="@pattern" />
    </xsl:variable>

    <xsl:variable name="student">
      <xsl:value-of select="@student" />
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
            <xsl:when test="/order/metas/meta/object[text() = $student]/../pattern[text() = $pattern]">
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
      <xsl:attribute name="data-meta">
        <xsl:value-of select="$uid" />
      </xsl:attribute>

      <xsl:choose>
        <xsl:when test="/order/metas/meta/object[text() = $student]/../pattern[text() = $pattern]">
          <xsl:attribute name="data-meta-id">
            <xsl:value-of select="/order/metas/meta/object[text() = $student]/../pattern[text() = $pattern]/../id" />
          </xsl:attribute>
          <xsl:attribute name="data-meta-text">
            <xsl:value-of select="/order/metas/meta/object[text() = $student]/../pattern[text() = $pattern]/../value" />
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="data-meta-id"></xsl:attribute>
          <xsl:attribute name="data-meta-text"></xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:attribute name="data-meta-order">
        <xsl:value-of select="/order/id" />
      </xsl:attribute>
      <xsl:attribute name="data-meta-type">2</xsl:attribute>
      <xsl:attribute name="data-meta-object">
        <xsl:value-of select="$student" />
      </xsl:attribute>
      <xsl:attribute name="data-meta-pattern">
        <xsl:value-of select="$pattern" />
      </xsl:attribute>
      <xsl:attribute name="data-required">
        <xsl:value-of select="$isRequired" />
      </xsl:attribute>

      <xsl:attribute name="class">order-meta nowrap</xsl:attribute>
      <xsl:attribute name="data-toggle">popover</xsl:attribute>
      <xsl:attribute name="data-placement">top</xsl:attribute>
      <xsl:attribute name="data-original-title">
        <xsl:value-of select="@title" />
      </xsl:attribute>
    </xsl:element>
    <xsl:element name="script">
      <xsl:attribute name="type">text/javascript</xsl:attribute>
        $(function() {
          initOrderMetaDateStudent('<xsl:value-of select="$uid" />');
        });
    </xsl:element>
  </xsl:template>

  <xsl:template match="meta_text_order">
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
            <xsl:when test="/order/metas/meta/object[text() = $order]/../pattern[text() = $pattern]">
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
      <xsl:attribute name="data-meta">
        <xsl:value-of select="$uid" />
      </xsl:attribute>

      <xsl:choose>
        <xsl:when test="/order/metas/meta/object[text() = $order]/../pattern[text() = $pattern]">
          <xsl:attribute name="data-meta-id">
            <xsl:value-of select="/order/metas/meta/object[text() = $order]/../pattern[text() = $pattern]/../id" />
          </xsl:attribute>
          <xsl:attribute name="data-meta-text">
            <xsl:value-of select="/order/metas/meta/object[text() = $order]/../pattern[text() = $pattern]/../value" />
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="data-meta-id"></xsl:attribute>
          <xsl:attribute name="data-meta-text"></xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>


      <xsl:attribute name="data-meta-order">
        <xsl:value-of select="/order/id" />
      </xsl:attribute>
      <xsl:attribute name="data-meta-type">0</xsl:attribute>
      <xsl:attribute name="data-meta-object">
        <xsl:value-of select="$order" />
      </xsl:attribute>
      <xsl:attribute name="data-meta-pattern">
        <xsl:value-of select="$pattern" />
      </xsl:attribute>
      <xsl:attribute name="data-required">
        <xsl:value-of select="$isRequired" />
      </xsl:attribute>

      <xsl:attribute name="class">order-meta</xsl:attribute>
      <xsl:attribute name="data-toggle">popover</xsl:attribute>
      <xsl:attribute name="data-placement">top</xsl:attribute>
      <xsl:attribute name="data-original-title">
        <xsl:value-of select="@title" />
      </xsl:attribute>
    </xsl:element>
    <xsl:element name="script">
      <xsl:attribute name="type">text/javascript</xsl:attribute>
      $(function() {
        initOrderMetaTextOrder('<xsl:value-of select="$uid" />');
      });
    </xsl:element>
  </xsl:template>

  <xsl:template match="meta_date_order">
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
            <xsl:when test="/order/metas/meta/object[text() = $order]/../pattern[text() = $pattern]">
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
      <xsl:attribute name="data-meta">
        <xsl:value-of select="$uid" />
      </xsl:attribute>

      <xsl:choose>
        <xsl:when test="/order/metas/meta/object[text() = $order]/../pattern[text() = $pattern]">
          <xsl:attribute name="data-meta-id">
            <xsl:value-of select="/order/metas/meta/object[text() = $order]/../pattern[text() = $pattern]/../id" />
          </xsl:attribute>
          <xsl:attribute name="data-meta-text">
            <xsl:value-of select="/order/metas/meta/object[text() = $order]/../pattern[text() = $pattern]/../value" />
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="data-meta-id"></xsl:attribute>
          <xsl:attribute name="data-meta-text"></xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>


      <xsl:attribute name="data-meta-order">
        <xsl:value-of select="/order/id" />
      </xsl:attribute>
      <xsl:attribute name="data-meta-type">0</xsl:attribute>
      <xsl:attribute name="data-meta-object">
        <xsl:value-of select="$order" />
      </xsl:attribute>
      <xsl:attribute name="data-meta-pattern">
        <xsl:value-of select="$pattern" />
      </xsl:attribute>
      <xsl:attribute name="data-required">
        <xsl:value-of select="$isRequired" />
      </xsl:attribute>

      <xsl:attribute name="class">order-meta nowrap</xsl:attribute>
      <xsl:attribute name="data-toggle">popover</xsl:attribute>
      <xsl:attribute name="data-placement">top</xsl:attribute>
      <xsl:attribute name="data-original-title">
        <xsl:value-of select="@title" />
      </xsl:attribute>
    </xsl:element>
    <xsl:element name="script">
      <xsl:attribute name="type">text/javascript</xsl:attribute>
      $(function() {
      initOrderMetaDateOrder('<xsl:value-of select="$uid" />');
      });
    </xsl:element>
  </xsl:template>

  <xsl:template match="meta_select_order">
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
            <xsl:when test="/order/metas/meta/object[text() = $order]/../pattern[text() = $pattern]">
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
      <xsl:attribute name="data-meta">
        <xsl:value-of select="$uid" />
      </xsl:attribute>

      <xsl:choose>
        <xsl:when test="/order/metas/meta/object[text() = $order]/../pattern[text() = $pattern]">
          <xsl:attribute name="data-meta-id">
            <xsl:value-of select="/order/metas/meta/object[text() = $order]/../pattern[text() = $pattern]/../id" />
          </xsl:attribute>
          <xsl:attribute name="data-meta-text">
            <xsl:value-of select="/order/metas/meta/object[text() = $order]/../pattern[text() = $pattern]/../value" />
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="data-meta-id"></xsl:attribute>
          <xsl:attribute name="data-meta-text"></xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>


      <xsl:attribute name="data-meta-order">
        <xsl:value-of select="/order/id" />
      </xsl:attribute>
      <xsl:attribute name="data-meta-type">0</xsl:attribute>
      <xsl:attribute name="data-meta-object">
        <xsl:value-of select="$order" />
      </xsl:attribute>
      <xsl:attribute name="data-meta-pattern">
        <xsl:value-of select="$pattern" />
      </xsl:attribute>
      <xsl:attribute name="data-meta-options">
        <xsl:value-of select="@options" />
      </xsl:attribute>
      <xsl:attribute name="data-meta-options-text">
        <xsl:value-of select="@options-text" />
      </xsl:attribute>
      <xsl:attribute name="data-required">
        <xsl:value-of select="$isRequired" />
      </xsl:attribute>

      <xsl:attribute name="class">order-meta</xsl:attribute>
      <xsl:attribute name="data-toggle">popover</xsl:attribute>
      <xsl:attribute name="data-placement">top</xsl:attribute>
      <xsl:attribute name="data-original-title">
        <xsl:value-of select="@title" />
      </xsl:attribute>
    </xsl:element>
    <xsl:element name="script">
      <xsl:attribute name="type">text/javascript</xsl:attribute>
      $(function() {
      initOrderMetaSelectOrder('<xsl:value-of select="$uid" />');
      });
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="meta_check_student">
    <xsl:variable name="pattern">
      <xsl:value-of select="@pattern" />
    </xsl:variable>

    <xsl:variable name="student">
      <xsl:value-of select="@student" />
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
            <xsl:when test="/order/metas/meta/object[text() = $student]/../pattern[text() = $pattern]">
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
      <xsl:attribute name="data-meta">
        <xsl:value-of select="$uid" />
      </xsl:attribute>

      <xsl:choose>
        <xsl:when test="/order/metas/meta/object[text() = $student]/../pattern[text() = $pattern]">
          <xsl:attribute name="data-meta-id">
            <xsl:value-of select="/order/metas/meta/object[text() = $student]/../pattern[text() = $pattern]/../id" />
          </xsl:attribute>
          <xsl:attribute name="data-meta-text">
            <xsl:value-of select="/order/metas/meta/object[text() = $student]/../pattern[text() = $pattern]/../value" />
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="data-meta-id"></xsl:attribute>
          <xsl:attribute name="data-meta-text"></xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>


      <xsl:attribute name="data-meta-order">
        <xsl:value-of select="/order/id" />
      </xsl:attribute>
      <xsl:attribute name="data-meta-type">2</xsl:attribute>
      <xsl:attribute name="data-meta-object">
        <xsl:value-of select="$student" />
      </xsl:attribute>
      <xsl:attribute name="data-meta-pattern">
        <xsl:value-of select="$pattern" />
      </xsl:attribute>
      <xsl:attribute name="data-required">
        <xsl:value-of select="$isRequired" />
      </xsl:attribute>

      <xsl:attribute name="class">order-meta</xsl:attribute>
      <xsl:attribute name="data-toggle">popover</xsl:attribute>
      <xsl:attribute name="data-placement">top</xsl:attribute>
      <xsl:attribute name="data-original-title">
        <xsl:value-of select="@title" />
      </xsl:attribute>
    </xsl:element>
    <xsl:element name="script">
      <xsl:attribute name="type">text/javascript</xsl:attribute>
      $(function() {
      initOrderMetaCheckStudent('<xsl:value-of select="$uid" />');
      });
    </xsl:element>
  </xsl:template>


</xsl:stylesheet>
