require 'uuid'

module Fabulator
  module Exhibit
    module Actions
      class Item
        def compile_xml(xml, c_attrs = { })
          @database = ActionLib.get_attribute(EXHIBIT_NS, 'database', c_attrs)
          @actions = ActionLib.compile_actions(xml, c_attrs)
          @id = ActionLib.get_local_attr(xml, EXHIBIT_NS, 'id', { :eval => true })
          @type = ActionLib.get_attribute(EXHIBIT_NS, 'type', c_attrs)
          @label = ActionLib.get_local_attr(xml, EXHIBIT_NS, 'label', { :eval => true })
          @select = ActionLib.get_local_attr(xml, FAB_NS, 'select', { :eval => true })
          self
        end

        def run(context, autovivify = false)
          items = [ ]
          if @select.nil?
            items = [ context ]
          else
            items = @select.run(context)
          end

          db = @database.run(context).first.to_s

          items.each do |item|
            info = Fabulator::Exhibit::Actions::Lib.accumulate_item_info do
              @actions.run(item)
            end
            info['id'] = (@id.run(item).first.to_s rescue nil)
            if info['id'].nil?
              @@uuid ||= UUID.new
              info['id'] = @@uuid.generate(:compact)
            end
            info['type'] = @type.run(item).first.to_s
            info['label'] = @label.run(item).first.to_s
            Fabulator::Exhibit::Actions::Lib.add_info(db, :items, info)
          end
        end
      end

      class Database
        def compile_xml(xml, c_attrs = { })
          @database = ActionLib.get_attribute(EXHIBIT_NS, 'database', c_attrs)
          @mode     = ActionLib.get_local_attr(xml, EXHIBIT_NS, 'mode', { :default => 'merge' })
          @actions = ActionLib.compile_actions(xml, c_attrs)
          @scope_type = ActionLib.get_attribute(EXHIBIT_NS, 'type', c_attrs)
          self
        end

        def run(context, autovivify = false)
          nom = @database.run(context).first.to_s
          mode = @mode.run(context).first.to_s
          scope_type = (@scope_type.run(context).first.to_s rescue nil)
          if mode == 'merge' || !scope_type.nil?
            Fabulator::Exhibit::Actions::Lib.set_database(nom, Fabulator::Exhibit::Actions::Lib.fetch_database(nom))
          else
            Fabulator::Exhibit::Actions::Lib.set_database(nom, { :items => {}, :types => {}, :properties => {} })
          end
          if mode == 'overwrite' && !scope_type.nil?
            # remove any items of scope_type
            db = Fabulator::Exhibit::Actions::Lib.get_database(nom)
            db[:items].delete_if{ |k,v| v['type'] == scope_type }
          end
          ret = [ ]
          begin
            ret = @actions.run(context)
          ensure
            Fabulator::Exhibit::Actions::Lib.store_database(
              nom,
              Fabulator::Exhibit::Actions::Lib.get_database(nom)
            )
          end
          return ret
        end
      end

    end
  end
end
