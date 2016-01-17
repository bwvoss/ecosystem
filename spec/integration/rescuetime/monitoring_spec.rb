require 'app'
require 'httparty'
require 'sequel'
require 'metrics/receivers/postgresql'
require 'spec_helper'
require 'time'

describe 'Metrics Captured during a rescuetime sync' do
  let(:utc_date) { Time.parse('2015-10-02 8:35').utc }
  let(:rescuetime_api_domain) { 'http://localhost:9292/rescuetime' }
  let(:interval_table) { :rescuetime_interval }

  let(:db) do
    c = Sequel.connect('postgres://postgres@localhost:2200/postgres')
    Sequel.database_timezone = :utc
    c
  end

  it 'captures the duration of every action', services: [:postgresql] do
    App.sync_rescuetime(
      db: db,
      table: interval_table,
      http: HTTParty,
      metrics: Metrics::Receivers::Postgresql.new(db),
      api_domain: rescuetime_api_domain,
      api_key: 'some-test-credential',
      datetime: utc_date,
      timezone: 'America/Chicago'
    )

    duration_metrics = db[:duration_metric].where(service: "rescuetime")
    expect(duration_metrics.count).to eq(Rescuetime::SingleDaySync.actions.count)

    actions_measured = duration_metrics.map do |metric|
      metric[:action]
    end
    expect(actions_measured).to eq(Rescuetime::SingleDaySync.actions.map(&:to_s))
  end
end

