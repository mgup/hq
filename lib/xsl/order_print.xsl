<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "entities.dtd">
<xsl:stylesheet version="1.0"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" version="1.0" indent="yes" encoding="UTF-8" />

  <xsl:include href="utilities.xsl" />


  <xsl:template match="order">
    <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">

      <!-- Верстка -->
      <fo:layout-master-set>
        <!-- Шаблон нечетных страниц -->
        <fo:simple-page-master master-name="mainOdd" page-height="297mm" page-width="210mm" margin-top="2cm" margin-bottom="2cm" margin-left="2.7cm" margin-right="1.5cm">
          <fo:region-body margin-bottom="1mm" />
          <fo:region-after region-name="oddFoot" />
        </fo:simple-page-master>

        <!-- Шаблон четных страниц -->
        <fo:simple-page-master master-name="mainEven" page-height="297mm" page-width="210mm" margin-top="2cm" margin-bottom="2cm" margin-left="2.7cm" margin-right="1.5cm">
          <fo:region-body margin-bottom="1mm" />
          <fo:region-after region-name="evenFoot" />
        </fo:simple-page-master>

        <!-- Правила чередования нечетных/четных страниц -->
        <fo:page-sequence-master master-name="main">
          <fo:repeatable-page-master-alternatives>
            <fo:conditional-page-master-reference master-reference="mainOdd" odd-or-even="odd" />
            <fo:conditional-page-master-reference master-reference="mainEven" odd-or-even="even" />
          </fo:repeatable-page-master-alternatives>
        </fo:page-sequence-master>
      </fo:layout-master-set>

      <fo:page-sequence master-reference="main">
        <fo:static-content flow-name="oddFoot">
          <fo:block>
            <xsl:value-of select="id" />&nbsp;&ndash;&nbsp;<xsl:value-of select="revision" />
          </fo:block>
        </fo:static-content>

        <fo:static-content flow-name="evenFoot">
          <!--<fo:block text-align="end">-->
          <fo:block>
            <xsl:value-of select="id" />&nbsp;&ndash;&nbsp;<xsl:value-of select="revision" />
          </fo:block>
        </fo:static-content>

        <fo:flow flow-name="xsl-region-body">
          <fo:block>
            <fo:block font="12pt PT Serif" font-weight="bold" text-align="center">
              МИНИСТЕРСТВО ОБРАЗОВАНИЯ И НАУКИ РОССИЙСКОЙ ФЕДЕРАЦИИ
            </fo:block>
            <fo:block font="14pt PT Serif" font-weight="bold" text-align="center">
              федеральное государственное бюджетное образовательное учреждение высшего профессионального образования
            </fo:block>
            <fo:block font="14pt PT Serif" font-weight="bold" text-align="center" padding-bottom="3pt">
              &laquo;МОСКОВСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПЕЧАТИ
              ИМЕНИ ИВАНА ФЕДОРОВА&raquo;
            </fo:block>
            <fo:block border-top="3pt solid black" space-after="1pt"></fo:block>
            <fo:block border-bottom="0.5pt solid black" space-after="13pt"></fo:block>
            <fo:block font="14pt PT Serif" font-weight="bold" text-align="center" space-after="13pt">
              ПРИКАЗ
            </fo:block>
            <fo:table table-layout="fixed" width="100%" space-after="25pt">
              <fo:table-column column-width="proportional-column-width(1.7)" />
              <fo:table-column column-width="proportional-column-width(1)" />
              <fo:table-column column-width="proportional-column-width(1.7)" />
              <fo:table-body>
                <fo:table-row>
                  <fo:table-cell>
                    <fo:block font="12pt PT Serif">
                      <xsl:choose>
                        <xsl:when test="not(./sign/date)">
                          от &laquo;______&raquo; ______________ 2013 г.
                        </xsl:when>
                        <xsl:otherwise>
                          от &laquo;<xsl:value-of select="substring(./sign/date, 9, 2)" />&raquo;
                          <xsl:call-template name="month_name">
                            <xsl:with-param name="date" select="substring(./sign/date, 6, 2)" />
                          </xsl:call-template>&nbsp;
                          <xsl:value-of select="substring(./sign/date, 0, 5)" /> г.
                        </xsl:otherwise>
                      </xsl:choose>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell>
                    <fo:block font="12pt PT Serif" text-align="center">Москва</fo:block>
                  </fo:table-cell>
                  <fo:table-cell>
                    <fo:block font="12pt PT Serif" text-align="end">
                      <xsl:choose>
                        <xsl:when test="not(./sign/number)">
                          № __________________
                        </xsl:when>
                        <xsl:otherwise>
                          № <xsl:value-of select="./sign/number" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </fo:table-body>
            </fo:table>
            <fo:table table-layout="fixed" width="100%">
              <fo:table-column column-width="proportional-column-width(45)" />
              <fo:table-column column-width="proportional-column-width(55)" />
              <fo:table-body>
                <fo:table-row>
                  <fo:table-cell>
                    <fo:block font="12pt PT Serif" font-weight="bold">
                      <xsl:value-of select="order_template/name" />
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
                <fo:table-row>
                  <fo:table-cell>
                    <fo:block font="12pt PT Serif" font-weight="bold">
                      <xsl:value-of select="students/student/speciality/faculty/short" />
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
                <fo:table-row>
                  <fo:table-cell>
                    <fo:block font="12pt PT Serif" font-weight="bold">
                      <xsl:call-template name="form_name">
                        <xsl:with-param name="id" select="students/student/group/form" />
                      </xsl:call-template>
                      форма обучения
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
                <!--<fo:table-row>-->
                <!--<fo:table-cell>-->
                <!--<fo:block font="12pt PT Serif">-->
                <!--<xsl:call-template name="form_name">-->
                <!--<xsl:with-param name="id" select="/order/form" />-->
                <!--</xsl:call-template>-->
                <!--форма обучения-->
                <!--</fo:block>-->
                <!--</fo:table-cell>-->
                <!--</fo:table-row>-->
                <xsl:if test="payment">
                  <fo:table-row>
                    <fo:table-cell>
                      <fo:block font="12pt PT Serif">
                        (<xsl:value-of select="payment/ip" /> основа)
                      </fo:block>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:if>
              </fo:table-body>
            </fo:table>
          </fo:block>
          <fo:block font="12pt PT Serif">
            <xsl:apply-templates select="content" />
          </fo:block>

          <fo:block page-break-before="avoid">
            <xsl:apply-templates select="/order/signature/approve" />
          </fo:block>

          <xsl:apply-templates select="/order/signature" />
          <xsl:apply-templates select="/order/dispatch" />
        </fo:flow>
      </fo:page-sequence>
    </fo:root>
  </xsl:template>

  <!-- Основания приказа -->
  <xsl:template match="reasons">
    <fo:block font="12pt PT Serif" space-before="20pt" margin-left="20pt">
      Основания:
    </fo:block>
    <fo:list-block margin-left="20pt">
      <xsl:apply-templates select="./reason" />
    </fo:list-block>
  </xsl:template>

  <!-- Отдельное основание приказа -->
  <xsl:template match="reason">
    <fo:list-item>
      <fo:list-item-label end-indent="label-end()">
        <fo:block>&mdash;</fo:block>
      </fo:list-item-label>
      <fo:list-item-body start-indent="body-start()">
        <fo:block font="12pt PT Serif" text-align="justify">
          <xsl:apply-templates />
          <!-- Вывод точки с запятой или точки, в зависимости от положения основания в списке. -->
          <xsl:choose>
            <xsl:when test="position() = last()">.</xsl:when>
            <xsl:otherwise>;</xsl:otherwise>
          </xsl:choose>
        </fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </xsl:template>

  <!-- Виза ректора -->
  <xsl:template match="approve">
    <fo:table table-layout="fixed" width="100%" space-before="40pt">
      <fo:table-column column-width="proportional-column-width(1.5)" />
      <fo:table-column column-width="proportional-column-width(2)" />
      <fo:table-body>
        <fo:table-row>
          <fo:table-cell>
            <fo:block font="12pt PT Serif">
              <xsl:call-template name="change_case">
                <xsl:with-param name="input_string" select="substring(./employee/title, 1, 1)" />
                <xsl:with-param name="direction" select="'up'" />
              </xsl:call-template><xsl:value-of select="substring(./employee/title, 2)" />
            </fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block font="12pt PT Serif" text-align="end">
              <xsl:value-of select="./employee/name" />
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-body>
    </fo:table>
  </xsl:template>

  <!-- Визы подписантов -->
  <xsl:template match="signature">
    <fo:block break-before="page">
      <fo:block font="12pt PT Serif">
        Проект вносит:
      </fo:block>
      <xsl:apply-templates select="responsible/employee" />

      <xsl:choose>
        <xsl:when test="responsible/employee/id != author/employee/id">
          <fo:block font="12pt PT Serif" space-before="40pt">
            Исполнитель:
          </fo:block>
          <xsl:apply-templates select="author/employee" />
        </xsl:when>
      </xsl:choose>
      <fo:block font="12pt PT Serif" space-before="10pt">
        тел: <xsl:value-of select="author/employee/phone" />
      </fo:block>

      <fo:block font="12pt PT Serif" space-before="40pt">
        Согласовано:
      </fo:block>
      <xsl:apply-templates select="concurrence/employee" />
    </fo:block>
  </xsl:template>

  <!-- Визы -->
  <xsl:template match="employee">
    <fo:block font="12pt PT Serif" space-after="10pt" space-before="15pt">
      <xsl:call-template name="change_case">
        <xsl:with-param name="input_string" select="substring(./title, 1, 1)" />
        <xsl:with-param name="direction" select="'up'" />
      </xsl:call-template><xsl:value-of select="substring(./title, 2)" /><xsl:text> </xsl:text><xsl:value-of select="./department_short_name" />
    </fo:block>
    <fo:block font="12pt PT Serif" space-after="10pt">
      ___________________
      <xsl:value-of select="./name" />
    </fo:block>
    <fo:block font="12pt PT Serif">
      &laquo;______&raquo; _______________ 2013 г.
    </fo:block>

  </xsl:template>

  <!-- Рассылка -->
  <xsl:template match="dispatch">
    <fo:block font="12pt PT Serif" margin-top="20pt" padding-top="10pt">
      Рассылка:
    </fo:block>
    <fo:list-block margin-left="20pt">
      <xsl:apply-templates select="./department" />
    </fo:list-block>
  </xsl:template>

  <xsl:template match="department">
    <fo:list-item>
      <fo:list-item-label end-indent="label-end()">
        <fo:block>&mdash;</fo:block>
      </fo:list-item-label>
      <fo:list-item-body start-indent="body-start()">
        <fo:block font="12pt PT Serif" text-align="justify">
          <xsl:apply-templates />
          <!-- Вывод точки с запятой или точки, в зависимости от положения основания в списке. -->
          <xsl:choose>
            <xsl:when test="position() = last()">.</xsl:when>
            <xsl:otherwise>;</xsl:otherwise>
          </xsl:choose>
        </fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </xsl:template>

  <!-- Обработка мета-информации -->
  <xsl:template match="outmeta">
    <xsl:value-of select="/order/metas/meta[@name=current()/@name]" />
  </xsl:template>

  <!-- Абзац с выравниванием по левому краю -->
  <xsl:template match="lBlock">
    <fo:block font="12pt PT Serif" space-before="20pt" text-align="justify" text-align-last="start"
              text-indent="20pt">
      <xsl:apply-templates />
    </fo:block>
  </xsl:template>

  <xsl:template match="tBlock">
    <fo:block font="12pt PT Serif" space-before="15pt" space-after="15pt" text-align="left" text-indent="20pt" letter-spacing="0.3em">
      <xsl:apply-templates />
    </fo:block>
  </xsl:template>

  <xsl:template match="sList">
    <fo:list-block font="12pt PT Serif" provisional-distance-between-starts="10mm"
                   provisional-label-separation="5mm" space-before="6pt" space-after="6pt">
      <xsl:apply-templates />
    </fo:list-block>
  </xsl:template>

  <xsl:template match="iList">
    <fo:list-item space-after="1mm">
      <fo:list-item-label start-indent="1mm" end-indent="label-end()">
        <fo:block>
          <xsl:number format="1" />.
        </fo:block>
      </fo:list-item-label>
      <fo:list-item-body start-indent="body-start()">
        <fo:block text-indent="0" margin-left="6mm">
          <xsl:apply-templates />
        </fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </xsl:template>

  <xsl:template match="table">
    <fo:table table-layout="fixed" width="100%" border="1pt solid #000000" space-before="10pt">
      <xsl:apply-templates />
    </fo:table>
  </xsl:template>

  <xsl:template match="table/columns/column">
    <fo:table-column>
      <xsl:attribute name="column-width">
        <xsl:value-of select="." />
      </xsl:attribute>
    </fo:table-column>
  </xsl:template>

  <xsl:template match="thead">
    <fo:table-header>
      <xsl:apply-templates />
    </fo:table-header>
  </xsl:template>

  <xsl:template match="tbody">
    <fo:table-body>
      <xsl:apply-templates />
    </fo:table-body>
  </xsl:template>

  <xsl:template match="tr">
    <fo:table-row>
      <xsl:apply-templates />
    </fo:table-row>
  </xsl:template>

  <xsl:template match="th">
    <xsl:choose>
      <xsl:when test="@class = 'screen'"></xsl:when>
      <xsl:otherwise>
        <fo:table-cell border="1pt solid #000000" padding="3pt">
          <fo:block font="12pt PT Serif" font-weight="bold">
            <xsl:apply-templates />
          </fo:block>
        </fo:table-cell>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="td">
    <xsl:choose>
      <xsl:when test="@class = 'screen'"></xsl:when>
      <xsl:otherwise>
        <fo:table-cell border="1pt solid #000000" padding="3pt" page-break-inside="avoid">
          <fo:block>
            <xsl:apply-templates />
          </fo:block>
        </fo:table-cell>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*[@class = 'screen']"></xsl:template>

</xsl:stylesheet>