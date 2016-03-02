require 'spec_helper'

describe 'Capturing non 200 errors from rescuetime' do
  let(:error_message) { '500 blow up' }

  it 'captures the error and returns specific failure identifier' do
    ENV['HTTP_TIMEOUT_THRESHOLD'] = '0.25'
    configure_rescuetime_response(
      hang: 0.5,
      response: {}
    )

    result = run_rescuetime

    expect(result.fetch(:failed)).to eq(
      'http_timeout'
    )

    result_record = result.fetch(:metrics).fetch(:run_result).first
    expect(result_record[:status]).to eq('failure')
    expect(result_record[:error]).to eq('Net::ReadTimeout')
  end
end

