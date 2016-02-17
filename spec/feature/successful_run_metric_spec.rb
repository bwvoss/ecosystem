require 'rescuetime/run'
require 'service_double/service_double'
require 'test_data/rescuetime_response'
require 'spec_helper'

describe 'Recording success at the end of the run', :truncate do
  before :all do
    ServiceDouble.set(
      path: "/rescuetime#{@mock_querystring}",
      response: {
        row_headers: TestData::RescuetimeResponse.headers,
        rows: TestData::RescuetimeResponse.rows
      }
    )
  end

  let(:result_record) do
    DB[:run_result_metric].first
  end

  it 'captures the run_uuid and time' do
    Rescuetime::Run.call(
      run_uuid: 'lsdkfj278',
      api_domain: "#{ServiceDouble::BASE_URL}/rescuetime",
      api_key: 'some-test-credential',
      datetime: utc_date('2015-10-02')
    )

    expect(result_record[:status]).to eq('success')
  end
end

