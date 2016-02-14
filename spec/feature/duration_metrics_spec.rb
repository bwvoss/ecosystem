require 'rescuetime/run'
require 'service_double/service_double'
require 'test_data/rescuetime_response'
require 'spec_helper'

describe 'Captures Duration metrics during rescuetime sync', :truncate do
  before :all do
    ServiceDouble.set(
      path: '/rescuetime',
      response: {
        row_headers: TestData::RescuetimeResponse.headers,
        rows: TestData::RescuetimeResponse.rows
      }
    )
  end

  let(:run_uuid) { 'lsdkfj278' }
  def actions_measured
    duration_metrics = DB[:duration_metric].where(run_uuid: run_uuid)

    duration_metrics.map do |metric|
      metric[:action]
    end
  end

  it 'captures the duration of every action' do
    Rescuetime::Run.call(
      run_uuid: run_uuid,
      api_domain: "#{ServiceDouble::BASE_URL}/rescuetime",
      api_key: 'some-test-credential',
      datetime: utc_date('2015-10-02')
    )

    actions = Rescuetime::SingleDaySync.actions.map(&:to_s)
    expect(actions_measured).to eq(actions)
  end
end

