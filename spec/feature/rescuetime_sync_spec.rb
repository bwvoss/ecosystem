require 'rescuetime/run'
require 'metric/receivers/no_op'
require 'service_double/service_double'
require 'test_data/rescuetime_response'
require 'spec_helper'

describe 'Rescuetime Data Sync', :truncate do
  let(:rescuetime_api_domain) { "#{ServiceDouble::BASE_URL}/rescuetime" }
  let(:rescuetime_deduplication_api_domain) do
    "#{ServiceDouble::BASE_URL}/rescuetime/deduplication"
  end

  def rescuetime_record_count
    DB[:rescuetime_interval].count
  end

  before :all do
    ServiceDouble.set(
      path: "/rescuetime#{@mock_querystring}",
      response: {
        row_headers: TestData::RescuetimeResponse.headers,
        rows: TestData::RescuetimeResponse.rows
      }
    )
  end

  def sync(api_domain = rescuetime_api_domain)
    Rescuetime::Run.call(
      metric_receiver: Metric::Receivers::NoOp.new,
      run_uuid: 'lskdjf838',
      api_domain: api_domain,
      api_key: 'some-test-credential',
      datetime: utc_date('2015-10-02')
    )
  end

  def assert_all_records_saved
    expect(rescuetime_record_count).to eq(5)
  end

  it 'for a day' do
    expect(rescuetime_record_count).to eq(0)

    sync

    assert_all_records_saved
  end

  it 'does not copy data' do
    expect(rescuetime_record_count).to eq(0)

    sync

    assert_all_records_saved

    expect do
      sync
    end.not_to change { rescuetime_record_count }
  end

  def assert_only_new_records_saved
    expect(rescuetime_record_count).to eq(8)
  end

  it 'saves only new data from rescuetime' do
    new_rows = [
      ['2015-10-02T09:50:00', 70, 1, 'shophex.com', 'Uncategorized', 0],
      ['2015-10-02T09:50:00', 43, 1, 'kk.org', 'News & Opinion', -2],
      ['2015-10-02T09:50:00', 14, 1, 'google.com', 'Search', 0]
    ]

    ServiceDouble.set(
      path: "/rescuetime/deduplication#{@mock_querystring}",
      response: {
        row_headers: TestData::RescuetimeResponse.headers,
        rows: TestData::RescuetimeResponse.rows + new_rows
      }
    )

    expect(rescuetime_record_count).to eq(0)

    sync

    assert_all_records_saved

    sync(rescuetime_deduplication_api_domain)

    assert_only_new_records_saved
  end
end

