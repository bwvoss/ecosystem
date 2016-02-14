require 'sinatra'
require 'json'

module ServiceDouble
  class Server < Sinatra::Base
    PATH_RESPONSES = {}

    put '/__config__/set_response' do
      config = JSON.parse(request.body.read)

      response = config.fetch('response')
      PATH_RESPONSES[config.fetch('path')] = response

      response.to_json
    end

    get '/*' do
      content_type :json

      path = "/#{params[:splat].first}"

      response = PATH_RESPONSES.fetch(path)

      failure = response['fail']

      if failure
        halt(failure.fetch('code'), failure.fetch('message').to_json)
      else
        response.to_json
      end
    end
  end
end
