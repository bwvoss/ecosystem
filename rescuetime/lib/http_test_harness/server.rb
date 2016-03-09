require 'sinatra'
require 'json'

module HttpTestHarness
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

      query_string = request.query_string

      if !query_string.empty?
        key = "#{request.path}?#{request.query_string}"
      else
        key = request.path
      end

      path_config = PATH_RESPONSES.fetch(key)

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
