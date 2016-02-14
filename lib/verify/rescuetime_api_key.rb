require 'rescuetime/invalid_api_key_error'

module Verify
  class RescuetimeApiKey
    def self.call(action, context)
      error = context.get_response['error']

      if error == '# key not found'
        api_key_error = Rescuetime::InvalidApiKeyError.new.to_s
        metrics = context.fetch(:metrics)
        metrics << build_error_metric(action, context, api_key_error)
        context[:failed_context_identifier] = 'invalid_rescuetime_api_key'
      end

      context
    end

    def self.build_error_metric(action, context, error)
      {
        run_uuid: context.fetch(:run_uuid),
        type: 'run_result',
        error: error,
        action: action.to_s,
        status: 'failure'
      }
    end
  end
end

