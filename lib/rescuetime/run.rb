require 'httparty'
require 'metric/receivers/rds'
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
  class Run
    extend LightService::Organizer
    def self.call(config)
      with(build_config(config))
        .around_each(verifier)
        .reduce(actions)
    end

    def self.build_config(config)
      {
        db: DB,
        table: :rescuetime_interval,
        http: HTTParty,
        metrics: metric_receiver(config),
        run_uuid: config.fetch(:run_uuid),
        api_domain: config.fetch(:api_domain),
        api_key: config.fetch(:api_key),
        datetime: config.fetch(:datetime),
        timezone: 'America/Chicago'
      }
    end

    def self.metric_receiver(config)
      config.fetch(:metric_receiver, Metric::Receivers::Rds.new(DB))
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

