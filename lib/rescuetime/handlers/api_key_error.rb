require 'rescuetime/invalid_api_key_error'

module Rescuetime
  module Handlers
    class ApiKeyError
      def self.call(action, context, metrics)
        error = context.get_response['error']

        if error == '# key not found'
          api_key_error = Rescuetime::InvalidApiKeyError.new.to_s
          metrics << build_error_metric(action, context, api_key_error)
          context[:failed_context_identifier] = 'invalid_rescuetime_api_key'
        end

        [context, metrics]
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

