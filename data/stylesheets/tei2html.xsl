<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <xsl:output method="xhtml" indent="yes" encoding="utf-8" />

    <!-- XSLT normalization code from http://wiki.tei-c.org/index.php/XML_Whitespace -->

    <xsl:template match="text()">
        <xsl:choose>
            <xsl:when test="ancestor::*[@xml:space][1]/@xml:space='preserve'">
                <xsl:value-of select="." />
            </xsl:when>
            <xsl:otherwise>
                <!-- Retain one leading space if node isn't first, has
	     non-space content, and has leading space.-->
                <xsl:if test="position()!=1 and matches(.,'^\s') and normalize-space()!=''">
                    <xsl:text> </xsl:text>
                </xsl:if>
                <xsl:value-of select="." />
                <xsl:choose>
                    <!-- node is an only child, and has content but it's all space -->
                    <xsl:when test="last()=1 and string-length()!=0 and normalize-space()=''">
                        <xsl:text> </xsl:text>
                    </xsl:when>
                    <!-- node isn't last, isn't first, and has trailing space -->
                    <xsl:when test="position()!=1 and position()!=last() and matches(.,'\s$')">
                        <xsl:text> </xsl:text>
                    </xsl:when>
                    <!-- node isn't last, is first, has trailing space, and has non-space content   -->
                    <xsl:when test="position()=1 and matches(.,'\s$') and normalize-space()!=''">
                        <xsl:text> </xsl:text>
                    </xsl:when>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- End of code -->

    <xsl:template match="/">
        <html>
            <head>
                <title>
                    <xsl:value-of select="titleStmt/title" />
                </title>
                <link rel="stylesheet" type="text/css" href="../stylesheets/style.css" />
            </head>
            <body>
                <h1><xsl:value-of select="//repository" />, <xsl:value-of select="//msDesc/msIdentifier/idno" /></h1>
                <div class="summary">
                    <xsl:value-of select="//head" />
                </div>
                <div class="short_description">
                    <span class="short_description_data">
                        <xsl:value-of select="//origin//origDate" />
                    </span>
                    <span class="short_description_data">
                        <xsl:value-of select="//supportDesc/@material" />
                    </span>
                    <span class="short_description_data">
                        <xsl:text> ff. </xsl:text>
                        <xsl:number format="i" value="//supportDesc/extent/num[@type='left_flyleaves']/@value" />
                        <xsl:text>, </xsl:text>
                        <xsl:value-of select="//supportDesc/extent/num[@type='textblock_leaves']/@value" />
                        <xsl:text>, </xsl:text>
                        <xsl:number format="i" value="//supportDesc/extent/num[@type='right_flyleaves']/@value" />
                        <xsl:text>'</xsl:text>
                    </span>
                    <span class="short_description_data">
                        <xsl:value-of select="//support//dimensions[@type='leaf']/height/@quantity" />
                        <xsl:text> &#215; </xsl:text>
                        <xsl:value-of select="//support//dimensions[@type='leaf']/width/@quantity" />
                        <xsl:text> mm</xsl:text>
                    </span>
                    <span class="short_description_data">
                        <xsl:for-each select="//layoutDesc/layout/@writtenLines">
                            <xsl:if test="position() != last()">
                                <xsl:value-of select="concat(substring(., 1, 2), '&#8211;', substring(., 4, 5))" />
                                <xsl:text>, </xsl:text>
                            </xsl:if>
                            <xsl:if test="position() = last()">
                                <xsl:value-of select="concat(substring(., 1, 2), '&#8211;', substring(., 4, 5))" />
                                <xsl:text> ll.</xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </span>
                </div>
                <xsl:apply-templates />
            </body>
        </html>
    </xsl:template>

    <xsl:template match="q">
        <xsl:text>&#8216;</xsl:text>
        <xsl:apply-templates />
        <xsl:text>&#8217;</xsl:text>
    </xsl:template>

    <xsl:template match="biblScope|citedRange">
        <xsl:if test="@unit='volume'">
            <xsl:choose>
                <xsl:when test="@from = @to">
                    <span class="pages">vol. <xsl:value-of select="@from" />, </span>
                </xsl:when>
                <xsl:otherwise>
                    <span class="pages">vols. <xsl:value-of select="@from" />&#8211;<xsl:value-of select="@to" />, </span>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="@unit='page'">
            <xsl:choose>
                <xsl:when test="@from = @to">
                    <span class="pages">p. <xsl:value-of select="@from" /></span>
                </xsl:when>
                <xsl:otherwise>
                    <span class="pages">pp. <xsl:value-of select="@from" />&#8211;<xsl:value-of select="@to" /></span>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="@unit='footnote'">
            <span class="footnote"> n. <xsl:value-of select="@from" /></span>
        </xsl:if>
    </xsl:template>

    <xsl:template match="date">
        <xsl:if test="@from">
            <span class="date"><xsl:value-of select="@from" />&#8211;<xsl:value-of select="@to" /></span>
        </xsl:if>
        <xsl:if test="@when">
            <span class="date">
                <xsl:value-of select="@when" />
            </span>
        </xsl:if>
    </xsl:template>

    <xsl:template match="msItem/locusGrp">
        <xsl:text>(ff. </xsl:text>
        <xsl:for-each select="locus">
            <xsl:if test="position() != last()">
                <xsl:choose>
                    <xsl:when test="@from = @to">
                        <span class="locus"><xsl:value-of select="@from" />, </span>
                    </xsl:when>
                    <xsl:otherwise>
                        <span class="locus"><xsl:value-of select="@from" />&#8211;<xsl:value-of select="@to" />, </span>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <xsl:if test="position() = last()">
                <span class="locus"><xsl:value-of select="@from" />&#8211;<xsl:value-of select="@to" />)<xsl:text> </xsl:text></span>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="locusGrp">
        <xsl:text>ff. </xsl:text>
        <xsl:for-each select="locus">
            <xsl:if test="position() != last()">
                <xsl:choose>
                    <xsl:when test="@from = @to">
                        <span class="locus"><xsl:value-of select="@from" />, </span>
                    </xsl:when>
                    <xsl:otherwise>
                        <span class="locus"><xsl:value-of select="@from" />&#8211;<xsl:value-of select="@to" />, </span>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <xsl:if test="position() = last()">
                <span class="locus"><xsl:value-of select="@from" />&#8211;<xsl:value-of select="@to" /><xsl:text> </xsl:text></span>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="msItem//locus">
        <xsl:choose>
            <xsl:when test="@from = @to">
                <span class="locus">(f. <xsl:value-of select="@from" />)<xsl:text> </xsl:text></span>
            </xsl:when>
            <xsl:otherwise>
                <span class="locus">(ff. <xsl:value-of select="@from" />&#8211;<xsl:value-of select="@to" />)<xsl:text> </xsl:text></span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="locus">
        <xsl:choose>
            <xsl:when test="@from = @to">
                <span class="locus">f. <xsl:value-of select="@from" /><xsl:text> </xsl:text></span>
            </xsl:when>
            <xsl:otherwise>
                <span class="locus">ff. <xsl:value-of select="@from" />&#8211;<xsl:value-of select="@to" /><xsl:text> </xsl:text></span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="lb">
        <xsl:text> | </xsl:text>
        <xsl:apply-templates/>
    </xsl:template>



    <!-- CONTENTS -->

    <!--<xsl:template match="tei:msPart">
        <h2>Codicological Unit <xsl:apply-templates select="@n"/></h2>
    </xsl:template>-->

    <!--<xsl:template match="//msContents">
        <div class="msContents">
            <h2>Contents</h2>
            <xsl:for-each select="msItem">
                <div class="msItem">
                    <span class="msItem_nr"><xsl:value-of select="@n" />. </span>
                    <xsl:apply-templates select="node()[not(self::msItem)]" />
                    <!-\- Excludes msItems -\->
                    <xsl:for-each select="descendant::msItem">
                        <div class="sub_msItem">
                            <span class="sub_msItem_nr"><xsl:value-of select="@n" />. </span>
                            <xsl:apply-templates />
                        </div>
                    </xsl:for-each>
                </div>
            </xsl:for-each>
        </div>
    </xsl:template>-->

    <xsl:template match="msContents">
        <div class="msContents">
            <h2>Contents</h2>
            <xsl:for-each select="descendant::msItem">
                <div class="msItem">
                    <span class="msItem_nr">
                        <xsl:number level="multiple" count="msItem" format="1.1" />
                    </span>
                    <xsl:apply-templates />


                </div>
            </xsl:for-each>
        </div>
    </xsl:template>

    <xsl:template match="msItem/author">
        <xsl:choose>
            <xsl:when test="supplied">
                <span class="msItem_author">
                    <xsl:text>&#10216;</xsl:text>
                    <!-- Mathematical left angle bracket U+27E8 -->
                    <xsl:value-of select="normalize-space(.)" />
                    <!-- Removes whitespace before and after -->
                    <xsl:text>&#10217;,</xsl:text>
                    <!-- Mathematical right angle bracket U+27E9 -->
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span class="msItem_author">
                    <xsl:apply-templates />
                    <xsl:text>,</xsl:text>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="msItem/title">
        <span class="msItem_title">
            <xsl:text> </xsl:text>
            <xsl:value-of select="." />
        </span>
        <xsl:if test="@key">
            <span class="key">
                <xsl:text> (</xsl:text>
                <xsl:value-of select="@key" />
                <xsl:text>) </xsl:text>
            </span>
        </xsl:if>
    </xsl:template>

    <xsl:template match="msItem/rubric">
        <span class="msItem_rubric">
            <span class="msItem_rubric_head">Rubric: </span>
            <xsl:apply-templates />
        </span>
    </xsl:template>

    <xsl:template match="msItem/finalRubric">
        <span class="msItem_finalRubric">
            <span class="msItem_finalRubric_head">Final rubric: </span>
            <xsl:apply-templates />
        </span>
    </xsl:template>

    <xsl:template match="msItem/incipit">
        <span class="incipit">
            <span class="incipit_head">Incipit: </span>
            <xsl:apply-templates />
        </span>
    </xsl:template>

    <xsl:template match="msItem/explicit">
        <span class="explicit">
            <span class="explicit_head">Explicit: </span>
            <xsl:apply-templates />
        </span>
    </xsl:template>

    <xsl:template match="note">
        <span class="note">
            <span class="note_head">Note: </span>
            <xsl:apply-templates />
        </span>
    </xsl:template>

    <xsl:template match="list">
        <xsl:choose>
            <xsl:when test="@type='toc'">
                <xsl:for-each select="item">
                    <xsl:apply-templates />
                    <xsl:if test="position() != last()">
                        <xsl:text>; </xsl:text>
                    </xsl:if>
                    <xsl:if test="position() = last()">
                        <xsl:text>.</xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="@type='collation_formula'">
                <xsl:for-each select="item">
                    <xsl:text>Quire </xsl:text>
                    <xsl:number count="item" format="1" />
                    <xsl:text>: </xsl:text>
                    <xsl:apply-templates />
                    <xsl:value-of select="." />
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!--   <xsl:template match="msItem/note[@type='toc']">
        <xsl:for-each select="p">
            <xsl:apply-templates />
        <xsl:if test="position() != last()">
            <xsl:text>; </xsl:text>
        </xsl:if></xsl:for-each>
    </xsl:template>-->

    <xsl:template match="msItem/colophon">
        <span class="colophon">
            <span class="colophon_head">Colophon: </span>
            <xsl:apply-templates />
        </span>
    </xsl:template>

    <xsl:template match="msItem/filiation">
        <span class="note">
            <span class="note_head">Filiation: </span>
            <xsl:apply-templates />
        </span>
    </xsl:template>

    <!--<xsl:template match="tei:msItem/tei:bibl">
        <span class="msItem_bibl"><span class="msItem_bibl_head">Edition: </span>
        <xsl:apply-templates select="tei:author|tei:editor"/>
            <xsl:text>, </xsl:text>
            <xsl:apply-templates select="tei:title"/>
            <xsl:text> (</xsl:text>
            <xsl:apply-templates select="tei:pubPlace"/>
            <xsl:text> </xsl:text>
            <xsl:apply-templates select="tei:date"/>
            <xsl:text>) </xsl:text>
            <xsl:apply-templates select="tei:biblScope"/>        
        </span>        
    </xsl:template>-->

    <xsl:template match="msItem/listBibl">
        <span class="msItem_listBibl">
            <span class="msItem_listBibl_head">Edition(s): </span>
            <xsl:choose>
                <xsl:when test="bibl/ref">
                    <xsl:apply-templates />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:for-each select="bibl">
                        <xsl:apply-templates select="author|editor" />
                        <xsl:text>, </xsl:text>
                        <xsl:apply-templates select="title" />
                        <xsl:text> (</xsl:text>
                        <xsl:apply-templates select="pubPlace" />
                        <xsl:text> </xsl:text>
                        <xsl:apply-templates select="date" />
                        <xsl:text>) </xsl:text>
                        <xsl:apply-templates select="biblScope" />
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>
        </span>
    </xsl:template>

    <!-- <xsl:template match="tei:bibl/*">
        <xsl:element name="span">
            <xsl:attribute name="class"><xsl:value-of select="local-name()"/></xsl:attribute>
            <xsl:value-of select="."/>    
        </xsl:element>        
    </xsl:template>-->

    <!-- <xsl:template match="tei:listBibl/tei:bibl/*">
        <xsl:element name="span">
            <xsl:attribute name="class"><xsl:value-of select="local-name()"/></xsl:attribute>
            <xsl:value-of select="."/>    
        </xsl:element>        
    </xsl:template>-->


    <!-- PHYSICAL DESCRIPTION -->

    <xsl:template match="physDesc">
        <div class="physDesc">
            <h2>Physical description</h2>
            <xsl:apply-templates />
        </div>
    </xsl:template>

    <xsl:template match="support">
        <div class="supportDesc">
            <span class="supportDesc_head">Support: </span>
            <xsl:for-each select="p">
                <div>
                    <xsl:apply-templates select="node()[not(self::watermark)]" />
                </div>
                <!-- Excludes watermark -->
            </xsl:for-each>
        </div>
        <div class="watermarks">
            <span class="watermarks_head">Watermarks: </span>
            <xsl:for-each select="watermark">
                <span class="watermark_nr"><xsl:value-of select="@n" />. </span>
                <xsl:apply-templates />
            </xsl:for-each>
        </div>
    </xsl:template>







    <!-- <xsl:template match="tei:extent">
        <div class="extent">
            <span class="extent_head">Extent: </span>            
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:extent/tei:dimensions">
        <div class="dimensions">
            <span class="dimensions_head">Dimensions: </span>
            <xsl:apply-templates/>            
        </div>
    </xsl:template>-->

    <xsl:template match="height">
        <xsl:value-of select="@quantity" />
        <xsl:text> &#215; </xsl:text>
    </xsl:template>

    <xsl:template match="width">
        <xsl:value-of select="@quantity" />
        <xsl:text> mm.</xsl:text>
    </xsl:template>

    <xsl:template match="foliation">
        <div class="foliation">
            <span class="foliation_head">Foliation: </span>
            <xsl:apply-templates />
        </div>
    </xsl:template>

    <xsl:template match="collation">
        <div class="collation">
            <span class="collation_head">Collation: </span>
            <xsl:apply-templates />
        </div>
    </xsl:template>

    <xsl:template match="collation/locus">
        <sup>f. <xsl:value-of select="@to" /></sup>
    </xsl:template>

    <xsl:template match="supportDesc/condition">
        <div class="condition">
            <span class="condition_head">Condition: </span>
            <xsl:apply-templates />
        </div>
    </xsl:template>

    <xsl:template match="layoutDesc">
        <div class="layoutDesc">
            <span class="layoutDesc_head">Layout: </span>
            <xsl:for-each select="layout">
                <xsl:value-of select="@columns" />
                <xsl:text> col., </xsl:text>
                <xsl:value-of select="@writtenLines" />
                <xsl:text> ll. </xsl:text>
            </xsl:for-each>

        </div>
    </xsl:template>

    <xsl:template match="handDesc">
        <div class="handDesc">
            <span class="handDesc_head">Script: </span>
            <xsl:for-each select="handNote">
                <xsl:value-of select="@n" />
                <xsl:text>: </xsl:text>
                <xsl:apply-templates />
                <xsl:text> - </xsl:text>
            </xsl:for-each>
        </div>
    </xsl:template>

    <xsl:template match="physDesc/additions">
        <div class="additions">
            <span class="additions_head">Marginalia/Glossing/Notes: </span>
            <xsl:apply-templates />
        </div>
    </xsl:template>

    <xsl:template match="physDesc/bindingDesc">
        <div class="bindingDesc">
            <span class="bindingDesc_head">Binding: </span>
            <xsl:apply-templates />
        </div>
    </xsl:template>



    <xsl:template match="decoDesc">
        <div class="decoDesc">
            <span class="decoDesc_head">Decoration: </span>
            <xsl:apply-templates />
        </div>
    </xsl:template>





    <!-- HISTORY -->

    <xsl:template match="history">
        <div class="history">
            <h2>History</h2>
            <xsl:apply-templates />
        </div>
    </xsl:template>

    <xsl:template match="history/origin">
        <div class="origin">
            <span class="origin_head">Origin: </span>
            <xsl:apply-templates />
        </div>
    </xsl:template>

    <xsl:template match="history/provenance">
        <div class="provenance">
            <span class="provenance_head">Provenance: </span>
            <xsl:apply-templates />
        </div>
    </xsl:template>

    <xsl:template match="history/acquisition">
        <div class="acquisition">
            <span class="acquisition_head">Acquisition: </span>
            <xsl:apply-templates />
        </div>
    </xsl:template>


    <!-- ADDITIONAL -->

    <xsl:template match="additional">
        <div class="additional">
            <h2>Bibliography</h2>
            <xsl:apply-templates />
        </div>
    </xsl:template>

    <xsl:template match="additional/listBibl">
        <span class="additional_listBibl">
            <xsl:for-each select="element(bibl)">
                <span class="additional_listBibl_item">
                    <xsl:apply-templates select="author|editor" />
                    <xsl:apply-templates select="title" />
                    <xsl:text>, </xsl:text>
                    <xsl:apply-templates select="pubPlace" />
                    <xsl:text> </xsl:text>
                    <xsl:apply-templates select="date" />
                    <xsl:text>, </xsl:text>
                    <xsl:apply-templates select="citedRange" />.
                </span>
            </xsl:for-each>
        </span>
    </xsl:template>

    <!--<xsl:template match="tei:additional/@*">        
        <xsl:element name="span">
            <xsl:attribute name="class"><xsl:value-of select="local-name()"/></xsl:attribute>
            <xsl:value-of select="."/>    
        </xsl:element>  
    </xsl:template>-->

    <!--<xsl:template match="tei:listBibl">
        <div class="listBibl">            
            <xsl:for-each select="tei:bibl">                
                <span class="biblItem"><xsl:value-of select="."/></span>                                
            </xsl:for-each>            
        </div>
    </xsl:template>-->

    <xsl:template match="author|editor">
        <xsl:for-each select=".">
            <xsl:if test="position() != last()">
                <span class="bibl_author">
                    <xsl:for-each select="persName/forename">
                        <xsl:if test="position() != last()">
                            <xsl:value-of select="substring(., 1, 1)" />
                            <xsl:text>. </xsl:text>
                        </xsl:if>
                        <xsl:if test="position() = last()">
                            <xsl:value-of select="substring(., 1, 1)" />
                            <xsl:text>. </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:value-of select="persName/surname" />
                    <xsl:text>, </xsl:text>
                </span>
            </xsl:if>
            <xsl:if test="position() = last()">
                <span class="bibl_author">
                    <xsl:for-each select="persName/forename">
                        <xsl:if test="position() != last()">
                            <xsl:value-of select="substring(., 1, 1)" />
                            <xsl:text>. </xsl:text>
                        </xsl:if>
                        <xsl:if test="position() = last()">
                            <xsl:value-of select="substring(., 1, 1)" />
                            <xsl:text>. </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:value-of select="persName/surname" />
                    <xsl:text>, </xsl:text>
                </span>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="title">
        <xsl:if test="@level='a'">
            <span class="bibl_article_title">
                <xsl:text>&quot;</xsl:text>
                <xsl:apply-templates />
                <xsl:text>&quot;, </xsl:text>
            </span>
        </xsl:if>
        <xsl:if test="@level='m'">
            <span class="bibl_book_title">
                <xsl:apply-templates />
            </span>
        </xsl:if>
        <xsl:if test="@level='j'">
            <span class="bibl_journal_title">
                <xsl:apply-templates />
            </span>
        </xsl:if>
        <xsl:if test="@level='s'">
            <span class="bibl_series_title">
                <xsl:text>, </xsl:text>
                <xsl:apply-templates />
            </span>
        </xsl:if>
    </xsl:template>

    <xsl:template match="pubPlace">
        <span class="pubPlace">
            <xsl:apply-templates />
        </span>
    </xsl:template>

    <xsl:template match="hi[@rend='sup']">
        <sup>
            <xsl:apply-templates />
        </sup>
    </xsl:template>

    <xsl:template match="ex">
        <xsl:text>(</xsl:text>
        <xsl:value-of select="." />
        <xsl:text>)</xsl:text>
    </xsl:template>

    <xsl:template match="sic">
        <xsl:value-of select="." />
        <xsl:text> (!)</xsl:text>
    </xsl:template>

    <xsl:template match="supplied">
        <xsl:text>[</xsl:text>
        <xsl:value-of select="." />
        <xsl:text>]</xsl:text>
    </xsl:template>

    <!--<xsl:template match="tei:date">
        <span class="date"><xsl:apply-templates/>)</span>
    </xsl:template>-->

    <!-- <xsl:template match="biblScope[@unit='page']">
        <span class="bibl_volume">pp. <xsl:apply-templates />, </span>
    </xsl:template>-->

    <xsl:template match="titleStmt"> </xsl:template>

    <xsl:template match="head"> </xsl:template>

    <xsl:template match="publicationStmt"> </xsl:template>

    <xsl:template match="msIdentifier"> </xsl:template>

    <xsl:template match="revisionDesc"> </xsl:template>

</xsl:stylesheet>
