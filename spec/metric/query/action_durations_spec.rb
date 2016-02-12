require 'spec_helper'
require 'metric/query/action_durations'

describe Metric::Query::ActionDurations do
  def add_duration_metrics(metrics)
    DB[:duration_metric].multi_insert(metrics)
  end
  let(:run_uuid) { '1' }

  def duration_metric(action, duration)
    {
      run_uuid: run_uuid,
      action: action,
      duration: duration
    }
  end

  it 'returns a list of actions durations per run uuid', services: [:rds] do
    add_duration_metrics([
      duration_metric('TestAction', 0.24),
      duration_metric('OtherAction', 1.24)
    ])

    metrics = described_class.call(
      metric: DB[:duration_metric],
      run_uuid: run_uuid
    )

    expect(metrics).to eq([
      { action: 'TestAction', duration: 0.24 },
      { action: 'OtherAction', duration: 1.24 }
    ])
  end
end

