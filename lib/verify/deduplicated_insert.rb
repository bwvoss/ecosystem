require 'verify/duration'

module Verify
  class DeduplicatedInsert
    def self.call(action, context)
      result, duration = Verify::Duration.call(action, context) do
        yield
      end

      metrics = [
        duration,
        {
          time: Time.now.utc,
          run_uuid: context.fetch(:run_uuid),
          type: 'run_result',
          status: 'success'
        }
      ]

      [result, metrics]
    end
  end
end

