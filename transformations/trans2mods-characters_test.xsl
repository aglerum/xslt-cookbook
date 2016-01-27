<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:fsul="https://www.lib.fsu.edu"
    exclude-result-prefixes="xs xd fsul" version="2.0">

    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Last updated: </xd:b>January 24, 2016</xd:p>
            <xd:p><xd:b>Author: </xd:b>Annie Glerum</xd:p>
            <xd:p><xd:b>Organization: </xd:b>Florida State University Libraries</xd:p>
            <xd:p><xd:b>Title: </xd:b>TBepress metadata to MODS transformation for testing fsul:characters2utf8</xd:p>
        </xd:desc>
    </xd:doc>

    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    <xsl:strip-space elements="*"/>

    <xsl:include href="../functions/characters2utf8.xsl"/>

    <xsl:template match="/">
        <collection>
            <xsl:for-each select="documents/document">

                <mods>
                    <!-- **titleInfo** -->
                    <!-- With fsul:strip-tags -->
                    <titleInfo lang="eng">
                        <title>
                            <xsl:value-of select="fsul:strip-tags(title)"/>
                        </title>
                    </titleInfo>

                    <!-- Without fsul:strip-tags -->
                    <titleInfo lang="eng">
                        <title>
                            <xsl:value-of select="title"/>
                        </title>
                    </titleInfo>

                    <!-- **abstract** -->
                    <xsl:for-each select="abstract">
                        <xsl:variable name="strip-tags">
                            <xsl:value-of select="fsul:strip-tags(normalize-space(.))"/>
                        </xsl:variable>

                        <!-- With fsul:characters2utf8 -->
                        <abstract>
                            <xsl:value-of select="fsul:characters2utf8($strip-tags)"/>
                        </abstract>

                        <!-- Without fsul:characters2utf8 -->
                        <abstract>
                            <xsl:value-of select="$strip-tags"/>
                        </abstract>

                        <!-- Without fsul:characters2utf8 or fsul:strip-tags-->
                        <abstract>
                            <xsl:value-of select="."/>
                        </abstract>

                    </xsl:for-each>

                </mods>

            </xsl:for-each>
        </collection>
    </xsl:template>

</xsl:stylesheet>
