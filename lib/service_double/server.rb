require 'sinatra'
require 'json'

module ServiceDouble
  class Server < Sinatra::Base
    PATH_RESPONSES = {}

    put '/__config__/set_response' do
      config = JSON.parse(request.body.read)
      response = config.fetch('response')

      PATH_RESPONSES[config.fetch('path')] = {
        code: config.fetch('code', 200),
        response: response,
        hang: config['hang']
      }

      response.to_json
    end

    get '/*' do
      content_type :json

      path = "/#{params[:splat].first}"

      path_config = PATH_RESPONSES.fetch(path)

      code = path_config.fetch(:code)
      response = path_config.fetch(:response).to_json

      hang = path_config[:hang]
      sleep(hang) if hang

      if code != 200
        halt(code, response)
      else
        response
      end
    end
  end
end
