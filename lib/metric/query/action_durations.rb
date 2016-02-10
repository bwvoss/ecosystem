module Metric
  module Query
    class ActionDurations
      def initialize(metric, run_uuid)
        @metric = metric
        @run_uuid = run_uuid
      end

      def inspect
        records = @metric.where(run_uuid: @run_uuid).all

        records.map do |record|
          {
            action: record.fetch(:action),
            duration: record.fetch(:duration)
          }
        end
      end
    end
  end
end

