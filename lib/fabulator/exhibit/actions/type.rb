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
            info = { :id => @name.run(ctx).first.to_s }
            if !@pluralLabel.nil?
              info['pluralLabel'] = @pluralLabel.run(ctx).first.to_s
            end
            Fabulator::Exhibit::Actions::Lib.add_info(
              @database.run(ctx).first.to_s, :types, info
            )
          end
        end
      end
    end
  end
end
