module Fabulator
  module Exhibit
    module Actions
      class Value < Fabulator::Action

        namespace Fabulator::EXHIBIT_NS
        attribute :name, :static => false

        has_select

        def run(context, autovivify = false)
          @context.with(context) do |ctx|
             value = self.select(ctx).collect{ |s| s.value }
             ctx.get_scoped_info('exhibit/item/info')[self.name(ctx).first.to_s] = value.empty? ? nil : (value.size == 1 ? value.first : value)
          end
        end
      end
    end
  end
end
