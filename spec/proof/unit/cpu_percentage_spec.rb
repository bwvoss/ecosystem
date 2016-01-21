require 'proof/cpu_percentage'
require 'test_doubles/db'

describe Proof::CpuPercentage do
  let(:threshold) { 80 }
  let(:from_time_utc) { Time.now.utc }

  xit 'passes when the sample size percentage is less than threshold' do
    db = TestDoubles::Db.new(count: 0)
    proof = described_class.new(db, threshold, from_time_utc, sample_size)

    proof.check!

    expect(proof).to be_passed
  end

  xit 'fails when percentage is greater than threshold' do
    proof = described_class.new(db, threshold, from_time_utc, sample_size)

    proof.check!

    expect(proof).not_to be_passed
  end

  it 'will not fail if there are not enough samples past the threshold'
end

