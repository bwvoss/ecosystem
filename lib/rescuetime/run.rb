require 'httparty'
require 'metric/receiver'
require 'rescuetime/single_day_sync'

module Rescuetime
  class Run
    def self.call(configuration)
      Rescuetime::SingleDaySync.call(
        db: DB,
        table: :rescuetime_interval,
        http: HTTParty,
        metrics: Metric::Receiver.new,
        run_uuid: configuration.fetch(:run_uuid),
        api_domain: configuration.fetch(:api_domain),
        api_key: configuration.fetch(:api_key),
        datetime: configuration.fetch(:datetime),
        timezone: 'America/Chicago'
      )
    end
  end
end

