# This file makes it possible to install RubyCAS-Client as a Rails plugin.

$: << File.expand_path(File.dirname(__FILE__))+'/../../lib'
$: << File.expand_path(File.dirname(__FILE__))+'/../../../fabulator/lib'

require 'fabulator'
require 'fabulator/exhibit'
require 'spec/expectations'
require 'xml/libxml'

Fabulator::Exhibit::Actions::Lib.class_eval do
  def self.fetch_database(nom)
    @@dbs ||= { }
    @@dbs[nom] ||= { :types => {}, :items => {}, :properties => {} }
    @@dbs[nom]
  end

  def self.store_database(nom, data)
    @@dbs[nom] = data
  end
end