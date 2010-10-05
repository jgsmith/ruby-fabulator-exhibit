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
            Fabulator::Exhibit::Lib.add_info(
              self.database(ctx).first.to_s, 
              :properties, {
                'id' => self.name(ctx).first.to_s,
                'valueType' => self.valueType(ctx).first.to_s
              }
            )
          end
        end
      end
    end
  end
end
