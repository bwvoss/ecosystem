module Metric
  class CollectorFactory
    def initialize(metrics, service, run_uuid, last_action)
      @metrics = metrics
      @service = service
      @run_uuid = run_uuid
      @last_action = last_action
    end

    def call(action, _context)
      start_time = Time.now

      result = yield

      record_duration(start_time, action)

      record_successful_run if action == Datastore::DeduplicatedInsert

      result
    end

    def record_duration(start_time, action)
      duration = Time.now - start_time

      @metrics << {
        action: action.to_s,
        duration: duration,
        run_uuid: @run_uuid,
        type: 'duration',
        service: @service.to_s
      }
    end

    def record_successful_run
      @metrics << {
        run_uuid: @run_uuid,
        type: 'run_result',
        status: 'success'
      }
    end
  end
end

