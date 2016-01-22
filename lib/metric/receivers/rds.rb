module Metric
  module Receivers
    class Rds
      def initialize(db)
        @db = db
      end

      def <<(event)
        type = event.delete(:type)
        event[:host] = event.fetch(:host, Socket.gethostname)
        event[:time] = event.fetch(:time, Time.now.utc)

        @db["#{type}_metric".to_sym] << event
      end
    end
  end
end

