@db
Feature: Simple database items

  Scenario: simple database with one item
    Given a context
     And the prefix f as "http://dh.tamu.edu/ns/fabulator/1.0#"
     And the statemachine
      """
        <f:application xmlns:f="http://dh.tamu.edu/ns/fabulator/1.0#" 
           xmlns:ex="http://dh.tamu.edu/ns/fabulator/exhibit/1.0#"
           ex:database="test"
        >
          <ex:database>
            <ex:item ex:id="'foo'" ex:type="fooType" ex:label="'fooLabel'">
              <ex:value ex:name="bar" f:select="'baz'" />
            </ex:item>
            <ex:item ex:id="'bar'" ex:type="fooType" ex:label="'barLabel'">
              <ex:value ex:name="bar" f:select="'bat'" />
            </ex:item>
          </ex:database>
          <ex:database>
            <f:value f:path="/f" f:select="ex:item('foo')" />
          </ex:database>
          <f:value f:path="/g" f:select="ex:items()" />
        </f:application>
      """
     And using the 'test' database
    Then there should be 2 items
     And the item 'foo' should have type 'fooType'
     And the item 'foo' should have the label 'fooLabel'
     And the item 'foo' should have the property 'bar' as 'baz'
     And the item 'bar' should have the label 'barLabel'
     And the expression (/f/bar) should equal ['baz']
     And the expression (/g/foo/bar) should equal ['baz']
     And the expression (/g/bar/bar) should equal ['bat']
