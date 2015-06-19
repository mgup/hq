<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "entities.dtd">
<xsl:stylesheet version="1.0"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" version="1.0" indent="yes" encoding="UTF-8" />

  <xsl:include href="utilities.xsl" />
  <xsl:include href="metas_print.xsl" />

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
            <fo:conditional-page-master-reference master-reference="mainOdd" odd-or-even="odd" />
            <fo:conditional-page-master-reference master-reference="mainEven" odd-or-even="even" />
          </fo:repeatable-page-master-alternatives>
        </fo:page-sequence-master>

          <fo:simple-page-master master-name="landscape" page-height="210mm" page-width="297mm" margin-top="2cm" margin-bottom="1.5cm" margin-left="2cm" margin-right="2cm">
              <fo:region-body margin-bottom="1mm" />
              <fo:region-after region-name="oddFoot" />
          </fo:simple-page-master>

          <fo:page-sequence-master master-name="protocol">
              <fo:repeatable-page-master-alternatives>
                  <fo:conditional-page-master-reference master-reference="landscape"  />
                  <fo:conditional-page-master-reference master-reference="landscape"  />
              </fo:repeatable-page-master-alternatives>
          </fo:page-sequence-master>
      </fo:layout-master-set>

      <fo:page-sequence master-reference="main">
        <fo:static-content flow-name="oddFoot">
          <fo:block>
            <xsl:value-of select="id" />&nbsp;&ndash;&nbsp;<xsl:value-of select="revision" />
			<fo:block font="5pt PT Serif">
			  <xsl:if test="1 = /order/status">ЧЕРНОВИК ЧЕРНОВИК ЧЕРНОВИК ЧЕРНОВИК ЧЕРНОВИК ЧЕРНОВИК ЧЕРНОВИК ЧЕРНОВИК ЧЕРНОВИК ЧЕРНОВИК ЧЕРНОВИК ЧЕРНОВИК ЧЕРНОВИК ЧЕРНОВИК ЧЕРНОВИК ЧЕРНОВИК ЧЕРНОВИК</xsl:if>
			</fo:block>
          </fo:block>
        </fo:static-content>

        <fo:static-content flow-name="evenFoot">
          <!--<fo:block text-align="end">-->
          <fo:block font="PT Serif">
            <xsl:value-of select="id" />&nbsp;&ndash;&nbsp;<xsl:value-of select="revision" />
			<fo:block font="5pt PT Serif">
			  <xsl:if test="1 = /order/status">ЧЕРНОВИК ЧЕРНОВИК ЧЕРНОВИК ЧЕРНОВИК ЧЕРНОВИК ЧЕРНОВИК ЧЕРНОВИК ЧЕРНОВИК ЧЕРНОВИК ЧЕРНОВИК ЧЕРНОВИК ЧЕРНОВИК ЧЕРНОВИК ЧЕРНОВИК ЧЕРНОВИК ЧЕРНОВИК ЧЕРНОВИК</xsl:if>
			</fo:block> 
          </fo:block>
        </fo:static-content>

        <fo:flow flow-name="xsl-region-body">
          <fo:block>
            <fo:block font="12pt PT Serif" font-weight="bold" text-align="center">
              МИНИСТЕРСТВО ОБРАЗОВАНИЯ И НАУКИ РОССИЙСКОЙ ФЕДЕРАЦИИ
            </fo:block>
            <fo:block font="12pt PT Serif" font-weight="bold" text-align="center">
              федеральное государственное бюджетное образовательное учреждение
            </fo:block>
            <fo:block font="12pt PT Serif" font-weight="bold" text-align="center">
               высшего профессионального образования
            </fo:block>
            <fo:block font="14pt PT Serif" font-weight="bold" text-align="center" padding-bottom="3pt">
              &laquo;МОСКОВСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПЕЧАТИ
            </fo:block>
            <fo:block font="14pt PT Serif" font-weight="bold" text-align="center" padding-bottom="3pt">
              ИМЕНИ ИВАНА ФЕДОРОВА&raquo;
            </fo:block>
            <fo:block border-top="3pt solid black" space-after="1pt"></fo:block>
            <fo:block border-bottom="0.5pt solid black" space-after="13pt"></fo:block>
            <fo:block font="14pt PT Serif" font-weight="bold" text-align="center" space-after="13pt">
              <xsl:if test="1 = /order/status">ЧЕРНОВИК ПРИКАЗА</xsl:if>
              <xsl:if test="2 = /order/status">ПРИКАЗ</xsl:if>
			  <xsl:if test="3 = /order/status">ПРИКАЗ</xsl:if>
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
                          от &laquo;______&raquo; ______________ 2015 г.
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
                <xsl:if test="'true' = order_template/check_group">
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
                  <fo:table-row>
                    <fo:table-cell>
                      <fo:block font="12pt PT Serif" font-weight="bold">
                        <xsl:if test="1 = /order/students/student/education_source">бюджетная </xsl:if>
                        <xsl:if test="2 = /order/students/student/education_source">внебюджетная </xsl:if>
                        основа
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
      <xsl:apply-templates select="/order/protocol" />
      <xsl:apply-templates select="/order/act" />
    </fo:root>
  </xsl:template>


  <!-- Основания приказа -->
  <xsl:template match="reasons">
    <fo:block font="12pt PT Serif" space-before="20pt" margin-left="20pt">
      Основания:
    </fo:block>
    <fo:list-block margin-left="20pt">
      <xsl:apply-templates select="./reason | /order/order_reasons/reason" />
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
          <fo:table-cell display-align="after">
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
	      <fo:block font="12pt PT Serif" space-after="10pt" space-before="15pt">
	        <xsl:call-template name="change_case">
	          <xsl:with-param name="input_string" select="substring(author/employee/title, 1, 1)" />
	          <xsl:with-param name="direction" select="'up'" />
	        </xsl:call-template><xsl:value-of select="substring(author/employee/title, 2)" /><xsl:text> </xsl:text><xsl:value-of select="author/employee/department_short_name" />
	      </fo:block>
	      <fo:block font="12pt PT Serif" space-after="10pt">
	        <xsl:apply-templates select="author/employee/name" />
	      </fo:block>
        </xsl:when>
      </xsl:choose>
      <fo:block font="12pt PT Serif" space-before="10pt">
        <xsl:value-of select="author/employee/phone" />
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
      <xsl:apply-templates select="./name" />
    </fo:block>
    <fo:block font="12pt PT Serif">
      &laquo;______&raquo; _______________ 2015 г.
    </fo:block>

  </xsl:template>

  <xsl:template match="user_name">
    <xsl:param name="form">ip</xsl:param>
    <xsl:value-of select="./name" />
  </xsl:template>

  <!-- Рассылка -->
  <xsl:template match="dispatch">
    <xsl:if test="count(./department) > 0">
      <fo:block font="12pt PT Serif" margin-top="160pt" padding-top="10pt">
        Рассылка:
      </fo:block>
      <fo:list-block margin-left="20pt">
        <xsl:apply-templates select="./department" />
      </fo:list-block>
    </xsl:if>
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
    <xsl:value-of select="/order/metas/meta[@name=current()/@name]/value" />
  </xsl:template>

  <!-- Протокол -->
  <xsl:template match="protocol">
      <!--<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">-->
          <fo:page-sequence master-reference="protocol">
              <fo:static-content flow-name="oddFoot">
                  <fo:block>
                      <xsl:value-of select="/order/id" />&nbsp;&ndash;&nbsp;<xsl:value-of select="/order/revision" />
                  </fo:block>
              </fo:static-content>

              <fo:static-content flow-name="evenFoot">
                  <!--<fo:block text-align="end">-->
                  <fo:block>
                      <xsl:value-of select="/order/id" />&nbsp;&ndash;&nbsp;<xsl:value-of select="/order/revision" />
                  </fo:block>
              </fo:static-content>
              <fo:flow flow-name="xsl-region-body">
                  <fo:block>
                      <fo:block font="12pt PT Serif" font-weight="bold" text-align="center">
                          ПРОТОКОЛ ЗАСЕДАНИЯ ПРИЕМНОЙ КОМИССИИ
                      </fo:block>
                      <fo:block font="12pt PT Serif" font-weight="bold" text-align="center">
                          МОСКОВСКОГО ГОСУДАРСТВЕННОГО УНИВЕРСИТЕТА ПЕЧАТИ ИМЕНИ ИВАНА ФЕДОРОВА
                      </fo:block>
                      <fo:block font="12pt PT Serif" space-before="5pt" font-weight="bold" text-align="center">
                          <xsl:apply-templates select="./name" />
                      </fo:block>
                      <fo:table table-layout="fixed" width="100%" space-after="8pt">
                          <fo:table-column column-width="proportional-column-width(1)" />
                          <fo:table-column column-width="proportional-column-width(2.5)" />
                          <fo:table-column column-width="proportional-column-width(1.2)" />
                          <fo:table-body>
                              <fo:table-row>
                                  <fo:table-cell>
                                      <fo:block font="12pt PT Serif" text-align="end">
                                          <xsl:choose>
                                              <xsl:when test="not(/order/sign/number)">
                                                  № __________________
                                              </xsl:when>
                                              <xsl:otherwise>
                                                  № <xsl:value-of select="/order/sign/number" />
                                              </xsl:otherwise>
                                          </xsl:choose>
                                      </fo:block>
                                  </fo:table-cell>
                                  <fo:table-cell>
                                      <fo:block />
                                  </fo:table-cell>
                                  <fo:table-cell>
                                      <fo:block font="12pt PT Serif">
                                          <xsl:choose>
                                              <xsl:when test="not(/order/sign/date)">
                                                  от &laquo;______&raquo; ______________ 2015 г.
                                              </xsl:when>
                                              <xsl:otherwise>
                                                  от &laquo;<xsl:value-of select="substring(/order/sign/date, 9, 2)" />&raquo;
                                                  <xsl:call-template name="month_name">
                                                      <xsl:with-param name="date" select="substring(/order/sign/date, 6, 2)" />
                                                  </xsl:call-template>&nbsp;
                                                  <xsl:value-of select="substring(/order/sign/date, 0, 5)" /> г.
                                              </xsl:otherwise>
                                          </xsl:choose>
                                      </fo:block>
                                  </fo:table-cell>
                              </fo:table-row>
                          </fo:table-body>
                      </fo:table>
                      <fo:block font="11pt PT Serif" space-before="8pt" font-weight="bold">
                          <xsl:value-of select="/order/students/student/speciality/new_code" />
                          &laquo;<xsl:value-of select="/order/students/student/speciality/name" />&raquo;
                      </fo:block>
                      <fo:block font="11pt PT Serif" space-before="2pt" font-weight="bold">
                          <xsl:choose>
                              <xsl:when test="'fulltime' = /order/students/student/group/form">Очная</xsl:when>
                              <xsl:when test="'semitime' = /order/students/student/group/form">Очно-заочная</xsl:when>
                              <xsl:when test="'postal' = /order/students/student/group/form">Заочная</xsl:when>
                              <xsl:when test="'distance' = /order/students/student/group/form">Заочная</xsl:when>
                          </xsl:choose> форма обучения, <xsl:if test="1 = /order/students/student/education_source"> бюджет</xsl:if>
                          <xsl:if test="2 = /order/students/student/education_source"> по договорам (внебюджетная)</xsl:if>
                      </fo:block>
                  </fo:block>

                  <fo:table font="11pt PT Serif" table-layout="fixed" width="100%" space-before="8pt">
                      <fo:table-column column-width="proportional-column-width(4.4)" />
                      <fo:table-column column-width="proportional-column-width(1)" />
                      <fo:table-column column-width="proportional-column-width(1)" />
                      <fo:table-body>
                          <fo:table-row>
                              <fo:table-cell>
                                  <fo:block>Председатель приемной комиссии</fo:block>
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block>Антипов К.В.</fo:block>
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block> _______________________________</fo:block>
                              </fo:table-cell>
                          </fo:table-row>
                          <fo:table-row>
                              <fo:table-cell>
                                  <fo:block>Зам. председателя приемной комиссии</fo:block>
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block>Маркелова Т.В.</fo:block>
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block> _______________________________</fo:block>
                              </fo:table-cell>
                          </fo:table-row>
                          <fo:table-row>
                              <fo:table-cell>
                                  <fo:block>Зам. председателя по приему в аспирантуру</fo:block>
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block>Назаров В.Г.</fo:block>
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block> _______________________________</fo:block>
                              </fo:table-cell>
                          </fo:table-row>
                          <fo:table-row>
                              <fo:table-cell>
                                  <fo:block>Ответственный секретарь</fo:block>
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block>Хохлогорская Е.Л.</fo:block>
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block> _______________________________</fo:block>
                              </fo:table-cell>
                          </fo:table-row>
                          <fo:table-row>
                              <fo:table-cell>
                                  <fo:block>Заместитель ответственного секретаря по бюджетному приему</fo:block>
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block>Боцман Ю.Ю.</fo:block>
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block> _______________________________</fo:block>
                              </fo:table-cell>
                          </fo:table-row>
                          <fo:table-row>
                              <fo:table-cell>
                                  <fo:block>Заместитель ответственного секретаря по приему в аспирантуру</fo:block>
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block>Ситникова Т.А.</fo:block>
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block> _______________________________</fo:block>
                              </fo:table-cell>
                          </fo:table-row>
                          <fo:table-row>
                              <fo:table-cell>
                                  <fo:block>Заместитель ответственного секретаря по проведению вступительных испытаний</fo:block>
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block>Алиева Д.В.</fo:block>
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block> _______________________________</fo:block>
                              </fo:table-cell>
                          </fo:table-row>
                          <fo:table-row>
                              <fo:table-cell>
                                  <fo:block>Заместитель ответственного секретаря по приему иностранных граждан</fo:block>
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block>Иванова И.А.</fo:block>
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block> _______________________________</fo:block>
                              </fo:table-cell>
                          </fo:table-row>
                          <fo:table-row>
                              <fo:table-cell>
                                  <fo:block>Заместитель ответственного секретаря</fo:block>
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block>Саркисова Е.Ю.</fo:block>
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block> _______________________________</fo:block>
                              </fo:table-cell>
                          </fo:table-row>
                      </fo:table-body>
                  </fo:table>
                  <fo:block font="12pt PT Serif" space-before="8pt">
                      Члены приемной комиссии
                  </fo:block>
                  <fo:table font="11pt PT Serif" table-layout="fixed" width="100%" space-before="8pt">
                      <fo:table-column column-width="proportional-column-width(0.9)" />
                      <fo:table-column column-width="proportional-column-width(1.1)" />
                      <fo:table-column column-width="proportional-column-width(0.3)" />
                      <fo:table-column column-width="proportional-column-width(0.9)" />
                      <fo:table-column column-width="proportional-column-width(1.1)" />
                      <fo:table-column column-width="proportional-column-width(0.3)" />
                      <fo:table-column column-width="proportional-column-width(0.9)" />
                      <fo:table-column column-width="proportional-column-width(1.1)" />
                      <fo:table-body>
                          <fo:table-row>
                              <fo:table-cell>
                                  <fo:block>Корытов О.В.</fo:block>
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block> _______________________________</fo:block>
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block />
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block>Горлов С.Ю.</fo:block>
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block> _______________________________</fo:block>
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block />
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block>Винокур А.И.</fo:block>
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block> _______________________________</fo:block>
                              </fo:table-cell>
                          </fo:table-row>
                          <fo:table-row>
                              <fo:table-cell>
                                  <fo:block>Кулаков В.В.</fo:block>
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block> _______________________________</fo:block>
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block />
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block>Столяров А.А.</fo:block>
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block> _______________________________</fo:block>
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block />
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block>Сидорова Н.В.</fo:block>
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block> _______________________________</fo:block>
                              </fo:table-cell>
                          </fo:table-row>
                          <fo:table-row>
                              <fo:table-cell>
                                  <fo:block>Дмитриев Я.В.</fo:block>
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block> _______________________________</fo:block>
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block />
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block>Миронова Г.В.</fo:block>
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block> _______________________________</fo:block>
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block />
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block>Перевалова Е.В.</fo:block>
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block> _______________________________</fo:block>
                              </fo:table-cell>
                          </fo:table-row>
                          <fo:table-row>
                              <fo:table-cell>
                                  <fo:block>Гордеева Е.Е.</fo:block>
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block> _______________________________</fo:block>
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block />
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block>Галицкий Д.В.</fo:block>
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block> _______________________________</fo:block>
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block />
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block>Шляга В.С.</fo:block>
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block> _______________________________</fo:block>
                              </fo:table-cell>
                          </fo:table-row>
                          <fo:table-row>
                              <fo:table-cell>
                                  <fo:block>Токмаков Б.В.</fo:block>
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block> _______________________________</fo:block>
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block />
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block>Голева О.П.</fo:block>
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block> _______________________________</fo:block>
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block />
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block>Толутанова Ю.Н.</fo:block>
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block> _______________________________</fo:block>
                              </fo:table-cell>
                          </fo:table-row>
                          <fo:table-row>
                              <fo:table-cell>
                                  <fo:block>Яковлев А.В.</fo:block>
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block> _______________________________</fo:block>
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block />
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block>Яковлев Р.В.</fo:block>
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block> _______________________________</fo:block>
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block />
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block>Самоделова Е.В.</fo:block>
                              </fo:table-cell>
                              <fo:table-cell>
                                  <fo:block> _______________________________</fo:block>
                              </fo:table-cell>
                          </fo:table-row>
                      </fo:table-body>
                  </fo:table>
                  <fo:block font="11pt PT Serif" space-before="10pt">
                      <xsl:apply-templates select="./content" />
                  </fo:block>
              </fo:flow>
          </fo:page-sequence>
      <!--</fo:root>-->
  </xsl:template>

    <xsl:template match="act">
      <fo:page-sequence master-reference="main">
        <fo:static-content flow-name="oddFoot">
          <fo:block>
            <xsl:value-of select="/order/id" />&nbsp;&ndash;&nbsp;<xsl:value-of select="/order/revision" />
          </fo:block>
        </fo:static-content>

        <fo:static-content flow-name="evenFoot">
          <fo:block>
            <xsl:value-of select="/order/id" />&nbsp;&ndash;&nbsp;<xsl:value-of select="/order/revision" />
          </fo:block>
        </fo:static-content>
        <fo:flow flow-name="xsl-region-body">
          <fo:block font="12pt PT Serif" text-indent="260">
              <fo:block>
                  УТВЕРЖДАЮ
              </fo:block>
              <fo:block space-before="5pt">
                     _____________________________________
              </fo:block>
              <fo:block>
                    Первый проректор по учебной работе
              </fo:block>
              <fo:block>
                    МГУП имени Ивана Федорова
              </fo:block>
              <fo:block>
                    Т.В. Маркелова
              </fo:block>
         </fo:block>
          <fo:block font="14pt PT Serif" space-before="15pt" font-weight="bold" text-align="center">
                АКТ
          </fo:block>
          <fo:block font="11pt PT Serif" space-before="15pt">
            <xsl:apply-templates select="./content" />
          </fo:block>
          <fo:block font="12pt PT Serif" space-before="40pt">
            <fo:table table-layout="fixed" width="100%" space-after="8pt">
              <fo:table-column column-width="proportional-column-width(1.2)" />
              <fo:table-column column-width="proportional-column-width(1)" />
              <fo:table-body>
                <fo:table-row>
                  <fo:table-cell>
                    <fo:block><xsl:apply-templates select="./act_employee/position" /></fo:block>
                  </fo:table-cell>
                  <fo:table-cell>
                    <fo:block text-align="end">__________________/<xsl:apply-templates select="./act_employee/name" />/</fo:block>
                  </fo:table-cell>
                </fo:table-row>
                <fo:table-row>
                  <fo:table-cell>
                      <fo:block> </fo:block>
                  </fo:table-cell>
                  <fo:table-cell>
                      <fo:block> </fo:block>
                  </fo:table-cell>
                </fo:table-row>
                 <fo:table-row>
                  <fo:table-cell>
                    <fo:block><xsl:apply-templates select="./act_ok/position" /></fo:block>
                  </fo:table-cell>
                  <fo:table-cell>
                    <fo:block text-align="end">__________________/<xsl:apply-templates select="./act_ok/name" />/</fo:block>
                  </fo:table-cell>
                 </fo:table-row>
              </fo:table-body>
            </fo:table>
          </fo:block>
        </fo:flow>
      </fo:page-sequence>
    </xsl:template>

  <!-- Абзац с выравниванием по левому краю -->
  <xsl:template match="lBlock">
    <fo:block font="12pt PT Serif" space-before="20pt" text-align="justify" text-align-last="start"
              text-indent="20pt">
      <xsl:apply-templates />
    </fo:block>
  </xsl:template>

    <xsl:template match="cBlock">
        <fo:block font="12pt PT Serif" space-before="5pt" text-align="justify" text-align-last="start"
                  text-indent="20pt">
            <xsl:apply-templates />
        </fo:block>
    </xsl:template>

  <xsl:template match="lBlockNoIndent">
     <fo:block font="11pt PT Serif" space-before="2pt" text-align="justify" text-align-last="start">
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

  <xsl:template match="iListInner">
    <fo:list-item>
      <fo:list-item-label end-indent="label-end()">
        <fo:block>
          <xsl:number format="1" />)
        </fo:block>
      </fo:list-item-label>
      <fo:list-item-body start-indent="body-start()">
        <fo:block>
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

    <xsl:template match="pListInner">
        <fo:list-item>
            <fo:list-item-label end-indent="label-end()">
                <fo:block>
                    <xsl:number format="1" />)
                </fo:block>
            </fo:list-item-label>
            <fo:list-item-body start-indent="body-start()">
                <fo:block>
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