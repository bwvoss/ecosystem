require 'verify/duration'

module Verify
  class DeduplicatedInsert
    def self.call(action, context)
      result = Verify::Duration.call(action, context) do
        yield
      end

      context.fetch(:metrics) << build_successful_run_metric(action, context)

      result
    end

    def self.build_successful_run_metric(action, context)
      {
        action: action.to_s,
        run_uuid: context.fetch(:run_uuid),
        type: 'run_result',
        status: 'success'
      }
    end
  end
end

