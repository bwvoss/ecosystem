require 'http/get'
require 'light-service'
require 'rescuetime/build_url'
require 'verify/run'
require 'verify/successful_run'
require 'verify/http_get'
require 'rescuetime/parse_date_to_utc'
require 'rescuetime/transactions/multi_insert'
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
        Rescuetime::Transactions::MultiInsert
      ]
    end

    def self.verifier
      Verify::Run.new(
        'Http::Get': Verify::HttpGet,
        'Rescuetime::Transactions::MultiInsert': Verify::SuccessfulRun
      )
    end
  end
end

