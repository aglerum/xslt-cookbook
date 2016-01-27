<xsl:stylesheet version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:fsul="https://www.lib.fsu.edu"
        xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" exclude-result-prefixes="xs xd">
        
        <xd:doc scope="stylesheet">
            <xd:desc>
                <xd:p><xd:b>Last updated: </xd:b>January 24, 2016</xd:p>
                <xd:p><xd:b>Author: </xd:b>Annie Glerum</xd:p>
                <xd:p><xd:b>Organization: </xd:b>Florida State University Libraries</xd:p>
                <xd:p><xd:b>Title: </xd:b>Functions for converting character references to UTF-8</xd:p>
                <xd:p><xd:b>Notes: </xd:b>This function was created to resolve charcter issues in Bepress metadata 
                    provided as a data dump in preparation to transform to MODS. (Note that metadata to be imported 
                    into Bepress is slightly different from metadata provided by Bepress as a data dump.) This program 
                    does not address all non-UTF-8 character references, and regex patterns in the analyze-string 
                    elements should be added to as new character references are found.</xd:p>
                <xd:p><xd:i>Associated XML table: </xd:i>unicode_map.xml</xd:p>               
            </xd:desc>
        </xd:doc>
    
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    <xsl:strip-space elements="*"/>
    
    <xd:doc>
        <xd:desc>
            <xd:p>
                <xd:b>fsul:strip-tags</xd:b>
            </xd:p>
            <xd:p>Function to strip HTLML tags from the title and summary fields. This is necessary for transformation to MARC21 or MODS but not for Bepress.</xd:p>
            <xd:p>Acknowledgement: Adapted from Joachim Selke: http://blog.joachim-selke.de/2011/01/stripping-html-tags-in-xslt/. Conditional updated to XPath 2.0.</xd:p>
        </xd:desc>
    </xd:doc>
    <!--    @param $string is the string to process  -->
    <xsl:function name="fsul:strip-tags">
        <xsl:param name="string" as="xs:string"/>
        <xsl:analyze-string select="$string" regex="(&lt;[A-Za-z]+&gt;)|(&lt;/[A-Za-z]+&gt;)|(&lt;br\s/&gt;)">
            <xsl:matching-substring>
                <xsl:value-of
                    select="
                    if (regex-group(1)) then
                    replace(regex-group(1), '&lt;[A-Za-z]+>', '')
                    else
                    if (regex-group(2)) then
                    replace(regex-group(2), '&lt;/[A-Za-z]+>', '')
                    else
                    if (regex-group(2)) then
                    replace(regex-group(3), '&lt;br\s/>', '')
                    else
                    ()"
                />
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:function>
    
    <xd:doc>
        <xd:desc>
            <xd:p>
                <xd:b>fsul:convert-curly</xd:b>
            </xd:p>
            <xd:p>
                <xd:b>Function to convert utf8 curly quotes characters found in Bepress metadata to
                    straight qotes.</xd:b>
            </xd:p>
            <xd:p/>
        </xd:desc>
    </xd:doc>
    
    <!--    @param $string is the string to process  -->
    <xsl:function name="fsul:convert-curly">
        <xsl:param name="string"/>
        <xsl:variable name="quote">
            <xsl:text>&quot;</xsl:text>
        </xsl:variable>
        <xsl:variable name="apos">
            <xsl:text>&apos;</xsl:text>
        </xsl:variable>
        
        <xsl:variable name="single-entity">
            <xsl:analyze-string select="$string"
                regex="â&#x80;&#x98;|â&#x80;&#x99;|â&#x80;&#x9a;|â&#x80;&#x9b;">
                <xsl:matching-substring>
                    <xsl:value-of
                        select="translate(.,.,$apos)
                        "/>
                </xsl:matching-substring>
                <xsl:non-matching-substring>
                    <xsl:value-of select="."/>
                </xsl:non-matching-substring>
            </xsl:analyze-string>
        </xsl:variable>
        
        <xsl:variable name="single-character">
            <xsl:analyze-string select="$single-entity" regex="(‘|’|`)">
                <xsl:matching-substring>
                    <xsl:value-of select="replace(.,'.',$apos)"/>
                </xsl:matching-substring>
                <xsl:non-matching-substring>
                    <xsl:value-of select="."/>
                </xsl:non-matching-substring>
            </xsl:analyze-string>
        </xsl:variable>
        
        <xsl:variable name="double-entity">
            <xsl:analyze-string select="$single-character"
                regex="â&#x80;&#x9c;|â&#x80;&#x9d;|â&#x80;&#x9e;|â&#x80;&#x9f;">
                <xsl:matching-substring>
                    <xsl:value-of
                        select="translate(.,.,$quote)
                        "/>
                </xsl:matching-substring>
                <xsl:non-matching-substring>
                    <xsl:value-of select="."/>
                </xsl:non-matching-substring>
            </xsl:analyze-string>
        </xsl:variable>
        
        <xsl:variable name="double-characters">
            <xsl:analyze-string select="$double-entity" regex="(“|”)">
                <xsl:matching-substring>
                    <xsl:value-of select="replace(.,'.',$quote)"/>
                </xsl:matching-substring>
                <xsl:non-matching-substring>
                    <xsl:value-of select="."/>
                </xsl:non-matching-substring>
            </xsl:analyze-string>
        </xsl:variable>
        
        <xsl:analyze-string select="$double-characters" regex="(\s¡°|¡±\s)">
            <xsl:matching-substring>
                <xsl:value-of select="replace(.,'.',$quote)"/>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:function>
    
    <xd:doc>
        <xd:desc>
            <xd:p>
                <xd:b>fsul:characters2utf8</xd:b>
            </xd:p>
            <xd:p>
                <xd:b>Purpose:</xd:b>Function to convert character references found in Bepress metadata to UTF-8 characters.
            </xd:p>
            <xd:p/>
        </xd:desc>
    </xd:doc>
    
    <xsl:function name="fsul:characters2utf8">
        <xsl:param name="string"/>
        <xsl:variable name="unicode-map" select="document('../tables/unicode_map.xml')/characters"/>
        
        <!-- ** Matches to <latin-literal> ** -->
        <!-- Starts a character then two entity references. Example: â&#x80;&#x94; â&#x80;&#x93;-->              
        <xsl:variable name="entities-double">      
            <xsl:analyze-string select="$string"
                regex="â&#x80;&#x83;|â&#x80;&#x96;|â&#x80;&#x95;|â&#x80;&#x93;|â&#x80;&#x94;|â&#x82;&#x82;|â&#x84;&#x83;|â&#x84;&#x93;|â&#x86;&#x90;|â&#x86;&#x91;|â&#x86;&#x92;|â&#x88;&#x82;|â&#x88;&#x86;|â&#x88;&#x92;|â&#x88;&#x92;|â&#x88;&#x99;|â&#x88;&#x9a;|â&#x88;&#x9b;|â&#x88;&#x9c;|â&#x88;&#x9d;|â&#x88;&#x9e;|â&#x8b;&#x85;|â&#x8b;&#x86;|â&#x89;&#x88;|â&#x94;&#x80;|Â¦Ã&#x81;|Â¦Ã&#x82;|Â¦Ã&#x8b;|Â¡Ã&#x96;|Â¡Ã&#x9c;|Â¡Ã&#x9d;|á¹&#x87;|ï¼&#x8d;">
                
                <xsl:matching-substring>
                    <xsl:value-of
                        select=" if ($unicode-map/unicode[latin-literal = current()]) then ($unicode-map/unicode[latin-literal = current()]/*[(self::character)]) else
                        (.)
                        "/>
                </xsl:matching-substring>
                <xsl:non-matching-substring>
                    <xsl:value-of select="."/>
                </xsl:non-matching-substring>
            </xsl:analyze-string>
        </xsl:variable>
        
        <!-- Starts a character then an entity references then a character. Example: â&#x88;¼. Note the space necessary in "Æ&#x92;Ã "  -->
        <xsl:variable name="entities-double-character">
            <xsl:analyze-string select="$entities-double"
                regex="â&#x88;¼|â&#x80;¦|â&#x89;¥|â&#x89;¤|â&#x80;¢|Æ&#x92;Ý|â&#x84;¢|â&#x84;«|â&#x80;°|ï&#x81;¡|Æ&#x92;¢|â&#x81;°|Ã&#x83;Â¶|Æ&#x92;Ã|â&#x80;²">
                <xsl:matching-substring>
                    <xsl:value-of
                        select="if ($unicode-map/unicode[latin-literal = current()]) then replace(.,.,$unicode-map/unicode[latin-literal = current()]/*[(self::character)]) else
                        (.)
                        "/>
                </xsl:matching-substring>
                <xsl:non-matching-substring>
                    <xsl:value-of select="."/>
                </xsl:non-matching-substring>
            </xsl:analyze-string>
        </xsl:variable>
        
        <!-- Starts with specific class of character then entity reference. Example: Ã&#x80; -->
        <xsl:variable name="entity-single">
            <xsl:analyze-string select="$entities-double-character"
                regex="â&#x89;|Ã&#x80;|Ã&#x81;|Ã&#x82;|Ã&#x83;|Ã&#x84;|Ã&#x85;|Ã&#x86;|Ã&#x87;|Ã&#x88;|Ã&#x89;|Ã&#x8a;|Ã&#x8b;|Ã&#x8c;|Ã&#x8d;|Ã&#x8e;|Ã&#x8f;|Ã&#x90;|Ã&#x91;|Ã&#x92;|Ã&#x93;|Ã&#x94;|Ã&#x95;|Ã&#x96;|Ã&#x97;|Ã&#x98;|Ã&#x99;|Ã&#x9a;|Ã&#x9b;|Ã&#x9c;|Ã&#x9d;|Ã&#x9e;|Ã&#x9f;|Ä&#x80;|Ä&#x81;|Ä&#x82;|Ä&#x83;|Ä&#x84;|Ä&#x85;|Ä&#x86;|Ä&#x87;|Ä&#x88;|Ä&#x89;|Ä&#x8a;|Ä&#x8b;|Ä&#x8c;|Ä&#x8d;|Ä&#x8e;|Ä&#x8f;|Ä&#x90;|Ä&#x91;|Ä&#x92;|Ä&#x93;|Ä&#x94;|Ä&#x95;|Ä&#x96;|Ä&#x97;|Ä&#x98;|Ä&#x99;|Ä&#x9a;|Ä&#x9b;|Ä&#x9c;|Ä&#x9d;|Ä&#x9e;|Ä&#x9f;|Å&#x80;|Å&#x81;|Å&#x82;|Å&#x83;|Å&#x84;|Å&#x85;|Å&#x86;|Å&#x87;|Å&#x88;|Å&#x89;|Å&#x8a;|Å&#x8b;|Å&#x8c;|Å&#x8d;|Å&#x8e;|Å&#x8f;|Å&#x90;|Å&#x91;|Å&#x92;|Å&#x93;|Å&#x94;|Å&#x95;|Å&#x96;|Å&#x97;|Å&#x98;|Å&#x99;|Å&#x9a;|Å&#x9b;|Å&#x9c;|Å&#x9d;|Å&#x9e;|Å&#x9f;|Ë&#x86;|Ë&#x87;|Ë&#x98;|Ë&#x99;|Ë&#x9a;|Ë&#x9b;|Ë&#x9c;|Ë&#x9d;|É&#x94;|Ì&#x91;|Î&#x91;|Î&#x92;|Î&#x93;|Î&#x94;|Î&#x95;|Î&#x96;|Î&#x97;|Î&#x98;|Î&#x99;|Î&#x9a;|Î&#x9b;|Î&#x9c;|Î&#x9d;|Î&#x9e;|Î&#x9f;|Ï&#x80;|Ï&#x81;|Ï&#x82;|Ï&#x83;|Ï&#x84;|Ï&#x85;|Ï&#x86;|Ï&#x87;|Ï&#x87;|Ï&#x88;|Ï&#x89;|Ï&#x91;|Ï&#x92;|Ï&#x95;|Ï&#x96;|Ï&#x87;|Ï&#x9c;|Ï&#x9d;|Ð&#x81;|Ð&#x82;|Ð&#x83;|Ð&#x84;|Ð&#x85;|Ð&#x86;|Ð&#x87;|Ð&#x88;|Ð&#x89;|Ð&#x8a;|Ð&#x8b;|Ð&#x8c;|Ð&#x8d;|Ð&#x8e;|Ð&#x8f;|Ð&#x90;|Ð&#x91;|Ð&#x92;|Ð&#x93;|Ð&#x94;|Ð&#x95;|Ð&#x96;|Ð&#x97;|Ð&#x98;|Ð&#x99;|Ð&#x9a;|Ð&#x9b;|Ð&#x9c;|Ð&#x9d;|Ð&#x9e;|Ð&#x9f;|Ñ&#x80;|Ñ&#x81;|Ñ&#x82;|Ñ&#x83;|Ñ&#x84;|Ñ&#x85;|Ñ&#x86;|Ñ&#x87;|Ñ&#x88;|Ñ&#x89;|Ñ&#x8a;|Ñ&#x8b;|Ñ&#x8c;|Ñ&#x8d;|Ñ&#x8e;|Ñ&#x8f;|Ñ&#x91;|Ñ&#x92;|Ñ&#x93;|Ñ&#x94;|Ñ&#x95;|Ñ&#x96;|Ñ&#x97;|Ñ&#x98;|Ñ&#x99;|Ñ&#x9a;|Ñ&#x9b;|Ñ&#x9c;|Ñ&#x9d;|Ñ&#x9e;|Ñ&#x9f;">
                <xsl:matching-substring>
                    <xsl:for-each select=".">
                        <xsl:value-of
                            select="if ($unicode-map/unicode[latin-literal = current()]) then replace(.,.,$unicode-map/unicode[latin-literal = current()]/*[(self::character)]) else
                            (.)
                            "/>
                    </xsl:for-each>
                </xsl:matching-substring>
                <xsl:non-matching-substring>
                    <xsl:value-of select="."/>
                </xsl:non-matching-substring>
            </xsl:analyze-string>
        </xsl:variable>
        
        <!-- Starts with specific class of characters followed by another class of characters. Example: Ã¡  -->
        <xsl:variable name="latin-double">  
            <xsl:analyze-string select="$entity-single"
                regex="[ÂÃÅÄÆÇÈÉÌÎÏÐ]{{1}}[¡¢£¤¥¦§¨©ª«¬®¯°±¹²³´µ¶·¸¹º»¼½¾¿­]{{1}}">
                <xsl:matching-substring>
                    <xsl:value-of
                        select="
                        if ($unicode-map/unicode[latin-literal = current()]) then ($unicode-map/unicode[latin-literal = current()]/*[(self::character)]) else
                        (.)
                        "/>
                </xsl:matching-substring>
                <xsl:non-matching-substring>
                    <xsl:value-of select="."/>
                </xsl:non-matching-substring>
            </xsl:analyze-string>
        </xsl:variable>
        
        <xsl:value-of select="fsul:convert-curly($latin-double)"/>
        
    </xsl:function>
        
</xsl:stylesheet>
