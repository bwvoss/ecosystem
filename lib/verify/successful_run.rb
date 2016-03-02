module Verify
  class SuccessfulRun
    def self.call(action, context)
      context.fetch(:metric_collector) <<
        build_successful_run_metric(action, context)

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

