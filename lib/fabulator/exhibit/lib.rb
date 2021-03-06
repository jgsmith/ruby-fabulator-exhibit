module Fabulator
  EXHIBIT_NS = "http://dh.tamu.edu/ns/fabulator/exhibit/1.0#"

  require 'fabulator/exhibit/actions/item'
  require 'fabulator/exhibit/actions/property'
  require 'fabulator/exhibit/actions/type'
  require 'fabulator/exhibit/actions/value'

  module Exhibit
    class Lib < Fabulator::TagLib

      @@databases = { }

      namespace EXHIBIT_NS

      action 'database', Actions::Database
      action 'item', Actions::Item
      action 'value', Actions::Value
      action 'property', Actions::Property
      action 'type', Actions::Type

      presentations do
        transformations_into.html do
          xslt_from_file File.join(File.dirname(__FILE__), "..", "..", "..", "xslt", "exhibit-html.xsl")
        end
      end
        

      ## should set up an empty database with :items, :types, and :properties
      def self.fetch_database(nom)
        raise "fetch_database is not implemented by the framework."
      end

      def self.store_database(nom, data)
        raise "store_database is not imeplemented by the framework."
      end

      def self.get_database(nom)
        @@databases ||= {}
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

      def self.add_info(nom, t, item)
        self.get_database(nom)
        @@databases[nom][t][item['id']] ||= { }
        @@databases[nom][t][item['id']].merge!(item)
        @@databases[nom][t][item['id']].each_pair do |k,v|
          if v.nil? || (v.is_a?(Array) && v.empty?) ||
             v.is_a?(String) && v == ""
            @@databases[nom][t][item['id']].delete(k)
          end
        end
        case t
          when :types, :properties
            @@databases[nom][t][item['id']].delete(:id)
        end
      end

      def self.remove_info(nom, t, id)
        self.get_database(nom)
        return if @@databases[nom][t].empty?
        @@databases[nom][t].delete(id)
      end
      
      def self.get_item(nom, ctx, id)
        self.get_database(nom)
        return {} if @@databases[nom][:items].empty?
        i = @@databases[nom][:items][id]
        ## now go through computed properties with i
        ctx_item = ctx.root.anon_node(nil)
        ctx_item.name = id
        i.each_pair do |k,v|
          next if k == "id"
          v = [ v ] unless v.is_a?(Array)
          v.each do |vv|
            ctx_item.create_child(k,vv)
          end
        end
        @@databases[nom][:properties].each_pair{ |prop, info|
          if info['select']
            # eval select and put the results in for prop
            c = ctx.with_root(ctx_item)
            if info['namespaces']
              info['namespaces'].each_pair do |p,n|
                c.set_ns(p,n)
              end
            end
            c.eval_expression(info['select']).each do |v|
              next if v.nil? || v.value.nil?
              ctx_item.create_child(prop, v.value)
            end
          end
        }
        ctx_item
      end

      function 'item' do |ctx, args|
        # need to get at the 'global' ex:database attribute
        nom = ctx.attribute(EXHIBIT_NS, 'database', { :inherited => true, :static => true })
        db = Fabulator::Exhibit::Lib.get_database(nom)
        args.collect{ |a|
          id = a.to_s
          Fabulator::Exhibit::Lib.get_item(nom, ctx, id)
        }
      end

      ## need to make this an iterator
      function 'items' do |ctx, args|
        nom = ctx.attribute(EXHIBIT_NS, 'database', { :inherited => true, :static => true })
        db = Fabulator::Exhibit::Lib.get_database(nom)
        ret = ctx.root.anon_node(nil)
        db[:items].each_pair{ |id, item|
          i = ret.create_child(id, nil)
          item.each_pair do |k,v|
            next if k == "id"
            v = [ v ] unless v.is_a?(Array)
            v.each do |vv|
              i.create_child(k,vv)
            end
          end
        }
        [ ret ]
      end
    end
  end
end
