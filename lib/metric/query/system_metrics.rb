module Metric
  module Query
    SystemMetrics = lambda do |context|
      run_uuid = context.fetch(:run_uuid)

      durations = context
                  .fetch(:duration_metric)
                  .where(run_uuid: run_uuid)
                  .order
                  .all

      start_time = durations.first.fetch(:time)
      end_time = durations.last.fetch(:time)

      context
      .fetch(:system_metric)
      .where(time: start_time..end_time)
      .select(:time, :cpu_percentage_used)
      .all
    end
  end
end

