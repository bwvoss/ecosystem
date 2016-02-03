module Metric
  module Checkers
    class CpuPercentage
      def initialize(db, cpu_threshold, metric_count_threshold, from_time)
        @db = db
        @cpu_threshold = cpu_threshold
        @metric_count_threshold = metric_count_threshold
        @from_time = from_time
      end

      def check!
        @check_result = @db.where("cpu_percentage_used >= #{@cpu_threshold}")
                        .filter('time >= ?', @from_time)
                        .count < @metric_count_threshold
      end

      def passed?
        @check_result
      end
    end
  end
end
