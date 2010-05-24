module Fabulator
  module Exhibit
    module Actions
      class Value
        def compile_xml(xml, c_attrs = { })
          @name = ActionLib.get_local_attr(xml, EXHIBIT_NS, 'name')
          @select = ActionLib.get_local_attr(xml, FAB_NS, 'select', { :eval => true })
          self
        end

        def run(context, autovivify = false)
          Fabulator::Exhibit::Actions::Lib.add_item_to_accumulator(
            @name.run(context).first.to_s, 
            @select.run(context).collect{ |s| s.to_s }
          )
        end
      end
    end
  end
end
