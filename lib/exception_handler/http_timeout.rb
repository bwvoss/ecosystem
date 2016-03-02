module ExceptionHandler
  class HttpTimeout
    def self.call(action, context)
      begin
       context = yield
      rescue => e

        metrics = context.fetch(:metric_collector)
        metrics << build_error_metric(action, context, e.message)
        context[:failed] = 'http_timeout'
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

