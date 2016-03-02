require 'metric/receiver'
require 'rescuetime/single_day_sync'

module Rescuetime
  class Run
    def self.call(configuration)
      Rescuetime::SingleDaySync.call(
        metric_collector: Metric::Receiver.new,
        run_uuid: configuration.fetch(:run_uuid),
        datetime: configuration.fetch(:datetime),
        timezone: 'America/Chicago'
      )
    end
  end
end

