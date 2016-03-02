require 'http/get'
require 'rescuetime/build_url'
require 'verify/duration'
require 'verify/non_200_http_response'
require 'verify/rescuetime_api_key'
require 'verify/successful_run'
require 'rescuetime/parse_date_to_utc'
require 'rescuetime/build_response'
require 'rescuetime/parse_rows'

module Rescuetime
  class SingleDaySync
    def self.call(context)
      configuration.each do |item|
        failed = context[:failed]
        Rescuetime::BuildResponse.execute(context) && break if failed

        action = item.fetch(:action)
        context = Verify::Duration.call(action, context) do
          context = action.execute(context)

          item.fetch(:verifiers, []).each do |monitor|
            context = monitor.call(action, context)
          end

          context
        end
      end

      context
    end

    def self.configuration
      [
        { action: Rescuetime::BuildUrl },
        { action: Http::Get, verifiers:
          [Verify::Non200HttpResponse,
           Verify::RescuetimeApiKey]
        },
        { action: Rescuetime::ParseRows },
        { action: Rescuetime::ParseDateToUtc },
        { action: Rescuetime::BuildResponse, verifiers:
          [Verify::SuccessfulRun]
        }
      ]
    end
  end
end

