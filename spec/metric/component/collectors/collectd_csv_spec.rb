require 'spec_helper'
require 'metric/collectors/collectd_csv'

describe Metric::Collectors::CollectdCsv do
  let(:collector) do
    described_class.new(
      DB[:system_metric],
      'spec/test_doubles/percent-active'
    )
  end

  it 'parses a csv to metric records', services: [:rds] do
    expect(DB[:system_metric].count).to eq(0)

    collector.call

    expect(DB[:system_metric].count).to eq(3)
  end

  it 'converts epoch time to utc', services: [:rds] do
    collector.call

    times = DB[:system_metric].select_map(:time)

    expect(times.all?(&:utc?)).to be_truthy
  end

  it 'sets the cpu_percentage_used', services: [:rds] do
    collector.call

    cpu_percentages = DB[:system_metric].select_map(:cpu_percentage_used)

    expect(cpu_percentages).to eq([
      2.496680,
      2.226670,
      4.120879
    ])
  end
end

