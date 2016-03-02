module Verify
  class HttpTimeout
    def self.call(action, context)

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

