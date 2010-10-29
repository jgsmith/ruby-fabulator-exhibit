<?xml version="1.0" ?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:ex="http://dh.tamu.edu/ns/fabulator/exhibit/1.0#"
  version="1.0"
>
  <xsl:output
    method="html"
    indent="yes"
  />

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="ex:exhibit">
    <div>
      <xsl:attribute name="class">fabulator-exhibit</xsl:attribute>
      <xsl:attribute name="source"><xsl:value-of select="@ex:database" /></xsl:attribute>
      <xsl:attribute name="id"><xsl:value-of select="generate-id(.)" /></xsl:attribute>
      <xsl:attribute name="ex:exhibitLabel"><xsl:value-of select="ex:caption"/></xsl:attribute>
      <xsl:if test="ex:counters"><xsl:attribute name="ex:counters"><xsl:value-of select="ex:counters/ex:single" />:<xsl:value-of select="ex:counters/ex:plural" /></xsl:attribute></xsl:if>
      <xsl:apply-templates select="ex:collection" />
      <div class="facets">
      <xsl:apply-templates select="*[substring(local-name(.), string-length(local-name(.))-5) = '-facet']" />
      </div>
      <div class="views">
      <xsl:attribute name="id"><xsl:value-of select="generate-id(.)" />-views</xsl:attribute>
        <xsl:if test="count(*[substring(local-name(.), string-length(local-name(.))-4) = '-view']) > 1">
          <xsl:attribute name="ex:role">viewPanel</xsl:attribute>
        </xsl:if>
        <xsl:apply-templates select="*[substring(local-name(.), string-length(local-name(.))-4) = '-view']" />
      </div>
      <xsl:apply-templates select="ex:lens" />
    </div>
  </xsl:template>

  <xsl:template match="ex:collection">
    <div>
      <xsl:attribute name="ex:role">exhibit-collection</xsl:attribute>
      <xsl:attribute name="ex:itemTypes"><xsl:value-of select="@ex:types" /></xsl:attribute>
    </div>
  </xsl:template>

  <xsl:template match="ex:tile-view">
    <div>
      <xsl:attribute name="ex:role">view</xsl:attribute>
      <xsl:attribute name="class">view tile-view</xsl:attribute>
      <xsl:attribute name="ex:viewClass">Tile</xsl:attribute>
      <xsl:attribute name="id"><xsl:value-of select="generate-id(.)" /></xsl:attribute>
      <xsl:attribute name="ex:viewLabel"><xsl:value-of select="ex:caption"/></xsl:attribute>
      <xsl:call-template name="apply-lenses" />
    </div>
  </xsl:template>

  <xsl:template name="apply-lenses">
    <xsl:choose>
      <xsl:when test="ex:lens">
        <xsl:apply-templates select="ex:lens" />
      </xsl:when>
      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  

  <xsl:template match="ex:thumbnail-view">
    <div>
      <xsl:attribute name="ex:role">view</xsl:attribute>
      <xsl:attribute name="ex:viewClass">Thumbnail</xsl:attribute>
      <xsl:attribute name="ex:viewLabel"><xsl:value-of select="ex:caption"/></xsl:attribute>
      <xsl:attribute name="id"><xsl:value-of select="generate-id(.)" /></xsl:attribute>
      <xsl:call-template name="apply-lenses" />
    </div>
  </xsl:template>

  <xsl:template match="ex:map-view">
    <div>
      <xsl:attribute name="ex:role">view</xsl:attribute>
      <xsl:attribute name="ex:viewClass">Map</xsl:attribute>
      <xsl:attribute name="id"><xsl:value-of select="generate-id(.)" /></xsl:attribute>
      <xsl:attribute name="ex:latlng"><xsl:value-of select="@ex:select" /></xsl:attribute>
      <xsl:attribute name="ex:center"><xsl:value-of select="@ex:center" /></xsl:attribute>
      <xsl:attribute name="ex:zoom"><xsl:value-of select="@ex:zoom-level" /></xsl:attribute>
      <xsl:attribute name="ex:size"><xsl:value-of select="@ex:controls-size" /></xsl:attribute>
      <xsl:attribute name="ex:type"><xsl:value-of select="@ex:map-type" /></xsl:attribute>
      <xsl:attribute name="ex:viewLabel"><xsl:value-of select="ex:caption"/></xsl:attribute>
      <xsl:call-template name="apply-lenses" />
    </div>
  </xsl:template>

  <xsl:template match="ex:timeline-view">
    <div>
      <xsl:attribute name="ex:role">view</xsl:attribute>
      <xsl:attribute name="id"><xsl:value-of select="generate-id(.)" /></xsl:attribute>
      <xsl:attribute name="ex:viewClass">Timeline</xsl:attribute>
      <xsl:attribute name="ex:start"><xsl:value-of select="@ex:select-start" /></xsl:attribute>
      <xsl:attribute name="ex:end"><xsl:value-of select="@ex:select-end" /></xsl:attribute>
      <xsl:attribute name="ex:viewLabel"><xsl:value-of select="ex:caption"/></xsl:attribute>
      <xsl:call-template name="apply-lenses" />
    </div>
  </xsl:template>

  <xsl:template match="ex:tabular-view">
    <div>
      <xsl:attribute name="ex:role">view</xsl:attribute>
      <xsl:attribute name="id"><xsl:value-of select="generate-id(.)" /></xsl:attribute>
      <xsl:attribute name="ex:viewClass">Tabular</xsl:attribute>
      <xsl:attribute name="ex:viewLabel"><xsl:value-of select="ex:caption"/></xsl:attribute>
      <xsl:attribute name="ex:columns"><xsl:for-each select="ex:column/@ex:select"><xsl:value-of select="."/><xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if></xsl:for-each></xsl:attribute>
      <xsl:attribute name="ex:columnLabels"><xsl:for-each select="ex:column/ex:caption"><xsl:value-of select="."/><xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if></xsl:for-each></xsl:attribute>
      <xsl:call-template name="apply-lenses" />
    </div>
  </xsl:template>

  <xsl:template match="ex:lens">
    <div>
      <xsl:attribute name="ex:role">lens</xsl:attribute>
      <xsl:attribute name="id"><xsl:value-of select="generate-id(.)" /></xsl:attribute>
      <xsl:attribute name="ex:itemTypes"><xsl:value-of select="@ex:types" /></xsl:attribute>
      <xsl:attribute name="style">display: none;</xsl:attribute>
      <xsl:apply-templates select="ex:title" />
      <xsl:apply-templates select="ex:body" />
      <xsl:if test="not(ex:title | ex:body)">
      </xsl:if>
    </div>
  </xsl:template>

  <xsl:template match="ex:list-facet">
    <div>
      <xsl:attribute name="ex:role">facet</xsl:attribute>
      <xsl:attribute name="id"><xsl:value-of select="generate-id(.)" /></xsl:attribute>
      <xsl:attribute name="ex:expression"><xsl:value-of select="@ex:select" /></xsl:attribute>
      <xsl:attribute name="ex:showMissing"><xsl:value-of select="@ex:show-missing" /></xsl:attribute>
      <xsl:attribute name="ex:facetClass">List</xsl:attribute>
      <xsl:attribute name="ex:facetLabel"><xsl:value-of select="ex:caption" /></xsl:attribute>
    </div>
  </xsl:template>

  <xsl:template match="ex:search-facet">
    <div>
      <xsl:attribute name="ex:role">facet</xsl:attribute>
      <xsl:attribute name="id"><xsl:value-of select="generate-id(.)" /></xsl:attribute>
      <xsl:attribute name="ex:facetClass">TextSearch</xsl:attribute>
      <xsl:attribute name="ex:expression"><xsl:value-of select="@ex:select" /></xsl:attribute>
    </div>
  </xsl:template>

  <xsl:template match="ex:title">
    <div class="exhibit-lens-title">
      <xsl:apply-templates />
    </div>
  </xsl:template>

  <xsl:template match="ex:value">
    <span>
      <xsl:attribute name="ex:content"><xsl:value-of select="@ex:select" /></xsl:attribute>
    </span>
  </xsl:template>

  <xsl:template match="ex:body">
    <div class="exhibit-lens-body">
      <xsl:apply-templates />
    </div>
  </xsl:template>

  <xsl:template match="ex:property-list">
    <table class="exhibit-lens-properties">
      <tbody>
        <xsl:apply-templates select="ex:property" />
      </tbody>
    </table>
  </xsl:template>

  <xsl:template match="ex:property-list/ex:property">
    <tr class="exhibit-lens-property">
      <td class="exhibit-lens-property-name"><xsl:value-of select="ex:caption" /><xsl:text>: </xsl:text></td>
      <td class="exhibit-lens-property-values"><span>
        <xsl:attribute xsl:name="ex:content"><xsl:value-of select="@ex:select" /></xsl:attribute>
      </span></td>
    </tr>
  </xsl:template>

  <xsl:template match="ex:property">
    <xsl:if test="ex:caption">
      <span class="exhibit-lens-property-name"><xsl:value-of select="ex:caption" /></span>
    </xsl:if>
    <span class="exhibit-lens-property-value">
      <xsl:attribute xsl:name="ex:content"><xsl:value-of select="@ex:select" /></xsl:attribute>
    </span>
  </xsl:template>

  <xsl:template match="ex:caption">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="ex:section">
    <div>
      <xsl:attribute name="ex:section"><xsl:value-of select="@ex:select" /></xsl:attribute>
      <xsl:apply-templates />
    </div>
  </xsl:template>

  <xsl:template match="ex:otherwise">
    <div>
      <xsl:attribute name="class">exhibit-otherwise</xsl:attribute>
      <xsl:apply-templates />
    </div>
  </xsl:template>

  <xsl:template match="ex:repeated">
    <div>
      <xsl:attribute name="ex:repeated"><xsl:value-of select="@ex:select" /></xsl:attribute>
      <xsl:apply-templates />
    </div>
  </xsl:template>

  <xsl:template match="ex:if-exists">
    <span>
      <xsl:attribute name="ex:if-exists"><xsl:value-of select="@ex:select" /></xsl:attribute>
      <xsl:apply-templates />
    </span>
  </xsl:template>
  
</xsl:stylesheet>
