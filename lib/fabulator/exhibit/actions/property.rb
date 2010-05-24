module Fabulator
  module Exhibit
    module Actions
      class Property
        def compile_xml(xml, c_attrs = { })
          @database = ActionLib.get_attribute(EXHIBIT_NS, 'database', c_attrs)
          @name = ActionLib.get_local_attr(EXHIBIT_NS, 'name')
          @valueType = ActionLib.get_local_attr(EXHIBIT_NS, 'valueType')
          self
        end

        def run(context, autovivify = false)
          Fabulator::Exhibit::Actions::Lib.add_info(
            @database.run(context).first.to_s, 
            :properties, {
              :id => @name.run(context).first.to_s,
              :valueType => @valueType.run(context).first.to_s
            }
          )
        end
      end
    end
  end
end
