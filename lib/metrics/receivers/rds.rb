module Metrics
  module Receivers
    class Rds
      def initialize(db)
        @db = db
      end

      def <<(event)
        type = event.delete(:type)
        @db["#{type}_metric".to_sym] << event
      end
    end
  end
end

