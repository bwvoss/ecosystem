require 'spec_helper'
require 'metric/inspectors/run_duration'

describe Metric::Inspectors::RunDuration do
  def add_duration_metrics(metrics)
    DB[:duration_metric].multi_insert(metrics)
  end
  let(:run_uuid) { '1' }

  def duration_metric(time, action, duration)
    {
      run_uuid: run_uuid,
      time: time,
      action: action,
      duration: duration
    }
  end

  it 'returns a duration snapshot', services: [:rds] do
    run_uuid = '1'
    time = Time.now.utc
    time_2 = (time + 60).utc
    add_duration_metrics([
      duration_metric(time, 'TestAction', 0.24),
      duration_metric(time_2, 'OtherAction', 1.24)
    ])

    metrics = described_class.new(DB[:duration_metric], run_uuid)

    expect(metrics.inspect).to eq(
      run_uuid: run_uuid,
      start_time: time,
      end_time: time_2,
      duration: 1.48,
      action_durations: {
        'TestAction': 0.24,
        'OtherAction': 1.24
      }
    )
  end
end

