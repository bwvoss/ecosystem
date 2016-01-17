require 'sinatra'
require 'json'
require_relative 'rescuetime_response'
require_relative 'rescuetime_deduplication_response'

class ServiceProxy < Sinatra::Base
  get '/hang' do
    sleep_time = params[:seconds]
    sleep(sleep_time.to_i) if sleep_time
    content_type :json
  end

  get '/rescuetime' do
    sleep_time = params[:hang]
    sleep(sleep_time.to_i) if sleep_time
    content_type :json
    RescuetimeResponse.response.to_json
  end

  get '/rescuetime/deduplication' do
    content_type :json
    RescuetimeDeduplicationResponse.response.to_json
  end
end
