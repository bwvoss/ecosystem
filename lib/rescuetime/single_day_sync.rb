require 'http/get'
require 'rescuetime/build_url'
require 'verify/duration'
require 'verify/successful_run'
require 'verify/http_get'
require 'rescuetime/parse_date_to_utc'
require 'rescuetime/build_response'
require 'rescuetime/parse_rows'

module Rescuetime
  class SingleDaySync
    def self.call(context)
      configuration.each do |item|
        action = item.fetch(:action)

        item.fetch(:monitor).call(action, context) do
          context = action.execute(context)
        end
      end

      context
    end

    def self.configuration
      [
        { action: Rescuetime::BuildUrl, monitor: Verify::Duration },
        { action: Http::Get, monitor: Verify::Duration },
        { action: Rescuetime::ParseRows, monitor: Verify::Duration },
        { action: Rescuetime::ParseDateToUtc, monitor: Verify::Duration },
        { action: Rescuetime::BuildResponse, monitor: Verify::SuccessfulRun }
      ]
    end
  end
end

