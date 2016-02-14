require 'verify/duration'

module Verify
  class DeduplicatedInsert
    def self.call(action, context)
      result, duration = Verify::Duration.call(action, context) do
        yield
      end

      metrics = [
        duration,
        build_successful_run_metric(action, context)
      ]

      [result, metrics]
    end

    def self.build_successful_run_metric(action, context)
      {
        time: Time.now.utc,
        action: action.to_s,
        run_uuid: context.fetch(:run_uuid),
        type: 'run_result',
        status: 'success'
      }
    end
  end
end

