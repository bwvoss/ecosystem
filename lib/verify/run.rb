require 'verify/duration'
require 'metric/transactions/send'

module Verify
  class Run
    def initialize(handlers)
      @handlers = handlers
    end

    def call(action, context)
      result = handler_for(action).call(action, context) do
        yield
      end

      failed_context_identifier = result[:failed_context_identifier]
      if failed_context_identifier
        Metric::Transactions::Send.execute(context)
        context.fail!(failed_context_identifier)
      end

      result
    end

    def handler_for(action)
      @handlers.fetch(action.to_s.to_sym, Verify::Duration)
    end
  end
end

