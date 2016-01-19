require 'proof/action_performance'

describe Proof::ActionPerformance  do
  context 'ensures no action takes longer than a threshold' do
    it 'passes when under 0.75 seconds' do
    end

    it 'passes when 0.75 seconds'
    it 'fails when over 0.75 seconds'
  end

  context 'ensures an entire run takes less than a threshold seconds' do
    it 'passes when under 4 seconds'
    it 'passes when 4 seconds'
    it 'fails when over 4 seconds'
  end
end

