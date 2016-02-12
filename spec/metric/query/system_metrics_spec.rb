require 'spec_helper'
require 'metric/query/system_metrics'

describe Metric::Query::SystemMetrics do
  def add_system_metrics(metrics)
    DB[:system_metric].multi_insert(metrics)
  end

  def system_metric(time, cpu_percentage_used)
    {
      time: time,
      cpu_percentage_used: cpu_percentage_used
    }
  end

  def add_duration_metrics(metrics)
    DB[:duration_metric].multi_insert(metrics)
  end

  def duration_metric(time, run_uuid)
    {
      time: time,
      run_uuid: run_uuid
    }
  end

  it 'returns system metrics during a run', services: [:rds] do
    run_uuid = '1'
    now = Time.now.utc
    add_duration_metrics([
      duration_metric(now, run_uuid),
      duration_metric(now + 5, run_uuid),
      duration_metric(now + 10, run_uuid)
    ])

    add_system_metrics([
      system_metric(now, 2.5),
      system_metric(now + 5, 3.5),
      system_metric(now + 10, 20)
    ])

    metrics = described_class.call(
      system_metric: DB[:system_metric],
      duration_metric: DB[:duration_metric],
      run_uuid: run_uuid
    )

    expect(metrics).to eq([
      { time: now, cpu_percentage_used: 2.5 },
      { time: now + 5, cpu_percentage_used: 3.5 },
      { time: now + 10, cpu_percentage_used: 20 }
    ])
  end

  it 'does not include metrics outside of the run', services: [:rds] do
    run_uuid = '1'
    now = Time.now.utc
    add_duration_metrics([
      duration_metric(now - 5, 'other'),
      duration_metric(now, run_uuid),
      duration_metric(now, 'another'),
      duration_metric(now + 5, run_uuid),
      duration_metric(now + 10, run_uuid),
      duration_metric(now + 15, 'another')
    ])

    add_system_metrics([
      system_metric(now - 5, 2.5),
      system_metric(now, 2.5),
      system_metric(now + 5, 3.5),
      system_metric(now + 10, 20),
      system_metric(now + 15, 40)
    ])

    metrics = described_class.call(
      system_metric: DB[:system_metric],
      duration_metric: DB[:duration_metric],
      run_uuid: run_uuid
    )

    expect(metrics).to eq([
      { time: now, cpu_percentage_used: 2.5 },
      { time: now + 5, cpu_percentage_used: 3.5 },
      { time: now + 10, cpu_percentage_used: 20 }
    ])
  end
end

