require 'verify/duration'
require 'verify/rescuetime_api_key'
require 'verify/non_200_http_response'

module Verify
  class HttpGet
    def self.call(action, context)
      result = Verify::Duration.call(action, context) do
        yield
      end

      result = Verify::Non200HttpResponse.call(action, result)
      result = Verify::RescuetimeApiKey.call(action, result)

      result
    end
  end
end

