module Fabulator
  module Exhibit
    module Actions
      class Value < Fabulator::Action

        namespace Fabulator::EXHIBIT_NS
        attribute :name, :static => false

        has_select

        def run(context, autovivify = false)
          @context.with(context) do |ctx|
            Fabulator::Exhibit::Actions::Lib.add_item_to_accumulator(
              self.name(ctx).first.to_s,
              self.select(ctx).collect{ |s| s.value }
            )
          end
        end
      end
    end
  end
end
