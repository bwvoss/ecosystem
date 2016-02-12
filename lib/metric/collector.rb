require 'rescuetime/invalid_api_key_error'

module Metric
  class Collector
    def initialize(metrics, service, run_uuid, last_action)
      @metrics = metrics
      @service = service
      @run_uuid = run_uuid
      @last_action = last_action
    end

    def call(action, context)
      start_time = Time.now

      result = yield

      record_duration(start_time, action)

      if action == Http::Get
        error = context.get_response['error']
        if error == '# key not found'
          api_key_error = Rescuetime::InvalidApiKeyError.new
          record_run(status: 'failure', error: api_key_error.to_s)
          context.fail!('invalid_rescuetime_api_key')
        end
      end

      record_run(status: 'success') if action == @last_action

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

    def record_run(attrs)
      @metrics << {
        run_uuid: @run_uuid,
        type: 'run_result'
      }.merge(attrs)
    end
  end
end

