module Metric
  module Query
    class AllRunDurations
      def initialize(metric)
        @metric = metric
      end

      def inspect
        @metric.select_group(:run_uuid)
          .select_append { sum(duration).as(duration) }
          .order(:run_uuid)
          .all
      end
    end
  end
end

