module Metrics
  module Receivers
    class Postgresql
      def initialize(db)
        @db = db
      end

      def push(event)
        type = event.delete(:type)
        @db["#{type}_metric".to_sym].insert(event)
      end
    end
  end
end

