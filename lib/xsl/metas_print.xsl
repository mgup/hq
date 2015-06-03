<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "entities.dtd">
<xsl:stylesheet version="1.0"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="xml" version="1.0" indent="yes" encoding="UTF-8" />

    <xsl:template match="meta_text_student">
        <xsl:variable name="pattern">
            <xsl:value-of select="@pattern" />
        </xsl:variable>

        <xsl:variable name="student">
            <xsl:value-of select="@student" />
        </xsl:variable>

        <xsl:value-of select="/order/metas/meta/object[text() = $student]/../pattern[text() = $pattern]/../value" />
    </xsl:template>

    <xsl:template match="meta_date_student">
        <xsl:variable name="pattern">
            <xsl:value-of select="@pattern" />
        </xsl:variable>

        <xsl:variable name="student">
            <xsl:value-of select="@student" />
        </xsl:variable>

        <xsl:value-of select="/order/metas/meta/object[text() = $student]/../pattern[text() = $pattern]/../value" />
    </xsl:template>

    <xsl:template match="meta_text_order">
        <xsl:variable name="pattern">
            <xsl:value-of select="@pattern" />
        </xsl:variable>

        <xsl:variable name="order">
            <xsl:value-of select="/order/id" />
        </xsl:variable>

        <xsl:value-of select="/order/metas/meta/object[text() = $order]/../pattern[text() = $pattern]/../value" />
    </xsl:template>

    <xsl:template match="meta_date_order">
        <xsl:variable name="pattern">
            <xsl:value-of select="@pattern" />
        </xsl:variable>

        <xsl:variable name="order">
            <xsl:value-of select="/order/id" />
        </xsl:variable>

        <xsl:value-of select="/order/metas/meta/object[text() = $order]/../pattern[text() = $pattern]/../value" />
    </xsl:template>

    <xsl:template match="meta_select_order">
        <xsl:variable name="pattern">
            <xsl:value-of select="@pattern" />
        </xsl:variable>

        <xsl:variable name="order">
            <xsl:value-of select="/order/id" />
        </xsl:variable>

        <xsl:value-of select="/order/metas/meta/object[text() = $order]/../pattern[text() = $pattern]/../value" />
    </xsl:template>

    <xsl:template match="meta_academic_year">
        <xsl:variable name="year">
            <xsl:value-of select="/order/metas/meta/pattern[text() = 'Учебный год']/../value" />
        </xsl:variable>

        <xsl:value-of select="$year" />/<xsl:value-of select="$year + 1" />
    </xsl:template>

    <xsl:template match="meta_check_student">
        <xsl:variable name="pattern">
            <xsl:value-of select="@pattern" />
        </xsl:variable>

        <xsl:variable name="student">
            <xsl:value-of select="@student" />
        </xsl:variable>

        <xsl:if test="1 = /order/metas/meta/object[text() = $student]/../pattern[text() = $pattern]/../value">, <xsl:value-of select="@pattern" /></xsl:if>
    </xsl:template>

    <xsl:template match="meta_employee_student">
        <xsl:variable name="pattern">
            <xsl:value-of select="@pattern" />
        </xsl:variable>

        <xsl:variable name="student">
            <xsl:value-of select="@student" />
        </xsl:variable>

        <xsl:value-of select="/order/metas/meta/object[text() = $student]/../pattern[text() = $pattern]/../value" />
    </xsl:template>

</xsl:stylesheet>