require 'datastore/deduplicated_insert'
require 'http/get'
require 'light-service'
require 'rescuetime/build_url'
require 'verify/run'
require 'verify/deduplicated_insert'
require 'verify/http_get'
require 'rescuetime/parse_date_to_utc'
require 'rescuetime/parse_rows'

module Rescuetime
  class SingleDaySync
    extend LightService::Organizer
    def self.call(config)
      with(config)
        .around_each(verifier(config))
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

    def self.verifier(config)
      Verify::Run.new(config.fetch(:metric_receiver), verifier_config)
    end

    def self.verifier_config
      {
        'Http::Get': Verify::HttpGet,
        'Datastore::DeduplicatedInsert': Verify::DeduplicatedInsert
      }
    end
  end
end

