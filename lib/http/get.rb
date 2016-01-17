require 'light-service'

module Http
  class Get
    extend LightService::Action
    expects :get_url, :http
    promises :get_response

    executed do |ctx|
      get_response = ctx.http.get(ctx.get_url)
      ctx.get_response = get_response
    end
  end
end
