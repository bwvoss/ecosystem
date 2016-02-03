require 'metric/receivers/rds'
require 'spec_helper'

describe Metric::Receivers::Rds do
  it 'sends metrics to a relational database', services: [:rds] do
    receiver = described_class.new(DB)

    receiver << {
      type: :duration,
      host: 'test-host',
      duration: 23
    }

    persisted_metric = DB[:duration_metric].first
    expect(persisted_metric[:duration]).to eq(23)
    expect(persisted_metric[:host]).to eq('test-host')
    expect(persisted_metric.keys).not_to include('type')
  end
end

