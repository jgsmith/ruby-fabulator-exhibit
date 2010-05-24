require 'fabulator/exhibit/actions/item'
require 'fabulator/exhibit/actions/property'
require 'fabulator/exhibit/actions/type'
require 'fabulator/exhibit/actions/value'

module Fabulator
  EXHIBIT_NS = "http://dh.tamu.edu/ns/fabulator/exhibit/1.0#"
  module Exhibit
    module Actions
      class Lib
        include Fabulator::ActionLib

        @@databases = { }

        register_namespace EXHIBIT_NS

        register_attribute 'database'

        register_type 'database', {
          :to => [
            { :type => [ FAB_NS, 'string' ],
              :weight => 1.0,
              :convert => lambda { |x| x.anon_node(x.value.to_s, [ FAB_NS, 'string' ]) }
            }
          ]
        }

        action 'database', Database
        action 'item', Item
        action 'value', Value
        action 'property', Property
        action 'type', Type

        ## should set up an empty database with :items, :types, and :properties
        def self.fetch_database(nom)
          raise "fetch_database is not implemented by the framework."
        end

        def self.store_database(nom, data)
          raise "store_database is not imeplemented by the framework."
        end

        def self.get_database(nom)
          @@databases[nom]
        end

        def self.set_database(nom, data)
          @@databases[nom] = data
        end

        def self.store_databases
          @@databases.keys.each do |k|
            self.store_database(k, @@databases[k])
          end
        end

        def self.accumulate_item_info(&block)
          @@item ||=[]
          @@item.unshift({})
          yield
          @@item.shift
        end

        def self.add_item_to_accumulator(k,v)
          return if @@item.empty?
          @@item[0][k] = v
        end

        def self.add_info(nom, t, item)
          @@databases[nom] ||= self.fetch_database(nom)
          case t
            when :items
              @@databases[nom][t].each do |i|
                if i[:id] == item[:id]
                  i.merge!(item)
                  return
                end
              end
              @@databases[nom][t] << item
            when :types, :properties
              @@databases[nom][:type][item[:id]] ||= { }
              @@databases[nom][:type][item[:id]].merge!(item)
              @@databases[nom][:type][item[:id]].delete(:id)
          end
        end

        def self.remove_info(nom, t, id)
          @@databases[nom] ||= self.fetch_database(nom)
          return if @@databases[nom][t].empty?
          case t
            when :items
              @@databases[nom][t].delete!{ |i| i[:id] == id }
            when :types
            when :properties
          end
        end
      end
    end
  end
end
