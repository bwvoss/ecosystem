require 'rescuetime/run'
require 'service_double/service_double'
require 'test_data/rescuetime_response'
require 'spec_helper'

describe 'Recording success at the end of the run', :truncate do
  before :all do
    ServiceDouble.set(
      path: '/rescuetime',
      response: {
        row_headers: TestData::RescuetimeResponse.headers,
        rows: TestData::RescuetimeResponse.rows
      }
    )
  end

  def result_record
    DB[:run_result_metric].limit(1).first
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

