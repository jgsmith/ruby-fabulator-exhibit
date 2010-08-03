module Fabulator
  module Exhibit
    module Actions
      class Property < Fabulator::Action
        namespace Fabulator::EXHIBIT_NS
        attribute :database, :inherited => true, :static => false
        attribute :name, :static => false
        attribute :valueType, :static => false
        
        def run(context, autovivify = false)
          @context.with(context) do |ctx|
            Fabulator::Exhibit::Actions::Lib.add_info(
              @database.run(ctx).first.to_s, 
              :properties, {
                'id' => @name.run(ctx).first.to_s,
                'valueType' => @valueType.run(ctx).first.to_s
              }
            )
          end
        end
      end
    end
  end
end
