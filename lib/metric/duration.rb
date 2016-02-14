module Metric
  class Duration
    def self.call(action, context)
      start_time = Time.now
      result = yield
      duration = Time.now - start_time

      metric = {
        time: Time.now.utc,
        action: action.to_s,
        duration: duration,
        run_uuid: context.fetch(:run_uuid),
        type: 'duration'
      }

      [result, metric]
    end
  end
end

