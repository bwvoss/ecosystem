require 'httparty'
require 'metric/receivers/rds'
require 'rescuetime/single_day_sync'

module Rescuetime
  class Run
    def self.call(configuration)
      Rescuetime::SingleDaySync.call(
        db: DB,
        table: :rescuetime_interval,
        http: HTTParty,
        transaction_dir: 'spec/file_sandbox',
        metrics: metric_receiver(configuration),
        run_uuid: configuration.fetch(:run_uuid),
        api_domain: configuration.fetch(:api_domain),
        api_key: configuration.fetch(:api_key),
        datetime: configuration.fetch(:datetime),
        timezone: 'America/Chicago'
      )
    end

    def self.metric_receiver(config)
      config.fetch(:metric_receiver, Metric::Receivers::Rds.new(DB))
    end
  end
end

