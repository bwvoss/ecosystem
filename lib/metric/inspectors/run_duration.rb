module Metric
  module Inspectors
    class RunDuration
      def initialize(metric, run_uuid)
        @metric = metric
        @run_uuid = run_uuid
      end

      def inspect
        records = @metric.where(run_uuid: @run_uuid).all

        {
          run_uuid: @run_uuid,
          start_time: records.first.fetch(:time),
          end_time: records.last.fetch(:time),
          duration: sum_duration(records),
          action_durations: action_durations(records)
        }
      end

      def sum_duration(records)
        records.map do |record|
          record.fetch(:duration)
        end.inject(:+)
      end

      def action_durations(records)
        records.each_with_object({}) do |record, acc|
          acc[record.fetch(:action).to_sym] = record.fetch(:duration)
        end
      end
    end
  end
end

