module Metrics
  module Observers
    class Duration
      def initialize(metrics, service)
        @metrics = metrics
        @service = service
      end

      def call(action, _context)
        start_time = Time.now
        result = yield
        duration = Time.now - start_time

        @metrics << {
          time: Time.now.utc,
          host: Socket.gethostname,
          action: action.to_s,
          duration: duration,
          type: 'duration',
          service: @service.to_s
        }

        result
      end
    end
  end
end

