require 'verify/duration'
require 'verify/rescuetime_api_key'
require 'verify/non_200_http_response'

module Verify
  class HttpGet
    def self.call(action, context)
      Verify::Duration.call(action, context) do
        yield
      end

      Verify::Non200HttpResponse.call(action, context)
      Verify::RescuetimeApiKey.call(action, context)

      context
    end
  end
end

