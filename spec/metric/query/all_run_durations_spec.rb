require 'spec_helper'
require 'metric/query/all_run_durations'

describe Metric::Query::AllRunDurations do
  def add_duration_metrics(metrics)
    DB[:duration_metric].multi_insert(metrics)
  end

  def duration_metric(run_uuid, duration)
    {
      run_uuid: run_uuid,
      duration: duration
    }
  end

  it 'returns the total duration for every run' do
    add_duration_metrics([
      duration_metric('1', 0.24),
      duration_metric('1', 1.24),
      duration_metric('2', 2.04),
      duration_metric('2', 0.04),
      duration_metric('3', 5.04)
    ])

    metrics = described_class.call(
      metric: DB[:duration_metric]
    )

    expect(metrics).to eq([
      { run_uuid: '1', duration: 1.48 },
      { run_uuid: '2', duration: 2.08 },
      { run_uuid: '3', duration: 5.04 }
    ])
  end
end

