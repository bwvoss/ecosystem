require 'sinatra'
require_relative 'inspectors/run_duration'
require 'json'

module Metric
  class Server < Sinatra::Base
    get '/duration/:run_uuid' do
      response['Access-Control-Allow-Origin'] = '*'
      content_type :json

      #metrics = Metric::Inspectors::RunDuration.new(
        #DB[:duration_metric],
        #params[:run_uuid]
      #)

      {"run_uuid":"88db2cfc-4dd6-4964-8633-0db7910422f1","start_time":"2016-02-09 01:33:27 -0600","end_time":"2016-02-09 01:33:28 -0600","duration":0.501699,"action_durations":{"Rescuetime::BuildUrl":9.0e-05,"Http::Get":0.401205,"Rescuetime::ParseRows":0.011794,"Rescuetime::ParseDateToUtc":0.058195,"Datastore::DeduplicatedInsert":0.030415}}.to_json

      #metrics.inspect.to_json
    end
  end
end

