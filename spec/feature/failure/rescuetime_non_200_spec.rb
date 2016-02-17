require 'spec_helper'

describe 'Capturing non 200 errors from rescuetime', :truncate do
  let(:error_message) { '500 blow up' }
  let(:result_record) do
    DB[:run_result_metric].first
  end

  it 'captures the error and returns specific failure identifier' do
    configure_rescuetime_response(
      code: 500,
      response: error_message
    )

    run_return = run_rescuetime

    expect(run_return.success?).to be_falsey
    expect(run_return.message).to eq(
      'rescuetime_http_exception'
    )

    expect(result_record[:status]).to eq('failure')
    expect(result_record[:error]).to eq("500: #{error_message}")
  end
end

