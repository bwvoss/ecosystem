require 'metric/duration'
require 'rescuetime/invalid_api_key_error'

module Rescuetime
  module Handlers
    class HttpGet
      def self.call(action, context)
        metrics = []
        result, duration = Metric::Duration.call(action, context) do
          yield
        end

        metrics << duration

        error = context.get_response['error']

        if error == '# key not found'
          metrics << build_error_metric(action, context)
          result[:failed_context_identifier] = 'invalid_rescuetime_api_key'
        end

        [result, metrics]
      end

      def self.build_error_metric(action, context)
        {
          time: Time.now.utc,
          run_uuid: context.fetch(:run_uuid),
          type: 'run_result',
          error: Rescuetime::InvalidApiKeyError.new.to_s,
          action: action.to_s,
          status: 'failure'
        }
      end
    end
  end
end

