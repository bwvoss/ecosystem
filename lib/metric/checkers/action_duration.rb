module Metric
  module Checkers
    class ActionDuration
      def initialize(db, duration_threshold, from_time_utc)
        @db = db
        @duration_threshold = duration_threshold
        @from_time_utc = from_time_utc
      end

      def check!
        @check_result = @db.where("duration >= #{@duration_threshold}")
        .filter('time >= ?', @from_time_utc)
        .count == 0
      end

      def passed?
        @check_result
      end
    end
  end
end
