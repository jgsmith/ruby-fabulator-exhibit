module Fabulator
  module Exhibit
    module Actions
      class Type < Fabulator::Action

        namespace Fabulator::EXHIBIT_NS
        attribute :database, :inherited => true, :static => false
        attribute :name, :static => false
        attribute :pluralLabel, :static => false

        def run(context, autovivify = false)
          @context.with(context) do |ctx|
            info = { :id => self.name(ctx).first.to_s }
            pl = (self.pluralLabel(ctx).first.to_s rescue nil)
            if !pl.nil?
              info['pluralLabel'] = pl
            end
            Fabulator::Exhibit::Lib.add_info(
              self.database(ctx).first.to_s, :types, info
            )
          end
        end
      end
    end
  end
end
