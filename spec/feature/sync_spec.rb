require 'httparty'
require 'test_data/rescuetime_response'
require 'metric/receivers/no_op'
require 'rescuetime/single_day_sync'
require 'spec_helper'
require 'service_double/service_double'

describe 'Rescuetime Data Sync', :truncate do
  let(:utc_date) { Time.parse('2015-10-02').utc }
  let(:rescuetime_api_domain) { "#{ServiceDouble::BASE_URL}/rescuetime" }
  let(:rescuetime_deduplication_api_domain) do
    "#{ServiceDouble::BASE_URL}/rescuetime/deduplication"
  end
  let(:interval_table) { :rescuetime_interval }
  let(:run_uuid) { 'lskdjf838' }

  before :all do
    ServiceDouble.set(
      path: '/rescuetime',
      response: {
        'row_headers' => TestData::RescuetimeResponse.headers,
        'rows' => TestData::RescuetimeResponse.rows
      }
    )
  end

  def sync(api_domain = rescuetime_api_domain)
    Rescuetime::SingleDaySync.call(
      db: DB,
      table: interval_table,
      http: HTTParty,
      metric_receiver: Metric::Receivers::NoOp.new,
      run_uuid: run_uuid,
      api_domain: api_domain,
      api_key: 'some-test-credential',
      datetime: utc_date,
      timezone: 'America/Chicago'
    )
  end

  it 'for a day', services: [:rds] do
    expect(DB[interval_table].count).to eq(0)

    sync

    expect(DB[interval_table].count).to eq(5)
  end

  it 'does not copy data', services: [:rds] do
    expect(DB[interval_table].count).to eq(0)

    sync

    expect(DB[interval_table].count).to eq(5)

    sync

    expect(DB[interval_table].count).to eq(5)
  end

  it 'saves only new data from rescuetime', services: [:rds] do
    new_rows = [
      ['2015-10-02T09:50:00', 70, 1, 'shophex.com', 'Uncategorized', 0],
      ['2015-10-02T09:50:00', 43, 1, 'kk.org', 'News & Opinion', -2],
      ['2015-10-02T09:50:00', 14, 1, 'google.com', 'Search', 0]
    ]

    ServiceDouble.set(
      path: '/rescuetime/deduplication',
      response: {
        'row_headers' => TestData::RescuetimeResponse.headers,
        'rows' => TestData::RescuetimeResponse.rows + new_rows
      }
    )

    expect(DB[interval_table].count).to eq(0)

    sync

    expect(DB[interval_table].count).to eq(5)

    sync(rescuetime_deduplication_api_domain)

    expect(DB[interval_table].count).to eq(8)
  end
end

