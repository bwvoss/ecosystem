require 'metric/duration'
require 'rescuetime/handlers/api_key_error'
require 'rescuetime/handlers/non_200_http_response'

module Rescuetime
  module Handlers
    class HttpGet
      def self.call(action, context)
        metrics = []
        result, duration = Metric::Duration.call(action, context) do
          yield
        end

        metrics << duration

        result, metrics =
          Rescuetime::Handlers::Non200HttpResponse.call(action, result, metrics)
        result, metrics =
          Rescuetime::Handlers::ApiKeyError.call(action, result, metrics)

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
end

