require 'verify/duration'
require 'rescuetime/build_response'

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
        context = Rescuetime::BuildResponse.execute(result)
        context.fail!(failed_context_identifier)
      end

      result
    end

    def handler_for(action)
      @handlers.fetch(action.to_s.to_sym, Verify::Duration)
    end
  end
end

