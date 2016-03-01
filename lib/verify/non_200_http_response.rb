module Verify
  class Non200HttpResponse
    def self.call(action, context)
      get_response = context.fetch(:get_response)

      unless get_response.success?
        error = "#{get_response.code}: #{get_response.parsed_response}"
        metrics = context.fetch(:metric_collector)
        metrics << build_error_metric(action, context, error)
        context[:failed_context_identifier] = 'rescuetime_http_exception'
      end
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

