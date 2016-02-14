module Metric
  module Receivers
    class Rds
      def initialize(db)
        @db = db
      end

      def <<(events)
        events = ensure_array(events)

        events.each do |event|
          type = event.delete(:type)

          event[:host] = event.fetch(:host, Socket.gethostname)
          event[:time] = event.fetch(:time, Time.now.utc)

          @db["#{type}_metric".to_sym] << event
        end
      end

      def ensure_array(events)
        [events].flatten
      end
    end
  end
end

