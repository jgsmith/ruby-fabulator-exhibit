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
        attribute :mode, :static => true, :default => 'add'

        has_select
        has_actions

        def run(context, autovivify = false)
          @context.with(context) do |ctx|
            items = self.select(ctx)

            db = @database.run(ctx).first.to_s

            items.each do |item|
              info = Fabulator::Exhibit::Actions::Lib.accumulate_item_info do
                self.run_actions(ctx.with_root(item))
              end
              info['id'] = (@id.run(ctx.with_root(item)).first.to_s rescue nil)
              if self.mode == 'add'
                if info['id'].nil?
                  @@uuid ||= UUID.new
                  info['id'] = @@uuid.generate(:compact)
                end
                info['type'] = self.type(ctx.with_root(item)).first.to_s
                info['label'] = self.label(ctx.with_root(item)).first.to_s
                Fabulator::Exhibit::Actions::Lib.add_info(db, :items, info)
              elsif self.mode == 'remove' && !info['id'].nil?
                Fabulator::Exhibit::Actions::Lib.remove_info(db, :items, info['id'])
              end
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
            nom = self.database(ctx).first.to_s
            m = self.mode(ctx).first.to_s
            scopeType = (self.scope_type(ctx).first.to_s rescue nil)
            db = nil
            if m == 'merge' || !scopeType.nil?
            db = Fabulator::Exhibit::Actions::Lib.fetch_database(nom)
              if !db.nil? && m == 'overwrite'  # !scope_type.nil? is a consequence
                # remove any items of scope_type
                db[:items].delete_if{ |k,v| v['type'] == scopeType }
              end
            end
            if db.nil?
              db = { :items => {}, :types => {}, :properties => {} }
            end
            Fabulator::Exhibit::Actions::Lib.set_database(nom, db)
 
            begin
              ret = self.run_actions(ctx)
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
