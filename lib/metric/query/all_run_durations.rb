module Metric
  module Query
    AllRunDurations = lambda do |context|
      metric = context.fetch(:metric)

      metric.select_group(:run_uuid)
      .select_append { sum(duration).as(duration) }
      .order(:run_uuid)
      .all
    end
  end
end

