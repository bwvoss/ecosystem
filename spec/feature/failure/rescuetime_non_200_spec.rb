require 'spec_helper'

describe 'Capturing non 200 errors from rescuetime' do
  let(:error_message) { '500 blow up' }

  it 'captures the error and returns specific failure identifier' do
    configure_rescuetime_response(
      code: 500,
      response: error_message
    )

    result = run_rescuetime

    expect(result.fetch(:failed)).to eq(
      'rescuetime_http_exception'
    )

    result_record = result.fetch(:metrics).fetch(:run_result).first
    expect(result_record[:status]).to eq('failure')
    expect(result_record[:error]).to eq("500: #{error_message}")
  end
end

