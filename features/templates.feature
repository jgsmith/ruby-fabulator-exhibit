@tmpl
Feature: Templates

  @nst
  Scenario: Rendering markup with namespaces
   Given a context
     And the template
       """
<div xmlns="http://dh.tamu.edu/ns/fabulator/1.0#"
     xmlns:ex="http://dh.tamu.edu/ns/fabulator/exhibit/1.0#"
>
  <ex:exhibit ex:database="00A">
    <ex:collection ex:types="Point" />
    <ex:map-view 
       ex:center="42.4603,-71.3494" 
       ex:zoom-level="10"
       ex:select=".pointLatLong"
    />
    <ex:list-facet ex:select=".label">
      <ex:caption>Names</ex:caption>
    </ex:list-facet>
    <ex:tile-view>
      <ex:caption>Points</ex:caption>
      <ex:lens ex:types="Point">
        <ex:title><ex:value ex:select=".label" /></ex:title>
        <ex:body>
          <ex:property-list>
            <ex:property ex:select=".label">
              <ex:caption>Label</ex:caption>
            </ex:property>
            <ex:property ex:select=".pointLatLong">
              <ex:caption>Lat/Long</ex:caption>
            </ex:property>
            <ex:property ex:select=".documents">
              <ex:caption>Documents</ex:caption>
            </ex:property>
          </ex:property-list>
        </ex:body>
      </ex:lens>
    </ex:tile-view>
  </ex:exhibit>
</div>
       """
   When I render the template
   Then the rendered html should equal
       """
<div> 
  <div class="fabulator-exhibit" source="00A" id="id" ex:exhibitlabel="">
    <div ex:role="exhibit-collection" ex:itemtypes="Point"></div>
    <div class="facets">
      <div ex:role="facet" id="id" ex:expression=".label" ex:facetClass="List" ex:facetlabel="Names"></div>
    </div>
    <div class="views" id="id-views" ex:role="viewPanel">
      <div ex:role="view" ex:viewclass="Map" id="id" ex:latlng=".pointLatLong" ex:center="42.4603,-71.3494" ex:zoom="10" ex:size="" ex:type="" ex:viewlabel="">
      </div>
      <div ex:role="view" class="view tile-view" ex:viewclass="Tile" id="id" ex:viewlabel="Points">
        <div ex:role="lens" id="id" ex:itemtypes="Point" style="display: none;">
          <div class="exhibit-lens-title"><span ex:content=".label"></span></div>
          <div class="exhibit-lens-body">
            <table class="exhibit-lens-properties">
              <tbody>
                <tr class="exhibit-lens-property">
                  <td class="exhibit-lens-property-name">Label: </td>
                  <td class="exhibit-lens-property-values"><span ex:content=".label"></span></td>
                </tr>
                <tr class="exhibit-lens-property">
                  <td class="exhibit-lens-property-name">Lat/Long: </td>
                  <td class="exhibit-lens-property-values"><span ex:content=".pointLatLong"></span></td>
                </tr>
                <tr class="exhibit-lens-property">
                  <td class="exhibit-lens-property-name">Documents: </td>
                  <td class="exhibit-lens-property-values"><span ex:content=".documents"></span></td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
       """
