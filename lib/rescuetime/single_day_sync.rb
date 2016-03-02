require 'exception_handler/http_timeout'
require 'http/get'
require 'rescuetime/build_response'
require 'rescuetime/build_url'
require 'rescuetime/parse_date_to_utc'
require 'rescuetime/parse_rows'
require 'verify/duration'
require 'verify/non_200_http_response'
require 'verify/rescuetime_api_key'
require 'verify/successful_run'

module Rescuetime
  class SingleDaySync
    def self.call(context)
      configuration.each do |item|
        failed = context[:failed]
        Rescuetime::BuildResponse.execute(context) && break if failed

        action = item.fetch(:action)
        context = Verify::Duration.call(action, context) do
          handler = item[:exception_handler]

          if handler
            context = handler.call(action, context) do
              action.execute(context)
            end
          else
            context = action.execute(context)
          end

          unless context[:failed]
            item.fetch(:state_change_verifiers, []).each do |monitor|
              context = monitor.call(action, context)
            end
          end

          context
        end
      end

      context
    end

    def self.configuration
      [
        {
          action: Rescuetime::BuildUrl
        },
        {
          action: Http::Get,
          state_change_verifiers: [
            Verify::Non200HttpResponse,
            Verify::RescuetimeApiKey
          ],
          exception_handler: ExceptionHandler::HttpTimeout
        },
        {
          action: Rescuetime::ParseRows
        },
        {
          action: Rescuetime::ParseDateToUtc
        },
        {
          action: Rescuetime::BuildResponse,
          state_change_verifiers: [
            Verify::SuccessfulRun
          ]
        }
      ]
    end
  end
end

