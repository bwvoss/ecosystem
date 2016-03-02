require 'grape'
require 'rescuetime/run'

module Rescuetime
  class Api < Grape::API
    format :json

    get '/run' do
      Rescuetime::Run.call(
        datetime: params[:datetime]
      )
    end
  end
end
