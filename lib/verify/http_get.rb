require 'verify/duration'
require 'verify/rescuetime_api_key'
require 'verify/non_200_http_response'

module Verify
  class HttpGet
    def self.call(action, context)
      metrics = []
      result, duration = Verify::Duration.call(action, context) do
        yield
      end

      metrics << duration

      result, metrics =
        Verify::Non200HttpResponse.call(action, result, metrics)
      result, metrics =
        Verify::RescuetimeApiKey.call(action, result, metrics)

      [result, metrics]
    end

    def self.build_error_metric(action, context, error)
      {
        time: Time.now.utc,
        run_uuid: context.fetch(:run_uuid),
        type: 'run_result',
        error: error,
        action: action.to_s,
        status: 'failure'
      }
    end
  end
end

