require 'sinatra'
require_relative 'query/all_run_durations'
require_relative 'query/run_duration'
require 'json'

module Metric
  class Server < Sinatra::Base
    get '/runs' do
      response['Access-Control-Allow-Origin'] = '*'
      content_type :json

      metrics = Metric::Query::AllRunDurations.new(
        DB[:duration_metric]
      )

      metrics.inspect.to_json
    end

    get '/runs/:run_uuid/duration' do
      response['Access-Control-Allow-Origin'] = '*'
      content_type :json

      metrics = Metric::Query::RunDuration.new(
        DB[:duration_metric],
        params[:run_uuid]
      )

      metrics.inspect.to_json
    end
  end
end

