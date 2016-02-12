require 'light-service'
require 'metric/collector'
require 'rescuetime/build_url'
require 'rescuetime/parse_rows'
require 'rescuetime/parse_date_to_utc'
require 'http/get'
require 'datastore/deduplicated_insert'

module Rescuetime
  class SingleDaySync
    extend LightService::Organizer
    def self.call(configuration)
      with(configuration)
        .around_each(observer(configuration))
        .reduce(actions)
    end

    def self.actions
      [
        Rescuetime::BuildUrl,
        Http::Get,
        Rescuetime::ParseRows,
        Rescuetime::ParseDateToUtc,
        Datastore::DeduplicatedInsert
      ]
    end

    def self.observer(configuration)
      Metric::Collector.new(
        configuration.fetch(:metric_receiver),
        :rescuetime,
        configuration.fetch(:run_uuid),
        actions.last
      )
    end
  end
end

