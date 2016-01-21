require 'metric/cpu'

describe Metric::Cpu do
  let(:cpu) { described_class.new }

  it 'returns the percentage used' do
    percentage_used = 23.89
    expect(Usagewatch).to receive(:uw_cpuused) { percentage_used }

    expect(cpu.percentage_used).to eq(percentage_used)
  end

  it 'returns the top 10 processes by consumption' do
    processes = [['apache2', 12.0], ['passenger', 13.2]]
    expect(Usagewatch).to receive(:uw_cputop) { processes }

    expect(cpu.top_processes).to eq('apache2: 12.0, passenger: 13.2')
  end
end

