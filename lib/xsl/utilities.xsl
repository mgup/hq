<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" version="1.0" indent="yes" encoding="UTF-8" />

  <!-- Склеивание элементов через разделитель. -->
  <xsl:template name="join" >
    <xsl:param name="values" select="''"/>
    <xsl:param name="separator" select="','"/>
    <xsl:for-each select="$values">
      <xsl:choose>
        <xsl:when test="position() = 1">
          <xsl:value-of select="."/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat($separator, .) "/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <!-- Имя месяца по номеру. -->
  <xsl:template name="month_name">
    <xsl:param name="date" />
    <xsl:choose>
      <xsl:when test="$date = '01'">января</xsl:when>
      <xsl:when test="$date = '02'">февраля</xsl:when>
      <xsl:when test="$date = '03'">марта</xsl:when>
      <xsl:when test="$date = '04'">апреля</xsl:when>
      <xsl:when test="$date = '05'">мая</xsl:when>
      <xsl:when test="$date = '06'">июня</xsl:when>
      <xsl:when test="$date = '07'">июля</xsl:when>
      <xsl:when test="$date = '08'">августа</xsl:when>
      <xsl:when test="$date = '09'">сентября</xsl:when>
      <xsl:when test="$date = '10'">октября</xsl:when>
      <xsl:when test="$date = '11'">ноября</xsl:when>
      <xsl:when test="$date = '12'">декабря</xsl:when>
      <xsl:otherwise><xsl:value-of select="$date" /></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Склонение после числительных -->
  <xsl:template name="declension">
    <xsl:param name="number" select="number" />
    <xsl:param name="f1" select="f1" />
    <xsl:param name="f2" select="f2" />
    <xsl:param name="f5" select="f5" />

    <xsl:variable name="absnum">
      <xsl:choose>
        <xsl:when test="$number &lt; 0">
          <xsl:value-of select="0 - $number" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$number" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="($absnum mod 10) = 1 and ($absnum mod 100) != 11">
        <xsl:value-of select="$f1" />
      </xsl:when>
      <xsl:when test="(($absnum mod 10) &gt;= 2) and (($absnum mod 10) &lt;= 4) and (($absnum mod 100 &lt; 10) or ($absnum mod 100 &gt;= 20))">
        <xsl:value-of select="$f2" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$f5" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Вывод названия типа специальности (направления) с учётом падежей. -->
  <xsl:template name="speciality_type_name">
    <xsl:param name="type" />
    <xsl:param name="form">ip</xsl:param>
    <xsl:choose>
      <xsl:when test="0 = $type">
        <xsl:choose>
          <xsl:when test="$form = 'ip'">специальность </xsl:when>
          <xsl:when test="$form = 'rp'">специальности </xsl:when>
          <xsl:when test="$form = 'dp'">специальности </xsl:when>
          <xsl:when test="$form = 'vp'">специальность </xsl:when>
          <xsl:when test="$form = 'tp'">специальностью </xsl:when>
          <xsl:when test="$form = 'pp'">специальности </xsl:when>
        </xsl:choose>
      </xsl:when>
      <xsl:when test='1 = $type or 2 = $type'>
        <xsl:choose>
          <xsl:when test="$form = 'ip'">направление </xsl:when>
          <xsl:when test="$form = 'rp'">направления </xsl:when>
          <xsl:when test="$form = 'dp'">направлению </xsl:when>
          <xsl:when test="$form = 'vp'">направление </xsl:when>
          <xsl:when test="$form = 'tp'">направлением </xsl:when>
          <xsl:when test="$form = 'pp'">направлении </xsl:when>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- Вывод названия формы обучения с учётом падежей. -->
  <xsl:template name="form_name">
    <xsl:param name="id" />
    <xsl:param name="form">ip</xsl:param>
    <xsl:choose>
      <xsl:when test="'fulltime' = $id">
        <xsl:choose>
          <xsl:when test="'ip' = $form">очная</xsl:when>
          <xsl:when test="'rp' = $form">очной</xsl:when>
          <xsl:when test="'dp' = $form">очной</xsl:when>
          <xsl:when test="'vp' = $form">очную</xsl:when>
          <xsl:when test="'tp' = $form">очной</xsl:when>
          <xsl:when test="'pp' = $form">очной</xsl:when>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="'semitime' = $id">
        <xsl:choose>
          <xsl:when test="'ip' = $form">очно-заочная</xsl:when>
          <xsl:when test="'rp' = $form">очно-заочной</xsl:when>
          <xsl:when test="'dp' = $form">очно-заочной</xsl:when>
          <xsl:when test="'vp' = $form">очно-заочную</xsl:when>
          <xsl:when test="'tp' = $form">очно-заочной</xsl:when>
          <xsl:when test="'pp' = $form">очно-заочной</xsl:when>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="'postal' = $id">
        <xsl:choose>
          <xsl:when test="'ip' = $form">заочная</xsl:when>
          <xsl:when test="'rp' = $form">заочной</xsl:when>
          <xsl:when test="'dp' = $form">заочной</xsl:when>
          <xsl:when test="'vp' = $form">заочную</xsl:when>
          <xsl:when test="'tp' = $form">заочной</xsl:when>
          <xsl:when test="'pp' = $form">заочной</xsl:when>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="'distance' = $id">
        <xsl:choose>
          <xsl:when test="'ip' = $form">заочная</xsl:when>
          <xsl:when test="'rp' = $form">заочной</xsl:when>
          <xsl:when test="'dp' = $form">заочной</xsl:when>
          <xsl:when test="'vp' = $form">заочную</xsl:when>
          <xsl:when test="'tp' = $form">заочной</xsl:when>
          <xsl:when test="'pp' = $form">заочной</xsl:when>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- Смена регистра строки -->
  <xsl:variable name="UPPER_CASE"
                select="'ABCDEFGHIJKLMNOPQRSTUVWXYZАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ'" />
  <xsl:variable name="LOWER_CASE"
                select="'abcdefghijklmnopqrstuvwxyzабвгдеёжзийклмнопрстуфхцчшщъыьэюя'" />
  <xsl:template name="change_case">
    <xsl:param name="input_string" />
    <xsl:param name="direction" select="'low'" />

    <xsl:choose>
      <xsl:when test="$direction = 'low'">
        <xsl:value-of select="translate($input_string, $UPPER_CASE, $LOWER_CASE)" />
      </xsl:when>
      <xsl:when test="$direction = 'up'">
        <xsl:value-of select="translate($input_string, $LOWER_CASE, $UPPER_CASE)" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$input_string" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>