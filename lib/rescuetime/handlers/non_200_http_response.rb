module Rescuetime
  module Handlers
    class Non200HttpResponse
      def self.call(action, context, metrics)
        get_response = context.get_response

        unless get_response.success?
          error = "#{get_response.code}: #{get_response.parsed_response}"
          metrics << build_error_metric(action, context, error)
          context[:failed_context_identifier] = 'rescuetime_http_exception'
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

