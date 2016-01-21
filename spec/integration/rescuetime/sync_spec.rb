require 'app'
require 'metric/receivers/no_op'
require 'httparty'
require 'sequel'
require 'spec_helper'
require 'time'

describe 'Rescuetime Data Sync' do
  let(:utc_date) { Time.parse('2015-10-02 8:35').utc }
  let(:rescuetime_api_domain) { 'http://localhost:9292/rescuetime' }
  let(:rescuetime_deduplication_api_domain) do
    'http://localhost:9292/rescuetime/deduplication'
  end
  let(:interval_table) { :rescuetime_interval }
  let(:run_uuid) { 'lskdjf838' }

  let(:db) do
    c = Sequel.connect('postgres://postgres@localhost:2200/postgres')
    Sequel.database_timezone = :utc
    c
  end

  def sync(api_domain = rescuetime_api_domain)
    App.sync_rescuetime(
      db: db,
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
    expect(db[interval_table].count).to eq(0)

    sync

    expect(db[interval_table].count).to eq(68)
  end

  it 'does not copy data', services: [:rds] do
    expect(db[interval_table].count).to eq(0)

    sync

    expect(db[interval_table].count).to eq(68)

    sync

    expect(db[interval_table].count).to eq(68)
  end

  it 'saves only new data from rescuetime', services: [:rds] do
    expect(db[interval_table].count).to eq(0)

    sync

    expect(db[interval_table].count).to eq(68)

    sync(rescuetime_deduplication_api_domain)

    expect(db[interval_table].count).to eq(79)
  end
end

