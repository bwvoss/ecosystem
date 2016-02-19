require 'verify/duration'
require 'metric/transactions/send'

module Verify
  class SuccessfulRun
    def self.call(action, context)
      context.fetch(:metrics) << build_successful_run_metric(action, context)

      Verify::Duration.call(action, context) do
        yield
      end

      Metric::Transactions::Send.execute(context)
      context
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

