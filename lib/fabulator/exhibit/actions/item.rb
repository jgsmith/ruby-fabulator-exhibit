require 'uuid'

module Fabulator
  module Exhibit
    module Actions
      class Item < Fabulator::Action
        namespace Fabulator::EXHIBIT_NS
        attribute :database, :inherited => true, :static => false
        attribute :id, :eval => true, :static => false
        attribute :type, :static => false, :inherited => true
        attribute :label, :eval => true, :static => false

        has_select
        has_actions

        def run(context, autovivify = false)
          @context.with(context) do |ctx|
            items = @select.run(ctx)

            db = @database.run(ctx).first.to_s
  
            items.each do |item|
              info = Fabulator::Exhibit::Actions::Lib.accumulate_item_info do
                @actions.run(ctx.with_root(item))
              end
              info['id'] = (@id.run(ctx.with_root(item)).first.to_s rescue nil)
              if info['id'].nil?
                @@uuid ||= UUID.new
                info['id'] = @@uuid.generate(:compact)
              end
              info['type'] = @type.run(ctx.with_root(item)).first.to_s
              info['label'] = @label.run(ctx.with_root(item)).first.to_s
              Fabulator::Exhibit::Actions::Lib.add_info(db, :items, info)
            end
          end
        end
      end

      class Database < Fabulator::Action
        namespace Fabulator::EXHIBIT_NS
        attribute :database, :inherited => true, :static => false
        attribute :mode, :default => 'merge', :static => false
        attribute :type, :as => :scope_type, :static => false

        has_actions

        def run(context, autovivify = false)
          ret = [ ]
          @context.with(context) do |ctx|
            nom = @database.run(ctx).first.to_s
            mode = @mode.run(ctx).first.to_s
            scope_type = (@scope_type.run(ctx).first.to_s rescue nil)
            db = nil
            if mode == 'merge' || !scope_type.nil?
            db = Fabulator::Exhibit::Actions::Lib.fetch_database(nom)
              if !db.nil? && mode == 'overwrite'  # !scope_type.nil? is a consequence
                # remove any items of scope_type
                db[:items].delete_if{ |k,v| v['type'] == scope_type }
              end
            end
            if db.nil?
              db = { :items => {}, :types => {}, :properties => {} }
            end
            Fabulator::Exhibit::Actions::Lib.set_database(nom, db)
 
            begin
              ret = @actions.run(ctx)
            ensure
              Fabulator::Exhibit::Actions::Lib.store_database(
                nom,
                Fabulator::Exhibit::Actions::Lib.get_database(nom)
              )
            end
          end
          return ret
        end
      end

    end
  end
end
