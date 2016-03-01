require 'httparty'

module Http
  class Get
    def self.execute(ctx)
      get_url = ctx.fetch(:get_url)
      http = ctx.fetch(:http, HTTParty)
      get_response = http.get(get_url)
      ctx[:get_response] = get_response

      ctx
    end
  end
end
