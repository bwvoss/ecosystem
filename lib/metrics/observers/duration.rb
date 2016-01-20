module Metrics
  module Observers
    class Duration
      def initialize(metrics, service)
        @metrics = metrics
        @service = service
      end

      def call(action, context)
        start_time = Time.now
        result = yield
        duration = Time.now - start_time

        @metrics << {
          time: Time.now.utc,
          host: Socket.gethostname,
          action: action.to_s,
          duration: duration,
          run_uuid: context.fetch(:run_uuid),
          type: 'duration',
          service: @service.to_s
        }

        result
      end
    end
  end
end

