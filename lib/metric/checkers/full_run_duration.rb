module Metric
  module Checkers
    class FullRunDuration
      def initialize(db, duration_threshold, run_uuid)
        @db = db
        @duration_threshold = duration_threshold
        @run_uuid = run_uuid
      end

      def check!
        duration = @db.where(run_uuid: @run_uuid)
                   .sum(:duration)
        if duration
          @check_result = duration < @duration_threshold
        else
          @check_result = true
        end
      end

      def passed?
        @check_result
      end
    end
  end
end
