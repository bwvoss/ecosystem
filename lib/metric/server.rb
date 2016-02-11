require 'sinatra'
require_relative 'query/all_run_durations'
require_relative 'query/action_durations'
require_relative 'query/system_metrics'
require 'json'

module Metric
  class Server < Sinatra::Base
    get '/runs' do
      response['Access-Control-Allow-Origin'] = '*'
      content_type :json

      Metric::Query::AllRunDurations.call(
        metric: DB[:duration_metric]
      ).to_json
    end

    get '/runs/:run_uuid/duration' do
      response['Access-Control-Allow-Origin'] = '*'
      content_type :json

      Metric::Query::RunDuration.call(
        metric: DB[:duration_metric],
        run_uuid: params[:run_uuid]
      ).to_json
    end

    get '/runs/:run_uuid/system_metrics' do
      response['Access-Control-Allow-Origin'] = '*'
      content_type :json

      Metric::Query::SystemMetrics.call(
        duration_metric: DB[:duration_metric],
        system_metric: DB[:system_metric],
        run_uuid: params[:run_uuid]
      ).to_json
    end
  end
end

