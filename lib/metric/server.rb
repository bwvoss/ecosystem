require 'sinatra'
require_relative 'inspectors/run_duration'
require 'json'

module Metric
  class Server < Sinatra::Base
    get '/duration/:run_uuid' do
      content_type :json

      metrics = Metric::Inspectors::RunDuration.new(
        DB[:duration_metric],
        params[:run_uuid]
      )

      metrics.inspect.to_json
    end
  end
end

