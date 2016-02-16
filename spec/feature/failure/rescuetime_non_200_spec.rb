require 'rescuetime/run'
require 'service_double/service_double'
require 'spec_helper'

describe 'Capturing non 200 errors from rescuetime', :truncate do
  let(:error_message) { '500 blow up' }
  def set_error_response
    ServiceDouble.set(
      path: '/rescuetime',
      code: 500,
      response: error_message
    )
  end

  let(:result_record) do
    DB[:run_result_metric].first
  end

  it 'captures the error and returns specific failure identifier' do
    set_error_response

    run_return = Rescuetime::Run.call(
      run_uuid: 'lsdkfj278',
      api_domain: "#{ServiceDouble::BASE_URL}/rescuetime",
      api_key: 'some-test-credential',
      datetime: utc_date('2015-10-02')
    )

    expect(run_return.success?).to be_falsey
    expect(run_return.message).to eq(
      'rescuetime_http_exception'
    )

    expect(result_record[:status]).to eq('failure')
    expect(result_record[:error]).to eq("500: #{error_message}")
  end
end
