require 'metric/duration'

describe Metric::Duration do
  let(:observe) do
    described_class.call do
      2 + 2
    end
  end

  it 'executes the given block and returns the result' do
    result, _ = observe

    expect(result).to eq(4)
  end

  it 'returns the duration metric' do
    _, metric = observe

    expect(metric.keys).to eq([:time, :duration, :type])
    expect(metric[:time]).to be_utc
    expect(metric[:duration]).not_to be_nil
    expect(metric[:type]).to eq('duration')
  end
end

