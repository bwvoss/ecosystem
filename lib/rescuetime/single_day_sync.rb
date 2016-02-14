require 'datastore/deduplicated_insert'
require 'http/get'
require 'light-service'
require 'metric/around_each_handler'
require 'rescuetime/build_url'
require 'rescuetime/handlers/deduplicated_insert'
require 'rescuetime/handlers/http_get'
require 'rescuetime/parse_date_to_utc'
require 'rescuetime/parse_rows'

module Rescuetime
  class SingleDaySync
    extend LightService::Organizer
    def self.call(config)
      with(config)
        .around_each(handler(config))
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

    def self.handler(config)
      Metric::AroundEachHandler.new(config.fetch(:metric_receiver), handlers)
    end

    def self.handlers
      namespace = Rescuetime::Handlers
      {
        'Http::Get': namespace::HttpGet,
        'Datastore::DeduplicatedInsert': namespace::DeduplicatedInsert
      }
    end
  end
end

