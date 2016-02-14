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
    def self.call(configuration)
      with(configuration)
        .around_each(handler(configuration))
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

    def self.handler(configuration)
      Metric::AroundEachHandler.new(
        configuration.fetch(:metric_receiver),
        'Http::Get': handlers::HttpGet,
        'Datastore::DeduplicatedInsert': handlers::DeduplicatedInsert
      )
    end

    def self.handlers
      Rescuetime::Handlers
    end
  end
end

