require 'spec_helper'

describe 'Rescuetime http timeouts' do
  it 'captures the error and returns specific failure identifier' do
    ENV['HTTP_TIMEOUT_THRESHOLD'] = '0.15'
    configure_rescuetime_response(
      hang: 0.25,
      response: {}
    )

    _, error = run_rescuetime

    expect(error).to eq(
      :http_timeout
    )
  end
end

