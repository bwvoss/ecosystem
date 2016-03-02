module Verify
  class Duration
    def self.call(action, context)
      start_time = Time.now
      context = yield
      duration = Time.now - start_time

      context.fetch(:metric_collector) << {
        action: action.to_s,
        duration: duration,
        run_uuid: context.fetch(:run_uuid),
        type: 'duration'
      }

      context
    end
  end
end

