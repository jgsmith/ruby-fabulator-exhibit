module Fabulator
  module Exhibit
    module Actions
      class Type
        def compile_xml(xml, c_attrs = { })
          @database = ActionLib.get_attribute(EXHIBIT_NS, 'database', c_attrs)
          @name = ActionLib.get_local_attr(xml, EXHIBIT_NS, 'name')
          @pluralLabel = ActionLib.get_local_attr(xml, EXHIBIT_NS, 'pluralLabel')
          self
        end

        def run(context, autovivify = false)
          info = { :id => @name.run(context).first.to_s }
          if !@pluralLabel.nil?
            info['pluralLabel'] = @pluralLabel.run(context).first.to_s
          end
          Fabulator::Exhibit::Actions::Lib.add_info(
            @database.run(context).first.to_s, :types, info
          )
        end
      end
    end
  end
end
