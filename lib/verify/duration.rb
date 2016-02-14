module Verify
  class Duration
    def self.call(action, context)
      start_time = Time.now
      result = yield
      duration = Time.now - start_time

      context.fetch(:metrics) << {
        action: action.to_s,
        duration: duration,
        run_uuid: context.fetch(:run_uuid),
        type: 'duration'
      }

      result
    end
  end
end

