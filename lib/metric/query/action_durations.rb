module Metric
  module Query
    ActionDurations = lambda do |context|
      metric = context.fetch(:metric)
      run_uuid = context.fetch(:run_uuid)
      records = metric.where(run_uuid: run_uuid).all

      records.map do |record|
        {
          action: record.fetch(:action),
          duration: record.fetch(:duration)
        }
      end
    end
  end
end

