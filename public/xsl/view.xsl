<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "../entities.dtd">
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" version="1.0" indent="yes" encoding="UTF-8" />

  <!--<xsl:include href="../utilities.xsl" />-->
  <!--<xsl:include href="../metas.xsl" />-->

  <xsl:template match="order">
    <div class="order-view">
      <p style="text-align: center; font-weight: bold; font-size: 17px; margin-bottom: 0;">МИНИСТЕРСТВО ОБРАЗОВАНИЯ И НАУКИ РОССИЙСКОЙ ФЕДЕРАЦИИ</p>
      <p style="text-align: center; font-weight: bold; margin-bottom: 3px; font-size: 16px;">федеральное государственное бюджетное образовательное<br />учреждение высшего профессионального образования</p>
      <p style="text-align: center; font-weight: bold; font-size: 16px; padding-bottom: 3px; margin-bottom: 20px; border-bottom: 3px solid black;">&laquo;МОСКОВСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПЕЧАТИ ИМЕНИ ИВАНА ФЕДОРОВА&raquo;</p>
      <p style="text-align: center; font-weight: bold; margin: 10px 0 5px 0;">ПРИКАЗ</p>
    </div>
  </xsl:template>

</xsl:stylesheet>