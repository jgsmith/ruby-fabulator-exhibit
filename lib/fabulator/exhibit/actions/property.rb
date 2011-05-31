module Fabulator
  module Exhibit
    module Actions
      class Property < Fabulator::Action
        namespace Fabulator::EXHIBIT_NS
        attribute :database, :inherited => true, :static => false
        attribute :name, :static => false
        attribute :valueType, :static => false
        attribute :select, :namespace => FAB_NS, :static => true
        
        def run(context, autovivify = false)
          @context.with(context) do |ctx|
            props = {
              'id' => self.name(ctx).first.to_s,
              'valueType' => self.valueType(ctx).first.to_s
            }
            if !@select.nil?
              props['select'] = @select
            end
            Fabulator::Exhibit::Lib.add_info(
              self.database(ctx).first.to_s, 
              :properties, props
            )
          end
        end
      end
    end
  end
end
