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
          @@databases[nom] ||= self.fetch_database(nom)
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
          if v.is_a?(Array) && v.size == 1
            v = v[0]
          end
          @@item[0][k] = v
        end

        def self.add_info(nom, t, item)
          @@databases ||= {}
          @@databases[nom] ||= self.fetch_database(nom)
          @@databases[nom][t][item[:id]] ||= { }
          @@databases[nom][t][item[:id]].merge!(item)
          case t
            when :types, :properties
              @@databases[nom][t][item[:id]].delete(:id)
          end
        end

        def self.remove_info(nom, t, id)
          @@databases[nom] ||= self.fetch_database(nom)
          return if @@databases[nom][t].empty?
          @@databases[nom][t].delete(id)
        end

        function 'items' do |ctx, args, ns|
          db = self.get_database(args.first.to_s)
          db[:items].collect{ |item|
            i = ctx.anon_node(item["id"])
            item.each_pair do |k,v|
              next if k == "id"
              v = [ v ] unless v.is_a?(Array)
              v.each do |vv|
                i.create_child(k,vv)
              end
            end
            i
          }
        end
      end
    end
  end
end
