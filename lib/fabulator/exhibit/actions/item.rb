module Fabulator
  module Exhibit
    module Actions
      class Item
        def compile_xml(xml, c_attrs = { })
          @database = ActionLib.get_attribute(EXHIBIT_NS, 'database', c_attrs)
          @actions = ActionLib.compile_actions(xml, c_attrs)
          @id = ActionLib.get_local_attr(xml, EXHIBIT_NS, 'id', { :eval => true })
          @type = ActionLib.get_local_attr(xml, EXHIBIT_NS, 'type')
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
            info[:id] = @id.run(item).first.to_s
            info[:type] = @type.run(item).first.to_s
            info[:label] = @label.run(item).first.to_s
            Fabulator::Exhibit::Actions::Lib.add_info(db, :items, info)
          end
        end
      end

      class Database
        def compile_xml(xml, c_attrs = { })
          @database = ActionLib.get_attribute(EXHIBIT_NS, 'database', c_attrs)
          @actions = ActionLib.compile_actions(xml, c_attrs)
          self
        end

        def run(context, autovivify = false)
          nom = @database.run(context).first.to_s
          Fabulator::Exhibit::Actions::Lib.set_database(nom, Fabulator::Exhibit::Actions::Lib.fetch_database(nom))
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
