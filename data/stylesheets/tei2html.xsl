<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0">

    <xsl:output method="html" version="5.0" indent="yes" encoding="utf-8" />
    
    <xsl:include href="templates.xsl"/>

    <xsl:template match="/">

        <xsl:apply-templates select="//revisionDesc" />

        <section class="short_description">

            <h1>
                <xsl:attribute name="id">
                    <xsl:value-of select="/TEI/@xml:id" />
                </xsl:attribute>
                <xsl:value-of select="//repository" />
                <xsl:text>, </xsl:text>
                <xsl:value-of select="//msDesc/msIdentifier/idno" />
                <xsl:if test="count(//msPart) gt 1">
                        (<xsl:value-of select="count(//msPart)" /> units)
                        </xsl:if>
                <!--<xsl:if test="//idno[@type='former_shelfmark']">
                            <xsl:text> (</xsl:text>
                            <xsl:value-of select="//idno[@type='former_shelfmark']" />
                            <xsl:text>)</xsl:text>
                        </xsl:if>-->
            </h1>

            <h3>
                <xsl:value-of select="//msDesc/head" />
            </h3>

            <p>
                <xsl:if test="exists(//origPlace)">
                    <xsl:value-of select="normalize-space(//msDesc/history/origin//origPlace)" />
                    <xsl:text>, </xsl:text>
                </xsl:if>
                <xsl:if test="exists(//origin/@notBefore)">
                    <xsl:value-of select="//origin/@notBefore" />
                    <xsl:text>&#8211;</xsl:text>
                    <xsl:value-of select="//origin/@notAfter" />
                </xsl:if>
                <xsl:if test="exists(//origDate)">
                    <xsl:value-of select="//origin//origDate" />
                </xsl:if>
            </p>
            <p>
                <xsl:value-of select=" distinct-values(//supportDesc/@material)" />
            </p>
            <p>
                <xsl:text> ff. </xsl:text>
                <xsl:if test="//measure[@type='left_flyleaves' and @quantity ge '1']">
                    <xsl:number format="i" value="//measure[@type='left_flyleaves']/@quantity" />
                    <xsl:text>, </xsl:text>
                </xsl:if>
                <xsl:value-of select="sum(//measure[@type='textblock_leaves']/@quantity)" />
                <xsl:if test="//measure[@type='right_flyleaves' and @quantity ge '1']">
                    <xsl:text>, </xsl:text>
                    <xsl:number format="i" value="//measure[@type='right_flyleaves']/@quantity" />
                    <xsl:text>'</xsl:text>
                </xsl:if>
            </p>
            <p>
                <xsl:value-of select="distinct-values(//support//dimensions[@type='leaf']/height/@quantity)" />
                <xsl:text> &#215; </xsl:text>
                <xsl:value-of select="distinct-values(//support//dimensions[@type='leaf']/width/@quantity)" />
                <xsl:text> mm</xsl:text>
            </p>
            <!--<p>
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
                    </p>-->
        </section>

        <section class="msContents">
            <h2>Contents</h2>
            <xsl:apply-templates select="//msDesc/msContents" />
            <xsl:for-each select="//msPart">
                <xsl:if test="count(//msPart) gt 1">
                    <h3>Unit <xsl:number count="msPart" format="I" /></h3>
                </xsl:if>
                <xsl:apply-templates select="msContents" />
            </xsl:for-each>
        </section>

        <section class="physDesc">

            <h2>Physical Description</h2>

            <div class="foliation">
                <h3>Foliation</h3>
                <xsl:for-each select="//foliation">
                    <xsl:choose>
                        <xsl:when test="ancestor::msPart">
                            <p>
                                <xsl:if test="count(//msPart) gt 1">
                                    <span class="unit_nr">Unit <xsl:number count="msPart" format="I" />: </span>
                                </xsl:if>
                                <xsl:apply-templates />
                            </p>
                        </xsl:when>
                        <xsl:otherwise>
                            <p>
                                <xsl:apply-templates />
                            </p>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </div>

            <div class="collation">
                <h3>Collation</h3>
                <p>
                    <xsl:for-each select="//msPart">
                        <xsl:if test="position() != last()">
                            <xsl:apply-templates select="physDesc//formula" />
                            <xsl:text>| </xsl:text>
                        </xsl:if>
                        <xsl:if test="position() = last()">
                            <xsl:apply-templates select="physDesc//formula" />
                        </xsl:if>
                    </xsl:for-each>
                </p>
                <!--<div class="signatures">
                            <h4>Signatures: </h4>
                            <xsl:for-each select="//msPart">
                                <xsl:choose>
                                    <xsl:when test="//signatures[contains(.,'none')]">
                                        <xsl:choose>
                                            <xsl:when test="following-sibling::msPart[//signatures[not(contains(.,'none'))]]">
                                                <p>
                                                    <span class="unit_nr">Unit <xsl:number count="msPart" format="I" />: </span>
                                                    TEST
                                                </p>
                                            </xsl:when>
                                        </xsl:choose>

                                    </xsl:when>
                                    <xsl:otherwise>
                                        <p>
                                            <span class="unit_nr">Unit <xsl:number count="msPart" format="I" />: </span>
                                            <xsl:apply-templates select="." />
                                        </p>
                                    </xsl:otherwise>

                                </xsl:choose>
                            </xsl:for-each>
                        </div>
                        <div class="catchwords">
                            <h4>Catchwords: </h4>
                            <xsl:for-each select="//catchwords">
                                <p>
                                    <span class="unit_nr">Unit <xsl:number count="msPart" format="I" />: </span>
                                    <xsl:apply-templates select="." />
                                </p>
                            </xsl:for-each>
                        </div>-->
            </div>

            <section class="support">
                <h3>Support</h3>
                <!--<xsl:for-each select="//supportDesc/support">
                            <p>
                                <xsl:if test="count(//msPart) gt 1">
                                    <span class="unit_nr">Unit <xsl:number count="msPart" format="I" />:</span>
                                </xsl:if>
                                <xsl:apply-templates select="." />
                            </p>
                        </xsl:for-each>-->
                <xsl:for-each select="//support">
                    <xsl:choose>
                        <xsl:when test="ancestor::msPart">
                            <xsl:if test="count(//msPart) gt 1">
                                <span class="unit_nr">Unit <xsl:number count="msPart" format="I" />: </span>
                            </xsl:if>
                            <xsl:apply-templates />
                        </xsl:when>
                        <xsl:otherwise>
                            <span class="unit_nr">Bookblock: </span>
                            <xsl:apply-templates />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </section>

            <h3>Script</h3>
            <xsl:for-each select="//handDesc">
                <xsl:choose>
                    <xsl:when test="ancestor::msPart">
                        <p>
                            <xsl:if test="count(//msPart) gt 1">
                                <span class="unit_nr">Unit <xsl:number count="msPart" format="I" />: </span>
                            </xsl:if>
                            <xsl:apply-templates select="handNote" />
                        </p>
                    </xsl:when>
                    <xsl:otherwise>
                        <p>
                            <span class="unit_nr">Book: </span>
                            <xsl:apply-templates select="handNote" />
                        </p>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>

            <h3>Binding</h3>
            <xsl:apply-templates select="//bindingDesc" />

            <!--<div class="handDesc">
                            <h4>Script: </h4>
                            <xsl:for-each select="//handDesc">
                                <xsl:apply-templates select="handNote" />
                            </xsl:for-each>
                        </div>
                        <div class="layoutDesc">
                            <h4>Layout: </h4>
                            <xsl:for-each select="layoutDesc">
                                <xsl:apply-templates select="." />
                            </xsl:for-each>
                        </div>
                        <div class="decoDesc">
                            <h4>Decoration: </h4>
                            <xsl:apply-templates select="//decoDesc" />
                        </div>-->
            <!--</xsl:for-each>-->
        </section>

        <section class="history">
            <h2>History</h2>
            <xsl:call-template name="history" />
        </section>

        <section class="additional">
            <h2>Bibliography</h2>
            <xsl:apply-templates select="//additional" />
        </section>

        <xsl:if test="exists(//text)">
            <section class="text">
                <h2>Texts</h2>
                <xsl:apply-templates select="//text" />
            </section>
        </xsl:if>

        <div class="lastRevision">
            <xsl:apply-templates select="//change" />
        </div>

    </xsl:template>

</xsl:stylesheet>
