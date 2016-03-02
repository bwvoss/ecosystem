require 'httparty'

module Http
  class Get
    def self.execute(ctx)
      get_url = ctx.fetch(:get_url)
      http = ctx.fetch(:http, HTTParty)
      timeout = ENV['HTTP_TIMEOUT_THRESHOLD'] || 10
      get_response = http.get(
        get_url,
        timeout: timeout.to_f
      )

      ctx[:get_response] = get_response

      ctx
    end
  end
end
