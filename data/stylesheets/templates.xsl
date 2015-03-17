<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0">

    <xsl:template name="makeLang">
        <xsl:if test="@xml:lang">
            <xsl:attribute name="lang" select="@xml:lang" />
        </xsl:if>
    </xsl:template>

    <xsl:template match="*">
        <xsl:if test="@xml:lang='la'">
            <em>
                <xsl:apply-templates />
            </em>
        </xsl:if>
    </xsl:template>

    <!-- TEI -->

    <xsl:template match="acquisition">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="add">
        <xsl:value-of select="." />
        <xsl:text> added </xsl:text>
        <xsl:value-of select="@place" />
    </xsl:template>

    <xsl:template match="additional">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="altIdentifier">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="author|editor">
        <xsl:choose>
            <xsl:when test="parent::msItem">
                <span class="msItem_author">
                    <xsl:apply-templates select="persName" />
                </span>
                <xsl:text>, </xsl:text>
            </xsl:when>
            <xsl:otherwise>
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
                        </span>
                    </xsl:if>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- authority -->

    <!-- availability -->

    <xsl:template match="bibl">
        <xsl:choose>
            <xsl:when test="parent::msItem">
                <div class="msItem_bibl">
                    <span class="head">Edition: </span>
                    <xsl:choose>
                        <xsl:when test="@type='edition'">
                            <xsl:value-of select="normalize-space(author)" />
                            <xsl:text>, </xsl:text>
                            <xsl:apply-templates select="title" />
                            <xsl:text>, ed. </xsl:text>
                            <xsl:apply-templates select="editor" />
                            <xsl:text> (</xsl:text>
                            <xsl:apply-templates select="pubPlace" />
                            <xsl:text> </xsl:text>
                            <xsl:apply-templates select="date" />
                            <xsl:text>) </xsl:text>
                            <xsl:apply-templates select="citedRange" />
                        </xsl:when>
                        <xsl:when test="child::title[@type='short']">
                            <xsl:apply-templates select="title[@type='short']" />
                            <xsl:text> </xsl:text>
                            <!--<xsl:apply-templates select="biblScope" />-->
                            <xsl:apply-templates select="citedRange" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="author|editor" />
                            <xsl:text>, </xsl:text>
                            <xsl:apply-templates select="title" />
                            <xsl:text> (</xsl:text>
                            <xsl:apply-templates select="pubPlace" />
                            <xsl:text> </xsl:text>
                            <xsl:apply-templates select="date" />
                            <xsl:text>) </xsl:text>
                            <!--<xsl:apply-templates select="biblScope" />-->
                            <xsl:apply-templates select="citedRange" />
                        </xsl:otherwise>
                    </xsl:choose>
                </div>
            </xsl:when>
            <xsl:when test="child::title[@type='short']">
                <a href="#" class="shortTitle" data-trigger="click" data-toggle="popover" data-content="{data(editor)}, {data(title[@type='main'])}">
                    <xsl:apply-templates select="title[@type='short']" />
                </a>
                <xsl:text> </xsl:text>
                <xsl:apply-templates select="biblScope" />
                <xsl:apply-templates select="citedRange" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="author|editor" />
                <xsl:text>, </xsl:text>
                <xsl:apply-templates select="title" />
                <xsl:text> (</xsl:text>
                <xsl:apply-templates select="pubPlace" />
                <xsl:text> </xsl:text>
                <xsl:apply-templates select="date" />
                <xsl:text>) </xsl:text>
                <xsl:apply-templates select="biblScope" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="biblScope|citedRange">
        <xsl:choose>
            <xsl:when test="@unit='volume'">
                <xsl:choose>
                    <xsl:when test="following-sibling::citedRange">
                        <xsl:choose>
                            <xsl:when test="@from = @to">
                                <xsl:text>vol. </xsl:text>
                                <xsl:value-of select="@from" />
                                <xsl:text>, </xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>vols. </xsl:text>
                                <xsl:value-of select="@from" />&#8211;<xsl:value-of select="@to" />
                                <xsl:text>, </xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="@from = @to">
                                <xsl:text>vol. </xsl:text>
                                <xsl:value-of select="@from" />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>vols. </xsl:text>
                                <xsl:value-of select="@from" />&#8211;<xsl:value-of select="@to" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="@unit='page'">
                <xsl:choose>
                    <xsl:when test="@from = @to">
                        <xsl:text>p. </xsl:text>
                        <xsl:value-of select="@from" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>pp. </xsl:text>
                        <xsl:value-of select="@from" />&#8211;<xsl:value-of select="@to" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="@unit='column'">
                <xsl:choose>
                    <xsl:when test="@from = @to">
                        <xsl:text>col. </xsl:text>
                        <xsl:value-of select="@from" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>cols. </xsl:text><xsl:value-of select="@from" />&#8211;<xsl:value-of select="@to" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="@unit='footnote'">
                <xsl:text>, n. </xsl:text>
                <xsl:value-of select="@from" />
            </xsl:when>
            <xsl:when test="@unit='number'">
                <xsl:choose>
                    <xsl:when test="@from = @to">
                        <xsl:text>no. </xsl:text>
                        <xsl:value-of select="@from" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>nos. </xsl:text><xsl:value-of select="@from" />&#8211;<xsl:value-of select="@to" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="bindingDesc">
        <xsl:apply-templates />
    </xsl:template>

    <!--  Body  -->

    <xsl:template match="catchwords">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="change">
        <xsl:if test="position() = 1">
            <xsl:text>Last revision: </xsl:text>
            <xsl:value-of select="@when" />
        </xsl:if>
    </xsl:template>

    <!--  CitedRange, see biblScope  -->

    <xsl:template match="collation">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="colophon">
        <div class="colophon">
            <span class="head">Colophon: </span>
            <xsl:apply-templates />
        </div>
    </xsl:template>

    <xsl:template match="condition">
        <div class="condition">
            <span class="head">Condition: </span>
            <xsl:apply-templates />
        </div>
    </xsl:template>

    <!--  Country  -->

    <xsl:template match="date">
        <xsl:if test="@from">
            <xsl:value-of select="@from" />
            <xsl:text>&#8211;</xsl:text>
            <xsl:value-of select="@to" />
        </xsl:if>
        <xsl:if test="@when">
            <xsl:value-of select="@when" />
        </xsl:if>
        <xsl:if test="text()">
            <xsl:apply-templates />
        </xsl:if>
    </xsl:template>

    <xsl:template match="decoDesc">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="decoNote">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="del">
        <xsl:value-of select="." />
        <xsl:text> deleted, </xsl:text>
    </xsl:template>

    <xsl:template match="depth">
        <xsl:if test="@quantity">
            <xsl:value-of select="@quantity" />
        </xsl:if>
        <xsl:if test="@min">
            <xsl:value-of select="@min" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="@max" />
        </xsl:if>
        <xsl:text> mm</xsl:text>
    </xsl:template>

    <!--  desc  -->

    <xsl:template match="dimensions">
        <xsl:if test="@type='written'">
            <em>Written area: </em>
            <xsl:apply-templates />
        </xsl:if>
        <xsl:if test="@type='binding'">
            <em>Binding dimensions: </em>
            <xsl:apply-templates />
        </xsl:if>
        <xsl:if test="@type='wm'">
            <em>Watermark dimensions: </em>
            <xsl:apply-templates />
        </xsl:if>
        <xsl:if test="@type='chain-lines'">
            <em>Chainlines: </em>
            <xsl:apply-templates />
        </xsl:if>
        <xsl:if test="@type='leaf'">
            <xsl:text>(</xsl:text>
            <xsl:apply-templates />
            <xsl:text>)</xsl:text>
        </xsl:if>
    </xsl:template>

    <!--  div -->

    <xsl:template match="ex">
        <xsl:text>(</xsl:text>
        <xsl:value-of select="." />
        <xsl:text>)</xsl:text>
    </xsl:template>

    <xsl:template match="explicit">
        <div class="explicit">
            <h4>Explicit: </h4>
            <xsl:apply-templates />
        </div>
    </xsl:template>

    <!--  extent  -->

    <!--  facsimile  -->

    <!--  fileDesc  -->

    <xsl:template match="filiation">
        <div class="note">
            <xsl:if test="@type='protograph'">
                <h4>Protograph: </h4>
                <xsl:apply-templates />
            </xsl:if>
            <xsl:if test="@type='apograph'">
                <h4>Apograph: </h4>
                <xsl:apply-templates />
            </xsl:if>
            <xsl:if test="@type='siglum'">
                <h4>Sigla: </h4>
                <xsl:apply-templates />
            </xsl:if>
        </div>
    </xsl:template>

    <xsl:template match="finalRubric">
        <div class="msItem_finalRubric">
            <h4>Final rubric: </h4>
            <xsl:apply-templates />
        </div>
    </xsl:template>

    <xsl:template match="foliation">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="foreign">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="formula">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="gap">
        <!--FIX-->
        <xsl:apply-templates />
    </xsl:template>

    <!--  graphic  -->

    <!--  handDesc  -->

    <xsl:template match="handNote">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="head">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="height">
        <xsl:if test="@quantity">
            <xsl:value-of select="@quantity" />
            <xsl:text> &#215; </xsl:text>
        </xsl:if>
        <xsl:if test="@min">
            <xsl:value-of select="@min" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="@max" />
            <xsl:text> &#215; </xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template match="hi">
        <xsl:if test="@rend='super'">
            <sup>
                <xsl:apply-templates />
            </sup>
        </xsl:if>
        <xsl:if test="@rend='sub'">
            <sub>
                <xsl:apply-templates />
            </sub>
        </xsl:if>
    </xsl:template>

    <xsl:template match="history" name="history">
        <div class="origin">
            <h4>Origin: </h4>
            <p>
                <xsl:apply-templates select="//msDesc/history/origin" />
            </p>
            <xsl:for-each select="//msPart/history/origin">
                <p>
                    <span class="unit_nr">Unit <xsl:number count="msPart" format="I" />: </span>
                    <xsl:apply-templates select="." />
                </p>
            </xsl:for-each>
        </div>
        <div class="provenance">
            <h4>Provenance: </h4>
            <xsl:for-each select="//provenance">
                <p>
                    <xsl:apply-templates select="." />
                </p>
            </xsl:for-each>
        </div>
        <!--<div class="formerShelfmarks">
            <xsl:apply-templates select="//idno" />
        </div>-->
        <div class="acquisition">
            <h4>Acquisition: </h4>
            <xsl:apply-templates select="//acquisition" />
        </div>
    </xsl:template>

    <xsl:template match="idno">
        <xsl:choose>
            <xsl:when test="@type='former_shelfmark'">
                <h4>Former shelfmarks: </h4>
                <xsl:for-each select="idno">
                    <xsl:apply-templates />
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="incipit">
        <div class="incipit">
            <h4>Incipit: </h4>
            <xsl:apply-templates />
        </div>
    </xsl:template>

    <!-- institution -->

    <!-- item -->

    <!-- layout -->

    <xsl:template match="layoutDesc">
        <xsl:for-each select="layout">
            <p>
                <xsl:apply-templates select="locus|locusGrp" />
                <!-- Only show columns when greater than 1 -->
                <xsl:if test="@columns[. gt '1']">
                    <xsl:value-of select="@columns" />
                    <xsl:text> columns, </xsl:text>
                </xsl:if>
                <xsl:if test="@ruledLines">
                    <xsl:value-of select="concat(substring(@ruledLines, 1, 2), '&#8211;', substring(@ruledLines, 4, 5))" />
                    <xsl:text> ruled lines, </xsl:text>
                </xsl:if>
                <xsl:if test="@writtenLines">
                    <xsl:choose>
                        <!-- Check for min and max values -->
                        <xsl:when test="substring(@writtenLines, 4, 5)">
                            <xsl:value-of select="concat(substring(@writtenLines, 1, 2), '&#8211;', substring(@writtenLines, 4, 5))" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="substring(@writtenLines, 1, 2)" />
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:text> written lines. </xsl:text>
                </xsl:if>
                <xsl:apply-templates select="dimensions" />
                <xsl:apply-templates select="note" />
            </p>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="lb">
        <xsl:text> | </xsl:text>
        <xsl:apply-templates />
    </xsl:template>

    <!-- licence -->

    <xsl:template match="list">
        <xsl:choose>
            <xsl:when test="@type='toc'">
                <xsl:for-each select="item">
                    <xsl:if test="position() != last()">
                        <xsl:apply-templates select="locus|locusGrp" />
                        <xsl:value-of select="normalize-space(.)" />
                        <xsl:text>; </xsl:text>
                    </xsl:if>
                    <xsl:if test="position() = last()">
                        <xsl:apply-templates select="locus|locusGrp" />
                        <xsl:value-of select="normalize-space(.)" />
                    </xsl:if>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="listBibl">
        <xsl:choose>
            <xsl:when test="parent::msItem">
                <div class="msItem_listBibl">
                    <h4>Editions: </h4>
                    <xsl:for-each select="bibl">
                        <p>
                            <xsl:choose>
                                <xsl:when test="@type='edition'">
                                    <xsl:apply-templates select="author" />
                                    <!--<xsl:value-of select="normalize-space(author)" />-->
                                    <xsl:text>, </xsl:text>
                                    <xsl:apply-templates select="title" />
                                    <xsl:text> (</xsl:text>
                                    <xsl:apply-templates select="pubPlace" />
                                    <xsl:text> </xsl:text>
                                    <xsl:apply-templates select="date" />
                                    <xsl:text>) </xsl:text>
                                    <xsl:apply-templates select="citedRange" />
                                </xsl:when>
                                <xsl:when test="child::title[@type='short']">
                                    <xsl:apply-templates select="title[@type='short']" />
                                    <xsl:text> </xsl:text>
                                    <xsl:apply-templates select="biblScope" />
                                    <xsl:apply-templates select="citedRange" />
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:apply-templates select="author|editor" />
                                    <xsl:text>, </xsl:text>
                                    <xsl:apply-templates select="title" />
                                    <xsl:text> (</xsl:text>
                                    <xsl:apply-templates select="pubPlace" />
                                    <xsl:text> </xsl:text>
                                    <xsl:apply-templates select="date" />
                                    <xsl:text>) </xsl:text>
                                    <xsl:apply-templates select="biblScope" />
                                    <xsl:apply-templates select="citedRange" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </p>
                    </xsl:for-each>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <span class="additional_listBibl">
                    <xsl:for-each select="element(bibl)">
                        <span class="additional_listBibl_item">
                            <xsl:choose>
                                <xsl:when test="title[@level='a']">
                                    <xsl:apply-templates select="author|editor" />
                                    <xsl:text>, </xsl:text>
                                    <xsl:apply-templates select="title[@level='a']" />
                                    <xsl:text>, </xsl:text>
                                    <xsl:apply-templates select="title[@level='j']" />
                                    <xsl:text> </xsl:text>
                                    <xsl:apply-templates select="biblScope[@unit='volume']" />
                                    <xsl:text> (</xsl:text>
                                    <xsl:apply-templates select="date" />
                                    <xsl:text>) </xsl:text>
                                    <xsl:if test="biblScope">
                                        <xsl:apply-templates select="biblScope[@unit='page']" />
                                    </xsl:if>
                                    <xsl:if test="citedRange">
                                        <xsl:text> [</xsl:text>
                                        <xsl:apply-templates select="citedRange" />
                                        <xsl:text>].</xsl:text>
                                    </xsl:if>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:apply-templates select="author|editor" />
                                    <xsl:text>, </xsl:text>
                                    <xsl:apply-templates select="title" />
                                    <xsl:text> (</xsl:text>
                                    <xsl:apply-templates select="pubPlace" />
                                    <xsl:if test="exists(pubPlace)">
                                        <xsl:text> </xsl:text>
                                    </xsl:if>
                                    <xsl:apply-templates select="date" />
                                    <xsl:text>) </xsl:text>
                                    <xsl:if test="biblScope">
                                        <xsl:apply-templates select="biblScope[@unit='page']" />
                                    </xsl:if>
                                    <xsl:if test="citedRange">
                                        <xsl:text> [</xsl:text>
                                        <xsl:apply-templates select="citedRange" />
                                        <xsl:text>].</xsl:text>
                                    </xsl:if>
                                    <xsl:text>.</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </span>
                    </xsl:for-each>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--<xsl:template match="locus">
        <xsl:choose>
            <xsl:when test="parent::msItem">
                <xsl:if test="@scheme='folios'">
                    <xsl:choose>
                        <xsl:when test="@from = @to">
                            <span class="locus">(f. <a href="#{data(//msDesc/@xml:id)}-{data(@from)}"><xsl:value-of select="@from" /></a>)<xsl:text> </xsl:text></span>
                        </xsl:when>
                        <xsl:otherwise>
                            <span class="locus">(ff. <a href="#{data(//msDesc/@xml:id)}-{data(@from)}"><xsl:value-of select="@from" /></a>&#8211;<a href="#{data(//msDesc/@xml:id)}-{data(@to)}"><xsl:value-of select="@to" /></a>)<xsl:text> </xsl:text></span>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
                <xsl:if test="@scheme='pages'">
                    <xsl:choose>
                        <xsl:when test="@from = @to">
                            <span class="locus">(p. <a href="#{data(//msDesc/@xml:id)}-{data(@from)}"><xsl:value-of select="@from" /></a>)<xsl:text> </xsl:text></span>
                        </xsl:when>
                        <xsl:otherwise>
                            <span class="locus">(pp. <a href="#{data(//msDesc/@xml:id)}-{data(@from)}"><xsl:value-of select="@from" /></a>&#8211;<a href="#{data(//msDesc/@xml:id)}-{data(@to)}"><xsl:value-of select="@to" /></a>)<xsl:text> </xsl:text></span>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="@scheme='folios'">
                    <xsl:choose>
                        <xsl:when test="@from = @to">
                            <span class="locus">f. 
                                <a href="#{data(//msDesc/@xml:id)}-{data(@from)}"><xsl:value-of select="@from" /></a>
                            </span>
                        </xsl:when>
                        <xsl:otherwise>
                            <span class="locus">ff. <a href="#{data(//msDesc/@xml:id)}-{data(@from)}"><xsl:value-of select="@from" /></a>&#8211;<a href="#{data(//msDesc/@xml:id)}-{data(@to)}"><xsl:value-of select="@to" /></a><xsl:text> </xsl:text></span>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
                <xsl:if test="@scheme='pages'">
                    <xsl:choose>
                        <xsl:when test="@from = @to">
                            <span class="locus">p. 
                                <a href="#{data(//msDesc/@xml:id)}-{data(@from)}"><xsl:value-of select="@from" /></a></span>
                        </xsl:when>
                        <xsl:otherwise>
                            <span class="locus">pp. <xsl:value-of select="@from" />&#8211;<xsl:value-of select="@to" /><xsl:text> </xsl:text></span>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>-->

    <xsl:template match="locus">
        <!--<xsl:variable name="locusFrom" select="if (@from[contains(.,':')]) then substring-before(@from,':') else if (@from[matches(.,'^\d{1,}$')]) then (concat(@from,'r')) else data(@from)" />
        <xsl:variable name="locusTo" select="if (@to[contains(.,':')]) then substring-before(@to,':') else if (@to[matches(.,'^\d{1,}$')]) then (concat(@to,'r')) else data(@to)" />-->
        <xsl:variable name="locusFrom" select="if (@from[contains(.,':')]) then substring-before(@from,':') else if (@scheme='folios' and @from[not(contains(.,'r') or contains(.,'v'))]) then (concat(@from,'r')) else data(@from)" />
        <xsl:variable name="locusTo" select="if (@to[contains(.,':')]) then substring-before(@to,':') else if (@scheme='folios' and @to[not(contains(.,'r') or contains(.,'v'))]) then (concat(@to,'r')) else data(@to)" />
        <xsl:choose>
            <xsl:when test="parent::msItem">
                <xsl:if test="@scheme='folios'">
                    <xsl:choose>
                        <xsl:when test="@from = @to">
                            <span class="locus">(f. <a onclick="$('#diva-wrapper').data('diva').gotoPageByName('{//surface[@xml:id=concat(//TEI/@xml:id,'-',$locusFrom)]/graphic/@url}')" href="#"><xsl:value-of select="@from" /></a>)<xsl:text> </xsl:text></span>
                        </xsl:when>
                        <xsl:otherwise>
                            <span class="locus">(ff. <a onclick="$('#diva-wrapper').data('diva').gotoPageByName('{//surface[@xml:id=concat(//TEI/@xml:id,'-',$locusFrom)]/graphic/@url}')" href="#"><xsl:value-of select="@from" /></a>&#8211;<a onclick="$('#diva-wrapper').data('diva').gotoPageByName('{//surface[@xml:id=concat(//TEI/@xml:id,'-',$locusTo)]/graphic/@url}')" href="#"><xsl:value-of select="@to" /></a>)<xsl:text> </xsl:text></span>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
                <xsl:if test="@scheme='pages'">
                    <xsl:choose>
                        <xsl:when test="@from = @to">
                            <span class="locus">(p. <a onclick="$('#diva-wrapper').data('diva').gotoPageByName('{//surface[@xml:id=concat(//TEI/@xml:id,'-',$locusFrom)]/graphic/@url}')" href="#"><xsl:value-of select="@from" /></a>)<xsl:text> </xsl:text></span>
                        </xsl:when>
                        <xsl:otherwise>
                            <span class="locus">(pp. <a onclick="$('#diva-wrapper').data('diva').gotoPageByName('{//surface[@xml:id=concat(//TEI/@xml:id,'-',$locusFrom)]/graphic/@url}')" href="#"><xsl:value-of select="@from" /></a>&#8211;<a onclick="$('#diva-wrapper').data('diva').gotoPageByName('{//surface[@xml:id=concat(//TEI/@xml:id,'-',$locusTo)]/graphic/@url}')" href="#"><xsl:value-of select="@to" /></a>)<xsl:text> </xsl:text></span>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
                <xsl:if test="@scheme='other'">
                    <xsl:choose>
                        <xsl:when test="@from = @to">
                            <span class="locus">(<a onclick="$('#diva-wrapper').data('diva').gotoPageByName('{//surface[@xml:id=concat(//TEI/@xml:id,'-',$locusFrom)]/graphic/@url}')" href="#"><xsl:value-of select="@from" /></a>)<xsl:text> </xsl:text></span>
                        </xsl:when>
                        <xsl:otherwise>
                            <span class="locus">(<a onclick="$('#diva-wrapper').data('diva').gotoPageByName('{//surface[@xml:id=concat(//TEI/@xml:id,'-',$locusFrom)]/graphic/@url}')" href="#"><xsl:value-of select="@from" /></a>&#8211;<a onclick="$('#diva-wrapper').data('diva').gotoPageByName('{//surface[@xml:id=concat(//TEI/@xml:id,'-',$locusTo)]/graphic/@url}')" href="#"><xsl:value-of select="@to" /></a>)<xsl:text> </xsl:text></span>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="@scheme='folios'">
                    <xsl:choose>
                        <xsl:when test="@from = @to">
                            <span class="locus">f. 
                                <a onclick="$('#diva-wrapper').data('diva').gotoPageByName('{//surface[@xml:id=concat(//TEI/@xml:id,'-',$locusFrom)]/graphic/@url}')" href="#"><xsl:value-of select="@from" /></a>
                            </span>
                        </xsl:when>
                        <xsl:otherwise>
                            <span class="locus">ff. <a onclick="$('#diva-wrapper').data('diva').gotoPageByName('{//surface[@xml:id=concat(//TEI/@xml:id,'-',$locusFrom)]/graphic/@url}')" href="#"><xsl:value-of select="@from" /></a>&#8211;<a onclick="$('#diva-wrapper').data('diva').gotoPageByName('{//surface[@xml:id=concat(//TEI/@xml:id,'-',$locusTo)]/graphic/@url}')" href="#"><xsl:value-of select="@to" /></a><xsl:text> </xsl:text></span>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
                <xsl:if test="@scheme='pages'">
                    <xsl:choose>
                        <xsl:when test="@from = @to">
                            <span class="locus">p. 
                                <a onclick="$('#diva-wrapper').data('diva').gotoPageByName('{//surface[@xml:id=concat(//TEI/@xml:id,'-',$locusFrom)]/graphic/@url}')" href="#"><xsl:value-of select="@from" /></a></span>
                        </xsl:when>
                        <xsl:otherwise>
                            <span class="locus">pp. <a onclick="$('#diva-wrapper').data('diva').gotoPageByName('{//surface[@xml:id=concat(//TEI/@xml:id,'-',$locusFrom)]/graphic/@url}')" href="#"><xsl:value-of select="@from" /></a>&#8211;<a onclick="$('#diva-wrapper').data('diva').gotoPageByName('{//surface[@xml:id=concat(//TEI/@xml:id,'-',$locusTo)]/graphic/@url}')" href="#"><xsl:value-of select="@to" /></a><xsl:text> </xsl:text></span>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
                <xsl:if test="@scheme='other'">
                    <xsl:choose>
                        <xsl:when test="@from = @to">
                            <span class="locus">
                                <a onclick="$('#diva-wrapper').data('diva').gotoPageByName('{//surface[@xml:id=concat(//TEI/@xml:id,'-',$locusFrom)]/graphic/@url}')" href="#">
                                    <xsl:value-of select="@from" />
                                </a>
                            </span>
                        </xsl:when>
                        <xsl:otherwise>
                            <span class="locus">
                                <a onclick="$('#diva-wrapper').data('diva').gotoPageByName('{//surface[@xml:id=concat(//TEI/@xml:id,'-',$locusFrom)]/graphic/@url}')" href="#">
                                    <xsl:value-of select="@from" />
                                </a>
                                &#8211;
                                <a onclick="$('#diva-wrapper').data('diva').gotoPageByName('{//surface[@xml:id=concat(//TEI/@xml:id,'-',$locusTo)]/graphic/@url}')" href="#"><xsl:value-of select="@to" />
                                </a>
                                <xsl:text> </xsl:text>
                            </span>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="locusGrp">
        <xsl:choose>
            <xsl:when test="parent::watermark">
                <xsl:if test="locus/@scheme='folios'">
                    <xsl:text>ff. </xsl:text>
                </xsl:if>
                <xsl:if test="locus/@scheme='pages'">
                    <xsl:text>pp. </xsl:text>
                </xsl:if>
                <!--<xsl:for-each select="locusGrp">-->
                <xsl:for-each select="locus">
                    <xsl:variable name="locusFrom" select="if (@from[contains(.,':')]) then substring-before(@from,':') else if (@scheme='folios' and @from[not(contains(.,'r') or contains(.,'v'))]) then (concat(@from,'r')) else data(@from)" />
                    <xsl:variable name="locusTo" select="if (@to[contains(.,':')]) then substring-before(@to,':') else if (@scheme='folios' and @to[not(contains(.,'r') or contains(.,'v'))]) then (concat(@to,'r')) else data(@to)" />
                    <!--<xsl:variable name="locusFrom" select="if (@from[contains(.,':')]) then substring-before(@from,':') else if (@from[matches(.,'^\d{1,}$')]) then (concat(@from,'r')) else data(@from)" />
                    <xsl:variable name="locusTo" select="if (@to[contains(.,':')]) then substring-before(@to,':') else if (@to[matches(.,'^\d{1,}$')]) then (concat(@to,'r')) else data(@to)" />-->
                    <xsl:if test="position() != last()">
                        <xsl:choose>
                            <xsl:when test="@from = @to">
                                <span class="locus">
                                    <a onclick="$('#diva-wrapper').data('diva').gotoPageByName('{//surface[@xml:id=concat(//TEI/@xml:id,'-',$locusFrom)]/graphic/@url}')" href="#">
                                        <xsl:value-of select="@from" />
                                    </a>/</span>
                            </xsl:when>
                            <xsl:otherwise>
                                <span class="locus">
                                    <a onclick="$('#diva-wrapper').data('diva').gotoPageByName('{//surface[@xml:id=concat(//TEI/@xml:id,'-',$locusFrom)]/graphic/@url}')" href="#">
                                        <xsl:value-of select="@from" />
                                    </a>–<a onclick="$('#diva-wrapper').data('diva').gotoPageByName('{//surface[@xml:id=concat(//TEI/@xml:id,'-',$locusTo)]/graphic/@url}')" href="#">
                                        <xsl:value-of select="@to" />
                                    </a>/</span>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                    <xsl:if test="position() = last()">
                        <xsl:choose>
                            <xsl:when test="@from = @to">
                                <span class="locus">
                                    <a onclick="$('#diva-wrapper').data('diva').gotoPageByName('{//surface[@xml:id=concat(//TEI/@xml:id,'-',$locusFrom)]/graphic/@url}')" href="#">
                                        <xsl:value-of select="@from" />
                                    </a>
                                </span>
                            </xsl:when>
                            <xsl:otherwise>
                                <span class="locus">
                                    <a onclick="$('#diva-wrapper').data('diva').gotoPageByName('{//surface[@xml:id=concat(//TEI/@xml:id,'-',$locusFrom)]/graphic/@url}')" href="#">
                                        <xsl:value-of select="@from" />
                                    </a>–<a onclick="$('#diva-wrapper').data('diva').gotoPageByName('{//surface[@xml:id=concat(//TEI/@xml:id,'-',$locusTo)]/graphic/@url}')" href="#">
                                        <xsl:value-of select="@to" />
                                    </a></span>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                </xsl:for-each>
                <!--</xsl:for-each>-->
                <xsl:if test="position() != last()">
                    <xsl:text>, </xsl:text>
                </xsl:if>
                <xsl:if test="position() = last()">
                    <xsl:text>. </xsl:text>
                </xsl:if>
                <!--<xsl:apply-templates />-->
            </xsl:when>
            <xsl:when test="parent::msItem">
                <xsl:if test="locus/@scheme='folios'">
                    <xsl:text>(ff. </xsl:text>
                </xsl:if>
                <xsl:if test="locus/@scheme='pages'">
                    <xsl:text>(pp. </xsl:text>
                </xsl:if>
                <xsl:for-each select="locus">
                    <xsl:variable name="locusFrom" select="if (@from[contains(.,':')]) then substring-before(@from,':') else if (@scheme='folios' and @from[not(contains(.,'r') or contains(.,'v'))]) then (concat(@from,'r')) else data(@from)" />
                    <xsl:variable name="locusTo" select="if (@to[contains(.,':')]) then substring-before(@to,':') else if (@scheme='folios' and @to[not(contains(.,'r') or contains(.,'v'))]) then (concat(@to,'r')) else data(@to)" />
                    <!--<xsl:variable name="locusFrom" select="if (@from[contains(.,':')]) then substring-before(@from,':') else if (@from[matches(.,'^\d{1,}$')]) then (concat(@from,'r')) else data(@from)" />
                    <xsl:variable name="locusTo" select="if (@to[contains(.,':')]) then substring-before(@to,':') else if (@to[matches(.,'^\d{1,}$')]) then (concat(@to,'r')) else data(@to)" />-->
                    <xsl:if test="position() != last()">
                        <xsl:choose>
                            <xsl:when test="@from = @to">
                                <span class="locus">
                                    <a onclick="$('#diva-wrapper').data('diva').gotoPageByName('{//surface[@xml:id=concat(//TEI/@xml:id,'-',$locusFrom)]/graphic/@url}')" href="#">
                                        <xsl:value-of select="@from" />
                                    </a>, 
                                </span>
                            </xsl:when>
                            <xsl:otherwise>
                                <span class="locus"><a onclick="$('#diva-wrapper').data('diva').gotoPageByName('{//surface[@xml:id=concat(//TEI/@xml:id,'-',$locusFrom)]/graphic/@url}')" href="#"><xsl:value-of select="@from" /></a>&#8211;<a onclick="$('#diva-wrapper').data('diva').gotoPageByName('{//surface[@xml:id=concat(//TEI/@xml:id,'-',$locusTo)]/graphic/@url}')" href="#"><xsl:value-of select="@to" /></a>, </span>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                    <xsl:if test="position() = last()">
                        <span class="locus"><a onclick="$('#diva-wrapper').data('diva').gotoPageByName('{//surface[@xml:id=concat(//TEI/@xml:id,'-',$locusFrom)]/graphic/@url}')" href="#"><xsl:value-of select="@from" /></a>&#8211;<a onclick="$('#diva-wrapper').data('diva').gotoPageByName('{//surface[@xml:id=concat(//TEI/@xml:id,'-',$locusTo)]/graphic/@url}')" href="#"><xsl:value-of select="@to" /></a>)<xsl:text> </xsl:text></span>
                    </xsl:if>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="locus/@scheme='folios'">
                    <xsl:text>ff. </xsl:text>
                </xsl:if>
                <xsl:if test="locus/@scheme='pages'">
                    <xsl:text>pp. </xsl:text>
                </xsl:if>
                <xsl:for-each select="locus">
                    <xsl:variable name="locusFrom" select="if (@from[contains(.,':')]) then substring-before(@from,':') else if (@scheme='folios' and @from[not(contains(.,'r') or contains(.,'v'))]) then (concat(@from,'r')) else data(@from)" />
                    <xsl:variable name="locusTo" select="if (@to[contains(.,':')]) then substring-before(@to,':') else if (@scheme='folios' and @to[not(contains(.,'r') or contains(.,'v'))]) then (concat(@to,'r')) else data(@to)" />
                    <!--<xsl:variable name="locusFrom" select="if (@from[contains(.,':')]) then substring-before(@from,':') else if (@from[matches(.,'^\d{1,}$')]) then (concat(@from,'r')) else data(@from)" />
                    <xsl:variable name="locusTo" select="if (@to[contains(.,':')]) then substring-before(@to,':') else if (@to[matches(.,'^\d{1,}$')]) then (concat(@to,'r')) else data(@to)" />-->
                    <xsl:if test="position() != last()">
                        <xsl:choose>
                            <xsl:when test="@from = @to">
                                <span class="locus">
                                    <a onclick="$('#diva-wrapper').data('diva').gotoPageByName('{//surface[@xml:id=concat(//TEI/@xml:id,'-',$locusFrom)]/graphic/@url}')" href="#">
                                        <xsl:value-of select="@from" />
                                    </a>, </span>
                            </xsl:when>
                            <xsl:otherwise>
                                <span class="locus">
                                    <a onclick="$('#diva-wrapper').data('diva').gotoPageByName('{//surface[@xml:id=concat(//TEI/@xml:id,'-',$locusFrom)]/graphic/@url}')" href="#">
                                        <xsl:value-of select="@from" />
                                    </a>–<a onclick="$('#diva-wrapper').data('diva').gotoPageByName('{//surface[@xml:id=concat(//TEI/@xml:id,'-',$locusTo)]/graphic/@url}')" href="#">
                                        <xsl:value-of select="@to" />
                                    </a>, </span>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                    <xsl:if test="position() = last()">
                        <xsl:choose>
                            <xsl:when test="@from = @to">
                                <span class="locus">
                                    <a onclick="$('#diva-wrapper').data('diva').gotoPageByName('{//surface[@xml:id=concat(//TEI/@xml:id,'-',$locusFrom)]/graphic/@url}')" href="#">
                                        <xsl:value-of select="@from" />
                                    </a>
                                </span>
                            </xsl:when>
                            <xsl:otherwise>
                                <span class="locus">
                                    <a onclick="$('#diva-wrapper').data('diva').gotoPageByName('{//surface[@xml:id=concat(//TEI/@xml:id,'-',$locusFrom)]/graphic/@url}')" href="#">
                                        <xsl:value-of select="@from" />
                                    </a>–<a onclick="$('#diva-wrapper').data('diva').gotoPageByName('{//surface[@xml:id=concat(//TEI/@xml:id,'-',$locusTo)]/graphic/@url}')" href="#">
                                        <xsl:value-of select="@to" />
                                    </a><xsl:text> </xsl:text></span>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--<xsl:template match="locusGrp">
        <xsl:choose>
            <xsl:when test="parent::watermark">
                <xsl:if test="locus/@scheme='folios'">
                    <xsl:text>ff. </xsl:text>
                </xsl:if>
                <xsl:if test="locus/@scheme='pages'">
                    <xsl:text>pp. </xsl:text>
                </xsl:if>
                <!-\-<xsl:for-each select="locusGrp">-\->
                <xsl:for-each select="locus">
                    <xsl:if test="position() != last()">
                        <xsl:choose>
                            <xsl:when test="@from = @to">
                                <span class="locus">
                                    <a href="#{data(//msDesc/@xml:id)}-{data(@from)}">
                                        <xsl:value-of select="@from" />
                                    </a>/</span>
                            </xsl:when>
                            <xsl:otherwise>
                                <span class="locus">
                                    <a href="#{data(//msDesc/@xml:id)}-{data(@from)}">
                                        <xsl:value-of select="@from" />
                                    </a>–<a href="#{data(//msDesc/@xml:id)}-{data(@to)}">
                                        <xsl:value-of select="@to" />
                                    </a>/</span>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                    <xsl:if test="position() = last()">
                        <xsl:choose>
                            <xsl:when test="@from = @to">
                                <span class="locus">
                                    <a href="#{data(//msDesc/@xml:id)}-{data(@from)}">
                                        <xsl:value-of select="@from" />
                                    </a>
                                </span>
                            </xsl:when>
                            <xsl:otherwise>
                                <span class="locus">
                                    <a href="#{data(//msDesc/@xml:id)}-{data(@from)}">
                                        <xsl:value-of select="@from" />
                                    </a>–<a href="#{data(//msDesc/@xml:id)}-{data(@to)}">
                                        <xsl:value-of select="@to" />
                                    </a></span>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                </xsl:for-each>
                <!-\-</xsl:for-each>-\->
                <xsl:if test="position() != last()">
                    <xsl:text>, </xsl:text>
                </xsl:if>
                <xsl:if test="position() = last()">
                    <xsl:text>. </xsl:text>
                </xsl:if>
                <!-\-<xsl:apply-templates />-\->
            </xsl:when>
            <xsl:when test="parent::msItem">
                <xsl:if test="locus/@scheme='folios'">
                    <xsl:text>(ff. </xsl:text>
                </xsl:if>
                <xsl:if test="locus/@scheme='pages'">
                    <xsl:text>(pp. </xsl:text>
                </xsl:if>
                <xsl:for-each select="locus">
                    <xsl:if test="position() != last()">
                        <xsl:choose>
                            <xsl:when test="@from = @to">
                                <span class="locus"><a href="#{data(//msDesc/@xml:id)}-{data(@from)}"><xsl:value-of select="@from" /></a>, </span>
                            </xsl:when>
                            <xsl:otherwise>
                                <span class="locus"><a href="#{data(//msDesc/@xml:id)}-{data(@from)}"><xsl:value-of select="@from" /></a>&#8211;<a href="#{data(//msDesc/@xml:id)}-{data(@to)}"><xsl:value-of select="@to" /></a>, </span>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                    <xsl:if test="position() = last()">
                        <span class="locus"><a href="#{data(//msDesc/@xml:id)}-{data(@from)}"><xsl:value-of select="@from" /></a>&#8211;<a href="#{data(//msDesc/@xml:id)}-{data(@to)}"><xsl:value-of select="@to" /></a>)<xsl:text> </xsl:text></span>
                    </xsl:if>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="locus/@scheme='folios'">
                    <xsl:text>ff. </xsl:text>
                </xsl:if>
                <xsl:if test="locus/@scheme='pages'">
                    <xsl:text>pp. </xsl:text>
                </xsl:if>
                <xsl:for-each select="locus">
                    <xsl:if test="position() != last()">
                        <xsl:choose>
                            <xsl:when test="@from = @to">
                                <span class="locus">
                                    <a href="#{data(//msDesc/@xml:id)}-{data(@from)}">
                                        <xsl:value-of select="@from" />
                                    </a>, </span>
                            </xsl:when>
                            <xsl:otherwise>
                                <span class="locus">
                                    <a href="#{data(//msDesc/@xml:id)}-{data(@from)}">
                                        <xsl:value-of select="@from" />
                                    </a>–<a href="#{data(//msDesc/@xml:id)}-{data(@to)}">
                                        <xsl:value-of select="@to" />
                                    </a>, </span>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                    <xsl:if test="position() = last()">
                        <xsl:choose>
                            <xsl:when test="@from = @to">
                                <span class="locus">
                                    <a href="#{data(//msDesc/@xml:id)}-{data(@from)}">
                                        <xsl:value-of select="@from" />
                                    </a>
                                </span>
                            </xsl:when>
                            <xsl:otherwise>
                                <span class="locus">
                                    <a href="#{data(//msDesc/@xml:id)}-{data(@from)}">
                                        <xsl:value-of select="@from" />
                                    </a>–<a href="#{data(//msDesc/@xml:id)}-{data(@to)}">
                                        <xsl:value-of select="@to" />
                                    </a><xsl:text> </xsl:text></span>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>-->

    <xsl:template match="material">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="measure">
        <xsl:if test="@type='laid-lines_in_20mm'">
            <em>Laid-lines in 20 mm: </em>
            <xsl:if test="@quantity">
                <xsl:value-of select="@quantity" />
            </xsl:if>
            <xsl:if test="@min">
                <xsl:value-of select="@min" />
                <xsl:text>/</xsl:text>
                <xsl:value-of select="@max" />
            </xsl:if>
            <xsl:if test="@unit='lines'">
                <xsl:text> lines</xsl:text>
            </xsl:if>
        </xsl:if>
        <xsl:if test="@type='folding'">
            <xsl:text> (</xsl:text>
            <xsl:value-of select="." />
            <xsl:text> folding)</xsl:text>
        </xsl:if>
    </xsl:template>

    <!--<xsl:template match="msContents">
        <xsl:choose>
            <xsl:when test="parent::msPart">
                <xsl:for-each select="msItem">
                    <div class="msItem">
                        <span class="msItem_nr">
                            <xsl:number level="multiple" count="msItem" format="1.1" />
                            <xsl:text> </xsl:text>
                        </span>
                        <xsl:apply-templates select="node()[not(self::msItem)]" />
                        <!-\- Excludes msItems -\->
                        <xsl:for-each select="descendant::msItem">
                            <div class="sub_msItem">
                                <span class="msItem_nr">
                                    <xsl:number level="multiple" count="msItem" format="1.1" />
                                    <xsl:text> </xsl:text>
                                </span>
                                <xsl:apply-templates />
                            </div>
                        </xsl:for-each>
                    </div>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="parent::msDesc">
                <xsl:for-each select="msItem">
                    <div class="msItem">
                        <xsl:apply-templates />
                    </div>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
    </xsl:template>-->

    <xsl:template match="msContents">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="msDesc">
        <xsl:apply-templates />
    </xsl:template>

    <!-- msIdentifier -->

    <xsl:template match="msItem">
        <div class="msItem">
            <span class="msItem_nr">
                <xsl:value-of select="@n" />
                <xsl:text> </xsl:text>
            </span>
            <xsl:apply-templates />
        </div>
    </xsl:template>

    <xsl:template match="msName">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template name="msPart" match="msPart">
        <xsl:if test="count(//msPart) gt 1">
            <h2>Codicological Unit <xsl:value-of select="msIdentifier/idno[@type='codicological_unit']/text()" /></h2>
        </xsl:if>
        <xsl:apply-templates />
    </xsl:template>

    <!-- <xsl:template match="msPart/msContents">
        <div class="msContents">
            <h3>Contents</h3>
            <!-\-<xsl:for-each select="descendant::msItem">
                <div class="msItem">
                    <span class="msItem_nr">
                        <xsl:number level="multiple" count="msItem" format="1.1" />
                    </span>
                    <xsl:apply-templates />
                </div>
            </xsl:for-each>-\->
            <xsl:apply-templates />
        </div>
    </xsl:template>
    <xsl:template match="msItem">
        <xsl:for-each select="descendant-or-self::msItem">
            <div class="msItem">
                <span class="msItem_nr">
                    <xsl:number level="multiple" count="msItem" format="1.1" />
                </span>
                <xsl:apply-templates />
            </div>
        </xsl:for-each>
    </xsl:template>-->

    <xsl:template match="musicNotation">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="note">
        <!--<xsl:choose>
            <xsl:when test="parent::msItem[@class='endleaf'] or parent::layout">
                <xsl:apply-templates />
            </xsl:when>
            <xsl:when test="child::list[@type='toc']">
                <xsl:apply-templates />
            </xsl:when>
            <xsl:otherwise>
                <span class="note">
                    <h4>Note: </h4>
                    <xsl:apply-templates />
                </span>
            </xsl:otherwise>
        </xsl:choose>-->
        <xsl:choose>
            <xsl:when test="parent::msItem[not(@class='left_endleaf' or @class='right_endleaf' )]">
                <div class="note">
                    <h4>Note: </h4>
                    <xsl:apply-templates />
                </div>
            </xsl:when>
            <xsl:when test="parent::layout">
                <xsl:apply-templates />
            </xsl:when>
            <xsl:otherwise>
                <p>
                    <xsl:apply-templates />
                </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="num">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="objectDesc">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="origDate">
        <xsl:if test="@from and not(text())">
            <xsl:value-of select="@from" />
            <xsl:text>&#8211;</xsl:text>
            <xsl:value-of select="@to" />
        </xsl:if>
        <xsl:if test="@when and not(text())">
            <xsl:value-of select="@when" />
        </xsl:if>
        <xsl:if test="text()">
            <xsl:apply-templates />
        </xsl:if>
    </xsl:template>

    <xsl:template match="origPlace">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="origin">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="p">
        <xsl:choose>
            <xsl:when test="parent::support">
                <div>
                    <xsl:apply-templates />
                </div>
            </xsl:when>
            <xsl:otherwise>
                <p>
                    <xsl:apply-templates />
                </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="persName">
        <xsl:choose>
            <xsl:when test="@evidence='external' or @evidence='conjecture'">
                <xsl:text>&#10216;</xsl:text>
                <!-- Mathematical left angle bracket U+27E8 -->
                <xsl:value-of select="normalize-space(.)" />
                <!-- Removes whitespace before and after -->
                <xsl:text>&#10217;</xsl:text>
                <!-- Mathematical right angle bracket U+27E9 -->
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="normalize-space(.)" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="physDesc">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="placeName">
        <xsl:value-of select="normalize-space(.)" />
    </xsl:template>

    <xsl:template match="provenance">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="pubPlace">
        <span class="pubPlace">
            <xsl:apply-templates />
        </span>
    </xsl:template>

    <!-- publicationStmt -->

    <xsl:template match="q">
        <xsl:text>&#8216;</xsl:text>
        <xsl:apply-templates />
        <xsl:text>&#8217;</xsl:text>
    </xsl:template>

    <xsl:template match="quote">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="ref">
        <xsl:choose>
            <xsl:when test="@target">
                <a href="{data(@target)}">
                    <xsl:apply-templates />
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- repository -->

    <!-- resp -->

    <!-- respStmt -->

    <xsl:template match="revisionDesc">
        <xsl:if test="@status='draft'">
            <div class="alert alert-danger alert-dismissible fade in" role="alert">
                <button class="close" aria-label="Close" data-dismiss="alert" type="button">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 style="display:block">Disclaimer</h4>
                <p>This description is a preliminary draft and is subject to change without notice</p>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template match="rubric">
        <div class="msItem_rubric">
            <span class="head">Rubric: </span>
            <xsl:apply-templates />
        </div>
    </xsl:template>

    <!-- settlement -->

    <xsl:template match="sic">
        <xsl:value-of select="." />
        <xsl:text> (!)</xsl:text>
    </xsl:template>

    <xsl:template match="signatures">
        <xsl:apply-templates />
    </xsl:template>

    <!-- sourceDesc -->

    <xsl:template match="summary">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="supplied">
        <xsl:text>&#10216;</xsl:text>
        <!-- Mathematical left angle bracket U+27E8 -->
        <xsl:value-of select="normalize-space(.)" />
        <!-- Removes whitespace before and after -->
        <xsl:text>&#10217;</xsl:text>
        <!-- Mathematical right angle bracket U+27E9 -->
    </xsl:template>

    <xsl:template match="support">
        <xsl:apply-templates />

        <!--<xsl:if test="count(p) gt 1">
            <xsl:for-each select="p">
                <xsl:number count="p" format="a" />
                <xsl:text>: </xsl:text>
                <xsl:apply-templates />
            </xsl:for-each>
        </xsl:if>-->
        <!--<xsl:apply-templates select="node()[not(self::watermark)]" />-->


        <!-- Excludes watermark -->



        <!--<div class="watermarks">
            <h4>Watermarks: </h4>
            <xsl:for-each select="p/watermark">
                <p>
                    <span class="watermark_nr"><xsl:value-of select="@n" />. </span>
                    <xsl:if test="locusGrp/locus/@scheme='folios'">
                        <xsl:text>ff. </xsl:text>
                    </xsl:if>
                    <xsl:if test="locusGrp/locus/@scheme='pages'">
                        <xsl:text>pp. </xsl:text>
                    </xsl:if>
                    <xsl:for-each select="locusGrp">
                        <xsl:for-each select="locus">
                            <xsl:if test="position() != last()">
                                <xsl:choose>
                                    <xsl:when test="@from = @to">
                                        <span class="locus">
                                            <a href="#{data(//msDesc/@xml:id)}-{data(@from)}">
                                                <xsl:value-of select="@from" />
                                            </a>/</span>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <span class="locus">
                                            <a href="#{data(//msDesc/@xml:id)}-{data(@from)}">
                                                <xsl:value-of select="@from" />
                                            </a>–<a href="#{data(//msDesc/@xml:id)}-{data(@to)}">
                                                <xsl:value-of select="@to" />
                                            </a>/</span>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:if>
                            <xsl:if test="position() = last()">
                                <xsl:choose>
                                    <xsl:when test="@from = @to">
                                        <span class="locus">
                                            <a href="#{data(//msDesc/@xml:id)}-{data(@from)}">
                                                <xsl:value-of select="@from" />
                                            </a>, 
                                                </span>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <span class="locus">
                                            <a href="#{data(//msDesc/@xml:id)}-{data(@from)}">
                                                <xsl:value-of select="@from" />
                                            </a>–<a href="#{data(//msDesc/@xml:id)}-{data(@to)}">
                                                <xsl:value-of select="@to" />
                                            </a>, </span>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:for-each>
                    <xsl:if test="position() != last()">
                        <xsl:text>, </xsl:text>
                    </xsl:if>
                    <xsl:if test="position() = last()">
                        <xsl:text>. </xsl:text>
                    </xsl:if>
                    <xsl:apply-templates />
                </p>
            </xsl:for-each>
        </div>-->
    </xsl:template>

    <xsl:template match="supportDesc">
        <xsl:apply-templates />
    </xsl:template>

    <!-- surface -->

    <!-- teiHeader -->

    <xsl:template match="term">
        <xsl:choose>
            <xsl:when test="@type='folding'">
                <em>Folding: </em>
                <xsl:apply-templates />
                <xsl:text>. </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="text">
        <a name="{data(body/div/@xml:id)}" />
        <h3>
            <xsl:value-of select="body/div/head/title" />
        </h3>
        <xsl:text>(</xsl:text>
        <xsl:apply-templates select="body/div/head/locus" />
        <xsl:text>) </xsl:text>
        <xsl:apply-templates select="body/div/p" />
    </xsl:template>

    <!-- textLang -->

    <xsl:template match="title">
        <xsl:if test="parent::msItem">
            <xsl:if test="not(@type='alt')">
                <span class="msItem_title">
                    <xsl:call-template name="makeLang" />
                    <xsl:text> </xsl:text>
                    <xsl:apply-templates />
                </span>
            </xsl:if>
            <xsl:if test="@type='alt'">
                <xsl:text> (</xsl:text>
                <xsl:apply-templates />
                <xsl:text>)</xsl:text>
            </xsl:if>
            <xsl:if test="@type='short'">
                <xsl:apply-templates />
            </xsl:if>
            <xsl:if test="@key">
                <span class="key">
                    <xsl:text> (</xsl:text>
                    <xsl:value-of select="@key" />
                    <xsl:text>) </xsl:text>
                </span>
            </xsl:if>
            <!--<xsl:if test="following-sibling::note/list[@type='toc']">
                <xsl:text> (</xsl:text>
                <xsl:apply-templates select="//list"/>
                <xsl:text>).</xsl:text>
            </xsl:if>-->
        </xsl:if>
        <xsl:if test="@level='a'">
            <span class="bibl_article_title">
                <xsl:text>&quot;</xsl:text>
                <xsl:apply-templates />
                <xsl:text>&quot;</xsl:text>
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
        <!--<xsl:if test="@level='s'">
            <span class="bibl_series_title">
                <xsl:text>, </xsl:text>
                <xsl:apply-templates />
            </span>
        </xsl:if>-->
        <xsl:if test="ancestor::list[@type='toc']">
            <em>
                <xsl:apply-templates />
            </em>
        </xsl:if>
    </xsl:template>

    <!-- titleStmt -->

    <xsl:template match="unclear">
        <xsl:text>[--- </xsl:text>
        <xsl:value-of select="@quantity" />
        <xsl:text> </xsl:text>
        <xsl:value-of select="@unit" />
        <xsl:text> ---]</xsl:text>
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="watermark">
        <div>
            <span class="watermark_nr">Watermark <xsl:value-of select="@n" />. </span>
            <xsl:apply-templates />
        </div>
    </xsl:template>

    <xsl:template match="width">
        <xsl:if test="@quantity">
            <xsl:value-of select="@quantity" />
        </xsl:if>
        <xsl:if test="@min">
            <xsl:value-of select="@min" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="@max" />
        </xsl:if>
        <xsl:choose>
            <xsl:when test="following-sibling::depth">
                <xsl:text> &#215; </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text> mm</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--<xsl:template match="exist:match" priority="10">
        <span class="hi">
            <xsl:value-of select="." />
        </span>
    </xsl:template>-->

</xsl:stylesheet>
