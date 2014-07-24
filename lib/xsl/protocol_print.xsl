<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "entities.dtd">
<xsl:stylesheet version="1.0"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="xml" version="1.0" indent="yes" encoding="UTF-8" />

    <xsl:include href="utilities.xsl" />

    <xsl:template match="protocol">
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
            </fo:layout-master-set>

            <fo:page-sequence master-reference="main">
                <fo:flow flow-name="xsl-region-body">
                    <fo:block>
                        <!--<fo:block font="12pt PT Serif" text-align="right" space-after="13pt">-->
                            <!--Приложение № <xsl:value-of select="position()" />-->
                        <!--</fo:block>-->
                        <fo:block font="12pt PT Serif" font-weight="bold" text-align="center">
                            ПРОТОКОЛ ЗАСЕДАНИЯ ПРИЕМНОЙ КОМИССИИ
                        </fo:block>
                        <fo:block font="12pt PT Serif" font-weight="bold" text-align="center">
                            МОСКОВСКОГО ГОСУДАРСТВЕННОГО УНИВЕРСИТЕТА ПЕЧАТИ ИМЕНИ ИВАНА ФЕДОРОВА
                        </fo:block>
                        <fo:block font="12pt PT Serif" space-before="5pt" font-weight="bold" text-align="center">
                            <xsl:apply-templates select="name" />
                        </fo:block>
                        <fo:block font="11pt PT Serif" space-before="15pt">
                            от &laquo;______&raquo; _______________ 2014 г.
                        </fo:block>
                        <fo:block font="12pt PT Serif" space-before="10pt" font-weight="bold">
                            Направление: <xsl:value-of select="/protocol/speciality/new_code" />
                            &laquo;<xsl:value-of select="/protocol/speciality/name" />&raquo;
                        </fo:block>
                        <fo:block font="12pt PT Serif" space-before="3pt" font-weight="bold">
                            Форма обучения: 
                            <xsl:choose>
                                <xsl:when test="101 = /protocol/form">очная</xsl:when>
                                <xsl:when test="102 = /protocol/form">очно-заочная</xsl:when>
                                <xsl:when test="103 = /protocol/form">заочная</xsl:when>
                            </xsl:choose>
                        </fo:block>
                        <fo:block font="12pt PT Serif" space-before="3pt" font-weight="bold">
                            Основа обучения:
                            <xsl:if test="1 = /order/students/student/education_source"> бюджет</xsl:if>
                            <xsl:if test="2 = /order/students/student/education_source"> контракт</xsl:if>
                        </fo:block>
                    </fo:block>

                    <fo:table font="11pt PT Serif" table-layout="fixed" width="100%" space-before="15pt">
                        <fo:table-column column-width="proportional-column-width(2.5)" />
                        <fo:table-column column-width="proportional-column-width(1)" />
                        <fo:table-column column-width="proportional-column-width(1)" />
                        <fo:table-body>
                            <fo:table-row>
                                <fo:table-cell>
                                    <fo:block>Председатель приёмной комиссии</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block>Антипов К.В.</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block>______________________</fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                            <fo:table-row>
                                <fo:table-cell>
                                    <fo:block>Зам. председателя приёмной комиссии</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block>Маркелова Т.В.</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block>______________________</fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                            <fo:table-row>
                                <fo:table-cell>
                                    <fo:block>Зам. председателя по приёму в аспирантуру</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block>Назаров В.Г.</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block>______________________</fo:block>
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
                                    <fo:block>______________________</fo:block>
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
                                    <fo:block>______________________</fo:block>
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
                                    <fo:block>______________________</fo:block>
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
                                    <fo:block>______________________</fo:block>
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
                                    <fo:block>______________________</fo:block>
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
                                    <fo:block>______________________</fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                        </fo:table-body>
                    </fo:table>
                    <fo:block font="12pt PT Serif" space-before="10pt">
                        Члены приемной комиссии
                    </fo:block>
                    <fo:table font="11pt PT Serif" table-layout="fixed" width="100%" space-before="10pt">
                        <fo:table-column column-width="proportional-column-width(1)" />
                        <fo:table-column column-width="proportional-column-width(1)" />
                        <fo:table-column column-width="proportional-column-width(0.2)" />
                        <fo:table-column column-width="proportional-column-width(1)" />
                        <fo:table-column column-width="proportional-column-width(1)" />
                        <fo:table-body>
                            <fo:table-row>
                                <fo:table-cell>
                                    <fo:block>Корытов О.В.</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block>______________________</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block />
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block>Горлов С.Ю.</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block>______________________</fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                            <fo:table-row>
                                <fo:table-cell>
                                    <fo:block>Винокур А.И.</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block>______________________</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block />
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block>Столяров А.А.</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block>______________________</fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                            <fo:table-row>
                                <fo:table-cell>
                                    <fo:block>Кулаков В.В.</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block>______________________</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block />
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block>Сидорова Н.В.</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block>______________________</fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                            <fo:table-row>
                                <fo:table-cell>
                                    <fo:block>Миронова Г.В.</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block>______________________</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block />
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block>Перевалова Е.В.</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block>______________________</fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                            <fo:table-row>
                                <fo:table-cell>
                                    <fo:block>Дмитриев Я.В.</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block>______________________</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block />
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block>Галицкий Д.В.</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block>______________________</fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                            <fo:table-row>
                                <fo:table-cell>
                                    <fo:block>Гордеева Е.Е.</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block>______________________</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block />
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block>Шляга В.С.</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block>______________________</fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                            <fo:table-row>
                                <fo:table-cell>
                                    <fo:block>Голева О.П.</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block>______________________</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block />
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block>Толутанова Ю.Н.</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block>______________________</fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                            <fo:table-row>
                                <fo:table-cell>
                                    <fo:block>Токмаков Б.В.</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block>______________________</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block />
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block>Яковлев Р.В.</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block>______________________</fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                            <fo:table-row>
                                <fo:table-cell>
                                    <fo:block>Яковлев А.В.</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block>______________________</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block />
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block />
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block />
                                </fo:table-cell>
                            </fo:table-row>
                        </fo:table-body>
                    </fo:table>
                    <fo:block font="11pt PT Serif" space-before="25pt">
                        <xsl:apply-templates select="content" />
                    </fo:block>
                </fo:flow>
            </fo:page-sequence>
        </fo:root>
    </xsl:template>

    <!-- Абзац с выравниванием по левому краю -->
    <xsl:template match="lBlock">
        <fo:block font="12pt PT Serif" space-before="20pt" text-align="justify" text-align-last="start"
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