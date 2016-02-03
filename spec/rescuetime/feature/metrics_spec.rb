require 'httparty'
require 'metric/receivers/rds'
require 'rescuetime/single_day_sync'
require 'spec_helper'

describe 'Metrics Captured during a rescuetime sync', :truncate do
  let(:utc_date) { Time.parse('2015-10-02').utc }
  let(:rescuetime_api_domain) { 'http://localhost:9292/rescuetime' }
  let(:interval_table) { :rescuetime_interval }
  let(:run_uuid) { 'lsdkfj278' }

  it 'captures the duration of every action', services: [:rds] do
    Rescuetime::SingleDaySync.call(
      db: DB,
      table: interval_table,
      http: HTTParty,
      metric_receiver: Metric::Receivers::Rds.new(DB),
      run_uuid: run_uuid,
      api_domain: rescuetime_api_domain,
      api_key: 'some-test-credential',
      datetime: utc_date,
      timezone: 'America/Chicago'
    )

    duration_metrics = DB[:duration_metric].where(service: 'rescuetime')
    expect(duration_metrics.count)
      .to eq(Rescuetime::SingleDaySync.actions.count)

    actions_measured = duration_metrics.map do |metric|
      metric[:action]
    end
    actions = Rescuetime::SingleDaySync.actions.map(&:to_s)
    expect(actions_measured).to eq(actions)
  end
end

