require 'httparty'
require 'metric/receivers/no_op'
require 'rescuetime/single_day_sync'
require 'spec_helper'

describe 'Rescuetime Data Sync', type: :integration  do
  let(:utc_date) { Time.parse('2015-10-02').utc }
  let(:rescuetime_api_domain) { 'http://localhost:9292/rescuetime' }
  let(:rescuetime_deduplication_api_domain) do
    'http://localhost:9292/rescuetime/deduplication'
  end
  let(:interval_table) { :rescuetime_interval }
  let(:run_uuid) { 'lskdjf838' }

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

    expect(DB[interval_table].count).to eq(68)
  end

  it 'does not copy data', services: [:rds] do
    expect(DB[interval_table].count).to eq(0)

    sync

    expect(DB[interval_table].count).to eq(68)

    sync

    expect(DB[interval_table].count).to eq(68)
  end

  it 'saves only new data from rescuetime', services: [:rds] do
    expect(DB[interval_table].count).to eq(0)

    sync

    expect(DB[interval_table].count).to eq(68)

    sync(rescuetime_deduplication_api_domain)

    expect(DB[interval_table].count).to eq(79)
  end
end

