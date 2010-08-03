Given /the '(.*)' database/ do |n|
  @exhibit_db_nom = n
end

Then /there should be (\d+) items?/ do |n|
  db = Fabulator::Exhibit::Actions::Lib.fetch_database(@exhibit_db_nom)
  db[:items].size.should == n.to_i
end

Then /^the item '(.*)' should have type '(.+)'$/ do |id, type|
  db = Fabulator::Exhibit::Actions::Lib.fetch_database(@exhibit_db_nom)
  db[:items][id]['type'].should == type
end

Then /^the item '(.*)' should have the label '(.*)'$/ do |id, label|
  db = Fabulator::Exhibit::Actions::Lib.fetch_database(@exhibit_db_nom)
  db[:items][id]['label'].should == label
end

Then /^the item '(.*)' should have the property '(.*)' as '(.*)'$/ do |id, prop_name, prop_value|
  db = Fabulator::Exhibit::Actions::Lib.fetch_database(@exhibit_db_nom)
  db[:items][id][prop_name].should == prop_value
end

