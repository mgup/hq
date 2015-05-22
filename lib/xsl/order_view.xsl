<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" version="1.0" indent="yes" encoding="UTF-8" />

  <xsl:include href="lib/xsl/utilities.xsl" />
  <xsl:include href="lib/xsl/metas_view.xsl" />
  <xsl:include href="lib/xsl/reasons_view.xsl" />

  <xsl:template match="order">
    <div>
    <div style="background-color: white; width: 745px; margin: 20px auto; padding: 40px 80px 40px 80px; border: 1px solid #666666; box-shadow: 0 2px 20px #666666; font-family: 'PT Sans'; font-size: 11pt; position: relative;">
      <p style="text-align: center; font-weight: bold; font-size: 17px; margin-bottom: 0;">МИНИСТЕРСТВО ОБРАЗОВАНИЯ И НАУКИ РОССИЙСКОЙ ФЕДЕРАЦИИ</p>
      <p style="text-align: center; font-weight: bold; margin-bottom: 3px; font-size: 16px;">федеральное государственное бюджетное образовательное<br />учреждение высшего профессионального образования</p>
      <p style="text-align: center; font-weight: bold; font-size: 16px; padding-bottom: 3px; margin-bottom: 20px; border-bottom: 3px solid black;">&laquo;МОСКОВСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПЕЧАТИ ИМЕНИ ИВАНА ФЕДОРОВА&raquo;</p>
      <p style="text-align: center; font-weight: bold; margin: 10px 0 5px 0;">ПРИКАЗ</p>
      <table style="width: 100%; margin-top: 0; margin-bottom: 20px;">
        <tbody>
          <tr>
            <td style="border: none; width: 34%;">
              <xsl:choose>
                <xsl:when test="not(./sign/date)">
                  от &laquo;___&raquo; _______________ 2015 г.
                </xsl:when>
                <xsl:otherwise>
                  от &laquo;<xsl:value-of select="substring(./sign/date, 9, 2)" />&raquo;
                  <xsl:call-template name="month_name">
                    <xsl:with-param name="date" select="substring(./sign/date, 6, 2)" />
                  </xsl:call-template>&nbsp;
                  <xsl:value-of select="substring(./sign/date, 0, 5)" /> г.
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td style="border: none; width: 22%; text-align: center;">Москва</td>
            <td style="border: none; width: 34%; text-align: right;">
              <xsl:choose>
                <xsl:when test="not(./sign/number)">
                  № __________________
                </xsl:when>
                <xsl:otherwise>
                  № <xsl:value-of select="./sign/number" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
        </tbody>
      </table>
      <p style="margin-bottom: 0; width: 40%; text-align: left;"><xsl:value-of select="order_template/name" /></p>
      <p style="margin-bottom: 0;">
        <xsl:value-of select="students/student/speciality/faculty/short" />
      </p>
      <p style="margin-bottom: 0;">
        <xsl:call-template name="form_name">
          <xsl:with-param name="id" select="students/student/group/form" />
        </xsl:call-template>
        форма обучения
      </p>
      <xsl:if test="payment">
        <p style="margin-bottom: 0;">(<xsl:value-of select="payment" /> основа)</p>
      </xsl:if>

      <div style="margin-top: 40px;">
        <xsl:apply-templates select="content" />
      </div>
      <xsl:apply-templates select="./signature/approve" />
      <div style="margin-top: 70px;">
        <xsl:value-of select="id" />&mdash;<xsl:value-of select="revision" />
      </div>
	</div>
    <div style="background-color: white; width: 745px; margin: 20px auto; padding: 40px 80px 40px 80px; border: 1px solid #666666; box-shadow: 0 2px 20px #666666; font-family: 'PT Sans'; font-size: 11pt; position: relative;">
        <xsl:apply-templates select="/order/signature" />
        <xsl:apply-templates select="./dispatch" />
        <div style="margin-top: 70px; text-align: right;">
          <xsl:value-of select="id" />&mdash;<xsl:value-of select="revision" />
        </div>
    </div>
    <!--	<script>
            totalMetas = 0;
            document.observe('dom:loaded', function() {
                Lightview.options.resizeDuration = 0.2;
                $$('a.meta').each(function(el) {
                    el.setAttribute('href', '#orderMeta' + totalMetas);
                    el.next('form').setAttribute('id', 'orderMeta' + totalMetas);
                    totalMetas++;
                });
            });
        </script> -->
	</div>
  </xsl:template>

  <xsl:template match="reasons">
    <div style="margin: 25px 0 0 25px;">
      Основания:
      <xsl:element name="reason_multy_select">
      	<xsl:variable name="pattern">
        	выберите основание(я)
      	</xsl:variable>
        <xsl:variable name="options">
          <xsl:for-each select="/order/order_template/reasons/reason">
              <xsl:value-of select="./pattern"/>
              <xsl:if test="not(position()=last())">
                  <xsl:text>|</xsl:text>
              </xsl:if>
          </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="options-text">
          <xsl:for-each select="/order/order_template/reasons/reason">
              <xsl:value-of select="./id"/>
              <xsl:if test="not(position()=last())">
                  <xsl:text>|</xsl:text>
              </xsl:if>
          </xsl:for-each>
        </xsl:variable>
      	<xsl:variable name="order">
        	<xsl:value-of select="/order/id" />
      	</xsl:variable>

      	<xsl:variable name="isRequired">
        	<xsl:value-of select="'required' = 'required'" />
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
          <xsl:when test="count(/order/order_reasons/reason) > 0">
            <xsl:attribute name="data-reason-text">
              <xsl:for-each select="/order/order_reasons/reason">
                  <xsl:value-of select="."/>
                  <xsl:if test="not(position()=last())">
                      <xsl:text>, </xsl:text>
                  </xsl:if>
              </xsl:for-each>
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
          <xsl:value-of select="$options" />
        </xsl:attribute>
        <xsl:attribute name="data-reason-options-text">
          <xsl:value-of select="$options-text" />
        </xsl:attribute>
        <xsl:attribute name="data-required">
          <xsl:value-of select="$isRequired" />
        </xsl:attribute>
        <xsl:attribute name="data-multiple">true</xsl:attribute>

        <xsl:attribute name="class">order-reason</xsl:attribute>
        <xsl:attribute name="data-toggle">popover</xsl:attribute>
        <xsl:attribute name="data-placement">top</xsl:attribute>
        <xsl:attribute name="data-original-title">
          Выберите основание(я)
        </xsl:attribute>
      </xsl:element>
      <xsl:element name="script">
        <xsl:attribute name="type">text/javascript</xsl:attribute>
        $(function() {
          initOrderReasonMultySelect('<xsl:value-of select="$uid" />');
        });
      </xsl:element>
    </xsl:element>
    </div>
    <ul style="margin: 0 0 0 25px; padding: 0; list-style-type: none;">
      <xsl:apply-templates select="./reason" />
    </ul>
  </xsl:template>

  <xsl:template match="reason">
    <li class="reason" style="text-align: justify;">– <xsl:apply-templates />
      <xsl:choose>
        <xsl:when test="position() = last()">.</xsl:when>
        <xsl:otherwise>;</xsl:otherwise>
      </xsl:choose>
    </li>
  </xsl:template>

  <xsl:template match="approve">
    <table style="width: 100%; margin-top: 40px;">
      <tbody>
        <tr>
          <td style="border: none; text-align: right;">
            <xsl:call-template name="change_case">
              <xsl:with-param name="input_string" select="substring(./employee/title, 1, 1)" />
              <xsl:with-param name="direction" select="'up'" />
            </xsl:call-template><xsl:value-of select="substring(./employee/title, 2)" />
          </td>
          <td style="border: none; width: 56%; text-align: right;">
            <xsl:value-of select="./employee/name" />
          </td>
        </tr>
      </tbody>
    </table>
  </xsl:template>

  <xsl:template match="signature">
    <div>
      Проект вносит:
    </div>
    <xsl:apply-templates select="responsible/employee" />
    <div style="margin-top: 60px;">
      Исполнитель:
    </div>
    <xsl:apply-templates select="author/employee" />
    <div style="margin-top: 60px;">
      Согласовано:
    </div>
    <xsl:apply-templates select="concurrence/employee" />
  </xsl:template>

  <xsl:template match="dispatch">
    <div style="border-top: 2px solid black; margin-top: 20px; padding-top: 10px;">
      Рассылка:
    </div>
    <ul style="margin: 0 0 0 25px;">
      <xsl:apply-templates select="./department" />
    </ul>
  </xsl:template>

  <xsl:template match="department">
    <li class="reason" style="text-align: justify;"><xsl:apply-templates />
      <xsl:choose>
        <xsl:when test="position() = last()">.</xsl:when>
        <xsl:otherwise>;</xsl:otherwise>
      </xsl:choose>
    </li>
  </xsl:template>

  <xsl:template match="employee">
	  <p>
        <xsl:call-template name="change_case">
          <xsl:with-param name="input_string" select="substring(./title, 1, 1)" />
          <xsl:with-param name="direction" select="'up'" />
        </xsl:call-template><xsl:value-of select="substring(./title, 2)" /><xsl:text> </xsl:text><xsl:value-of select="./department_short_name" />
	  </p>
	  <p><xsl:apply-templates select="./name" /></p>
		<div style="margin-top: 15px; margin-bottom: 10px;">
          «_____» _________________ 2015 г.
         </div>
	  <p> </p>
  </xsl:template>

  <xsl:template match="user_name">
    <xsl:param name="form">ip</xsl:param>
    <xsl:value-of select="./name" />
  </xsl:template>

  <xsl:template match="lBlock">
    <div style="text-indent: 2em; margin-top: 1em; text-align: justify;">
      <xsl:apply-templates />
    </div>
  </xsl:template>

  <xsl:template match="tBlock">
    <div style="text-indent: 2em; text-align: left; margin: 1.1em auto; letter-spacing: 0.3em;">
      <xsl:apply-templates />
    </div>
  </xsl:template>

  <xsl:template match="sList">
    <ol style="margin: 10px 0 0 0; padding-left: 4em;">
      <xsl:apply-templates />
    </ol>
  </xsl:template>

  <xsl:template match="iList">
    <ol style="margin-left: 8em; padding-left: 2em;">
       <xsl:apply-templates />
    </ol>
  </xsl:template>

  <xsl:template match="iListInner">
    <li style="text-indent: 0; margin-bottom: 0.5em;"><xsl:apply-templates /></li>
  </xsl:template>

  <xsl:template match="pListInner">
      <li style="text-indent: 0; margin-bottom: 0.5em;"><xsl:apply-templates /></li>
  </xsl:template>

  <xsl:template match="table">
    <table class="table table-striped table-bordered table-condensed">
      <xsl:apply-templates />
    </table>
  </xsl:template>

  <!-- Этот элемент используется для информации о ширине колонок при печати. -->
  <xsl:template match="columns"></xsl:template>

  <xsl:template match="thead">
    <thead><xsl:apply-templates /></thead>
  </xsl:template>

  <xsl:template match="tbody">
    <tbody><xsl:apply-templates /></tbody>
  </xsl:template>

  <xsl:template match="tr">
    <tr><xsl:apply-templates /></tr>
  </xsl:template>

  <xsl:template match="th">
    <th><xsl:apply-templates /></th>
  </xsl:template>

  <xsl:template match="td">
    <td><xsl:apply-templates /></td>
  </xsl:template>

  <xsl:template match="strong">
    <strong><xsl:apply-templates /></strong>
  </xsl:template>

</xsl:stylesheet>
