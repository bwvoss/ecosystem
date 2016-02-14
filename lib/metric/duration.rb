module Metric
  class Duration
    def self.call
      start_time = Time.now
      result = yield
      duration = Time.now - start_time

      metric = {
        time: Time.now.utc,
        duration: duration,
        type: 'duration',
      }

      [result, metric]
    end
  end
end

