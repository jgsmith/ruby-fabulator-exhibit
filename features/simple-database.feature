Feature: Simple database items

  Scenario: simple database with one item
    Given the statemachine
      """
        <f:application xmlns:f="http://dh.tamu.edu/ns/fabulator/1.0#" 
           xmlns:ex="http://dh.tamu.edu/ns/fabulator/exhibit/1.0#"
           ex:database="test"
        >
          <ex:database>
            <ex:item ex:id="'foo'" ex:type="fooType" ex:label="'fooLabel'">
              <ex:value ex:name="bar" f:select="'baz'" />
            </ex:item>
          </ex:database>
          <ex:database>
            <f:value f:path="/f" f:select="ex:item('foo')" />
          </ex:database>
        </f:application>
      """
     And using the 'test' database
    Then there should be 1 item
     And the item 'foo' should have type 'fooType'
     And the item 'foo' should have the label 'fooLabel'
     And the item 'foo' should have the property 'bar' as 'baz'
     And the expression (/f/bar) should equal ['baz']
