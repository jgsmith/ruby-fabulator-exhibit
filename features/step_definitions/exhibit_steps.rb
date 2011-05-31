Given /the '(.*)' database/ do |n|
  @exhibit_db_nom = n
end

Then /there should be (\d+) items?/ do |n|
  db = Fabulator::Exhibit::Lib.fetch_database(@exhibit_db_nom)
  db[:items].size.should == n.to_i
end

Then /^the item '(.*)' should have type '(.+)'$/ do |id, type|
  db = Fabulator::Exhibit::Lib.fetch_database(@exhibit_db_nom)
  #item = Fabulator::Exhibit::Lib.get_item(@exhibit_db_nom, @context, id)
  db[:items][id]['type'].should == type
end

Then /^the item '(.*)' should have the label '(.*)'$/ do |id, label|
  db = Fabulator::Exhibit::Lib.fetch_database(@exhibit_db_nom)
  db[:items][id]['label'].should == label
end

Then /^the item '(.*)' should have the property '(.*)' as '(.*)'$/ do |id, prop_name, prop_value|
  #db = Fabulator::Exhibit::Lib.fetch_database(@exhibit_db_nom)
  item = Fabulator::Exhibit::Lib.get_item(@exhibit_db_nom, @context, id)
  item.children(prop_name).select{ |p| p.value == prop_value }.size.should > 0
  #db[:items][id][prop_name].should == prop_value
end

