require 'verify/duration'

module Verify
  class Run
    def initialize(metric_datastore, handlers)
      @metric_datastore = metric_datastore
      @handlers = handlers
    end

    def call(action, context)
      result, metrics = handler_for(action).call(action, context) do
        yield
      end

      @metric_datastore << metrics

      failed_context_identifier = result[:failed_context_identifier]
      context.fail!(failed_context_identifier) if failed_context_identifier

      result
    end

    def handler_for(action)
      @handlers.fetch(action.to_s.to_sym, Verify::Duration)
    end
  end
end

