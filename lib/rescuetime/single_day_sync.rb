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
        .around_each(verifier)
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

    def self.verifier
      Verify::Run.new(
        'Http::Get': Verify::HttpGet,
        'Datastore::DeduplicatedInsert': Verify::DeduplicatedInsert
      )
    end
  end
end

